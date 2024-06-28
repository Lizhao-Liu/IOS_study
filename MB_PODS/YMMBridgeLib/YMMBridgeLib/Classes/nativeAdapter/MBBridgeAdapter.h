//
//  MBBridgeAdapter.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "MBBridgeReuest.h"
#import "MBBridgeResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBBridgeAdapter : NSObject

+ (instancetype)modelWithBridgeRequest:(MBBridgeReuest *)request
                             container:(nullable id)container
                              callback:(MBBridgeNativeBlock)block;

- (void)invoke;

@end

NS_ASSUME_NONNULL_END
