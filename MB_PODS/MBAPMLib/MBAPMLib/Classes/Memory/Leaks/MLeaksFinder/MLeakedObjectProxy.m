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

#import "MLeakedObjectProxy.h"
#import "MLeaksFinder.h"
#import "MLeaksMessenger.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "MBAPMPluginManager.h"
#import "MBAPMMemoryMonitor.h"

//#if _INTERNAL_MLF_RC_ENABLED
//#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
//#endif

static NSMutableSet *leakedObjectPtrs;

/// FB Header
///
///
///
@protocol FBObjectiveCGraphElementProtocol <NSObject>
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *> *namePath;
@property (nonatomic, weak, nullable) id object;
- (nullable NSSet *)allRetainedObjects;
- (size_t)objectAddress;
- (nullable Class)objectClass;
- (nonnull NSString *)classNameOrNull;
@end
///
///
@class FBObjectiveCGraphElement;
@protocol FBRetainCycleDetectorProtocol <NSObject>
- (void)addCandidate:(nonnull id)candidate;
- (nonnull NSSet<NSArray<FBObjectiveCGraphElement *> *> *)findRetainCycles;
- (nonnull NSSet<NSArray<FBObjectiveCGraphElement *> *> *)findRetainCyclesWithMaxCycleLength:(NSUInteger)length;
@end



@interface APMLeakModel : NSObject <MBAPMMemoryLeakProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@end

@implementation APMLeakModel

@end

@interface MLeakedObjectProxy ()<UIAlertViewDelegate>
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber *objectPtr;
@property (nonatomic, strong) NSArray *viewStack;
@end

@implementation MLeakedObjectProxy

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs {
    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [[NSMutableSet alloc] init];
    });
    
    if (!ptrs.count) {
        return NO;
    }
    if ([leakedObjectPtrs intersectsSet:ptrs]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)addLeakedObject:(id)object {
    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    
    MLeakedObjectProxy *proxy = [[MLeakedObjectProxy alloc] init];
    proxy.object = object;
    proxy.objectPtr = @((uintptr_t)object);
    proxy.viewStack = [object viewStack];
    static const void *const kLeakedObjectProxyKey = &kLeakedObjectProxyKey;
    objc_setAssociatedObject(object, kLeakedObjectProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    
    [leakedObjectPtrs addObject:proxy.objectPtr];
    NSString *title = [[NSString stringWithFormat:@"%@", proxy.viewStack] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\t()"]];
    [self logLeakMessageWithObject:object title:title];
    
    if (![NSObject isEnableLeaksAlert]) {
        return;
    }
}

+ (void)logLeakMessageWithObject:(id)object title:(NSString *)title {
#if _INTERNAL_MLF_RC_ENABLED
    if ([NSObject isEnableCheckRetainCycle]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            Class FBRetainCycleDetectorClass = NSClassFromString(@"FBRetainCycleDetector");
            id detector = [[FBRetainCycleDetectorClass alloc] init];
            [detector addCandidate:object];
            NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:20];
            
            BOOL hasFound = NO;
            for (NSArray *retainCycle in retainCycles) {
                NSInteger index = 0;
                for (id<FBObjectiveCGraphElementProtocol> element in retainCycle) {
                    if (element.object == object) {
                        hasFound = YES;
                        NSArray *shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
                        
                        MBAPMMemoryMonitor *plugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
                        APMLeakModel * model = [[APMLeakModel alloc] init];
                        model.title = title;
                        model.message = [NSString stringWithFormat:@"%@", shiftedRetainCycle];;
                        [plugin logMemoryLeak:model];
                        [self alertWithTitle:model.title desc:model.message];
                        break;
                    }
                    
                    ++index;
                }
                if (hasFound) {
                    break;
                }
            }
            if (!hasFound) {
                MBAPMMemoryMonitor *plugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
                APMLeakModel * model = [[APMLeakModel alloc] init];
                model.title = title;
                model.message = @"";
                [plugin logMemoryLeak:model];
                [self alertWithTitle:model.title desc:nil];
            }
        });
        
        
    } else {
        MBAPMMemoryMonitor *plugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
        APMLeakModel * model = [[APMLeakModel alloc] init];
        model.title = title;
        model.message = @"";
        [plugin logMemoryLeak:model];
        [self alertWithTitle:model.title desc:nil];
        return;
    }
#else
    MBAPMMemoryMonitor *plugin = (MBAPMMemoryMonitor *)[[MBAPMPluginManager shared] getPlugin:MBAPMPluginTagMemory];
    APMLeakModel * model = [[APMLeakModel alloc] init];
    model.title = title;
    model.message = @"";
    [plugin logMemoryLeak:model];
    [self alertWithTitle:model.title desc:nil];
#endif
}

+ (void)alertWithTitle:(NSString *)text desc:(NSString *)desc {
    if ([NSObject isEnableLeaksAlert]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [NSString stringWithFormat:@"Memory Leak: %@", text];
            NSString *message = desc ?: @"Fail to find a retain cycle";
            [MLeaksMessenger alertWithTitle:title message:message];
        });
    }
}

- (void)dealloc {
    NSNumber *objectPtr = _objectPtr;
    NSArray *viewStack = _viewStack;
    dispatch_async(dispatch_get_main_queue(), ^{
        [leakedObjectPtrs removeObject:objectPtr];
        [MLeaksMessenger alertWithTitle:@"Object Deallocated"
                                message:[NSString stringWithFormat:@"%@", viewStack]];
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        return;
    }
    
    id object = self.object;
    if (!object) {
        return;
    }
    
#if _INTERNAL_MLF_RC_ENABLED
    if ([NSObject isEnableCheckRetainCycle]) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Class FBRetainCycleDetectorClass = NSClassFromString(@"FBRetainCycleDetector");
        id detector = [[FBRetainCycleDetectorClass alloc] init];
//        FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
        [detector addCandidate:self.object];
        NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:20];
        
        BOOL hasFound = NO;
        for (NSArray *retainCycle in retainCycles) {
            NSInteger index = 0;
            for (id<FBObjectiveCGraphElementProtocol> element in retainCycle) {
                if (element.object == object) {
                    NSArray *shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MLeaksMessenger alertWithTitle:@"Retain Cycle"
                                                message:[NSString stringWithFormat:@"%@", shiftedRetainCycle]];
                    });
                    hasFound = YES;
                    break;
                }
                
                ++index;
            }
            if (hasFound) {
                break;
            }
        }
        if (!hasFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MLeaksMessenger alertWithTitle:@"Retain Cycle"
                                        message:@"Fail to find a retain cycle"];
            });
        }
    });
    }
#endif
}

- (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray *result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

+ (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray *result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

@end
