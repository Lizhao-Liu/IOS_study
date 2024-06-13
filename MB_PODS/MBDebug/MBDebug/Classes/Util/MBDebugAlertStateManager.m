//
//  MBDebugAlertStateManager.m
//  MBDebug
//
//  Created by Lizhao on 2023/10/20.
//

#import "MBDebugAlertStateManager.h"
#import "MBDebugDefine.h"

@interface MBDebugAlertStateManager()

@property (nonatomic, strong) NSHashTable *allShowRedDotCallers;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation MBDebugAlertStateManager

DEFINE_SINGLETON_FOR_CLASS(MBDebugAlertStateManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isToastAlertDisabled = NO;
        _semaphore = dispatch_semaphore_create(1);
        _allShowRedDotCallers = [NSHashTable weakObjectsHashTable];
        [self registerRedDotNotifications];
    }
    return self;
}

- (void)registerRedDotNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRedDotFromNotification:) name:MBDebugMonitorShowRedDotNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRedDotFromNotification:) name:MBDebugMonitorHideRedDotNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBDebugMonitorShowRedDotNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBDebugMonitorHideRedDotNotification object:nil];
}

#pragma mark - event handlers

- (void)showRedDotFromNotification:(NSNotification *)notification {
    NSString *monitorTitle = [notification.userInfo mb_stringForKey:@"monitorTitle"];
    [self showRedDot:monitorTitle];
}

- (void)hideRedDotFromNotification:(NSNotification *)notification {
    NSString *monitorTitle = [notification.userInfo mb_stringForKey:@"monitorTitle"];
    [self hideRedDot:monitorTitle];
}

- (void)showRedDot:(id)caller{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if([self.allShowRedDotCallers containsObject:caller]){
        dispatch_semaphore_signal(_semaphore);
        return;
    }
    
    [self.allShowRedDotCallers addObject:caller];
    if(self.allShowRedDotCallers.count > 0 && self.isRedDotVisible==NO){
        self.isRedDotVisible = YES;
    }
    dispatch_semaphore_signal(_semaphore);
}

- (void)hideRedDot:(id)caller {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    if(![self.allShowRedDotCallers containsObject:caller]){
        dispatch_semaphore_signal(_semaphore);
        return;
    }
    [self.allShowRedDotCallers removeObject:caller];
    if(self.allShowRedDotCallers.count == 0 && self.isRedDotVisible){
        self.isRedDotVisible = NO;
    }
    dispatch_semaphore_signal(_semaphore);
}

- (BOOL)shouldShowRedDot:(id)caller{
    return [self.allShowRedDotCallers containsObject:caller];
}

@end
