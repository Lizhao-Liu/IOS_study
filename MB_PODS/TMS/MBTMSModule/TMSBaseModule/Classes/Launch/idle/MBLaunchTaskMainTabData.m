//
//  MBLaunchTaskMainTabData.m
//  YMMMainModule
//
//  Created by xp on 2022/4/18.
//

#import "MBLaunchTaskMainTabData.h"
#import "TMSBaseModule.h"
@import MBLauncherLib;
@import YMMMainServices;
@import MBFoundation;

@MBLaunchTaskEX(MBLaunchTaskMainTabData)
@interface MBLaunchTaskMainTabData() <MBLaunchTask> {
    uint64_t _enterBackgroundTime;
}

@end

@implementation MBLaunchTaskMainTabData


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - MBLaunchTask

- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneIdle;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    [self updateTabData:@"launch"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    return YES;
}

- (nonnull NSString *)taskName {
    return @"maintab_update";
}

#pragma mark - private method

- (void)updateTabData:(NSString *)updateScene {
    
    id<MBTabDataProtocol> tabDataService = GET_SERVICE(TMSBaseModule.class, MBTabDataProtocol);
    [tabDataService requestTabData];
}

- (void)enterBackground {
    _enterBackgroundTime = [MBLaunchTaskMainTabData currentTimestamp];
}

- (void)enterForeground {
    MB_WEAKIFY(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        MB_STRONGIFY(self)
        uint64_t currentTime = [MBLaunchTaskMainTabData currentTimestamp];
        if (currentTime - self->_enterBackgroundTime > 1000 * 60 * 10) {
            [self updateTabData:@"enterForeground"];
        }
    });
}

+ (long long)currentTimestamp {
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}

@end
