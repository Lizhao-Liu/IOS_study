//
//  MBAPMContext.m
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import "MBAPMContext.h"

@implementation MBAPMContext

static MBAPMContext *sContextInstance;
+ (MBAPMContext *)createContext {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sContextInstance = [MBAPMContext new];
    });
    return sContextInstance;
}

+ (MBAPMContext *)globalContext {
    return sContextInstance;
}

- (NSMutableArray<NSString *> *)allRenderDetectBlockList {
    if(!_allRenderDetectBlockList) {
        _allRenderDetectBlockList = [[NSMutableArray<NSString *> alloc]init];
    }
    return _allRenderDetectBlockList;
}

@end
