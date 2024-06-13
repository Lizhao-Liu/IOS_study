//
//  MBMatrixWechatManager.m
//  MBAPMLib
//
//  Created by 别施轩 on 2021/8/10.
//

#import "MBMatrixWechatManager.h"
#import "MBAPMLogDef.h"
@import MBBuildPreLib;
#import "MBAPMZombieSniffer.h"
#import "MBAPMAppStateUtil.h"

@implementation MBMatrixConfig

@end

void mbapm_onHandleExceptionStart(KSCrashMonitorType monitorType) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MBMatrixWechatManager sharedInstance].crashHandlStartBlock([NSString stringWithFormat:@"%d", monitorType]);
    });
}

/// 添加额外数据，在子线程中回调
void mbapm_crashAddAdditionalData(const KSCrashReportWriter *writer, const KSCrash_MonitorContext *const context)
{
    if (!context || context->userException.userDumpType >= EDumpType_Unlag) {
        return;
    }
    if (![MBMatrixWechatManager sharedInstance].additionalInfoBlock) {
        return;
       
    }
//    if (context->ZombieException.address != 0) {
//        KSStackCursor *stackCursor = [MBAPMZombieSniffer deallocStackForObj:context->ZombieException.address];
//        context->ZombieException.stackCursor = stackCursor;
//    }
    NSDictionary *additionalData = [MBMatrixWechatManager sharedInstance].additionalInfoBlock();
    if (!additionalData || ![additionalData isKindOfClass:NSDictionary.class]) {
        return;
    }
    NSString *additionalJsonStr = [additionalData yy_modelToJSONString];
    if (!additionalData || additionalJsonStr.length <= 0) {
        return;
    }
    const char *additionalJsonCStr = [additionalJsonStr cStringUsingEncoding:NSUTF8StringEncoding];
    writer->beginObject(writer, "mb_data");
    writer->addJSONElement(writer, "apm", additionalJsonCStr, false);
    writer->endContainer(writer);
}


@interface MBMatrixWechatManager () <WCCrashBlockMonitorDelegate, MatrixAdapterDelegate, MatrixPluginListenerDelegate>
{
    MatrixBuilder *_curBuilder;
    WCCrashBlockMonitorPlugin *m_cbPlugin;
    WCMemoryStatPlugin *_memoryStatPlugin;
    
    MBMatrixLagTimeBlock _lagTimeBlock;
    MBMatrixLagReportBlock _lagReportBlock;
    MBMatrixFOOMReportBlock _foomReportBlock;
    MBMatrixCrashReportBlock _crashReportBlock;
    MBMatrixCrashReportBlock _crashLagReportBlock;
    
    BOOL _crashLagReported;
    
    NSInteger _lagDumpType;
    NSThread *_lagReportThread;
}

@end

@implementation MBMatrixWechatManager

+ (MBMatrixWechatManager *)sharedInstance
{
    static MBMatrixWechatManager *g_handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_handler = [[MBMatrixWechatManager alloc] init];
        [g_handler installMatrix];
    });
    
    return g_handler;
}

- (void)installMatrix
{
    [Matrix sharedInstance];
    [MatrixAdapter sharedInstance].delegate = self;
    _curBuilder = [[MatrixBuilder alloc] init];
    _curBuilder.pluginListener = self;
    _lagReportThread = [[NSThread alloc] initWithTarget:self selector:@selector(initLagReportThread) object:nil];
    [_lagReportThread start];
}

- (void)initLagReportThread {
    [[NSThread currentThread] setName:@"com.amh.apm.report_lag"];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (void)installBlockPlugin:(MBMatrixConfig *)config {
    WCCrashBlockMonitorConfig *crashBlockConfig = [[WCCrashBlockMonitorConfig alloc] init];
    crashBlockConfig.enableCrash = config.enableCrashMonitor;
    crashBlockConfig.enableBlockMonitor = config.enableBlockMonitor;
    crashBlockConfig.blockMonitorDelegate = self;
    crashBlockConfig.reportStrategy = EWCCrashBlockReportStrategy_All;
    crashBlockConfig.onAppendAdditionalInfoCallBack = mbapm_crashAddAdditionalData;
    crashBlockConfig.onHandleExceptionStartCallBack = mbapm_onHandleExceptionStart;
    WCBlockMonitorConfiguration *blockMonitorConfig = [WCBlockMonitorConfiguration defaultConfig];
    blockMonitorConfig.runloopTimeOut = 3 * BM_MicroFormat_Second; //判定卡顿主循环时间2 * BM_MicroFormat_Second;
    blockMonitorConfig.checkPeriodTime = 1 * BM_MicroFormat_Second; //检查周期1 * BM_MicroFormat_Second;
    blockMonitorConfig.bMainThreadHandle = YES;//是否从主线程获取最耗时堆栈
    blockMonitorConfig.perStackInterval = g_defaultPerStackInterval;//从主线程获取堆栈的间隔
    blockMonitorConfig.mainThreadCount = g_defaultMainThreadCount;//保存的线程个数
    blockMonitorConfig.limitCPUPercent = g_defaultCPUUsagePercent;//cpu百分比警告线
    blockMonitorConfig.bPrintCPUUsage = NO;
    blockMonitorConfig.bGetCPUHighLog = NO;

    blockMonitorConfig.bGetPowerConsumeStack = NO;//功耗堆栈
    blockMonitorConfig.powerConsumeStackCPULimit = g_defaultPowerConsumeCPULimit;//功耗堆栈警告线
    blockMonitorConfig.bFilterSameStack = NO;//启用在一天内过滤相同的堆栈
    blockMonitorConfig.triggerToBeFilteredCount = 10;//在一天内过滤相同的堆栈个数
    blockMonitorConfig.bPrintMemomryUse = NO;
    blockMonitorConfig.bEnableLocalSymbolicate = ([MBFMacro ymm_buildAdhoc] || [MBFMacro ymm_buildDebug]);//本地符号化
    
//    WCFPSMonitorPlugin *fpsMonitorPlugin = [[WCFPSMonitorPlugin alloc] init];
//    [_curBuilder addPlugin:fpsMonitorPlugin]; // add fps monitor.
    
    crashBlockConfig.blockMonitorConfiguration = blockMonitorConfig;
    
    WCCrashBlockMonitorPlugin *crashBlockPlugin = [[WCCrashBlockMonitorPlugin alloc] init];
    crashBlockPlugin.pluginConfig = crashBlockConfig;
    [_curBuilder addPlugin:crashBlockPlugin];
    
    [[Matrix sharedInstance] addMatrixBuilder:_curBuilder];
    [crashBlockPlugin start];
    m_cbPlugin = crashBlockPlugin;
}

- (void)installMemoryPluginWithConfigDic:(NSDictionary<NSString *, NSNumber *> *)dic {
    NSAssert(dic[@"skipMinMallocSize"], @"传入的 skipMinMallocSize 参数错误");
    NSAssert(dic[@"skipMaxStackDepth"], @"传入的 skipMaxStackDepth 参数错误");
    NSAssert(dic[@"dumpCallStacks"], @"传入的 dumpCallStacks 参数错误");
    NSAssert(dic[@"reportStrategy"], @"传入的 reportStrategy 参数错误");
    
    int skipMinMallocSize = [dic[@"skipMinMallocSize"] intValue];
    int skipMaxStackDepth = [dic[@"skipMaxStackDepth"] intValue];
    int dumpCallStacks = [dic[@"dumpCallStacks"] intValue];
    NSUInteger reportStrategy = [dic[@"reportStrategy"] unsignedIntegerValue];
    
    WCMemoryStatPlugin *memoryPlugin = [[WCMemoryStatPlugin alloc]init];
    WCMemoryStatConfig *config = [WCMemoryStatConfig defaultConfiguration];
    config.skipMinMallocSize = skipMinMallocSize;
    config.skipMaxStackDepth = skipMaxStackDepth;
    config.dumpCallStacks = dumpCallStacks;
    config.reportStrategy = EWCMemStatReportStrategy(reportStrategy);
    memoryPlugin.pluginConfig  = config;
    [_curBuilder addPlugin:memoryPlugin];
    [[Matrix sharedInstance] addMatrixBuilder:_curBuilder];
    _memoryStatPlugin = memoryPlugin;
}

- (WCCrashBlockMonitorPlugin *)getCrashBlockPlugin;
{
    return m_cbPlugin;
}

- (WCMemoryStatPlugin *)getMemoryStatPlugin {
    return _memoryStatPlugin;
}

- (void)setLagTimeBlock:(MBMatrixLagTimeBlock)block {
    _lagTimeBlock = block;
}

- (void)setLagReportModelBlock:(MBMatrixLagReportBlock)block {
    _lagReportBlock = block;
}

- (void)setFOOMReportBlock:(MBMatrixFOOMReportBlock)block {
    _foomReportBlock = block;
}

- (void)setCrashReportBlock:(MBMatrixCrashReportBlock)block {
    _crashReportBlock = block;
}

- (void)setCrashLagReportBlock:(MBMatrixCrashReportBlock)block {
    _crashLagReportBlock = block;
}

- (void)setCrashHandleStartBlock:(MBMatrixCrashHandleStartBlock)block {
    _crashHandlStartBlock = block;
}

- (NSUInteger)getAppBootType {
    return [[Matrix sharedInstance]lastRebootType];
}

// ============================================================================
#pragma mark - MatrixPluginListenerDelegate
// ============================================================================

- (void)onReportIssue:(MatrixIssue *)issue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reportIssueTask:issue];
    });
}

- (void)reportIssueTask:(MatrixIssue *)issue
{
    if ([issue.issueTag isEqualToString:[WCMemoryStatPlugin getTag]]) {
        if (_foomReportBlock) {
            _foomReportBlock(issue);
        }
    }
    
    if ([issue.issueTag isEqualToString:[WCCrashBlockMonitorPlugin getTag]]) {
        if (issue.reportType == EMCrashBlockReportType_Crash) {
            NSString *issueContent = [[NSString alloc]initWithData:issue.issueData encoding:NSUTF8StringEncoding];
            if (_crashReportBlock) {
                _crashReportBlock([MatrixReportModel yy_modelWithJSON:issueContent]);
            }
        }
        else if (issue.reportType == EMCrashBlockReportType_Lag) {
            [self reportCrashLagIssue:issue];
        }
    }
    [[Matrix sharedInstance] reportIssueComplete:issue success:YES];
    MBAPMLogInfo(@"matrix issue on report, rebootType:%ld, isAfterLastLaunchUserRebootDevice:%d", [self getAppBootType], [[Matrix sharedInstance] isAfterLastLaunchUserRebootDevice]);
}

- (void)reportCrashLagIssue:(MatrixIssue *)issue {
    if (_crashLagReported) {
        return;
    }
    _crashLagReported = YES;
    
    NSString *issueContents = [[NSString alloc]initWithData:issue.issueData encoding:NSUTF8StringEncoding];
    if (issueContents.length == 0) {
        return;
    }
    NSArray<MatrixReportModel *> *issues = [NSArray yy_modelArrayWithClass:[MatrixReportModel class] json:issueContents];
    NSUInteger lastLaunchEndT = [[MBAPMAppStateUtil shared] lastLaunchEndTime];
    NSUInteger launchT = [[MBAPMAppStateUtil shared] launchStartTime];
    if (_crashLagReportBlock && issues.lastObject) {
        MatrixReportModel* _Nonnull obj = issues.lastObject;
        NSUInteger reportT = obj.report.timestamp * 1000;
        if (reportT > lastLaunchEndT - 100000 && reportT < launchT) {
            _crashLagReportBlock(obj);
        }
    }
}

// ============================================================================
#pragma mark - MatrixAdapterDelegate
// ============================================================================

- (BOOL)matrixShouldLog:(MXLogLevel)level
{
    return YES;
}

- (void)matrixLog:(MXLogLevel)logLevel
           module:(const char *)module
             file:(const char *)file
             line:(int)line
         funcName:(const char *)funcName
          message:(NSString *)message
{
    MBLogLevel mbLogLevel = MBLogLevelInfo;
    switch (logLevel) {
        case MXLogLevelDebug:
        case MXLogLevelVerbose:
            mbLogLevel = MBLogLevelDebug;
            break;
        case MXLogLevelInfo:
            mbLogLevel = MBLogLevelInfo;
            break;
        case MXLogLevelWarn:
            mbLogLevel = MBLogLevelWarning;
            break;
        case MXLogLevelFatal:
            mbLogLevel = MBLogLevelFatal;
            break;
        case MXLogLevelError:
            mbLogLevel = MBLogLevelError;
            break;
        default:
            mbLogLevel = MBLogLevelInfo;
            break;
    }
    [MBLogLogger appendLog:message level:MBLogLevelInfo module:"app" subModule:"matrix" function:funcName line:0];
}

// ============================================================================
#pragma mark - WCCrashBlockMonitorDelegate
// ============================================================================

- (void)onCrashBlockMonitorBeginDump:(EDumpType)dumpType blockTime:(uint64_t)blockTime
{
    _lagDumpType = dumpType;
    [self performSelector:@selector(reportThread_onCrashBlockMonitorBlockTime:) onThread:_lagReportThread withObject:@(blockTime) waitUntilDone:NO];
}

- (void)reportThread_onCrashBlockMonitorBlockTime:(NSNumber *)blockTime
{
    if (_lagTimeBlock != nil) {
        _lagTimeBlock([blockTime unsignedLongLongValue]);
    }
}

- (void)onCrashBlockMonitorGetDumpFile:(NSString *)dumpFile withDumpType:(EDumpType)dumpType {
    _lagDumpType = dumpType;
    [self performSelector:@selector(reportThread_reportMainThreadBlockWithDumpFile:) onThread:_lagReportThread withObject:dumpFile waitUntilDone:NO];
}

- (void)reportThread_reportMainThreadBlockWithDumpFile:(NSString *)dumpFile {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reportMainThreadBlockWithDumpFile:) withObject:dumpFile afterDelay:2];
}

- (void)reportMainThreadBlockWithDumpFile:(NSString *)dumpFile {
    NSString *content = [NSString stringWithContentsOfFile:dumpFile encoding:NSUTF8StringEncoding error:nil];
    if (content.length == 0) {
        return;
    }
    MatrixReportModel *report = [MatrixReportModel yy_modelWithJSON:content];
    report.dumpType = _lagDumpType;
    NSUInteger launchT = [[[report.system valueForKey:@"application_stats"] valueForKey:@"app_launch_time"] longLongValue];
    NSUInteger reportT = report.report.timestamp;
    if (reportT < launchT) {
        return;
    }
    if (_lagReportBlock != nil) {
        _lagReportBlock(report);
    }
}


@end
