//
//  MBAPMWhiteScreenAnalysisStrategy.h
//  Pods
//
//  Created by 别施轩 on 2023/8/11.
//

#ifndef MBAPMWhiteScreenAnalysisStrategy_h
#define MBAPMWhiteScreenAnalysisStrategy_h

typedef NS_ENUM(NSUInteger, MBAPMWhiteScreenScenarioType) {
MBAPMWhiteScreenSenarioTypePage = 1, /// 页面开屏白屏场景
};
 
 
typedef void(^MBAPMWhiteScreenCaptureCallback) (BOOL isScaled, UIImage *captureImage, BOOL isWindow);
 
 
/// 白屏检测策略，支持图片检测范围和白色像素最低占比参数
@interface MBAPMWhiteScreenAnalysisStrategy : NSObject
 
 
/// 返回图片上下左右边距设置，单位为像素
@property(nonatomic, assign) UIEdgeInsets detectInsets;
 
 
/// 返回纯色像素点最低占比
@property(nonatomic, assign) double pureColorPixelRatio;
 
@end
 
@interface MBAPMPageviewStepInfo : NSObject
 
 
/// 步骤名称
@property (nonatomic, copy) NSString *name;
 
 
/// 步骤执行的时间点，需要按照yyyy-MM-dd HH:mm:ss进行格式化
@property (nonatomic, copy) NSString *st;
 
/// 步骤执行耗时
@property (nonatomic, assign) NSUInteger duration;
 
 
/// 步骤是否执行成功
@property (nonatomic, assign) NSUInteger success;
 
@end
 
/// 白屏检测协议，支持自定义设置参数和截图方法
@protocol MBAPMWhiteScreenDetectProtocol <NSObject>
 
 
@optional
 
/// 是否开启白屏检测
- (BOOL)mbapm_whiteScreenDetectEnable;
 
/// 返回白屏检测WatchDog超时时间
/// - Parameter scenarioType: 白屏检测场景，不同的场景，超时时间不一样，比如开屏超时时间可以设为10s，后台切前台场景检测的超时时间可以设为3s
- (NSInteger)mbapm_whiteScreenDetectTimeoutDuration:(MBAPMWhiteScreenScenarioType)scenarioType;
 
 
/// 页面截屏方法，支持传入缩放比例，若在截屏时直接支持了缩放则callback返回时isScaled返回YES，则在分析时不再进行采样处理
/// - Parameters:
/// - scaleRatio: 缩放比例
/// - callback: 回调方法，返回isScaled（是否实际进行了缩放）和图片对象
- (void)mbapm_whiteScreenCapture:(double)scaleRatio callback:(MBAPMWhiteScreenCaptureCallback)callback;
 
 
/// 返回自定义分析策略
- (MBAPMWhiteScreenAnalysisStrategy *)mbapm_whiteScreenAnalysisStrategy;
 
 
/// 返回最近发生的影响白屏的关键异常
- (NSString *)occurExceptionType;
 
 
/// 返回白屏前执行的关键步骤
- (NSArray<MBAPMPageviewStepInfo *> *)pageviewExecuteSteps;
 
 
@end

@interface UIViewController (MBAPMWhiteScreenDetect) <MBAPMWhiteScreenDetectProtocol>

@end

#endif /* MBAPMWhiteScreenAnalysisStrategy_h */
