//
//  MBBridgeLogModel.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/4/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MBBridgeLogType) {
    MBBridgeLogTypeNone = 0,
    MBBridgeLogTypePerformFailed,   // 调用失败
    MBBridgeLogTypeUseage,          // bridge使用情况埋点
    MBBridgeLogTypeNoAccess,        // bridge无权限访问埋点
};

NS_ASSUME_NONNULL_BEGIN

@interface MBBridgeLogModel : NSObject

@property (nonatomic, assign) MBBridgeLogType type;
@property (nonatomic, assign) NSInteger protocol;
@property (nonatomic, copy) NSString *bridgeName;   // module.method or module.submodule.method
@property (nonatomic, copy) NSString *source;       // rn/flutter/h5...
@property (nonatomic, copy) NSString *visitor;
@property (nonatomic, strong) NSDictionary *extras;

@property (nonatomic, copy, nullable) NSString *bundleName;

@property (nonatomic, copy, nullable) NSString *bundleVersion;

@end

NS_ASSUME_NONNULL_END
