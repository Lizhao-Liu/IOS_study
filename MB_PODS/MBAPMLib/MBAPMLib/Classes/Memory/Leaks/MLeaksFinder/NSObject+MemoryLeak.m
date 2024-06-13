/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "NSObject+MemoryLeak.h"
#import "MLeakedObjectProxy.h"
#import "MLeaksFinder.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@import MBBuildPreLib;

//#if _INTERNAL_MLF_RC_ENABLED
////#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
//#endif

static const void *const kViewStackKey = &kViewStackKey;
static const void *const kParentPtrsKey = &kParentPtrsKey;
const void *const kLatestSenderKey = &kLatestSenderKey;
static BOOL vEnableLeaksFinder = NO;
static BOOL vEnableLeaksAlert = NO;
static BOOL vEnableCheckRetainCycle = NO;
static dispatch_once_t onceToken;

@implementation NSObject (MemoryLeak)

- (BOOL)willDealloc {
    if (!vEnableLeaksFinder)
        return NO;
    
    NSString *className = NSStringFromClass([self class]);
    if ([[NSObject classNamesWhitelist] containsObject:className])
        return NO;
    
    NSNumber *senderPtr = objc_getAssociatedObject([UIApplication sharedApplication], kLatestSenderKey);
    if ([senderPtr isEqualToNumber:@((uintptr_t)self)])
        return NO;
    
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });
    
    return YES;
}

- (void)assertNotDealloc {
    if ([MLeakedObjectProxy isAnyObjectLeakedAtPtrs:[self parentPtrs]]) {
        return;
    }
    [MLeakedObjectProxy addLeakedObject:self];
    
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"Possibly Memory Leak.\nIn case that %@ should not be dealloced, override -willDealloc in %@ by returning NO.\nView-ViewController stack: %@", className, className, [self viewStack]);
}

- (void)willReleaseObject:(id)object relationship:(NSString *)relationship {
    if ([relationship hasPrefix:@"self"]) {
        relationship = [relationship stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
    }
    NSString *className = NSStringFromClass([object class]);
    className = [NSString stringWithFormat:@"%@(%@), ", relationship, className];
    
    [object setViewStack:[[self viewStack] arrayByAddingObject:className]];
    [object setParentPtrs:[[self parentPtrs] setByAddingObject:@((uintptr_t)object)]];
    [object willDealloc];
}

- (void)willReleaseChild:(id)child {
    if (!child) {
        return;
    }
    
    [self willReleaseChildren:@[ child ]];
}

- (void)willReleaseChildren:(NSArray *)children {
    NSArray *viewStack = [self viewStack];
    NSSet *parentPtrs = [self parentPtrs];
    for (id child in children) {
        NSString *className = NSStringFromClass([child class]);
        [child setViewStack:[viewStack arrayByAddingObject:className]];
        [child setParentPtrs:[parentPtrs setByAddingObject:@((uintptr_t)child)]];
        [child willDealloc];
    }
}

- (NSArray *)viewStack {
    NSArray *viewStack = objc_getAssociatedObject(self, kViewStackKey);
    if (viewStack) {
        return viewStack;
    }
    
    NSString *className = NSStringFromClass([self class]);
    return @[ className ];
}

- (void)setViewStack:(NSArray *)viewStack {
    objc_setAssociatedObject(self, kViewStackKey, viewStack, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)parentPtrs {
    NSSet *parentPtrs = objc_getAssociatedObject(self, kParentPtrsKey);
    if (!parentPtrs) {
        parentPtrs = [[NSSet alloc] initWithObjects:@((uintptr_t)self), nil];
    }
    return parentPtrs;
}

- (void)setParentPtrs:(NSSet *)parentPtrs {
    objc_setAssociatedObject(self, kParentPtrsKey, parentPtrs, OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableSet *)classNamesWhitelist {
    static NSMutableSet *whitelist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whitelist = [NSMutableSet setWithObjects:
                     @"UIFieldEditor", // UIAlertControllerTextField
                     @"UINavigationBar",
                     @"_UIAlertControllerActionView",
                     @"_UIVisualEffectBackdropView",
                     nil];
        
        // System's bug since iOS 10 and not fixed yet up to this ci.
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        if ([systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            [whitelist addObject:@"UISwitch"];
        }
    });
//#if _INTERNAL_MLF_ENABLED
//    
//#if _INTERNAL_MLF_RC_ENABLED
//    if (vEnableCheckRetainCycle) {
//        // Just find a place to set up FBRetainCycleDetector.
//        dispatch_once(&onceToken, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [FBAssociationManager hook];
//            });
//        });
//    }
//#endif
    return whitelist;
}

+ (void)addClassNamesToLeaksWhitelist:(NSArray *)classNames {
    [[self classNamesWhitelist] addObjectsFromArray:classNames];
}

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
#if _INTERNAL_MLF_ENABLED
    
#if _INTERNAL_MLF_RC_ENABLED
    // Just find a place to set up FBRetainCycleDetector.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            Class fbAssociationManager = NSClassFromString(@"FBAssociationManager");
            SEL fbAssociationManagerHook = NSSelectorFromString(@"hook");
            if ([fbAssociationManager respondsToSelector:fbAssociationManagerHook]) {
                (((void (*)(id, SEL))[fbAssociationManager methodForSelector:fbAssociationManagerHook])(self, fbAssociationManagerHook));
            }
        });
    });
#endif
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
#endif
}

+ (void)setEnableCheckRetainCycle:(BOOL)enable {
    if (!enable) {
        vEnableCheckRetainCycle = NO;
        return;
    }
    if ([MBFMacro ymm_buildDebug] || [MBFMacro ymm_buildAdhoc]) {
        vEnableCheckRetainCycle = YES;
        dispatch_once(&onceToken, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
#if _INTERNAL_MLF_ENABLED
#if _INTERNAL_MLF_RC_ENABLED
                Class fbAssociationManager = NSClassFromString(@"FBAssociationManager");
                SEL fbAssociationManagerHook = NSSelectorFromString(@"hook");
                if ([fbAssociationManager respondsToSelector:fbAssociationManagerHook]) {
                    (((void (*)(id, SEL))[fbAssociationManager methodForSelector:fbAssociationManagerHook])(self, fbAssociationManagerHook));
                }
#endif
#endif
            });
        });
    } else {
        vEnableCheckRetainCycle = NO;
    }
}

+ (BOOL)isEnableCheckRetainCycle {
    return vEnableCheckRetainCycle;
}

+ (void)setEnableLeaksFinder:(BOOL)enable {
    vEnableLeaksFinder = enable;
}

+ (BOOL)isEnableLeaksFinder {
    return vEnableLeaksFinder;
}

+ (void)setEnableLeaksAlert:(BOOL)enable {
    if (!enable) {
        vEnableLeaksAlert = NO;
        return;
    }
    if ([MBFMacro ymm_buildDebug] || [MBFMacro ymm_buildAdhoc]) {
        vEnableLeaksAlert = enable;
    } else {
        vEnableLeaksAlert = NO;
    }
}

+ (BOOL)isEnableLeaksAlert {
    return vEnableLeaksAlert;
}
@end
