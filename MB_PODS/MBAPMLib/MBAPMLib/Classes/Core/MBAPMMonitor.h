//
//  MBAPMMonitor.h
//  MBAPMLib
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;
@class MBAPMMetric;
@class MBAPMAppLaunchTimeModel;
@class MBAPMMemoryMonitor;
@import MBLauncherLib;
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

#define MBAPM_LAUNCH_SECTION_BEGIN($sectionName) \
[[[MBAPMMonitor sharedInstance]getAppLaunchTrack]beginIsolatedSection:$sectionName withExtra:nil];

#define MBAPM_LAUNCH_SECTION_END($sectionName) \
[[[MBAPMMonitor sharedInstance]getAppLaunchTrack]endIsolatedSection:$sectionName withExtra:nil];


typedef void(^MBAPMLaunchTimeCallback)( MBAPMAppLaunchTimeModel * _Nonnull launchTimeModel); // 获取启动耗时callback


@protocol MBAPMDelegate <NSObject> 

@optional

/// 传入在metric上报时需要携带的数据，可以通过performanceType来判断指标的类型, 返回的NSDictionary中的数据必须可序列化
/// @param metric 指标
- (NSDictionary * __nullable)attachmentForMetric:(MBAPMMetric * __nullable)metric;


///// 在metric指标发生时会回调
///// @param metric 指标
//- (void)reportMetric:(MBAPMMetric * __nonnull)metric;

@end

@interface MBAPMMonitor : NSObject

/// 初始化方法，需要在监控指标之前调用
+ (void)startMonitor:(MBAPMConfiguration *)configuration;

+ (instancetype)sharedInstance;

/// 是否开启页面耗时分析
+ (void)enableRenderMonitor:(BOOL)enable;


///开启自定义app启动结束点，此方法必须在applicationDidFinishLaunching方法中或之前调用
+ (void)enableCustomLaunchEnding;


///  开始启动
/// - Parameter launchMode: 启动模式
+ (void)startAppLaunch:(MBLaunchMode)launchMode launchTags:(NSDictionary *)tags;

/// 启动结束，在自定义启动结束点需要调用此方法，否则无法统计启动时间
+ (void)endAppLaunch;

/// 内存 Monitor
- (MBAPMMemoryMonitor *)memoryMonitor;

/// 设置apm代理协议
/// 1.负责从外部获取自定义数据
/// 2.抛出metric指标
- (void)setDelegate:(id<MBAPMDelegate>)delegate;

/// 获取AppLaunch耗时检测的Track，用于手动插入分段耗时
- (id<MBAPMEventTimeTrack>)getAppLaunchTrack;

/// 获取App启动耗时数据模型
/// 注意：此方法在主页ViewController viewDidAppear之后才能获取到数据
- (MBAPMAppLaunchTimeModel *)getAppLaunchTime;


/// 异步获取App启动耗时
/// @param callback 回调block
- (void)aysncGetAppLaunchTime:(_Nonnull MBAPMLaunchTimeCallback)callback;


/// 手动页面渲染耗时埋点，支持插入自定义中间分段节点
/// @param viewPage MBAPM页面协议
/// @return id<MBAPMEventTrack>  事件耗时跟踪协议
- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage;

/// 手动页面渲染耗时埋点，支持插入自定义中间分段节点
/// @param viewPage MBAPM页面协议
/// @return id<MBAPMEventTrack>  事件耗时跟踪协议
- (id<MBAPMEventTimeTrack>)startPageRenderTrack:(id<MBAPMViewPageProtocol>)viewPage;

/// 增加页面加载耗时检测页面黑名单
/// @param pageClassNameList 页面className列表
- (void)addRenderDetectBlockList:(NSArray<NSString *> *)pageClassNameList;


/// 追踪 app 埋点数据
/// @param event 埋点数据
/// @param context 埋点上下文
+ (void)trackDoctorEvent:(__kindof id<MBDoctorEventProtocol>)event context:(__kindof id<MBContextProtocol>)context;

@end

NS_ASSUME_NONNULL_END
