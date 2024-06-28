//
//  MBEventScheduler.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/8/22.
//

#import "MBEventScheduler.h"
#import "MBEventTargetQueueScheduler.h"
#import "MBEventImmediateScheduler.h"
#import "MBEventScheduler+Private.h"

@interface MBEventScheduler ()

@property (nonatomic, readonly, copy) NSString *name;
@end

@implementation MBEventScheduler

- (instancetype)initWithName:(NSString *)name {
    self = [super init];

    if (name == nil) {
        _name = [NSString stringWithFormat:@"com.mb.%@.anonymousScheduler", self.class];
    } else {
        _name = [name copy];
    }

    return self;
}

#pragma mark - Schedulers
+ (MBEventScheduler *)immediateScheduler {
    static dispatch_once_t onceToken;
    static MBEventScheduler *immediateScheduler;
    dispatch_once(&onceToken, ^{
        immediateScheduler = [[MBEventImmediateScheduler alloc] init];
    });
    
    return immediateScheduler;
}

+ (MBEventScheduler *)mainThreadScheduler {
    static dispatch_once_t onceToken;
    static MBEventScheduler *mainThreadScheduler;
    dispatch_once(&onceToken, ^{
        mainThreadScheduler = [[MBEventTargetQueueScheduler alloc] initWithName:@"com.mb.ContainerScheduler.mainThreadScheduler" targetQueue:dispatch_get_main_queue()];
    });
    
    return mainThreadScheduler;
}

#pragma mark Scheduling

- (void)schedule:(void (^)(void))block {
    NSCAssert(NO, @"%@ must be implemented by subclasses.", NSStringFromSelector(_cmd));
}

@end
