//
//  MBMemoryOOMDetector.m
//  
//
//  Created by 别施轩 on 2022/8/10.
//

#import "MBMemoryOOMCounter.h"
#import "MBAPMServiceContext.h"
#import "MBAPMAppStateUtil.h"

@import ObjectiveC;
@import MMKV;

static NSString * const kMBAPMMemoryWarningKey_Warning = @"kMBAPMMemoryWarningKey_Warning";
static NSString * const kMBAPMMemoryWarningKey_WarningExitInfo = @"kMBAPMMemoryWarningKey_WarningExitInfo";

@interface MBMemoryOOMCounter () {
    dispatch_queue_t _storeQueue;
}

@end

@implementation MBMemoryOOMCounter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _storeQueue = dispatch_queue_create("com.apm.memory.oom_counter", DISPATCH_QUEUE_SERIAL);
        [self addObserver];
        [self checkOOM];
    }
    return self;
}

- (void)checkOOM {
    dispatch_async(_storeQueue, ^{
        NSUInteger lastIs = [self lastExitWithMemoryWarning];
        [self updateStorageWarningExitInfo:lastIs];
        [self storageWarningExitInfo];
    });
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(memoryWarning)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

- (void)memoryWarning {
    // 更新app
    [[MBAPMAppStateUtil shared] updateAppAliveInfo];
    
    // 0105 如果是后台收到的warning，忽略
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    
    //内存告警的时候记录次数
    dispatch_async(_storeQueue, ^{
        [self memoryWarningTimesPlusOrMinus:YES];
    });
    
    //一定时间后，如果 app 还存活，减少次数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), _storeQueue, ^{
        [self memoryWarningTimesPlusOrMinus:NO];
    });
}

- (void)memoryWarningTimesPlusOrMinus:(BOOL)pom {
    NSInteger i = [[MMKV defaultMMKV] getInt64ForKey:kMBAPMMemoryWarningKey_Warning];
    if (pom) {
        ++i;
    } else {
        if (i > 0) {
            --i;
        }
    }
    [self setWarningTimes:i];
}

- (void)appWillTerminate {
    dispatch_async(_storeQueue, ^{
        [self setWarningTimes:0];
    });
    [[MBAPMAppStateUtil shared] updateAppAliveInfo];
}

- (void)setCallBack:(MemoryOOMCounterCallback)callBack {
    _callBack = callBack;
    
    if (_callBack) {
        BOOL isBackground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] == UIApplicationStateBackground;
        _callBack([self lastExitWithMemoryWarning], isBackground);
        
        dispatch_async(_storeQueue, ^{
            [self setWarningTimes:0];
        });
    }
}

- (BOOL)lastExitWithMemoryWarning {
    static BOOL lastIs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger value = [[MMKV defaultMMKV] getInt64ForKey:kMBAPMMemoryWarningKey_Warning];
        lastIs = value != 0;
    });
    return lastIs;
}

- (void)setWarningTimes:(NSInteger)times {
    [[MMKV defaultMMKV] setInt64:times forKey:kMBAPMMemoryWarningKey_Warning];
}

- (void)updateStorageWarningExitInfo:(BOOL)lastIsExitWithMemoryWarning {
    NSUInteger value = [[MMKV defaultMMKV] getInt64ForKey:kMBAPMMemoryWarningKey_WarningExitInfo];
    if (value > INT32_MAX) {
        value = (value >> 16);
    }
    value = (value << 1) + lastIsExitWithMemoryWarning;
    [[MMKV defaultMMKV] setInt64:value forKey:kMBAPMMemoryWarningKey_WarningExitInfo];
}

- (void)cleanStorageWarningExitInfo {
    dispatch_async(_storeQueue, ^{
        [[MMKV defaultMMKV] setInt64:0 forKey:kMBAPMMemoryWarningKey_WarningExitInfo];
    });
}

- (NSUInteger)storageWarningExitInfo {
    static NSUInteger memoryWarningExitInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger value = [[MMKV defaultMMKV] getInt64ForKey:kMBAPMMemoryWarningKey_WarningExitInfo];
        memoryWarningExitInfo = value;
    });
    return memoryWarningExitInfo;
}

@end
