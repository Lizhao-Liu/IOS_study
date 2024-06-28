//
//  MBContainerscribeCollection.h
//  Pods
//
//  Created by 常贤明 on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import "MBContainerEventSubscriber.h"
#import "MBContainerEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBContainerscribeCollection : NSObject

- (void)addSubscriber:(MBContainerEventSubscriber *)subscriber forTarget:(id)target;
- (void)removeSubscriberForTarget:(id)target;
- (void)actionEvent:(MBContainerEvent *)event;
- (BOOL)hasContainSubscriberForTarget:(id)target;
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
