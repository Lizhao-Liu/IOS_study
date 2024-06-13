//
//  MBAPMCallStackUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/8/16.
//

#import "MBAPMCallStackUtil.h"
#import "MBAPMBacktraceLogger.h"
#import "MBAPMLogDef.h"
#import <mach/mach.h>

@implementation MBAPMThreadStack

- (size_t)occupyMemorySize {
    return self.returnAddresses.count * sizeof(pointer_t) + sizeof(self.class);
}

@end

@implementation MBAPMCallStackUtil

+ (NSString *)callStackOfMainThread {
    MBAPMDebug(@"start");
    NSString *callStack = [MBAPMBacktraceLogger mbapm_backtraceOfMainThread];
    MBAPMDebug(@"end");
    MBAPMDebug(@"result:\n%@", callStack);
    return callStack;
}

+ (void)selfThreadStackByMatrix:(KSStackCursor *)stackCursor {
    NSArray *addresses = [NSThread callStackReturnAddresses];
    NSUInteger numFrames = addresses.count;
    uintptr_t *callstack = malloc(numFrames * sizeof(*callstack));
    for (NSUInteger i = 0; i < numFrames; i++) {
        callstack[i] = (uintptr_t)[addresses[i] unsignedLongLongValue];
    }
    KSMC_NEW_CONTEXT(machineContext);
    ksmc_getContextForThread(ksthread_self(), machineContext, false);
    kssc_initWithBacktrace(stackCursor, callstack, (int)numFrames, 2);
}

+ (void)selfThreadStackReturnAddresses:(MBAPMThreadStack *)threadStack {
    NSArray * returnAddresses = [NSThread callStackReturnAddresses];
    threadStack.returnAddresses = returnAddresses;
}

+ (void)selfThreadStackByMatrix:(KSStackCursor *)stackCursor withReturnAddresses:(NSArray *)addresses {
    NSUInteger numFrames = addresses.count;
    uintptr_t *callstack = malloc(numFrames * sizeof(*callstack));
    for (NSUInteger i = 0; i < numFrames; i++) {
        callstack[i] = (uintptr_t)[addresses[i] unsignedLongLongValue];
    }
    kssc_initWithBacktrace(stackCursor, callstack, (int)numFrames, 2);
}

@end
