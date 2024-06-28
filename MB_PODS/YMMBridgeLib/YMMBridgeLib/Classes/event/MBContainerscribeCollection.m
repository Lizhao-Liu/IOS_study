//
//  MBContainerscribeCollection.m
//  Pods
//
//  Created by 常贤明 on 2022/8/29.
//

#import "MBContainerscribeCollection.h"

@interface MBContainerscribeCollection ()

@property (nonatomic, strong) NSMapTable<id, MBContainerEventSubscriber *> *scriberMap;

@end

@implementation MBContainerscribeCollection

- (void)addSubscriber:(MBContainerEventSubscriber *)subscriber forTarget:(id)target {
    if (target) {
        [self.scriberMap setObject:subscriber forKey:target];
    }
}

- (void)removeSubscriberForTarget:(id)target {
    if (target) {
        [self.scriberMap removeObjectForKey:target];
    }
}

- (void)actionEvent:(MBContainerEvent *)event {
    [[self.scriberMap.objectEnumerator allObjects] enumerateObjectsUsingBlock:^(MBContainerEventSubscriber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.scheduler schedule:^{
            if (obj.actionBlock) {
                obj.actionBlock(event);
            }
        }];
    }];
}

- (BOOL)hasContainSubscriberForTarget:(id)target {
    if (target == nil) {
        return NO;
    }
    return ([self.scriberMap objectForKey:target] != nil);
}

- (BOOL)isEmpty {
    return ([self.scriberMap count] <= 0);
}

#pragma mark - property method
- (NSMapTable<id, MBContainerEventSubscriber *> *)scriberMap {
    if (_scriberMap == nil) {
        _scriberMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory
                                                valueOptions:NSPointerFunctionsStrongMemory
                                                    capacity:0];
    }
    return _scriberMap;
}

@end
