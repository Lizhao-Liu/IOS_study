//
//  TMSTigaRuntimeBridgeImpl.m
//  AAChartKit
//
//  Created by Lizhao on 2023/12/19.
//

#import "TMSTigaRuntimeBridgeImpl.h"
#import "TMSAppStatusManager.h"
@import YMMModuleLib;

@serviceEX(TMSTigaRuntimeBridgeImpl, MBTigaRuntimePluginDelegate)

- (BOOL)isAppLaunchedViaScheme {
    return [[TMSAppStatusManager shared] isSchemeOpenApp];
}

@end
