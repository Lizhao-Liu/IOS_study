//
//  YMMRouter+SetResult.m
//  YMMRouterLib
//
//  Created by xp on 2022/11/9.
//

#import "YMMRouter+SetResult.h"
#import "YMMRouterFilterChain.h"
#import "UIViewController+MBRouter.h"
#import "YMMRouterHandlerFilter.h"
#import <objc/runtime.h>

@interface YMMRouterConfig(SetResult)

@end

@implementation YMMRouterConfig(SetResult)

- (NSArray<NSString *> *)autoInjectIntentWhiteClassNameList {
    return objc_getAssociatedObject(self, @selector(autoInjectIntentWhiteClassNameList));
}

- (void)setAutoInjectIntentWhiteClassNameList:(NSArray<NSString *> *)autoInjectIntentWhiteClassNameList {
    objc_setAssociatedObject(self, @selector(autoInjectIntentWhiteClassNameList), autoInjectIntentWhiteClassNameList, OBJC_ASSOCIATION_COPY);
}

- (BOOL)globalEnableAutoInjectIntent {
    return [objc_getAssociatedObject(self, @selector(globalEnableAutoInjectIntent)) boolValue];
}

- (void)setGlobalEnableAutoInjectIntent:(BOOL)autoInjectIntent {
    objc_setAssociatedObject(self, @selector(globalEnableAutoInjectIntent), @(autoInjectIntent), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface YMMRouterTable(SetResult)

@property (nonatomic, assign) BOOL autoInjectIntent;

@end

@implementation YMMRouterTable(SetResult)

- (void)enableAutoInjectIntentToVC {
    self.autoInjectIntent = YES;
}



#pragma mark - Property Method

- (BOOL)autoInjectIntent {
    return objc_getAssociatedObject(self, @selector(autoInjectIntent));
}

- (void)setAutoInjectIntent:(BOOL)autoInjectIntent {
    objc_setAssociatedObject(self, @selector(autoInjectIntent), @(autoInjectIntent), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface YMMRouterHandlerFilter(SetResult)

@end



@implementation YMMRouterHandlerFilter(SetResult)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)routerTableDidMatched:(id<YMMRouterRoutable>)routable response:(YMMRouterResponse *)response table:(YMMRouterTable *)table {
    if (table.autoInjectIntent) {
        if (response.status == YMMRouterStatusSuccess) {
            response.needAutoInjectIntent = YES;
        }
    }
}
#pragma clang diagnostic pop

@end



@interface YMMRouterResponse(SetResult)


@end

@implementation YMMRouterResponse(SetResult)


#pragma mark - Property Method

- (BOOL)needAutoInjectIntent {
    return objc_getAssociatedObject(self, @selector(needAutoInjectIntent));
}

- (void)setNeedAutoInjectIntent:(BOOL)needAutoInjectIntent {
    objc_setAssociatedObject(self, @selector(needAutoInjectIntent), @(needAutoInjectIntent), OBJC_ASSOCIATION_ASSIGN);
}


@end

@interface MBRouterResultInterceptor()

@end

@implementation MBRouterResultInterceptor

- (BOOL)routerShouldHandle:(id<YMMRouterRoutable>)routable {
    return YES;
}

- (void)routerDidHandle:(id<YMMRouterRoutable>)routable response:(YMMRouterResponse *)response {
    if (response.status == YMMRouterStatusSuccess && response.result && [response.result isKindOfClass:[UIViewController class]]) {
        UIViewController *targetVC = (UIViewController *)response.result;
        BOOL globalEnable = [YMMRouterConfigManager getConfig].globalEnableAutoInjectIntent;
        NSArray<NSString *> *whilteClassNameList = [YMMRouterConfigManager getConfig].autoInjectIntentWhiteClassNameList;
        if (whilteClassNameList && whilteClassNameList.count > 0 && ![whilteClassNameList containsObject:NSStringFromClass(targetVC.class)]) {
            globalEnable = NO;
        }
        if (response.needAutoInjectIntent || globalEnable) {
            MBRouterIntent *intent = [MBRouterIntent new];
            if ([routable respondsToSelector:@selector(handleBlock)]) {
                if (routable.handleBlock) {
                    intent.mbRouterResultBlock = routable.handleBlock;
                }
            }
            intent.params = routable.params;
            if ([routable respondsToSelector:@selector(requestId)]) {
                intent.requestId = [routable performSelector:@selector(requestId)];
            }
            if ([routable respondsToSelector:@selector(navHandleBlock)]) {
                if (routable.navHandleBlock) {
                    intent.mbNavResultBlock = routable.navHandleBlock;
                }
            }
            [targetVC mbrouter_setIntent:intent];
        } else {
            [targetVC mbrouter_setIntent:nil];
        }
    }
}


@end


