//
//  TMSAppStatusManager.m
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/18.
//

#import "TMSAppStatusManager.h"

@interface TMSAppStatusManager () {
    BOOL _schemeOpenAppState;
}

@end

@implementation TMSAppStatusManager

+ (instancetype)shared {
    static TMSAppStatusManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TMSAppStatusManager alloc]init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        _schemeOpenAppState = NO;
    }
    return self;
}

- (void)setSchemeOpenAppState:(BOOL)state {
    _schemeOpenAppState = state;
}

- (BOOL)isSchemeOpenApp {
    return _schemeOpenAppState;
}


@end
