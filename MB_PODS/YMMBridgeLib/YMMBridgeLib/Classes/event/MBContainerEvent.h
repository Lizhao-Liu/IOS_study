//
//  MBContainerEvent.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBContainerEvent : NSObject

@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, strong, readonly, nullable) NSDictionary *params;

- (instancetype)initWithName:(NSString *)name userInfo:(nullable NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
