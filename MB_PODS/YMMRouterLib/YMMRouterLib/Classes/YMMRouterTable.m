//
//  YMMRouterTable.m
//  Pods-YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/2/19.
//

#import "YMMRouterTable.h"
#import "YMMRouter.h"

@interface YMMRouterBlockHandler : NSObject

- (instancetype)initWithBlock:(HandlerBlock)block;

@end

@interface YMMRouterBlockHandler ()<YMMRouterAsyncHandlerProtocol>

@property (nonatomic, copy) HandlerBlock handlerBlock;

@end

@implementation YMMRouterBlockHandler

- (instancetype)initWithBlock:(HandlerBlock)block {
    self = [super init];
    if (self) {
        self.handlerBlock = block;
    }
    return self;
}

- (void)handle:(id<YMMRouterRoutable>)routable
      callback:(nullable HandlerCallback)callback {
    if (self.handlerBlock) {
        self.handlerBlock(routable, callback);
    }
}

@end

@interface YMMRouterActionHandler : NSObject

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action;

@end

@interface YMMRouterActionHandler ()<YMMRouterAsyncHandlerProtocol>

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *action;

@end

@implementation YMMRouterActionHandler

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        self.target = target;
        self.action = NSStringFromSelector(action);
    }
    return self;
}

- (void)handle:(id<YMMRouterRoutable>)routable
    callback:(nullable HandlerCallback)callback {
    SEL selector = NSSelectorFromString(self.action);
    if ([self.target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:selector
                          withObject:routable
                          withObject:callback];
#pragma clang diagnostic pop
    }
}

@end

@interface YMMRouterTable () {
    NSMutableDictionary<NSString *, id<YMMRouterBaseHandlerProtocol>> *_map;
}
@end

@implementation YMMRouterTable

- (instancetype)init {
    self = [super init];
    if (self) {
        _map = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerHandler:(id<YMMRouterBaseHandlerProtocol>)handler
         forPathPattern:(NSString *)pathPattern {
    [_map setObject:handler forKey:pathPattern];
}

- (void)registerBlock:(HandlerBlock)handlerBlock
       forPathPattern:(NSString *)pathPattern {
    [_map setObject:[[YMMRouterBlockHandler alloc] initWithBlock:handlerBlock]
             forKey:pathPattern];
}

- (void)registerAction:(SEL)action
                target:(id)target
        forPathPattern:(NSString *)pathPattern {
    [_map setObject:[[YMMRouterActionHandler alloc] initWithTarget:target action:action]
             forKey:pathPattern];
}

- (void)unregisterHandlerForPathPattern:(NSString *)pathPattern {
    [_map removeObjectForKey:pathPattern];
}

- (id<YMMRouterBaseHandlerProtocol>)matches:(NSString *)path {
    for (NSString *key in _map.allKeys) {
        if ([YMMRouter match:key content:path]) {
            return [_map objectForKey:key];
        }
    }
    return nil;
}

@end
