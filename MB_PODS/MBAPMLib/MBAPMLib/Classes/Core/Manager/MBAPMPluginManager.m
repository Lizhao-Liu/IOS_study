//
//  MBAPMPluginManager.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMPluginManager.h"
#import "MBAPMPluginBuilder.h"
#import "MBAPMRenderMonitor.h"
#import "MBAPMPluginConfig.h"
#import "MBAPMAppLaunchMonitor.h"
#import "MBAPMLagMonitor.h"
#import "MBAPMCrashMonitor.h"
#import "MBAPMMemoryMonitor.h"
#import "MBAPMWakeupsMonitor.h"
#import "MBAPMMatrixPlugin.h"
#import "MBAPMCpuMonitor.h"
#import "MBAPMCpuMonitorConfig.h"
#import "MBAPMMetricMonitor.h"
#import "MBAPMFPSMonitor.h"
#import "MBAPMWhiteScreenMonitor.h"
#import "MBAPMStorageMonitor.h"
#import "MBAPMStorageMonitorConfig.h"
#import "MBAPMDataMonitor.h"

@interface MBAPMPluginManager() <MBAPMPluginListenerDelegate>

@property (nonatomic, strong) MBAPMPluginBuilder  *pluginBuilder;
@property (nonatomic, strong) MBAPMContext *context;

@end

@implementation MBAPMPluginManager

static MBAPMPluginManager *sharedInstance = nil;

+ (instancetype)initWithContext:(MBAPMContext *)context {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MBAPMPluginManager alloc]initWithContext:context];
    });
    return sharedInstance;
}

+ (instancetype)shared {
    return sharedInstance;
}

- (instancetype)initWithContext:(MBAPMContext *)context {
    if(self = [super init]) {
        _context = context;
        [self addDefaultPlugins];
    }
    return self;
}

- (MBAPMPlugin *)getPlugin:(MBAPMPluginTag)pluginTag {
    return [self getPluginByTag:pluginTag];
}

- (void)enablePlugin:(BOOL)enable withTag:(MBAPMPluginTag)pluginTag{
    MBAPMPlugin *plugin = [self getPluginByTag:pluginTag];
    if(plugin) {
        plugin.config.isEnable = enable;
    }
}

- (void)startPlugins {
    NSArray<MBAPMPlugin *> *plugins = [self.pluginBuilder getPlugins].copy;
    if(plugins) {
        for(MBAPMPlugin *plugin in plugins) {
            if(!plugin.config.isEnable) {
                continue;
            }
            SEL selector = @selector(isSelfStart);
            if([plugin respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[plugin class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:plugin];
                [invocation invoke];
                BOOL startBySelf;
                [invocation getReturnValue:&startBySelf];
                if(startBySelf) {
                    continue;
                }
            }
            [plugin start];
        }
    }
}

#pragma mark - private method

- (void)addDefaultPlugins {
    //添加页面加载耗时插件
    MBAPMRenderMonitor *renderMonitor = [[MBAPMRenderMonitor alloc]init];
    MBAPMPluginConfig *renderMonitorConfig = [[MBAPMPluginConfig alloc]init];
    renderMonitorConfig.isEnable = YES;
    renderMonitor.context = self.context;
    renderMonitor.config = renderMonitorConfig;
    [self.pluginBuilder addPlugin:renderMonitor];
    //添加App启动耗时插件
    MBAPMAppLaunchMonitor *appLaunchMonitor = [MBAPMAppLaunchMonitor shareInstance];
    MBAPMPluginConfig *appLaunchMonitorConfig = [[MBAPMPluginConfig alloc]init];
    appLaunchMonitorConfig.isEnable = YES;
    appLaunchMonitor.context = self.context;
    appLaunchMonitor.config = appLaunchMonitorConfig;
    [self.pluginBuilder addPlugin:appLaunchMonitor];
    //检查Matrix插件
    MBAPMMatrixPlugin *matrixPlugin = [[MBAPMMatrixPlugin alloc]init];
    MBAPMPluginConfig *matrixPluginConfig = [[MBAPMPluginConfig alloc]init];
    matrixPluginConfig.isEnable = YES;
    matrixPlugin.config = matrixPluginConfig;
    matrixPlugin.context = self.context;
    [self.pluginBuilder addPlugin:matrixPlugin];
    //添加卡顿监控插件
    MBAPMLagMonitor *lagMonitor = [[MBAPMLagMonitor alloc]init];
    MBAPMPluginConfig *lagMonitorConfig = [[MBAPMPluginConfig alloc]init];
    lagMonitorConfig.isEnable = self.context.configuration.enableLagMonitor;
    lagMonitor.context = self.context;
    lagMonitor.config = lagMonitorConfig;
    lagMonitor.channel = self.context.configuration.lagChannel;
    [self.pluginBuilder addPlugin:lagMonitor];
    //添加崩溃监控插件
    MBAPMCrashMonitor *crashMonitor = [[MBAPMCrashMonitor alloc]init];
    MBAPMPluginConfig *crashPluginConfig = [[MBAPMPluginConfig alloc]init];
    crashPluginConfig.isEnable = self.context.configuration.enableCrashMonitor;
    crashMonitor.context = self.context;
    crashMonitor.config = crashPluginConfig;
    [self.pluginBuilder addPlugin:crashMonitor];
    
#if TARGET_IPHONE_SIMULATOR
#else
    //添加内存监控插件
    MBAPMMemoryMonitor *memoryMonitor = [[MBAPMMemoryMonitor alloc]init];
    MBAPMPluginConfig *memoryPluginConfig = [[MBAPMPluginConfig alloc]init];
    memoryPluginConfig.isEnable = self.context.configuration.enableMemoryMonitor;
    memoryMonitor.context = self.context;
    memoryMonitor.config = memoryPluginConfig;
    [self.pluginBuilder addPlugin:memoryMonitor];
#endif
    //添加 CPU 监控插件
    MBAPMCpuMonitor *cpuMonitor = [[MBAPMCpuMonitor alloc] init];

    MBAPMCpuMonitorConfig *cpuPluginConfig = [[MBAPMCpuMonitorConfig alloc] initWithConfigDictionary:self.context.configuration.cpuConfigDictionary];
    cpuMonitor.cpuConfig = cpuPluginConfig;

    MBAPMPluginConfig *cpuConfig = [[MBAPMPluginConfig alloc] init];
    cpuMonitor.config = cpuConfig;
    cpuMonitor.config.isEnable = YES;
    cpuMonitor.context = self.context;
    [self.pluginBuilder addPlugin:cpuMonitor];
    
    // 添加流量监控插件
    MBAPMDataMonitor *trafficMonitor = [[MBAPMDataMonitor alloc] init];
    
    MBAPMDataMonitorConfig *trafficConfig = [[MBAPMDataMonitorConfig alloc] init];
    trafficConfig.isEnable = self.context.configuration.enableNetTraffic;
    trafficMonitor.trafficConfig = trafficConfig;
    
    MBAPMPluginConfig *trafficPluginConfig = [[MBAPMPluginConfig alloc] init];
    trafficPluginConfig.isEnable = YES;
    trafficMonitor.config = trafficPluginConfig;

    trafficMonitor.context = self.context;
    [self.pluginBuilder addPlugin:trafficMonitor];
    
    // 添加苹果的 metric
    MBAPMMetricMonitor *metricMonitor = [[MBAPMMetricMonitor alloc] init];
    MBAPMPluginConfig *metricPluginConfig = [[MBAPMPluginConfig alloc]init];
    metricPluginConfig.isEnable = self.context.configuration.enableMetricMonitor;
    metricMonitor.context = self.context;
    metricMonitor.config = metricPluginConfig;
    [self.pluginBuilder addPlugin:metricMonitor];
    
    MBAPMFPSMonitor *fpsMonitor = [[MBAPMFPSMonitor alloc] init];
    MBAPMPluginConfig *fpsPluginConfig = [[MBAPMPluginConfig alloc]init];
    fpsPluginConfig.isEnable = self.context.configuration.enableFPSMonitor;
    fpsMonitor.config = fpsPluginConfig;
    fpsMonitor.context = self.context;
    [self.pluginBuilder addPlugin:fpsMonitor];
    
    MBAPMWhiteScreenMonitor *whiteScreenMonitor = [[MBAPMWhiteScreenMonitor alloc] init];
    MBAPMPluginConfig *whiteScreenPluginConfig = [[MBAPMPluginConfig alloc]init];
    whiteScreenPluginConfig.isEnable = YES;//self.context.configuration.enableWhiteScreenMonitor;
    whiteScreenMonitor.config = whiteScreenPluginConfig;
    whiteScreenMonitor.context = self.context;
    [self.pluginBuilder addPlugin:whiteScreenMonitor];
    
    MBAPMStorageMonitor *storageMonitor = [[MBAPMStorageMonitor alloc]init];
    storageMonitor.config = self.context.configuration.storageMonitorConfig;
    storageMonitor.context = self.context;
    [self.pluginBuilder addPlugin:storageMonitor];
    
    // 添加wakeups监控插件
    MBAPMWakeupsMonitor *wakeupsMonitor = [[MBAPMWakeupsMonitor alloc] init];
    wakeupsMonitor.context = self.context;
    MBAPMWakeupsMonitorConfig *wakeupsMonitorConfig = self.context.configuration.wakeupsMonitorConfig ?: [MBAPMWakeupsMonitorConfig new];
    wakeupsMonitor.config = wakeupsMonitorConfig;
    [self.pluginBuilder addPlugin:wakeupsMonitor];
} 

- (MBAPMPlugin *)getPluginByTag:(MBAPMPluginTag)pluginTag {
    return [self.pluginBuilder getPlugin:pluginTag];
}

#pragma mark - property method

- (MBAPMPluginBuilder *)pluginBuilder {
    if(!_pluginBuilder) {
        _pluginBuilder = [[MBAPMPluginBuilder alloc]init];
        _pluginBuilder.pluginListener = self;
    }
    return _pluginBuilder;
}

@end
