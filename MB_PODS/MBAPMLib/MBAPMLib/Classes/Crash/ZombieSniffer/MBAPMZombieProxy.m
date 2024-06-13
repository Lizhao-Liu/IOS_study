//
//  MBAPMZombieProxy.m
//  MBAPMLib
//
//  Created by xp on 2022/10/19.
//

#import "MBAPMZombieProxy.h"
#import "MBAPMZombieSniffer.h"
#import "MBAPMLogDef.h"
#import <objc/runtime.h>

@implementation MBAPMZombieProxy

+ (Class)zombieIsa
{
    return [self class];
}

+ (size_t)zombieInstanceSize
{
    return class_getInstanceSize([MBAPMZombieProxy zombieIsa]);
}


- (BOOL)respondsToSelector: (SEL)aSelector
{
    return [self.originClass instancesRespondToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)sel
{
    return [self.originClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation: (NSInvocation *)invocation
{
    [self _throwMessageSentExceptionWithSelector: invocation.selector];
}

#define MBZombieThrowMesssageSentException() [self _throwMessageSentExceptionWithSelector: _cmd]

- (Class)class
{
    MBZombieThrowMesssageSentException();
    return nil;
}

- (BOOL)isEqual:(id)object
{
    MBZombieThrowMesssageSentException();
    return NO;
}

- (NSUInteger)hash
{
    MBZombieThrowMesssageSentException();
    return 0;
}

- (id)self
{
    MBZombieThrowMesssageSentException();
    return nil;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    MBZombieThrowMesssageSentException();
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    MBZombieThrowMesssageSentException();
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    MBZombieThrowMesssageSentException();
    return NO;
}

- (BOOL)isProxy
{
    MBZombieThrowMesssageSentException();
    
    return NO;
}

- (id)retain
{
    MBZombieThrowMesssageSentException();
    return nil;
}

- (oneway void)release
{
    MBZombieThrowMesssageSentException();
}

- (id)autorelease
{
    MBZombieThrowMesssageSentException();
    return nil;
}

- (void)dealloc
{
    MBZombieThrowMesssageSentException();
    [super dealloc];
}

- (NSUInteger)retainCount
{
    MBZombieThrowMesssageSentException();
    return 0;
}

- (NSZone *)zone
{
    MBZombieThrowMesssageSentException();
    return nil;
}

- (NSString *)description
{
    MBZombieThrowMesssageSentException();
    return nil;
}


#pragma mark - Private
- (void)_throwMessageSentExceptionWithSelector: (SEL)selector
{
    NSString *exceptionLog = [NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p", NSStringFromClass(self.originClass), NSStringFromSelector(selector), self];
    MBAPMError(exceptionLog);
    if (self.throwExceptionWhenDetectZombie) {
        void *p = (__bridge void *)(self);
        uintptr_t address = (uintptr_t)p;
        NSValue *stackValue = nil;
        if (self.reportDeallocStack) {
            KSStackCursor stackCursor;
            kssc_initCursor(&stackCursor, NULL, NULL);
            [MBAPMZombieSniffer deallocStack: &stackCursor ForObj:address];
            stackValue = [NSValue valueWithBytes:&stackCursor objCType:@encode(typeof(stackCursor))];
        }
        NSMutableDictionary *exceptionUserInfo = [NSMutableDictionary new];
        exceptionUserInfo[@"faultAddress"] = @(address);
        if (stackValue) {
            exceptionUserInfo[@"faultStack"] = stackValue;
        }
        @throw [NSException exceptionWithName:@"MBAPMZombieException" reason:[NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p", NSStringFromClass(self.originClass), NSStringFromSelector(selector), self] userInfo:exceptionUserInfo.copy];
    }
}


@end
