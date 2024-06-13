//
//  EnvironmentFinder.h
//  Runner
//
//  Created by heyAdrian on 2018/11/1.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "BaseChannelModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnvironmentFinder : BaseChannelModule

- (void)findEnvironment:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
