//
//  MBDebugFPSUtil.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MBDebugFPSBlock)(NSInteger fps);

@interface MBDebugFPSUtil : NSObject

- (void)start;
- (void)end;
- (void)addFPSBlock:(MBDebugFPSBlock)block;

@end

NS_ASSUME_NONNULL_END
