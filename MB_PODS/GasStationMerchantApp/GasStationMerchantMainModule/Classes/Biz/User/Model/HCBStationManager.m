//
//  HCBStationManager.m
//  GasStationBiz
//
//  Created by ty on 2017/11/14.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBStationManager.h"

@interface HCBStationManager()


@end

@implementation HCBStationManager
+ (instancetype)shareManager {
    
    static HCBStationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        manager.stationModel = [HCBStationModel new];
    });
    return manager;
}

- (void)setStationModel:(HCBStationModel *)stationModel {
    
    _stationModel = stationModel;
}
@end
