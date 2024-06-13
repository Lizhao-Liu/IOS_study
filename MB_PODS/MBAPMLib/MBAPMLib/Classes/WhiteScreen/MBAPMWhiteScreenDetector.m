//
//  MBAPMWhiteScreenDetector.m
//  Pods
//
//  Created by 别施轩 on 2023/7/24.
//

#import "MBAPMWhiteScreenDetector.h"
#import "MBAPMPageLaunchDivideCenter.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMDataUploader.h"
#import "MBAPMLogDef.h"
#import "MBAPMWhiteScreenCounter.h"

@import MBUIKit;
@import MBDoctorService;
@import MBAPMServiceLib;
@import YYModel;
@import YMMModuleLib;

#import <objc/runtime.h>

@interface MBAPMPageviewStepInfo (YYModel) <YYModel>

@end

@implementation MBAPMPageviewStepInfo  (YYModel)

@end


@interface UIViewController (MBAPMWhiteScreenDetector)

@end

@implementation UIViewController (MBAPMWhiteScreenDetector)

- (BOOL)whiteScreen_hasAppearFlag {
    return [objc_getAssociatedObject(self, @selector(whiteScreen_hasAppearFlag)) boolValue];
}

- (void)setWhiteScreen_hasAppearFlag:(BOOL)hasAppearFlag {
    objc_setAssociatedObject(self, @selector(whiteScreen_hasAppearFlag), @(hasAppearFlag), OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation MBAPMWhiteScreenData : NSObject
@end

@interface MBAPMWhiteScreenDetector () <MBAPMPageLaunchDivideCenterProtocal>

@end

@interface MBAPMWhiteScreenDetector ()
@property (nonatomic, weak) id<MBAPMWhiteScreenDetectorDelegate> delegate;

@end

@implementation MBAPMWhiteScreenDetector


- (void)startDetectWithDelegate:(id<MBAPMWhiteScreenDetectorDelegate>)delegate {
    [[MBAPMPageLaunchDivideCenter sharedInstance] setDelegate:self];
    _delegate = delegate;
}

- (void)stopDetect {
    
}

//MARK: -

// 需要在主线程调用
- (void)whiteScreenCheck:(nonnull NSString *)pageName duration:(NSUInteger)duration moduleInfo:(MBModuleInfo *)moduleInfo controller:(UIViewController *)controller {
    
//    NSLog(@"😁%s: %d %s😁\n%@", __FILE_NAME__, __LINE__, __FUNCTION__, pageName);
//    NSLog(@"😁%s: %d %s😁\n%@", __FILE_NAME__, __LINE__, __FUNCTION__, controller);
    NSTimeInterval t1 = [[NSDate date] timeIntervalSince1970] * 1000;
    // 截屏
    __block UIEdgeInsets inset;
    __block double pixelRatio;
    [self vcScreenAnalysisStrategy:controller complete:^(UIEdgeInsets aInset, double aPixelRatio) {
        inset = aInset;
        pixelRatio = aPixelRatio;
    }];
    
    UIViewController *topVC = controller;
    __block UIImage *image;
    __block BOOL isScaled;
    __block BOOL isWindow;
    if ([controller respondsToSelector:@selector(mbapm_whiteScreenCapture:callback:)]) {
        [topVC mbapm_whiteScreenCapture:pixelRatio callback:^(BOOL resultIsScaled, UIImage *captureImage, BOOL resultIsWindow) {
            image = captureImage;
            isWindow = resultIsWindow;
        }];
    } else {
        [self mbapm_whiteScreenCaptureVC:topVC scaleRatio:0 callback:^(BOOL resultIsScaled, UIImage *captureImage, BOOL resultIsWindow) {
            image = captureImage;
            isWindow = resultIsWindow;
        }];
    }
    
    NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970] * 1000;
    // 分析
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSInteger whiteC;
        __block NSInteger blackC;
        __block NSInteger totalC;
        __block BOOL pureImg;
        __block CGFloat xPCWhite;
        __block CGFloat yPCWhite;
        __block CGFloat xPCBlack;
        __block CGFloat yPCBlack;
        [self pixelDetection:image isScaled:isScaled inset:inset pixelRatio:pixelRatio completion:^(NSInteger whiteCount, NSInteger blackCount, NSInteger totalCount, BOOL pureImage, CGFloat xPrecentWhite, CGFloat yPrecentWhite, CGFloat xPrecentBlack, CGFloat yPrecentBlack) {
            whiteC = whiteCount;
            blackC = blackCount;
            totalC = totalCount;
            pureImg = pureImage;
            xPCWhite = xPrecentWhite;
            yPCWhite = yPrecentWhite;
            xPCBlack = xPrecentBlack;
            yPCBlack = yPrecentBlack;
        }];
        
        if (totalC <= 0) {
            return;
        }
        NSInteger bitmapDtectResult = 0;
        BOOL whiteScreen = NO;
        NSString *coverLog = @"";
        CGFloat coverRatio = 0;
        //((CGFloat)whiteC)/((CGFloat)totalC) > 0.95 || ((CGFloat)blackC)/((CGFloat)totalC) > 0.95 ||
        if (((CGFloat)whiteC)/((CGFloat)totalC) > 0.95) {
            bitmapDtectResult = 1;
            coverRatio = ((CGFloat)whiteC)/((CGFloat)totalC);
            whiteScreen = !((yPCBlack > 0.3 && xPCBlack > 0.5) || (yPCBlack > 0.5 && xPCBlack > 0.3));
            coverLog = [NSString stringWithFormat:@"%f,%f", xPCBlack, yPCBlack];
        } else if (((CGFloat)blackC)/((CGFloat)totalC) > 0.95) {
            bitmapDtectResult = 1;
            coverRatio = ((CGFloat)blackC)/((CGFloat)totalC);
            whiteScreen = !((yPCWhite > 0.3 && xPCWhite > 0.5) || (yPCWhite > 0.5 && xPCWhite > 0.3));
            coverLog = [NSString stringWithFormat:@"%f,%f", xPCWhite, yPCWhite];
        }
        
        
        NSTimeInterval t3 = [[NSDate date] timeIntervalSince1970] * 1000;
        
        __block MBAPMWhiteScreenData *data = [[MBAPMWhiteScreenData alloc] init];
        data.pageId = pageName ?: [MBAPMCurrentPageInfo currentPageName];;
        data.pagePath = [MBAPMCurrentPageInfo currentPagePath];
        data.pageClassName = [MBAPMCurrentPageInfo currentPageClassName];
        data.isCaptured = YES;
        data.captureCostTime = t2 - t1;
        data.analysisCostTime = t3 - t2;
        data.isWhiteScreen = whiteScreen;
        data.isFinished = YES;
        
        data.captureRatio = 0.25;
        data.timeoutDuration = 10;
        data.whitepixelRatio = 0.95;
        data.source = @"apm";
        data.detectSenario = @"pageview";
        data.moduleInfo = moduleInfo;
#if DEBUG
        [self temp_debugHandleImage:image isWhite:whiteScreen vc:controller desc: [NSString stringWithFormat:@"%lu/%lu/%lu/%d\n%f\n%f", whiteC, blackC, totalC, pureImg, whiteC / MAX(totalC, 1.0), blackC / MAX(totalC, 1.0)]];
#endif
        
        if (whiteScreen) {
            bitmapDtectResult = 2;
            [[MBAPMWhiteScreenCounter shared] whiteScreen:data];
        } else {
            [[MBAPMWhiteScreenCounter shared] notWhiteScreen:data.pageId techStack:data.moduleInfo.bundleType];
        }
        data.bitmapDtectResult = bitmapDtectResult;
        
        if (!self.apmConfiguration.enableWhiteScreenUploadImageMonitor) {
            if (whiteScreen) {
                MBAPMDataUploader *uploader = [MBAPMDataUploader new];
                __weak typeof(self) weakSelf = self;
                [uploader uploadData:UIImageJPEGRepresentation(image, 0.95) extensionName:@"jpg" success:^(NSString * _Nullable uri) {
                    __strong typeof(self) strongSelf = weakSelf;
                    MBAPMLogInfo(@"White screen image upload success, uri = %@", uri);
                    data.exceptionType = [self vcExceptionType:topVC];
                    data.hasBitMap = YES;
                    data.attrs = @{@"window": @(isWindow), @"bitmap": uri ?: @"", @"duration": @(duration ?: 0), @"steps": [self vcPageviewExecuteSteps:topVC] ?: @""};
                    data.errorFeature = [NSString stringWithFormat:@"截屏白屏 %@", data.pageId ?: data.pagePath ?: @""];
                    if (strongSelf.delegate
                        && [strongSelf.delegate respondsToSelector:@selector(whiteScreen:data:)]) {
                        [strongSelf.delegate whiteScreen:pageName data:data];
                    }
                    //                NSLog(@"😁%s: %d %s😁\n%@", __FILE_NAME__, __LINE__, __FUNCTION__, controller);
                } failure:^(NSError * _Nullable errorObj) {
                    __strong typeof(self) strongSelf = weakSelf;
                    MBAPMError(@"White screen image fails, errorCode = %ld", (long)errorObj.code);
                    data.exceptionType = [self vcExceptionType:topVC];
                    data.hasBitMap = NO;
                    data.attrs = @{@"window": @(isWindow), @"bitmap": @"", @"duration": @(duration ?: 0), @"steps": [self vcPageviewExecuteSteps:topVC] ?: @""};
                    data.errorFeature = [NSString stringWithFormat:@"截屏白屏 %@", data.pageId ?: data.pagePath ?: @""];
                    if (strongSelf.delegate
                        && [strongSelf.delegate respondsToSelector:@selector(whiteScreen:data:)]) {
                        [strongSelf.delegate whiteScreen:pageName data:data];
                    }
                }];
            }
            
            data.attrs = @{@"timeout_duration": @(data.timeoutDuration ?: 0), @"capture_ratio": @(data.captureCostTime ?: 0), @"whitepixel_ratio": @(data.whitepixelRatio), @"pixe_ratio_threshold": @(0.95), @"pixel_asis_cover_rate": coverLog, @"pixel_ratio": @(coverRatio)};
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(whiteScreenDetect:data:)]) {
                [self.delegate whiteScreenDetect:pageName data:data];
            }
            return;
            
        }
        
        MBAPMDataUploader *uploader = [MBAPMDataUploader new];
        __weak typeof(self) weakSelf = self;
        [uploader uploadData:UIImageJPEGRepresentation(image, 0.95) extensionName:@"jpg" success:^(NSString * _Nullable uri) {
            __strong typeof(self) strongSelf = weakSelf;
            MBAPMLogInfo(@"White screen image upload success, uri = %@", uri);
            if (whiteScreen) {
                data.exceptionType = [self vcExceptionType:topVC];
                data.hasBitMap = YES;
                data.attrs = @{@"window": @(isWindow), @"bitmap": uri ?: @"", @"duration": @(duration ?: 0), @"steps": [self vcPageviewExecuteSteps:topVC] ?: @""};
                data.errorFeature = [NSString stringWithFormat:@"截屏白屏 %@", data.pageId ?: data.pagePath ?: @""];
                if (strongSelf.delegate
                    && [strongSelf.delegate respondsToSelector:@selector(whiteScreen:data:)]) {
                    [strongSelf.delegate whiteScreen:pageName data:data];
                }
            }
            
            data.attrs = @{@"timeout_duration": @(data.timeoutDuration ?: 0), @"capture_ratio": @(data.captureCostTime ?: 0), @"whitepixel_ratio": @(data.whitepixelRatio), @"pixe_ratio_threshold": @(0.95), @"pixel_asis_cover_rate": coverLog, @"pixel_ratio": @(coverRatio)};
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(whiteScreenDetect:data:)]) {
                [self.delegate whiteScreenDetect:pageName data:data];
            }
            
            //                NSLog(@"😁%s: %d %s😁\n%@", __FILE_NAME__, __LINE__, __FUNCTION__, controller);
        } failure:^(NSError * _Nullable errorObj) {
            __strong typeof(self) strongSelf = weakSelf;
            MBAPMError(@"White screen image fails, errorCode = %ld", (long)errorObj.code);
            if (whiteScreen) {
                data.exceptionType = [self vcExceptionType:topVC];
                data.hasBitMap = NO;
                data.attrs = @{@"window": @(isWindow), @"bitmap": @"", @"duration": @(duration ?: 0), @"steps": [self vcPageviewExecuteSteps:topVC] ?: @"", @"capture_ratio": @(data.captureRatio), @"pixe_ratio_threshold": @(0.95), @"pixel_asis_cover_rate": coverLog, @"pixel_ratio": @(coverRatio)};
                data.errorFeature = [NSString stringWithFormat:@"截屏白屏 %@", data.pageId ?: data.pagePath ?: @""];
                if (strongSelf.delegate
                    && [strongSelf.delegate respondsToSelector:@selector(whiteScreen:data:)]) {
                    [strongSelf.delegate whiteScreen:pageName data:data];
                }
            }
            
            data.attrs = @{@"timeout_duration": @(data.timeoutDuration ?: 0), @"capture_ratio": @(data.captureCostTime ?: 0), @"whitepixel_ratio": @(data.whitepixelRatio), @"pixe_ratio_threshold": @(0.95), @"pixel_asis_cover_rate": coverLog, @"pixel_ratio": @(coverRatio)};
            if (strongSelf.delegate
                && [strongSelf.delegate respondsToSelector:@selector(whiteScreenDetect:data:)]) {
                [strongSelf.delegate whiteScreenDetect:pageName data:data];
            }
            
        }];
    });
}

- (void)temp_debugHandleImage:(UIImage *)image isWhite:(BOOL)isWhite vc:(UIViewController *)controller desc:(NSString *)desc {
    // debug 方法，在debug库hook，然后显示白屏判定在页面上
}

/// 图片像素检测
- (void)pixelDetection:(UIImage *)image isScaled:(BOOL)isScaled inset:(UIEdgeInsets)inset pixelRatio:(double)pixelRatio completion:(void(^)(NSInteger whiteCount, NSInteger blackCount, NSInteger totalCount, BOOL pureImage, CGFloat xPrecentWhite, CGFloat yPrecentWhite, CGFloat xPrecentBlack, CGFloat yPrecentBlack))completion {
    if (!image) {
        completion(0, 0, 0, NO, 0, 0, 0, 0);
        return;
    }
    CGImageRef cgImage = [image CGImage];
    if (!cgImage) {
        if (completion) { completion(0, 0, 0, NO, 0, 0, 0, 0); }
        return;
    }
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    CGFloat miniHeight = isScaled ? inset.top + inset.bottom : 12;
    CGFloat maxHeight = isScaled ? height - inset.bottom : height;
    CGFloat miniLeft = isScaled ? inset.left : 0;
    CGFloat maxRight = isScaled ? width - inset.right : width;
    
    if (width <= 0 || height <= miniHeight) {
        if (completion) { completion(0, 0, 0, NO, 0, 0, 0, 0); }
        return;
    }
    
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage); //每个像素点包含r g b a 四个字节
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    if (!data) {
        if (completion) { completion(0, 0, 0, NO, 0, 0, 0, 0); }
        return;
    }
    
    UInt8 *buffer = (UInt8 *)CFDataGetBytePtr(data);
    
    int whiteCount = 0;
    int totalCount = 0;
    int blackCount = 0;
    
    UInt8 firstRed = 0;
    UInt8 firstGreen = 0;
    UInt8 firstBlue = 0;
    
    BOOL pureImage = YES;
    BOOL skiPureImageDetection = NO;
    
//    unsigned long colorCount = width/4*height/4/10 + 1;
//    unsigned long colorIndex = 0;
//    int64_t array[colorCount];
    // 排除顶部
    int addIndex = isScaled ? 1 : 4;
    
    // 非主颜色的坐标大值和小值
    int maWhiteX = 0;
    int miWhiteX = maxRight;
    int maWhiteY = 0;
    int miWhiteY = maxRight;
    int maBlackX = 0;
    int miBlackX = maxRight;
    int maBlackY = 0;
    int miBlackY = maxRight;
    
    for (int j = miniHeight + 1; j < maxHeight; j+=addIndex ) {
        for (int i = miniLeft; i < maxRight; i+=addIndex) {
            UInt8 * pt = buffer + j * bytesPerRow + i * (bitsPerPixel / 8);
            UInt8 red   = *pt;
            UInt8 green = *(pt + 1);
            UInt8 blue  = *(pt + 2);
            // 取第一个点的数据
            if (0 == i && 0 == j) {
                firstRed = red;
                firstGreen = green;
                firstBlue = blue;
            }
        
//            colorIndex ++;
            totalCount ++;
            // 白色像素
            if (245 <= red && 245 <=  green && 245 <=  blue) {
                whiteCount++;
                maWhiteX = MAX(maWhiteX, i);
                miWhiteX = MIN(miWhiteX, i);
                maWhiteY = MAX(maWhiteY, j);
                miWhiteY = MIN(miWhiteY, j);
            }
            // 黑色像素
            if (10 >= red && 10 >= green && 10 >= blue) {
                blackCount++;
                maBlackX = MAX(maBlackX, i);
                miBlackX = MIN(miBlackX, i);
                maBlackY = MAX(maBlackY, j);
                miBlackY = MIN(miBlackY, j);
            }
            // 纯色检测逻辑，如果存在与第一个点像素不一致的点，就视为非纯色
            if (!skiPureImageDetection && (red != firstRed || green != firstGreen || blue != firstBlue)) {
                pureImage = NO;
                skiPureImageDetection = YES;
            }
        }
    }
    
    if (totalCount == 0) {
        if (completion) { completion(0, 0, 0, NO, 0, 0, 0, 0); }
        return;
    }
    
    CGFloat xPrecentWhite = 0.0;
    CGFloat yPrecentWhite = 0.0;
    CGFloat xPrecentBlack = 0.0;
    CGFloat yPrecentBlack = 0.0;
    if (maxHeight > 0 && maxRight > 0) {
        xPrecentWhite = (maWhiteX - miWhiteX) / maxRight;
        yPrecentWhite = (maWhiteY - miWhiteY) / maxHeight;
        xPrecentBlack = (maBlackX - miBlackX) / maxRight;
        yPrecentBlack = (maBlackY - miBlackY) / maxHeight;
    }
    
    if (completion) { completion(whiteCount, blackCount, totalCount, pureImage, xPrecentWhite, yPrecentWhite, xPrecentBlack, yPrecentBlack); }
}


//MARK: - MBAPMPageLaunchDivideCenterProtocal

- (void)pageDidEndLaunchMonitor:(nonnull NSString *)pageName controller:(UIViewController *)controller moduleInfo:(MBModuleInfo *)moduleInfo duration:(NSUInteger)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self ignoreWebview:controller]) {
            return;
        }
        if ([self ignoreCamera:controller]) {
            return;
        }
        UIViewController *needCheckVC = controller;
        UIViewController *current = [MBDoctorVCUtil currentViewController] ?: [UIViewController mb_currentViewController];
        if (current.parentViewController == controller) {
            needCheckVC = current;
        } else if (current != controller) {
            return;
        }
        if ([controller whiteScreen_hasAppearFlag]) {
            return;
        }
        [controller setWhiteScreen_hasAppearFlag:YES];
        [self whiteScreenCheck:pageName duration:duration moduleInfo:moduleInfo controller:needCheckVC];
    });
}

- (BOOL)ignoreWebview:(UIViewController *)controller {
    // 非微前端忽略
    if ([self needCloseIgnoreWebview]) {
        return NO;
    }
    
    if ([controller isKindOfClass:NSClassFromString(@"MBWebViewController")]) {
        if ([controller respondsToSelector:@selector(webView)]) {
            id webview = [controller performSelector:@selector(webView)];
            if (![webview isKindOfClass:NSClassFromString(@"MBMicroWebView")]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)ignoreCamera:(UIViewController *)controller {
    // 忽略拍摄
    NSString * className = NSStringFromClass(controller.class);
    if ([className containsString:@"amera"] || [className containsString:@"photo"]) {
        return YES;
    }
    return NO;
}

// MARK: - var

- (BOOL)needCloseIgnoreWebview {
    return self.apmConfiguration.enableWhiteScreenWebViewMonitor;
}

- (void)vcScreenAnalysisStrategy:(UIViewController *)controller complete:(void(^)(UIEdgeInsets aInset, double aPixelRatio))complete {
    UIEdgeInsets inset = UIEdgeInsetsMake(48, 0, 0, 0);
    double pixelRatio = 0.95;
    if ([controller respondsToSelector:@selector(mbapm_whiteScreenAnalysisStrategy)]) {
        MBAPMWhiteScreenAnalysisStrategy *config = [controller mbapm_whiteScreenAnalysisStrategy];
        inset = config.detectInsets;
    }
    if ([controller respondsToSelector:@selector(mbapm_whiteScreenAnalysisStrategy)]) {
        MBAPMWhiteScreenAnalysisStrategy *config = [controller mbapm_whiteScreenAnalysisStrategy];
        pixelRatio = config.pureColorPixelRatio;
    }
    if (complete) {
        complete(inset, pixelRatio);
    }
}

- (NSString *)vcExceptionType:(UIViewController *)controller {
    NSString *exceptionType;
    if ([controller respondsToSelector:@selector(occurExceptionType)]) {
        exceptionType = controller.occurExceptionType;
    }
    return exceptionType;
}

- (nullable id)vcPageviewExecuteSteps:(UIViewController *)controller {
    NSArray<MBAPMPageviewStepInfo *> *pageviewExecuteSteps;
    if ([controller respondsToSelector:@selector(pageviewExecuteSteps)]) {
        pageviewExecuteSteps = controller.pageviewExecuteSteps;
    }
    
    return [pageviewExecuteSteps yy_modelToJSONObject];
}

// MARK: - 截屏方法

- (void)mbapm_whiteScreenCaptureVC:(UIViewController *)vc scaleRatio:(double)scaleRatio callback:(MBAPMWhiteScreenCaptureCallback)callback {
    UIView *view = vc.view;
    BOOL isWindow = NO;
    if (view.size.width <= 320 || view.size.height <= 480 || view.subviews.count == 0) {
        view = [[UIApplication sharedApplication] keyWindow];
        isWindow = YES;
        if (view.size.width <= 0 || view.size.height <= 0) {
            callback(0, nil, isWindow);
            return;
        }
    }
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, scaleRatio > 0.5 ? scaleRatio : 1);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (callback) {
        callback(scaleRatio > 0.5, image, isWindow);
    }
}

@end
