//
//  MBContainerEventSubscriber.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import "MBContainerEventDefine.h"
#import "MBEventScheduler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBContainerEventSubscriber : NSObject

@property (nonatomic, weak) id subscriber;
@property (nonatomic, copy) MBEventActionBlock actionBlock;
@property (nonatomic, strong) MBEventScheduler *scheduler;

- (instancetype)initWithSubscriber:(id)subscriber
                            action:(MBEventActionBlock)block
                       onScheduler:(MBEventScheduler *)scheduler;

@end

NS_ASSUME_NONNULL_END
