//
//  MBIdleTimerManager.m
//  MBFoundation
//  多个业务同时想对某一个全局性的设置进行赋值时候，会存在冲突，不好管理的情况，
//  此类即在解决此类问题。
//  Created by 张二板 on 2022/2/16.
//

#import "MBIdleTimerManager.h"

@interface MBIdleTimerManager(){
    NSMutableSet<NSString*> *_allKeysSet;
}
@end


static MBIdleTimerManager *_instance NS_EXTENSION_UNAVAILABLE_IOS("MBIdleTimerManager which use UIApplication.shared is NS_EXTENSION_UNAVAILABLE.");
@implementation MBIdleTimerManager

/// 是否开启屏幕常亮
/// @param turnOn 开关（YES表示打开屏幕常亮，NO表示禁用屏幕常亮）
/// @param identify 业务侧唯一标识符（用来标识该业务，）
+ (void)screenLight:(BOOL)turnOn key:(NSString *)identify{
    [[MBIdleTimerManager sharedInstance] screenLight:turnOn key:identify];
}

- (void)screenLight:(BOOL)turnOn key:(NSString *)identify{
    
    //1、业务侧唯一标识符不符合要求，直接return
    if (!identify || ![identify isKindOfClass:NSString.class] || identify.length == 0) {
        return;
    }
    
    @synchronized(self) {
        if (turnOn&&![_allKeysSet containsObject:identify]) {
            //2、identify添加到集合里面，说明是有业务方想要屏幕常亮
            [_allKeysSet addObject:identify];
        }
        else if(!turnOn&&[_allKeysSet containsObject:identify]){
            //3、identify从集合里面移除，说明是有业务方想要禁用屏幕常亮（并不代表一定会禁用）
            [_allKeysSet removeObject:identify];
        }
        //4、最终描述的口语化一点：只要有一个人说想要屏幕常亮，那一定是屏幕常亮。
        [self handleIdleTimer:_allKeysSet.count > 0];
    }
}

#pragma mark - Action

- (void)handleIdleTimer:(BOOL)disabled{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:disabled];
    });
}

#pragma mark - singleton

+ (MBIdleTimerManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allKeysSet = [NSMutableSet set];
    }
    return self;
}

@end
