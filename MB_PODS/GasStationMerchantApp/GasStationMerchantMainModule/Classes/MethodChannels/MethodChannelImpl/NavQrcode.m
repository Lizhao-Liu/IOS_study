//
//  NavQrcode.m
//  Runner
//
//  Created by heyAdrian on 2018/10/30.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavQrcode.h"

@implementation NavQrcode

- (void)createQrcode:(NSArray *)arguement {
    NSString *codeContent = arguement.count > 0 ? arguement[0] : nil;
    if (codeContent.length ==0) {
        !self.result ?: self.result(@"payCode内容为空!");
        return;
    }
    CGFloat qrCodeWidth = arguement.count > 1 ? [arguement[1] floatValue] : 0.0;
//    CGFloat qrCodeHeight = arguement.count > 2 ? [arguement[2] floatValue] : 0.0;
    
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSData *data = [codeContent dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    CGFloat size = qrCodeWidth;
    if (size == 0) {
        size = 100.0;
    }
    UIImage *qrCodeImage =[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    NSData *imageData = UIImageJPEGRepresentation(qrCodeImage, 1);
    !self.result ?: self.result([FlutterStandardTypedData typedDataWithBytes:imageData]);
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return newImage;
}

@end
