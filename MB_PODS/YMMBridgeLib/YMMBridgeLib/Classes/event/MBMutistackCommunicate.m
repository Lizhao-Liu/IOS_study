//
//  MBMutistackCommunicate.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/6.
//

#import "MBMutistackCommunicate.h"
#include <pthread.h>

static NSString *const EventMethodName = @"onEvent"; // 事件调用 方法名

@interface MBMutistackCommunicate() {
    NSLock *dataLock;
}

@property (nonatomic, strong) NSMapTable<NSString *, NSHashTable<id<MBBridgeContainer>> *> *subscribeMapTable;

@end

@implementation MBMutistackCommunicate

static MBMutistackCommunicate *g_manager;
#pragma mark - lifeCycle method
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_manager = [[self alloc] init];
    });
    return g_manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dataLock = [[NSLock alloc] init];
        self.subscribeMapTable = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                           valueOptions:NSPointerFunctionsStrongMemory
                                                               capacity:0];
        
    }
    return self;
}

#pragma mark - public method
- (void)subscribe:(NSString *)eventName forContainer:(id<MBBridgeContainer>)container {
    if (eventName == nil || container == nil) {
        return;
    }
    [dataLock lock];
    eventName = [NSString stringWithFormat:@"%@", eventName];
    NSHashTable *table = [self.subscribeMapTable objectForKey:eventName];
    if (table == nil) {
        table = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory
                                            capacity:1];
        [self.subscribeMapTable setObject:table forKey:eventName];
        [table addObject:container];
    } else {
        __block BOOL haveFind = NO;
        [[table objectEnumerator].allObjects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id<MBBridgeContainer> subscriber = (id<MBBridgeContainer>)obj;
            if (container == subscriber) {
                haveFind = YES;
                *stop = YES;
            }
        }];
        if (!haveFind) {
            [table addObject:container];
        }
    }
    [dataLock unlock];
}

- (void)unsubscribe:(NSString *)eventName forContainer:(id<MBBridgeContainer>)container {
    if (eventName == nil || container == nil) {
        return;
    }
    [dataLock lock];
    eventName = [NSString stringWithFormat:@"%@", eventName];
    NSHashTable *table = [self.subscribeMapTable objectForKey:eventName];
    if (table == nil) {
        [dataLock unlock];
        return;
    }
        
    __block BOOL haveFind = NO;
    [[table objectEnumerator].allObjects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<MBBridgeContainer> subscriber = (id<MBBridgeContainer>)obj;
        if (container == subscriber) {
            *stop = YES;
            haveFind = YES;
        }
    }];
    
    if (haveFind == YES) {
        [table removeObject:container];
    }
    
    if (table.count <= 0) {
        [self.subscribeMapTable removeObjectForKey:eventName];
    }
    [dataLock unlock];
}

- (void)publishEvent:(NSString *)eventName data:(NSDictionary *)params {
    [self _sendEvent:eventName data:params];
}

#pragma mark - private method
- (void)_sendEvent:(NSString *)eventName data:(NSDictionary *)params {
    if (eventName == nil) {
        return;
    }
    
    eventName = [NSString stringWithFormat:@"%@", eventName];
    [self _sendToOtherEvent:eventName data:params];
}

// 通过bridge订阅事件技术栈通知
- (void)_sendToOtherEvent:(NSString *)eventName data:(NSDictionary *)params {
    // 然后，发其它技术栈事件
    [dataLock lock];
    NSHashTable *table = [self.subscribeMapTable objectForKey:eventName];
    if (table == nil) {
        [dataLock unlock];
        return;
    }
    
    NSDictionary *userInfo = [self paramsFrom:eventName data:params];
    [[table objectEnumerator].allObjects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<MBBridgeContainer> subscriber = (id<MBBridgeContainer>)obj;
        if ([subscriber respondsToSelector:@selector(call:params:)]) {
            [subscriber call:EventMethodName params:userInfo];
        }
    }];
    
    [dataLock unlock];
}

- (NSDictionary *)paramsFrom:(NSString *)eventName data:(NSDictionary *)params {
    if (eventName == nil) {
        return nil;
    }
    NSString *eventId = [NSUUID UUID].UUIDString;
    return @{
        @"eventId" : eventId != nil ? eventId : @"",
        @"eventName" : eventName,
        @"eventData" : params != nil ? params : @{}
    };
}

@end
