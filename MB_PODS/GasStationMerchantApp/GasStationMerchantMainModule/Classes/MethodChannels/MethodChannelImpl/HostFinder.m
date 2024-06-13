//
//  HostFinder.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "HostFinder.h"
#import "HCBNetworkGasStationHostProvider.h"
@import MBFoundation;
@import HCBNetwork;


@implementation HostFinder

- (void)findHostFromNativeByHostType:(NSArray *)arguments {
    if (!arguments || arguments.count ==0) {
        !self.result ?: self.result(@"入参错误，请传入HostType，才能获取host url");
    } else {
        id hostType = arguments[0];
        if (![hostType isKindOfClass:[NSString class]]) {
            !self.result ?: self.result(@"入参类型错误，请传入String类型的HostType，才能获取host url");
        } else {
            NSString *hostTypeString = (NSString *)hostType;
            HCBNetworkGasStationHostProvider *provider = [HCBNetworkGasStationHostProvider new];
            NSDictionary *hosts = [provider hostMapForEnv:[HCBNetworkDataManager shareDataManager].serverEnv_type];
            NSString *hostURL;
            for (NSString *hostName in hosts.allKeys) {
                if (hostName && hostTypeString && [hostName.lowercaseString isEqualToString:hostTypeString.lowercaseString]) {
                    hostURL = [hosts mb_objectForKeyIgnoreNil:hostName];
                    break;
                }
            }
            if (hostURL && hostURL.length > 0) {
                !self.result ?: self.result(hostURL);
            } else {
                !self.result ?: self.result([NSString stringWithFormat:@"没有找到HostType: %@ 对应的hostURL", hostType]);
            }
            
        }
    }
}

@end
