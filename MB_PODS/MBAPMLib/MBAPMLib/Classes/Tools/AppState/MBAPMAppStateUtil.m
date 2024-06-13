//
//  MBAPMAppStateUtil.m
//  MBAPMLib
//
//  Created by xp on 2022/6/7.
//

#import "MBAPMAppStateUtil.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMServiceContext.h"

@import MBStorageLibService;
@import MMKV;
@import MBProjectConfig;

static NSString * const kMBAPMDataCacheStorageKey_LastLaunchId = @"kMBAPMDataCacheStorageKey_LastLaunchId";
static NSString * const kMBAPMDataLaunchKey_LastLaunchStart = @"kMBAPMDataLaunchKey_LastLaunchStart";
static NSString * const kMBAPMDataLaunchKey_LastLaunchEnd = @"kMBAPMDataLaunchKey_LastLaunchEnd";
static NSString * const kMBAPMDataLaunchKey_LastAppState = @"kMBAPMDataLaunchKey_LastAppState";

@interface MBAPMAppStateUtil()
// current
@property (nonatomic, assign) UInt64 launchStartTime;
@property (nonatomic, assign) UIApplicationState applicationState;
@property (nonatomic, assign) BOOL isJail;
@property (nonatomic, assign) UInt64 appRunTime;

// last
@property (nonatomic, assign) UInt64 lastLaunchAppRunTime;
@property (nonatomic, assign) UInt64 lastLaunchStartTime;
@property (nonatomic, assign) UInt64 lastLaunchEndTime;
@property (nonatomic, strong) NSString *lastLaunchId;
@property (nonatomic, assign) UIApplicationState lastLaunchApplicationState;

@end

@implementation MBAPMAppStateUtil

+ (instancetype)shared {
    static MBAPMAppStateUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMAppStateUtil alloc]init];
        // UIApplicationStateInactive | UIApplicationStateBackground | 0xfffffffffffffffc
        instance.lastLaunchApplicationState = -1;
    });
    return instance;
}

# pragma mark - get
- (UInt64)appRunTime {
    UInt64 currentTime = [MBAPMTimeUtil currentTimestamp];
    return currentTime - self.launchStartTime;
}

- (UInt64)lastLaunchAppRunTime {
    return [self lastLaunchStartTime] - [self lastLaunchEndTime];
}

- (UInt64)lastLaunchStartTime {
    if (_lastLaunchStartTime) {
        return _lastLaunchStartTime;
    }
    _lastLaunchStartTime = [[MMKV defaultMMKV] getUInt64ForKey:kMBAPMDataLaunchKey_LastLaunchStart];
    return _lastLaunchStartTime;
}

- (UInt64)lastLaunchEndTime {
    if (_lastLaunchEndTime) {
        return _lastLaunchEndTime;
    }
    _lastLaunchEndTime = [[MMKV defaultMMKV] getUInt64ForKey:kMBAPMDataLaunchKey_LastLaunchEnd];
    return _lastLaunchEndTime;
}

- (UIApplicationState)lastLaunchApplicationState {
    if (_lastLaunchApplicationState != -1) {
        return _lastLaunchApplicationState;
    }
    
    UInt64 state = [[MMKV defaultMMKV] getUInt64ForKey:kMBAPMDataLaunchKey_LastAppState];
    _lastLaunchApplicationState = (state >= 0 && state <= 2) ? state : UIApplicationStateActive;
    return _lastLaunchApplicationState;
}

- (BOOL)isJail {
    return [MBAppDelegate appInfo].isJail;
}

# pragma mark - update
- (void)updateApplicationState {
    _applicationState = [UIApplication sharedApplication].applicationState;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MMKV defaultMMKV] setInt64:[UIApplication sharedApplication].applicationState forKey:kMBAPMDataLaunchKey_LastAppState];
    });
}

- (void)updateAppAliveInfo {
    [[MMKV defaultMMKV] setUInt64:[MBAPMTimeUtil currentTimestamp] forKey:kMBAPMDataLaunchKey_LastLaunchEnd];
}

- (UIApplicationState)applicationState {
    return _applicationState;
}

- (NSString *)lastLaunchId {
    if (_lastLaunchId) {
        return _lastLaunchId;
    }
    
    _lastLaunchId = [[MMKV defaultMMKV] getStringForKey:kMBAPMDataCacheStorageKey_LastLaunchId];
    if (_lastLaunchId) {
        return _lastLaunchId;
    }
    
    MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
    id<MBStorageProtocol> storage = BIND_SERVICE(serviceContext , MBStorageProtocol);
    _lastLaunchId = [storage getString:kMBAPMDataCacheStorageKey_LastLaunchId];
    return _lastLaunchId;
}

- (void)configAppLaunchWithId:(NSString *)currentLaunchId {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self lastLaunchStartTime];
        [self lastLaunchEndTime];
        [self lastLaunchId];
        [self lastLaunchApplicationState];
        
        _launchStartTime = [MBAPMTimeUtil currentTimestamp];
        [[MMKV defaultMMKV] setUInt64: [MBAPMTimeUtil currentTimestamp] forKey:kMBAPMDataLaunchKey_LastLaunchStart];
        [[MMKV defaultMMKV] setString:currentLaunchId forKey:kMBAPMDataCacheStorageKey_LastLaunchId];
        
        MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
        id<MBStorageProtocol> storage = BIND_SERVICE(serviceContext , MBStorageProtocol);
        [storage set:currentLaunchId forKey:kMBAPMDataCacheStorageKey_LastLaunchId];
    });
}


@end
