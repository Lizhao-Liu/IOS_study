//
//  MBBridgeContainer.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBBridgeContainerListener;
@protocol MBContainerWindowInfo;
@protocol MBContainerOperation;
@protocol MBPageContainerOperation;

@protocol MBBridgeContainer <NSObject>

@optional
/**
 * 添加容器状态监听
 
 * @param listener 监听器对象
 * @param key 唯一标识，建议为className+methodName，可以为空
 */
- (void)addContainerListener:(MBBridgeContainerListener *)listener
                      unique:(nullable NSString *)key;

/**
 * 用于容器回调方法
 
 * @param methodId 方法标识，可以是方法名或其它标识
 * @param params 参数
 */
- (void)call:(NSString *)methodId params:(nullable NSDictionary *)params;

/**
 * 获取容器window信息协议实例
 */
- (id<MBContainerWindowInfo>)getWindowInfo;

/**
 * 操作容器对象实例
 * 页面操作：MBPageContainerOperation
 * Dialog操作：待定
 * ......
 */
- (id<MBContainerOperation>)opertionInstance;

/**
 * 获取容器视图
 
 * @return 视图, 使用侧注意不要强引用, 否则会有内存无法释放风险
 */
- (UIView *)containerView;

/**
 * 获取容器vc控制器
 
 * @return 控制器, 使用侧注意不要强引用, 否则会有内存无法释放风险
 */
- (UIViewController *)containerViewController;

@end

@protocol MBContainerOperation <NSObject>

@end


@protocol MBPageContainerOperation <MBContainerOperation>

@optional
/// 设置状态栏风格,
/// @param isDark YES: light style, NO: dark style
/// @return YES 设置成功，NO 设置失败
- (BOOL)setPageStatusBarFrontStyle:(BOOL)isLight;
/// 设置沉浸式,
/// @param isImmersive YES: 沉浸式 NO: 标准模式
/// @return YES 设置成功，NO 设置失败
- (BOOL)setPageImmersiveMode:(BOOL)isImmersive;

@end


@protocol MBContainerWindowInfo <NSObject>
/// 容器窗口宽度单位px
- (CGFloat)getWindowWidth;
/// 容器窗口高度单位px
- (CGFloat)getWindowHeight;
/// 容器窗口真实安全区域单位px
- (UIEdgeInsets)getSafeAreaMargins;

@end

/**
 容器事件监听
 */
typedef void(^DeallocBlock)(void);

@interface MBBridgeContainerListener : NSObject

@property (nullable, nonatomic, copy, readonly) DeallocBlock deallocBlock;


/**
 添加监听-销毁
 
 @param deallocBlock dealloc
 */
+ (MBBridgeContainerListener *)listenDealloc:(nullable DeallocBlock)deallocBlock;

@end


NS_ASSUME_NONNULL_END
