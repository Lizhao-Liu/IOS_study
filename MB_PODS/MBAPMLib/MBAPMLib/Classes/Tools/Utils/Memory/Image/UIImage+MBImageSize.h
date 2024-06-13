//
//  UIImage+MBImageSize.h
//  MBAPMLib
//
//  Created by 别施轩 on 2022/5/30.
//

#import <UIKit/UIKit.h>
@import SDWebImage;

NS_ASSUME_NONNULL_BEGIN


typedef void(^LargeImageBlock)(NSString * _Nullable path,  double imaegLength);

@interface UIImage (MBImageSize)

- (NSUInteger)imagesTotalLoadSize;

+ (void)startMonitorImageSize;
+ (void)stopMonitorImageSize;
+ (void)largeImageSizeThreshold:(double)threshold;
+ (void)largeImageCallBack:(LargeImageBlock)callback;

@end

NS_ASSUME_NONNULL_END
