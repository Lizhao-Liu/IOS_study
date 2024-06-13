//
//  UIImage+MBImageSize.m
//  MBAPMLib
//
//  Created by 别施轩 on 2022/5/30.
//

#import "UIImage+MBImageSize.h"
#import <objc/runtime.h>

@import MBBuildPreLib;

@interface MBSDWebImageDelegateObject : NSObject <SDWebImageManagerDelegate>

@end

static BOOL mb_startMonitorImageSize = NO;
static double mb_largeImageSizeThreshold = 5000;
static LargeImageBlock mb_largeImageBlock;
static MBSDWebImageDelegateObject * mb_webImageDelegate;

@implementation MBSDWebImageDelegateObject

#pragma mark -- sdwebimagemanager delegate

- (void)imageManager:(SDWebImageManager *)imageManager didLoadImageForURL:(NSURL *)imageURL image:(UIImage *)downloadedImage data:(NSData *)downloadedData {
    if (mb_startMonitorImageSize) {
        double imageLength = downloadedImage.imagesTotalLoadSize / 1000;
        if (imageLength > mb_largeImageSizeThreshold) {
            mb_largeImageBlock(imageURL.absoluteString, imageLength);
        } else {
            if ([MBFMacro ymm_buildDebug] || [MBFMacro ymm_buildAdhoc]) {
                if ([downloadedImage sd_imageFormat] == SDImageFormatWebP) {
                    mb_largeImageBlock([NSString stringWithFormat:@"(webp)%@", imageURL.absoluteString], imageLength);
                }
            }
        }
    }
}

@end

@implementation UIImage (MBImageSize)

+ (void)startMonitorImageSize {
    // 7.33/8.33 修复线上大图没有上报的问题。
    mb_startMonitorImageSize = YES;
    if ([MBFMacro ymm_buildDebug] || [MBFMacro ymm_buildAdhoc]) {
        Class cls = object_getClass(self);
        
        Method srcMethod = class_getClassMethod(cls, @selector(imageNamed:inBundle:compatibleWithTraitCollection:));
        Method tarMethod = class_getClassMethod(cls, @selector(mb_swizzle_imageNamed:inBundle:compatibleWithTraitCollection:));
        
        method_exchangeImplementations(srcMethod, tarMethod);
        
        Method srcMethod2 = class_getClassMethod(cls, @selector(imageWithContentsOfFile:));
        Method tarMethod2 = class_getClassMethod(cls, @selector(mb_swizzle_imageWithContentsOfFile:));
        
        method_exchangeImplementations(srcMethod2, tarMethod2);
        
    }
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        mb_webImageDelegate = [[MBSDWebImageDelegateObject alloc] init];
        [SDWebImageManager sharedManager].delegate = mb_webImageDelegate;
    });
    
}

+ (void)stopMonitorImageSize {
    mb_startMonitorImageSize = NO;
}

+ (void)largeImageSizeThreshold:(double)threshold {
    mb_largeImageSizeThreshold = threshold;
}
+ (void)largeImageCallBack:(LargeImageBlock)callback {
    mb_largeImageBlock = callback;
}

+ (UIImage *)mb_swizzle_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *)traitCollection {
    UIImage *image = [self mb_swizzle_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
    if (mb_startMonitorImageSize) {
        double imageLength = image.imagesTotalLoadSize / 1000;
        if (imageLength > mb_largeImageSizeThreshold) {
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@", bundle.bundleIdentifier ?: @"", name];
            mb_largeImageBlock(imagePath, imageLength);
        }
    }
    return image;
}


+ (UIImage *)mb_swizzle_imageWithContentsOfFile:(NSString *)path {
    UIImage *image = [self mb_swizzle_imageWithContentsOfFile:path];
    if (mb_startMonitorImageSize) {
        double imageLength = image.imagesTotalLoadSize / 1000;
        if (imageLength > mb_largeImageSizeThreshold) {
            mb_largeImageBlock(path, imageLength);
        }
    }
    return image;
}

- (NSUInteger)imagesTotalLoadSize {
    __block NSUInteger totalSize = 0;
    if (self.images) {
        [self.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            double imageLoadSize = image.size.width * image.size.height * self.scale * 4;
            totalSize += imageLoadSize;
        }];
    } else {
        double imageLoadSize = self.size.width * self.size.height * self.scale * 4;
        totalSize += imageLoadSize;
    }
    return  totalSize;
}
@end
