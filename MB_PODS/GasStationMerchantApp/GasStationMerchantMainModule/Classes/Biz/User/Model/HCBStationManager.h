//
//  HCBStationManager.h
//  GasStationBiz
//
//  Created by ty on 2017/11/14.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBStationModel.h"

@interface HCBStationManager : NSObject

@property (nonatomic, strong) HCBStationModel *stationModel;

+ (instancetype)shareManager;
@end
