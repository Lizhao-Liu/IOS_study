//
//  HCBCodeScannerModule.m
//  HCBCodeScaner-HCBCodeScaner
//
//  Created by zhaozhao on 2024/3/21.
//

#import "HCBCodeScannerModule.h"
#import "MBCodeScannerRouter.h"

@moduleEX(HCBCodeScannerModule)

+ (nonnull NSString *)moduleName {
    return @"app";
}

+ (NSString *)subModuleName {
    return @"HCBCodeScannerModule";
}


- (NSArray<YMMRouter *> *)routers {
    
    NSArray *defaultSchemes = @[@"ymm", @"ymm-driver", @"ymm-consignor", @"wlqq", @"wlqq.driver", @"wlqq.consignor", @"wlqq.consignor.launch"];
    
    MBCodeScannerRouter *scanRouterHandle = [[MBCodeScannerRouter alloc] init];
    
    YMMRouter *scanRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                   hostPattern:@"codescanner"];
    YMMRouterTable *scanTable = [[YMMRouterTable alloc] init];
    [scanTable registerHandler:scanRouterHandle forPathPattern:@"/codescanner"];
    [scanTable registerHandler:scanRouterHandle forPathPattern:@"/rich_scan"];
    [scanTable registerHandler:scanRouterHandle forPathPattern:@"/scan"];
    [scanRouter addRouterTable:scanTable];
    
    YMMRouter *activityRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                       hostPattern:@"activity"];
    YMMRouterTable *activityTable = [[YMMRouterTable alloc] init];
    [activityTable registerHandler:scanRouterHandle forPathPattern:@"^/\\S+$"];
    [activityRouter addRouterTable:activityTable];

    
    return @[scanRouter,activityRouter];
    
}

@end
