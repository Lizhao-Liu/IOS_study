//
//  UIImage+HCBCodeScanerExtension.m
//  HCBCodeScaner
//
//  Created by tp on 2018/6/20.
//

#import "UIImage+HCBCodeScanerExtension.h"
#import <CoreImage/CoreImage.h>
#import "HCBCodeScaner.h"
#import <Vision/Vision.h>
@import ScanKitFrameWork;

@implementation UIImage (HCBCodeScaner_Recognize)

- (NSString *)hcb_cs_recognize {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];

    CIImage *ciimage = [[CIImage alloc] initWithImage:self];

    if (!ciimage) {
        return nil;
    }

    NSArray<CIFeature *> *features = [detector featuresInImage:ciimage];

    if (features.count == 0) {
        return nil;
    }

    NSMutableString *result = [NSMutableString string];

    for (CIFeature *feature in features) {
        if (![feature isKindOfClass:[CIQRCodeFeature class]]) {
            continue;
        }
        NSString *messageString = [(CIQRCodeFeature *)feature messageString];
        if (messageString != nil) {
            [result appendFormat:@"%@", messageString];
        }
    }

    return result.length == 0 ? nil : result.copy;
}

- (NSString *)mb_cs_recognizeType:(MBImageScanFormatType)formatType {
    
    NSDictionary *dataDic = [HmsBitMap bitMapForImage:self withOptions:[self optionsBy:formatType]];
    if (dataDic == nil || dataDic.count <= 0) {
        return nil;
    }
    
    NSString *result = dataDic[@"text"];
    return result.length == 0 ? nil : result.copy;
}

- (HmsScanOptions *)optionsBy:(MBImageScanFormatType)formatType {
    HmsScanOptions *options = nil;
    if (formatType == MBImageScanFormatTypeQR) {
        options = [[HmsScanOptions alloc] initWithScanFormatType:(QR_CODE | DATA_MATRIX)];
    } else {
        options = [[HmsScanOptions alloc] initWithScanFormatType:ALL];
    }
    return options;
}

static NSBundle *__codescanerBundle = nil;
+ (UIImage *)imageNamed_CodeScaner:(NSString *)name {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __codescanerBundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[HCBCodeScaner class]] URLForResource:@"HCBCodeScaner" withExtension:@"bundle"]];
    });
    NSString *fullName = [NSString stringWithFormat:@"%@@%dx", name, (int)[UIScreen mainScreen].scale];
    NSString *filePath = [__codescanerBundle pathForResource:fullName ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    if (!img) {
        img = [UIImage imageWithContentsOfFile:[__codescanerBundle pathForResource:name ofType:@"png"]];
    }
    return img;
}

@end
