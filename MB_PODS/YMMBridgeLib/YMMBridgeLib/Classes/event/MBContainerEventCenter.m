//
//  MBContainerEventCenter.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import "MBContainerEventCenter.h"
#import "MBContainerscribeCollection.h"

@interface MBContainerEventCenter() {
    NSLock *_eventLock;
}

@property (nonatomic, strong)NSMutableDictionary<NSString *, MBContainerscribeCollection *> *scribeCollection;
@property (nonatomic, strong)MBContainerscribeCollection *globalCollection;

@end

@implementation MBContainerEventCenter

#pragma mark - lifeCycle method
static MBContainerEventCenter *g_center = NULL;

+ (MBContainerEventCenter *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_center = [[self alloc] init];
    });
    return g_center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventLock = [[NSLock alloc] init];
    }
    return self;
}

#pragma mark - subscriber
- (void)_subscribeEvent:(NSString *)eventName
             subscriber:(id)subscriber
            onScheduler:(nullable MBEventScheduler *)scheduler
                 action:(MBEventActionBlock)block {
    if (eventName.length <= 0 || subscriber == nil || block == nil) {
        return;
    }
    [_eventLock lock];
    
    if (scheduler == nil) {
        scheduler = [MBEventScheduler immediateScheduler];
    }
    
    MBContainerscribeCollection *collection = [self.scribeCollection objectForKey:eventName];
    if (collection == nil) {
        collection = [[MBContainerscribeCollection alloc] init];
        [self.scribeCollection setObject:collection forKey:eventName];
    }
    MBContainerEventSubscriber *eventScriber =
    [[MBContainerEventSubscriber alloc] initWithSubscriber:subscriber
                                                    action:block
                                               onScheduler:scheduler];
    [collection addSubscriber:eventScriber forTarget:subscriber];
    [_eventLock unlock];
}

#pragma mark - public method
- (void)subscribeEvent:(NSString *)eventName subscriber:(id)subscriber action:(MBEventActionBlock)block {
    
    [self _subscribeEvent:eventName
               subscriber:subscriber
              onScheduler:[MBEventScheduler immediateScheduler]
                   action:block];
}

- (void)subscribeEventOnMainThread:(NSString *)eventName
                        subscriber:(id)subscriber
                            action:(MBEventActionBlock)block {
    
    [self _subscribeEvent:eventName
               subscriber:subscriber
              onScheduler:[MBEventScheduler mainThreadScheduler]
                   action:block];
}

- (void)unsubscribeEvent:(NSString *)eventName subscriber:(id)subscriber {
    if (eventName.length <= 0) {
        return;
    }
    
    [_eventLock lock];
    MBContainerscribeCollection *collection = [self.scribeCollection objectForKey:eventName];
    if (collection == nil) {
        [_eventLock unlock];
        return;
    }
    if ([collection hasContainSubscriberForTarget:subscriber] == NO) {
        [_eventLock unlock];
        return;
    }
    
    [collection removeSubscriberForTarget:subscriber];
    if (collection.isEmpty) {
        [self.scribeCollection removeObjectForKey:eventName];
    }
    [_eventLock unlock];
}

- (void)unsubscribeAllEvent:(id)subscriber {
    if (subscriber == nil) {
        return;
    }
    
    [_eventLock lock];
    NSMutableArray *removeKeys = [NSMutableArray array];
    [self.scribeCollection enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MBContainerscribeCollection * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj hasContainSubscriberForTarget:subscriber] == YES) {
            [obj removeSubscriberForTarget:subscriber];
        }
        // 清理一遍没有监听者的事件
        if (obj.isEmpty) {
            [removeKeys addObject:key];
        }
    }];
    
    if (removeKeys.count > 0) {
        for (NSString *key in removeKeys) {
            [self.scribeCollection removeObjectForKey:key];
        }
    }
    
    if ([_globalCollection hasContainSubscriberForTarget:subscriber]) {
        [_globalCollection removeSubscriberForTarget:subscriber];
    }
    
    [_eventLock unlock];
}

- (void)publishEvent:(NSString *)eventName data:(nullable NSDictionary *)params {
    if (eventName.length <= 0) {
        return;
    }
    [_eventLock lock];
    
    MBContainerEvent *event = [[MBContainerEvent alloc] initWithName:eventName userInfo:params];
    [self _publishForMemberSubscriber:event];
    
    [self _publishForGlobalSubscriber:event];
    
    [_eventLock unlock];
}

// 全局只能有一个此类订阅者, 请勿调用
- (void)subscribeAllEvent:(id)subscriber action:(MBEventActionBlock)block {
    if (subscriber == nil || block == nil) {
        return;
    }
    
    [_eventLock lock];
    
    if (_globalCollection != nil) {
        _globalCollection = nil;
    }
    
    _globalCollection = [[MBContainerscribeCollection alloc] init];
    
    MBContainerEventSubscriber *eventScriber =
    [[MBContainerEventSubscriber alloc] initWithSubscriber:subscriber
                                                    action:block
                                               onScheduler:[MBEventScheduler immediateScheduler]];
    [_globalCollection addSubscriber:eventScriber forTarget:subscriber];
    
    [_eventLock unlock];
}

#pragma mark - publish
- (void)_publishForMemberSubscriber:(MBContainerEvent *)event {
    if (event == nil || event.eventName == nil) {
        return;
    }
    MBContainerscribeCollection *collection = [self.scribeCollection objectForKey:event.eventName];
    if (collection == nil) {
        return;
    }
    if ([collection isEmpty] == YES) {
        
        [self removeEventCollection:event.eventName];
        return;
    }
    
    [collection actionEvent:event];
}

- (void)_publishForGlobalSubscriber:(MBContainerEvent *)event {
    
    // 发全局
    if (_globalCollection != nil && event != nil) {
        [_globalCollection actionEvent:event];
    }
}

#pragma mark - private method
- (void)removeEventCollection:(NSString *)eventName {
    if (eventName) {
        [self.scribeCollection removeObjectForKey:eventName];
    }
}

#pragma mark - property method
- (NSMutableDictionary<NSString *, MBContainerscribeCollection *> *)scribeCollection {
    if (_scribeCollection == nil) {
        _scribeCollection = [NSMutableDictionary dictionary];
    }
    return _scribeCollection;
}

@end
