//
//  UIImage+HCBCodeScanerExtension.h
//  HCBCodeScaner
//
//  Created by tp on 2018/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBImageScanFormatType) {
    MBImageScanFormatTypeQR = 0,         // 二维码
    MBImageScanFormatTypeQRAndBar = 1    // 二维码、条形码
};

@interface UIImage (HCBCodeScaner_Recognize)

- (nullable NSString *)hcb_cs_recognize;

- (NSString *)mb_cs_recognizeType:(MBImageScanFormatType)formatType;

+ (nullable UIImage *)imageNamed_CodeScaner:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
