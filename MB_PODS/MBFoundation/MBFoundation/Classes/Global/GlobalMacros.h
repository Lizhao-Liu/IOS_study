//
//  GlobalMacros.h
//  MBFoundation
//
//  Created by rensihao on 2021/1/30.
//

#ifndef GlobalMacros_h
#define GlobalMacros_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#ifdef __cplusplus
#define MB_EXTERN_C_BEGIN  extern "C" {
#define MB_EXTERN_C_END  }
#else
#define MB_EXTERN_C_BEGIN
#define MB_EXTERN_C_END
#endif

MB_EXTERN_C_BEGIN

#pragma mark - ARC

#ifndef MB_WEAKIFY
#define MB_WEAKIFY(var) __weak typeof(var) var##Weak = var;
#endif

#ifndef MB_STRONGIFY
#define MB_STRONGIFY(var)                                \
    _Pragma("clang diagnostic push")                     \
        _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong typeof(var) var = var##Weak;        \
    _Pragma("clang diagnostic pop")
#endif

// Note20211202：以下宏没有用到过
#pragma mark - Assert

#ifndef MB_ASSERT_OR_RETURN
#define MB_ASSERT_OR_RETURN(condition, comment)    \
    NSAssert((condition), (comment));              \
    if (!(condition)) {                            \
        return;                                    \
    }
#endif

#define MBAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define MBCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define MBAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define MBCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define MBAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define MBCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")

#pragma mark - Timer

#ifndef MB_DELAY_ACTION
#define MB_DELAY_ACTION(delay, action) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay)*NSEC_PER_SEC)), dispatch_get_main_queue(), (action));
#endif

#pragma mark - Runtime

/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) UIColor *myColor;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
     YYSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
     @end
 */
#ifndef MBSYNTH_DYNAMIC_PROPERTY_OBJECT
#define MBSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


/**
 Synthsize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
     @interface NSObject (MyAdd)
     @property (nonatomic, retain) CGPoint myPoint;
     @end
     
     #import <objc/runtime.h>
     @implementation NSObject (MyAdd)
     YYSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
     @end
 */
#ifndef MBSYNTH_DYNAMIC_PROPERTY_CTYPE
#define MBSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    _type_ cValue = { 0 }; \
    NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
    [value getValue:&cValue]; \
    return cValue; \
}
#endif

#pragma mark - Multi-thread Safe

#define MB_ASYNC_MAINQUEUE(block)                                                                                                   \
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) { \
        block();                                                                                                                    \
    } else {                                                                                                                        \
        dispatch_async(dispatch_get_main_queue(), block);                                                                           \
    }

MB_EXTERN_C_END

#endif /* GlobalMacros_h */
