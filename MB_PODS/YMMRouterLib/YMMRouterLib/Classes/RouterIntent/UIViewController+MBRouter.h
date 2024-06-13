//
//  UIViewController+MBRouter.h
//  YMMRouterLib
//
//  Created by xp on 2022/11/9.
//

#import <Foundation/Foundation.h>
#import "YMMRouter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBRouterNavPageProtocol <NSObject>

///  接收页面回传数据
/// @param resultData 需要回传的数据
/// @param error 错误
- (void)mbrouter_onResult:(id)resultData withError:(NSError *)error;


/// 接收页面回传数据，支持requestId
/// @param resultData  需要回传的数据
/// @param error 错误信息
/// @param requestId 页面跳转时传入的requestId
- (void)mbrouter_onResult:(id)resultData withError:(NSError *)error withRequestId:(nullable NSString *)requestId;


/// 路由二次打开页面时回调此方法
/// @param params 路由参数
- (void)mbrouter_onNewIntent:(NSDictionary *)params;

@end


/// 用于UIViewController跳转时向目标页传递参数和回传数据到原页面的callBack
/// 通过路由给UIViewController注入MBRouterIntent原理如下：
///   1.给YMMRouterTable增加Category方法enableAutoInjectIntentToVC，并将开关状态记录在autoInjectIntent属性中；
///   2.YMMRouter通过YMMRouterHandlerFileter匹配YMMRouterTable，判断匹配到的YMMRouterTable的autoInjectIntent属性，并将此属性状态传递给YMMRouterResponse增加的category属性needAutoInjectIntent；
///   3.增加MBRouterResultInterceptor拦截器，在routerDidHandle中判断reponse status为YMMRouterStatusSuccess，result为UIViewController及其子类且needAutoInjectIntent为YES时，通过request params和handleBlock构建MBRouterIntent，并注入到result对应的ViewController中。
@interface MBRouterIntent: NSObject


/// 回传数据到原页面的callBack
@property (nonatomic, copy) HandleBlock mbRouterResultBlock;


/// 通过MBNav发起页面调整的回调callBack
@property (nonatomic, copy) MBNavHandleBlock mbNavResultBlock;


/// 传递到目标页面的参数
@property (nonatomic, copy) NSDictionary *params;


/// 回传到上个页面的数据
@property (nonatomic, copy, nullable) id resultData;


/// 是否已回传数据，在一个页面可见周期内只能回传一次
@property (nonatomic, assign) BOOL hasCallbackResult;


///  路由请求唯一标记ID
@property (nonatomic, copy, nullable) NSString *requestId;


@end


/// 提供页面跳转Intent的传递和获取，以及数据回传的触发
@interface UIViewController(MBRouter)


/// 设置页面跳转Intent
/// @param intent
- (void)mbrouter_setIntent:(MBRouterIntent * _Nullable)intent;


/// 获取页面跳转Intent
- (MBRouterIntent *)mbrouter_getIntent;


/// 触发目标页面数据回传，只有在目标页面设置了intent且intent中HandleBlock不会nil的情况下原页面才能收到回调
/// @param resultData 回传数据，发生异常即error不为nil的情况下resultData为nil
/// @param error 页面跳转错误信息
- (void)mbrouter_setResult:(id)resultData withError:(NSError * _Nullable)error;



/// 通过路由二次打开时更新Intent
/// @param intent 路由跳转相关参数
- (void)mbrouter_setNewIntent:(MBRouterIntent * _Nullable)intent;


/// 页面退出
- (void)mbrouter_onExit;


/// 页面展示
- (void)mbrouter_onShow;


@end

NS_ASSUME_NONNULL_END
