//
//  MBAPMZombieConfig.h
//  MBAPMLib
//
//  Created by xp on 2022/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBAPMZombieDetectStrategy) {
    MBAPMZombieDetectStrategyCustomObjectOnly = 1 << 0, //只监控自定义对象策略
    MBAPMZombieDetectStrategyWhiteList = 1 << 1, //白名单策略
    MBAPMZombieDetectStrategyAll = 1 << 2 //监控全部对象
};

@interface MBAPMZombieConfig : NSObject


/// 检测策略，MBAPMZombieDetectStrategyCustomObjectOnly可以和MBAPMZombieDetectStrategyWhiteList、MBAPMZombieDetectStrategyBlackList配合使用，MBAPMZombieDetectStrategyAll可以和MBAPMZombieDetectStrategyBlackList配合使用
@property (nonatomic, assign) MBAPMZombieDetectStrategy detectStrategy;


/// 设置检测到僵尸对象后是否触发崩溃
@property (nonatomic, assign) BOOL crashedWhenDetectZombie;


/// 设置是否记录对象释放堆栈
@property (nonatomic, assign) BOOL traceDeallocStack;



/// 对象类名白名单
@property (nonatomic, strong) NSArray<NSString *> *whiteList;


/// 对象类名黑名单
@property (nonatomic, strong) NSArray<NSString *> *blackList;

/// 设置释放对象和释放堆栈占有最大内存限制
@property (nonatomic, assign) NSUInteger maxOccupyMemorySize;









@end

NS_ASSUME_NONNULL_END
