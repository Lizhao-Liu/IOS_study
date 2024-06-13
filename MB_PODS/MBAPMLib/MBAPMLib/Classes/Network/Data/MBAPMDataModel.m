//
//  MBAPMDataModel.m
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import "MBAPMDataModel.h"

@implementation MBAPMDataModel

- (NSMutableDictionary *)bundleSumTraffic {
    if (!_bundleSumTraffic) {
        _bundleSumTraffic = @{}.mutableCopy;
    }
    return _bundleSumTraffic;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    MBAPMDataModel *model = [[MBAPMDataModel alloc] init];
    model.sumTraffic = self.sumTraffic;
    model.foregroundSumTraffic = self.foregroundSumTraffic;
    model.backgroundSumTraffic = self.backgroundSumTraffic;
    model.upSumTraffic = self.upSumTraffic;
    model.downSumTraffic = self.downSumTraffic;
    model.wifiSumTraffic = self.wifiSumTraffic;
    model.mobileSumTraffic = self.mobileSumTraffic;
    model.otherSumTraffic = self.otherSumTraffic;
    model.bundleSumTraffic = self.bundleSumTraffic;
    model.h5SumTraffic = self.h5SumTraffic;
    model.threshSumTraffic = self.threshSumTraffic;
    model.nativeSumTraffic = self.nativeSumTraffic;
    
    model.date = self.date;
    model.type = self.type;
    model.calculationPeriod = self.calculationPeriod;
    return model;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    MBAPMDataModel *model = [[MBAPMDataModel alloc] init];
    model.sumTraffic = self.sumTraffic;
    model.TPM = self.TPM;
    model.foregroundSumTraffic = self.foregroundSumTraffic;
    model.backgroundSumTraffic = self.backgroundSumTraffic;
    model.upSumTraffic = self.upSumTraffic;
    model.downSumTraffic = self.downSumTraffic;
    model.wifiSumTraffic = self.wifiSumTraffic;
    model.mobileSumTraffic = self.mobileSumTraffic;
    model.otherSumTraffic = self.otherSumTraffic;
    model.bundleSumTraffic = self.bundleSumTraffic;
    model.h5SumTraffic = self.h5SumTraffic;
    model.threshSumTraffic = self.threshSumTraffic;
    model.nativeSumTraffic = self.nativeSumTraffic;
    
    model.date = self.date;
    model.type = self.type;
    model.calculationPeriod = self.calculationPeriod;
    return model;
}

@end
