//
//  UIViewController+MBNav.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import "UIViewController+MBNav.h"
#import "MBRouterLogger.h"
#import "MBNavTransitionBuilder_Private.h"
#import "MBNavContainerTransitionBuilder.h"
#import <objc/runtime.h>
@import MBFoundation;

@interface UIViewController(MBNav)

@end

@implementation UIViewController(MBNav)


#pragma mark - Property Methods

- (MBNavPageInfo *)mbNavPageInfo {
    return objc_getAssociatedObject(self, @selector(mbNavPageInfo));
}

- (void)setMbNavPageInfo:(MBNavPageInfo *)mbNavPageInfo {
    objc_setAssociatedObject(self, @selector(mbNavPageInfo), mbNavPageInfo, OBJC_ASSOCIATION_RETAIN);
}

- (void)mbnav_onResult:(nonnull id)resultData withError:(nonnull NSError *)error {
    MBRouterInfo(@"MBNav container receive onResult %@", resultData);
    MBNavTransitionBuilder *builder = [MBNavContainerTransitionBuilder new];
    [builder build];
    [builder current:self];
    [builder setResult:resultData withError:error];
    [builder start:^{
        MBRouterInfo(@"MBNav container onResult finish");
    }];
}

- (void)mbnav_onResult:(id)resultData withError:(NSError *)error withRequestId:(NSString *)requestId {
    MBRouterInfo(@"MBNav container receive onResult %@, requestId = %@", resultData, requestId);
    MBNavTransitionBuilder *builder = [MBNavContainerTransitionBuilder new];
    [builder build];
    [builder current:self];
    [builder setResult:resultData withError:error withRequestId:requestId];
    [builder start:^{
        MBRouterInfo(@"MBNav container onResult finish");
    }];
}

- (void)mbnav_popN:(NSUInteger)delta complete:(nonnull void (^)(BOOL))complete{
    MBRouterInfo(@"MBNav container run  popN delta = %lu", delta);
    MBNavTransitionBuilder *builder = [MBNavContainerTransitionBuilder new];
    [builder build];
    [builder current:self];
    [builder pop:delta options:MBNavParameterOptionsHidden];
    [builder start:^{
        MBRouterInfo(@"MBNav container run popN complete delta = %lu", delta);
        if (complete) {
            complete(YES);
        }
    }];
}

//- (void)stopRenderComplete:(nonnull void (^)(BOOL))complete {
//    // 需要子类复写此方法
//    MBRouterInfo(@"MBNav container stop render");
//}

@end
