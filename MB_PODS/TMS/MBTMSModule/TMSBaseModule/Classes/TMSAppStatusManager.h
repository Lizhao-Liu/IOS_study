//
//  TMSAppStatusManager.h
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMSAppStatusManager : NSObject

+ (instancetype)shared;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (void)setSchemeOpenAppState:(BOOL)state;

/// 判断是否是外链打开App，包括通过url scheme和notification两种场景
/// 注意：在第一次从二级页面返回主页后会重置为NO
- (BOOL)isSchemeOpenApp;

@end

NS_ASSUME_NONNULL_END
