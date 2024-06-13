//
//  NavHostService.h
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseChannelModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface NavHostService : BaseChannelModule

- (void)getGasStationName:(NSArray *)arguments;

- (void)getGasStationId:(NSArray *)arguments;

// 切换油站选择时更新油站信息
- (void)setGasStationInfo:(NSArray *)arguments;
@end

NS_ASSUME_NONNULL_END
