//
//  MBNavTransitionBuilder.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import <Foundation/Foundation.h>
#import "MBNavPageInfo.h"
#import "MBNavTransition.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN


/// 页面切换任务构造器，外部调用通过builder构建页面切换任务，然后加入队列中依次执行
@interface MBNavTransitionBuilder : NSObject

@property (nonatomic, strong) MBNavBaseTransition *transition;


/// 执行start方法后会将transitionBuilder加入队列中，若当前没有任务在执行，则立马执行。
- (void)start;

/// 执行start方法后会将transitionBuilder加入队列中，若当前没有任务在执行，则立马执行，并通过completion接收页面切换结束回调
- (void)start:(MBNavTransitionCompletion)completion;


/// 设置App根导航VC，暂未使用
/// - Parameter rootVC: App根导航VC
- (void)root:(UINavigationController *)rootVC;


/// 设置App当前VC，在执行push、pop和popUtil操作中会使用
/// - Parameter currentVC: 当前VC
- (void)current:(UIViewController *)currentVC;


/// 跳转页面，能够根据不同的options和flags实现不同的页面切换效果
/// - Parameters:
///   - url: 页面路由地址
///   - options: 配置选项，主要控制是在UINavigationController上push二级页面还是presenter弹窗页面、弹窗透明属性和是否展示动画等
///   - flags: 标识发生页面跳转时页面栈的处理模式
///   - params: 参数
- (void)push:(NSString *)url options:(MBNavParameterOptions)options flags:(MBNavParameterFlags)flags params:(NSDictionary * __nullable)params;


/// 回退页面，能够自动识别当前页面是push还是presenter，通过pop或dismiss回退页面
/// - Parameters:
///   - delta: 回退的页面个数，只pop当前页面则delta为1，pop非当前页面时delta可以通过getAppPageStacks获取到全局页面栈后进行匹配获取
///   - options: 配置选项，支持MBNavParameterOptionsAnimated和MBNavParameterOptionsPopNav
- (void)pop:(NSUInteger)delta options:(MBNavParameterOptions)options;


/// 回退页面，能够自动识别当前页面是push还是presenter，通过pop或dismiss回退页面，与pop的差异在于直接通过url在全局页面栈中匹配对应页面
/// - Parameters:
///   - url: 路由url
///   - options:配置选项，支持MBNavParameterOptionsAnimated和MBNavParameterOptionsPopNav
///   - params: 路由参数
- (void)popUtil:(NSString *)url options:(MBNavParameterOptions)options params:(NSDictionary * __nullable)params;


/// 回退页面，保留当前naviVC前N个VC
/// - Parameters:
///   - delta: 保留的页面个数
///   - options: 配置选项
- (void)popKeepN:(NSUInteger)delta options:(MBNavParameterOptions)options;

/// 添加子页面数据，针对跨端技术栈单页面存在多个跨端页面场景需要维护子页面数据
/// - Parameter childPages: 子页面列表
- (void)childPages:(NSArray<MBNavContainerInnerPageInfo *> *)childPages;


/// action延时执行时间，delay方法需要在push、pop、popUtil方法调用之后，针对前一个方法进行延时
/// - Parameter delta: 与当前时间的时间差
- (void)delay:(int64_t)delta;


///  设置页面返回回传数据callback
/// - Parameter callback: 回传数据callback
- (void)popBackResultCallback:(MBNavTransitionOnResultCallback)callback;


/// 回传数据给上个页面
/// - Parameters:
///   - data:需要回传的数据，当error不为nil是data应返回nil
///   - error:发生的错误
- (void)setResult:(id __nullable)data withError:(NSError * __nullable)error;

- (void)setResult:(id __nullable)data withError:(NSError * __nullable)error withRequestId: (NSString * __nullable) requestId;


/// 页面切换流程唯一请求标记ID，在transition生成时生成requestId
- (NSString *)transitionRequestId;


@end

NS_ASSUME_NONNULL_END

