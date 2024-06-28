//
//  MBBridgeResponse.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MBBridgeResponse;

typedef void(^MBBridgeNativeBlock)(MBBridgeResponse *response);

@interface MBBridgeResponse : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy, nullable) NSString *reason;
@property (nonatomic, strong, nullable) id data;

@end

NS_ASSUME_NONNULL_END
