//
//  YMMRouter+SetResult.h
//  YMMRouterLib
//
//  Created by xp on 2022/11/9.
//

#import <Foundation/Foundation.h>
#import "YMMRouter.h"
#import "YMMRouterResponse.h"
#import "YMMRouterCenter.h"
#import "YMMRouterConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterConfig(SetResult)

@property (nonatomic, assign) BOOL globalEnableAutoInjectIntent;

@property (nonatomic, copy) NSArray<NSString *> *autoInjectIntentWhiteClassNameList;

@end


@interface YMMRouterTable(SetResult)


/// 开启自动注入MBRouterIntent到目标ViewController中，方便在目标ViewController中获取路由参数和回调HandleBlock
- (void)enableAutoInjectIntentToVC;

@end

@interface YMMRouterResponse(SetResult)


/// 路由request被routerTable匹配成功后将routerTable是否自动注入MBRouterIntent的开关状态赋值给response
@property (nonatomic, assign) BOOL needAutoInjectIntent;

@end


/// 对路由匹配结果进行拦截，若reponse的needAutoInjectIntent属性为YES且responsed的result为UIViewController及其子类则自动注入MBRouterIntent
@interface MBRouterResultInterceptor : NSObject <YMMRouterCenterInterceptorProtocol>

@end

NS_ASSUME_NONNULL_END
