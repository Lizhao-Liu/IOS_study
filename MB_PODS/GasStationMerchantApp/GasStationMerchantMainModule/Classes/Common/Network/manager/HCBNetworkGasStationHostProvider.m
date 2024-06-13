//
//  HCBNetworkGasStationHostProvider.m
//  GasStationBiz
//
//  Created by 娄耀文 on 2018/8/21.
//  Copyright © 2018年 56qq. All rights reserved.
//

#import "HCBNetworkGasStationHostProvider.h"
#import "HCBAPIs.h"
@import MBFoundation;

static NSMutableDictionary *HostMapping;

@implementation HCBNetworkGasStationHostProvider

// 配置 module name 以与其它 app 或组件区分 host，module name 需要确保唯一性
HCBNETWORK_EXPORT_HOST_PROVIDER_FOR_MODULE(HCBGasStation)

- (NSDictionary *)hostMapForEnv:(HCBNetworkdServerEnv)env {
    return [self getHostMappingForEnv:env];
}

- (NSDictionary *)getHostsForEnv:(HCBNetworkdServerEnv)env {
    switch (env) {
        case HCBNetworkdServerEnv_Dev:
            return @{ @"jyz": gashost_dev,
                      @"enterprise": enterprisehost_dev,
                      @"sso" : ssohost_dev,
                      @"GATEWAY" : mmobile_Dev,
                      @"MERCHANT":MERCHANT_dev,
                      @"FINANCE":finance_dev
                      };
        case HCBNetworkdServerEnv_Test:
            return @{ @"jyz": gashost_qa,
                      @"enterprise": enterprisehost_qa,
                      @"sso" : ssohost_qa,
                      @"GATEWAY" : mmobile_QA,
                      @"MERCHANT":MERCHANT_qa,
                      @"FINANCE":finance_qa
                      };
        default:
            return @{ @"jyz": gashost_pro,
                      @"enterprise": enterprisehost_pro,
                      @"sso" : ssohost_pro,
                      @"GATEWAY" : mmobile_Pro,
                      @"MERCHANT":MERCHANT_pro,
                      @"FINANCE":finance_pro
                      };
    }
}

- (NSMutableDictionary *)getHostMappingForEnv:(HCBNetworkdServerEnv)env {
    if (HostMapping && HostMapping.allKeys > 0) {
        return HostMapping;
    } else {
        HostMapping = [[self getHostsForEnv:env] mutableCopy];
        return HostMapping;
    }
}

+ (void)updateHost:(NSString *)hostUrl withHostName:(NSString *)hostName {
    if (hostUrl.length == 0 || hostName.length ==0) {
        return;
    }
    NSString *hostKey = hostName;
    for (NSString *hostAlias in HostMapping.allKeys) {
        if ([hostAlias.lowercaseString isEqualToString:hostName.lowercaseString]) {
            hostKey = hostAlias;
            break;
        }
    }
    [HostMapping setObject:hostUrl forKey:hostKey];
    [[HCBNetworkHostManager sharedManager] reloadAllHosts];
}

+ (void)restoreHostForEnv:(HCBNetworkdServerEnv)env {
    
}

+ (void)restoreHost:(NSString *)hostName forEnv:(HCBNetworkdServerEnv)env {
    NSDictionary *defaultHosts = [[self new] getHostsForEnv:env];
    NSString *hostKey = hostName;
    for (NSString *hostAlias in defaultHosts.allKeys) {
        if ([hostAlias.lowercaseString isEqualToString:hostName.lowercaseString]) {
            hostKey = hostAlias;
            break;
        }
    }
    [HostMapping setObject:[defaultHosts mb_objectForKeyIgnoreNil:hostKey] forKey:hostKey];
    [[HCBNetworkHostManager sharedManager] reloadAllHosts];
}

// 配置是否使用 https 协议
- (BOOL)https:(NSString *)host {
    return YES;
}

@end
