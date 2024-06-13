//
//  MBAPMFPSUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBAPMFPSCallback)(CGFloat fps);

@interface MBAPMFPSUtil : NSObject

+ (MBAPMFPSUtil *)sharedInstance;

- (void)startFPSMonitor:(MBAPMFPSCallback)callback;

- (void)stopFPSMonitor;

- (BOOL)isHighFps;

@end

NS_ASSUME_NONNULL_END
