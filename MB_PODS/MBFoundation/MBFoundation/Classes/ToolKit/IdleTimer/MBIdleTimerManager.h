//
//  MBIdleTimerManager.h
//  MBFoundation
//
//  Created by 张二板 on 2022/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_EXTENSION_UNAVAILABLE_IOS("MBIdleTimerManager which use UIApplication.shared is NS_EXTENSION_UNAVAILABLE.")
@interface MBIdleTimerManager : NSObject

/// 是否开启屏幕常亮
/// @param turnOn 开关（YES表示打开屏幕常亮，NO表示禁用屏幕常亮）
/// @param identify 业务侧的唯一标识符，业务侧自定义
+ (void)screenLight:(BOOL)turnOn key:(NSString *)identify;

+ (MBIdleTimerManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
