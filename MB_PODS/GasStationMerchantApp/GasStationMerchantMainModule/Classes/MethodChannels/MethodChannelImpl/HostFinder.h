//
//  HostFinder.h
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseChannelModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface HostFinder : BaseChannelModule

- (void)findHostFromNativeByHostType:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
