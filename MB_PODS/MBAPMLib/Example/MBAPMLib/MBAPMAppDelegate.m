//
//  MBAPMAppDelegate.m
//  MBAPMLib
//
//  Created by seal on 07/14/2020.
//  Copyright (c) 2020 seal. All rights reserved.
//

#import "MBAPMAppDelegate.h"

@import MBAPMServiceLib;
@import MBFoundation;
@import MBAPMDebug;
@import MBAPMLib;

@interface MBAPMAppDelegate () <MBAPMDelegate>

@end

@implementation MBAPMAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MBToolsManager setupWithCompany:NO];
    
//    MBAPMConfiguration *apmConfig = [[MBAPMConfiguration alloc]init];
//    apmConfig.enableCrashMonitor = YES;
//
//    [MBAPMMonitor startMonitor:apmConfig];
    
    MBAPMConfiguration *apmConfig = [MBAPMConfiguration new];
    apmConfig.env = MBAPMEnvDebug;
    apmConfig.enableLagMonitor = YES;
    apmConfig.lagChannel = MBAPMReportChannelMatrix;
    apmConfig.enableCrashMonitor = YES;
    apmConfig.enableDataGather = YES;
    apmConfig.renderDetectBlockList = @[@"MBAPMPageRenderManualVC"];
    MBAPMZombieConfig *config = [MBAPMZombieConfig new];
    config.crashedWhenDetectZombie = YES;
    config.traceDeallocStack = YES;
    config.maxOccupyMemorySize = 10 * 1024;
    config.detectStrategy = MBAPMZombieDetectStrategyWhiteList;
    config.whiteList = @[@"MBAPMPageRenderMetric", @"MBAPMPageRenderManualVC", @"__NSDictionaryM"];
    config.blackList = @[@"MBAPMThreadStack"];
    apmConfig.zombieConfig = config;
    
    
    WCCrashBlockMonitorConfig *crashBlockConfig = [[WCCrashBlockMonitorConfig alloc] init];
    crashBlockConfig.enableCrash = YES;
    crashBlockConfig.enableBlockMonitor = YES;
//    crashBlockConfig.blockMonitorDelegate = self;
    crashBlockConfig.reportStrategy = EWCCrashBlockReportStrategy_All;
//    crashBlockConfig.onAppendAdditionalInfoCallBack = mbapm_crashAddAdditionalData;
    WCBlockMonitorConfiguration *blockMonitorConfig = [WCBlockMonitorConfiguration defaultConfig];
    blockMonitorConfig.runloopTimeOut = 3 * BM_MicroFormat_Second; //判定卡顿主循环时间2 * BM_MicroFormat_Second;
    blockMonitorConfig.checkPeriodTime = 1 * BM_MicroFormat_Second; //检查周期1 * BM_MicroFormat_Second;
    blockMonitorConfig.bMainThreadHandle = YES;//是否从主线程获取最耗时堆栈
    blockMonitorConfig.perStackInterval = g_defaultPerStackInterval;//从主线程获取堆栈的间隔
    blockMonitorConfig.mainThreadCount = g_defaultMainThreadCount;//保存的线程个数
    blockMonitorConfig.limitCPUPercent = g_defaultCPUUsagePercent;//cpu百分比警告线
    blockMonitorConfig.bPrintCPUUsage = NO;
    blockMonitorConfig.bGetCPUHighLog = NO;

    blockMonitorConfig.bGetPowerConsumeStack = YES;//功耗堆栈
    blockMonitorConfig.powerConsumeStackCPULimit = g_defaultPowerConsumeCPULimit;//功耗堆栈警告线
    blockMonitorConfig.bFilterSameStack = NO;//启用在一天内过滤相同的堆栈
    blockMonitorConfig.triggerToBeFilteredCount = 10;//在一天内过滤相同的堆栈个数
    blockMonitorConfig.bPrintMemomryUse = NO;
    blockMonitorConfig.bEnableLocalSymbolicate = YES;//本地符号化
    
//    WCFPSMonitorPlugin *fpsMonitorPlugin = [[WCFPSMonitorPlugin alloc] init];
//    [_curBuilder addPlugin:fpsMonitorPlugin]; // add fps monitor.
    
    crashBlockConfig.blockMonitorConfiguration = blockMonitorConfig;
    
    
    WCCrashBlockMonitorPlugin *crashBlockPlugin = [[WCCrashBlockMonitorPlugin alloc] init];
    crashBlockPlugin.pluginConfig = crashBlockConfig;
    
    
    MatrixBuilder *_curBuilder = [[MatrixBuilder alloc] init];
    [_curBuilder addPlugin:crashBlockPlugin];
    
    [[Matrix sharedInstance] addMatrixBuilder:_curBuilder];
    
    
    [crashBlockPlugin start];
    
    
    [MBAPMMonitor startMonitor:apmConfig];
    [MBAPMMonitor enableRenderMonitor:YES];
    
    [[MBAPMMonitor sharedInstance]setDelegate:self];
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MBAPMDebugViewController *debugMainVC = [MBAPMDebugViewController new];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:debugMainVC];
//    [debugMainVC.navigationController setNavigationBarHidden:YES animated:NO];
    [_window setRootViewController:navigationVC];
    [_window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
