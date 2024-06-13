//
//  MBAPMModel.h
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusWifi,
    NetworkStatusMobile,
    NetworkStatusNone,
};

typedef NS_ENUM(NSUInteger, TechStack) {
    TechStackNone = 0,
    TechStacknative,
    TechStackH5,
    TechStackThresh
};

typedef NS_ENUM(NSUInteger, BusinessModule) {
    BusinessModuleNone = 0,
    BusinessModuleNetwork,
    BusinessModuleImage,
    BusinessModuleLog,
    BusinessModuleDownload,
    BusinessModuleUpload
};

@interface MBAPMModel : NSObject
// 流量
@property (nonatomic, assign) NSUInteger traffic;
@property (nonatomic, assign) BOOL isForeground;
// 上行
@property (nonatomic, assign) NSUInteger upTraffic;
// 下行
@property (nonatomic, assign) NSUInteger downTraffic;
@property (nonatomic, assign) NetworkStatus networkStatus;
// cargo/user/...
@property (nonatomic, copy) NSString *bundle;
@property (nonatomic, assign) BusinessModule businessModule;
@property (nonatomic, assign) TechStack stack;

@end

NS_ASSUME_NONNULL_END
