//
//  MBAPMMetricMonitor.m
//  ABCAppPaySDK
//
//  Created by FDW on 2022/9/2.
//

#import "MBAPMMetricMonitor.h"
#import "MBAPMPluginConfig.h"
#import "MBAPMErrorMetric.h"
#import "MBAPMUUIDUtil.h"
#import "MBAPMAppStateUtil.h"

@import MetricKit;

#define NAME_MAPPING(A) @{@(A): @""#A""}

API_AVAILABLE(ios(13.0))
@interface MBAPMMetricMonitor () <MXMetricManagerSubscriber>
@property (nonatomic, strong) MXMetricManager *manager;
@property (nonatomic, copy) NSString *bundleName;
// 用于计算 feature
@property (nonatomic, assign) NSInteger sampleCount;
// 非崩溃的 feature (当前 binaryName 为 App 的)
@property (nonatomic, copy) NSString *curFeature;
// 非崩溃的 feature (找不到当前 app 的,默认取第一行的)
@property (nonatomic, copy) NSString *curFirFeature;
// 崩溃的 feature (当前 binaryName 为 App 的)
@property (nonatomic, copy) NSString *curCrashFeature;
// 崩溃的 feature (找不到当前 app 的,默认取第一行的)
@property (nonatomic, copy) NSString *curFirCrashFeature;

@property (nonatomic, strong) NSMutableDictionary *execptionParams;
@end
@implementation MBAPMMetricMonitor

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagMetric;
}

- (void)start {
    [super start];
    [self.manager addSubscriber:self];
}

- (void)abort {
    [super abort];
    
    [_manager removeSubscriber:self];
}

- (void)stop {
    [super stop];
}

- (void)dealloc {
    [_manager removeSubscriber:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initExceptionData];
    }
    return self;
}
#pragma mark - MXMetricManagerSubscriber
// 暂不处理
//- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> * _Nonnull)payloads  API_AVAILABLE(ios(13.0)) {
//}

- (void)didReceiveDiagnosticPayloads:(NSArray<MXDiagnosticPayload *> * _Nonnull)payloads  API_AVAILABLE(ios(14.0)) {
    [self reportMetricWithPayloads:payloads];
}
#pragma mark - data upload
- (void)reportMetricWithPayloads:(NSArray <MXDiagnosticPayload *> *)payloads  API_AVAILABLE(ios(14.0)) {
    
    if (@available(iOS 14.0, *)) {
        for (MXDiagnosticPayload *payload in payloads) {
            // cpu
            for (MXCPUExceptionDiagnostic *diagnostic in payload.cpuExceptionDiagnostics) {
                MBAPMErrorMetric *metric = [[MBAPMErrorMetric alloc] init];
                metric.performanceType = MBAPMPerformanceTypeError;
                metric.tag = @"metric_cpu";
                NSData *data = diagnostic.callStackTree.JSONRepresentation;
                [self parseFeatureNameWithData:data isCrash:NO];
                NSString *err_feature = nil;
                if (_curFeature.length) {
                    err_feature = _curFeature;
                } else if (_curFirFeature.length) {
                    err_feature = _curFirFeature;
                } else {
                    err_feature = @"unfound";
                }
                metric.feature = err_feature;
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                metric.stack = jsonString ?: @"";
                metric.attrs = @{@"stack_type": @"metric",
                                 @"mapping_type": @"dsym",
                                 @"bundles": [MBAPMUUIDUtil getUnsystemImageUUIDs],
                                 @"other_info": @{
                                     @"totalCPUTime": @(diagnostic.totalCPUTime.doubleValue),
                                     @"totalSampledTime": @(diagnostic.totalSampledTime.doubleValue)
                                 }
                };
                [self reportMetrics:metric];
                
                _sampleCount = 0;
                _curFeature = nil;
                _curFirFeature = nil;
            }
            
            // disk
            for (MXDiskWriteExceptionDiagnostic *diagnostic in payload.diskWriteExceptionDiagnostics) {
                MBAPMErrorMetric *metric = [[MBAPMErrorMetric alloc] init];
                metric.performanceType = MBAPMPerformanceTypeError;
                metric.tag = @"metric_disk";
                NSData *data = diagnostic.callStackTree.JSONRepresentation;
                [self parseFeatureNameWithData:data isCrash:NO];
                NSString *err_feature = nil;
                if (_curFeature.length) {
                    err_feature = _curFeature;
                } else if (_curFirFeature.length) {
                    err_feature = _curFirFeature;
                } else {
                    err_feature = @"unfound";
                }
                metric.feature = err_feature;
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                metric.stack = jsonString ?: @"";
                metric.attrs = @{@"stack_type": @"metric",
                                 @"mapping_type": @"dsym",
                                 @"bundles": [MBAPMUUIDUtil getUnsystemImageUUIDs],
                                 @"other_info": @{
                                     @"duration": @(diagnostic.totalWritesCaused.doubleValue)
                                 }
                };
                [self reportMetrics:metric];
                
                _sampleCount = 0;
                _curFeature = nil;
                _curFirFeature = nil;
            }
            
            // hang
            for (MXHangDiagnostic *diagnostic in payload.hangDiagnostics) {
                MBAPMErrorMetric *metric = [[MBAPMErrorMetric alloc] init];
                metric.performanceType = MBAPMPerformanceTypeError;
                metric.tag = @"metric_hang";
                NSData *data = diagnostic.callStackTree.JSONRepresentation;
                [self parseFeatureNameWithData:data isCrash:NO];
                NSString *err_feature = nil;
                if (_curFeature.length) {
                    err_feature = _curFeature;
                } else if (_curFirFeature.length) {
                    err_feature = _curFirFeature;
                } else {
                    err_feature = @"unfound";
                }
                metric.feature = err_feature;
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                metric.stack = jsonString ?: @"";
                metric.attrs = @{@"stack_type": @"metric",
                                 @"mapping_type": @"dsym",
                                 @"bundles": [MBAPMUUIDUtil getUnsystemImageUUIDs],
                                 @"other_info": @{
                                     @"duration": @(diagnostic.hangDuration.doubleValue)
                                 }
                };
                [self reportMetrics:metric];
                
                _sampleCount = 0;
                _curFeature = nil;
                _curFirFeature = nil;
            }
            
            // crash
            for (MXCrashDiagnostic *diagnostic in payload.crashDiagnostics) {
                MBAPMErrorMetric *metric = [[MBAPMErrorMetric alloc] init];
                metric.performanceType = MBAPMPerformanceTypeError;
                metric.tag = @"metric_crash";
                NSData *data = diagnostic.callStackTree.JSONRepresentation;
                [self parseFeatureNameWithData:data isCrash:YES];
                NSString *err_feature = nil;
                if (_curCrashFeature.length) {
                    err_feature = [NSString stringWithFormat:@"%@,%@,%@",
                                                                [self getSignalStringWithSignal:diagnostic.signal.integerValue],
                                                                [self getMachExceptionStringWithMachException:diagnostic.exceptionType.integerValue],
                                   _curCrashFeature];
                } else if (_curFirCrashFeature.length) {
                    err_feature = [NSString stringWithFormat:@"%@,%@,%@",
                                   [self getSignalStringWithSignal:diagnostic.signal.integerValue],
                                   [self getMachExceptionStringWithMachException:diagnostic.exceptionType.integerValue],
                                   _curFirCrashFeature];
                } else {
                    err_feature = @"unfound";
                }
                metric.feature = err_feature;
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                metric.stack = jsonString ?: @"";
                metric.attrs = @{@"stack_type": @"metric",
                                 @"mapping_type": @"dsym",
                                 @"bundles": [MBAPMUUIDUtil getUnsystemImageUUIDs],
                                 @"app_foreground": MBAPMAppStateUtil.shared.applicationState == UIApplicationStateActive ? @(1) : @(0),
                                 @"other_info":  @{
                                     @"reason": diagnostic.terminationReason ?: @"",
                                     @"info": diagnostic.virtualMemoryRegionInfo ?: @"",
                                     @"type": diagnostic.exceptionType ?: @"",
                                     @"code": diagnostic.exceptionCode ?: @"",
                                     @"signal": diagnostic.signal ?: @""
                                 }
                };
                [self reportMetrics:metric];
                
                _sampleCount = 0;
                _curCrashFeature = nil;
                _curFirCrashFeature = nil;
            }
        }
    }
}

#pragma mark - helper

- (void)parseFeatureNameWithData:(NSData *)data isCrash:(BOOL )isCrash {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *callStacks = dictionary[@"callStacks"];
    
    for (int i = 0; i < callStacks.count; i++) {
        NSDictionary *callStack = callStacks[i];
        NSArray *callStackRootFrames = callStack[@"callStackRootFrames"];
        // 崩溃堆栈才有
        NSNumber *threadAttributed = callStack[@"threadAttributed"];
        if (isCrash) {
            if (threadAttributed.boolValue) {
                for (int j = 0; j < callStackRootFrames.count; j++) {
                    NSDictionary *subCallStack = callStackRootFrames[j];
                    NSNumber *offsetIntoBinaryTextSegment = subCallStack[@"offsetIntoBinaryTextSegment"];
                    NSString *binaryName = subCallStack[@"binaryName"];
                    NSNumber *sampleCount = subCallStack[@"sampleCount"];
                    
                    if (sampleCount.integerValue > self.sampleCount && [binaryName containsString:self.bundleName]) {
                        self.curCrashFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                        self.sampleCount = sampleCount.integerValue;
                    }
                    // 取第一行堆栈,以防后面取不到
                    if (j == 0) {
                        self.curFirCrashFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                    }
                    // 是根据 sampleCount 和 binaryName 来寻找的,即使一次匹配到了,后面也需要全部循环完一遍
                    [self checkForSubFrames:subCallStack isCrash:isCrash];
                }
                // 是崩溃堆栈,找完该 callStackRootFrames 直接 return
                return;
            }
        } else {
            for (int j = 0; j < callStackRootFrames.count; j++) {
                NSDictionary *subCallStack = callStackRootFrames[j];
                NSNumber *offsetIntoBinaryTextSegment = subCallStack[@"offsetIntoBinaryTextSegment"];
                NSString *binaryName = subCallStack[@"binaryName"];
                NSNumber *sampleCount = subCallStack[@"sampleCount"];
                
                if (sampleCount.integerValue > self.sampleCount && [binaryName containsString:self.bundleName]) {
                    self.curFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                    self.sampleCount = sampleCount.integerValue;
                }
                // 取第一行堆栈,以防后面取不到
                if (j == 0) {
                    self.curFirFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                }
                // 是根据 sampleCount 和 binaryName 来寻找的,即使一次匹配到了,后面也需要全部循环完一遍
                [self checkForSubFrames:subCallStack isCrash:isCrash];
            }
        }
    }
}

- (void)checkForSubFrames:(NSDictionary *)stackFrame isCrash:(BOOL )isCrash {
    NSArray *subFrames = stackFrame[@"subFrames"];
    if (subFrames && subFrames.count) {
        for (int i = 0; i < subFrames.count; i++) {
            NSDictionary *callStack = subFrames[i];
            NSNumber *offsetIntoBinaryTextSegment = callStack[@"offsetIntoBinaryTextSegment"];
            NSString *binaryName = callStack[@"binaryName"];
            NSNumber *sampleCount = callStack[@"sampleCount"];
            // 非崩溃堆栈
            if (sampleCount.integerValue > self.sampleCount && [binaryName containsString:self.bundleName]) {
                if (isCrash) {
                    self.curCrashFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                } else {
                    self.curFeature = [NSString stringWithFormat:@"%@ + %@", binaryName ?: self.bundleName, offsetIntoBinaryTextSegment];
                }
                self.sampleCount = sampleCount.integerValue;
            }
            // 递归查找
            [self checkForSubFrames:callStack isCrash:isCrash];
        }
    }
}

- (NSString *)getSignalStringWithSignal:(NSInteger )sigNum {
    NSString *signal = self.execptionParams[@(signgam)];
    return signal ?: @"(null)";
}

- (NSString *)getMachExceptionStringWithMachException:(NSInteger )code {
    NSString *exception = self.execptionParams[@(code)];
    return exception ?: @"(null)";
}

- (void)initExceptionData {
    // signal
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGABRT)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGBUS)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGFPE)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGILL)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGPIPE)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGSEGV)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGSYS)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGTRAP)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGEMT)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(SIGKILL)];
    
    // machException
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_BAD_ACCESS)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_BAD_INSTRUCTION)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_ARITHMETIC)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_EMULATION)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_SOFTWARE)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_BREAKPOINT)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_SYSCALL)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_RPC_ALERT)];
    [self.execptionParams addEntriesFromDictionary:NAME_MAPPING(EXC_CRASH)];
}

#pragma mark - getters

- (MXMetricManager *)manager API_AVAILABLE(ios(13.0)) {
    if (!_manager) {
        _manager = [MXMetricManager sharedManager];
    }
    return _manager;
}

- (NSString *)bundleName {
    if (!_bundleName) {
        NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
        _bundleName = bundleInfo[@"CFBundleName"];
    }
    return _bundleName;
}

- (NSMutableDictionary *)execptionParams {
    if (!_execptionParams) {
        _execptionParams = @{}.mutableCopy;
    }
    return _execptionParams;
}
@end
