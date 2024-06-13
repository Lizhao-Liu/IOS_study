//
//  HCBNetworkGasStationHostProvider.h
//  GasStationBiz
//
//  Created by 娄耀文 on 2018/8/21.
//  Copyright © 2018年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
@import HCBNetwork;


@interface HCBNetworkGasStationHostProvider : NSObject <HCBNetworkHostProvider>

- (NSDictionary *)hostMapForEnv:(HCBNetworkdServerEnv)env;

+ (void)updateHost:(NSString *)hostUrl withHostName:(NSString *)hostName;

+ (void)restoreHost:(NSString *)hostName forEnv:(HCBNetworkdServerEnv)env;

@end
