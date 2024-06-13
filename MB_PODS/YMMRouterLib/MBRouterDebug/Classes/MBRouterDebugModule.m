//
//  MBRouterDebugModule.m
//  MBRouterDebug
//
//  Created by xp on 2022/11/10.
//

#import "MBRouterDebugModule.h"
#import "MBRouterDebugRouterHandler.h"
@import YMMRouterLib;

@moduleEX(MBRouterDebugModule)

+ (nonnull NSString *)moduleName {
    return @"app";
}

+ (NSString *)subModuleName {
    return @"MBRouterDebug";
}

- (NSArray<YMMRouter *> *) routers {
    
    NSArray *defaultSchemes = @[@"ymm", @"ymm-driver", @"ymm-consignor", @"wlqq", @"wlqq.driver", @"wlqq.consignor", @"wlqq.consignor.launch"];
    
    YMMRouter *appRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                  hostPattern:@"app"];
    MBRouterDebugRouterHandler *handler = [MBRouterDebugRouterHandler new];
    YMMRouterTable *appTable = [[YMMRouterTable alloc] init];
    [appTable enableAutoInjectIntentToVC];
    [appTable registerHandler:handler forPathPattern:@"/debug/router_setresult"];
    [appRouter addRouterTable:appTable];
    
    return @[appRouter];
}


@end
