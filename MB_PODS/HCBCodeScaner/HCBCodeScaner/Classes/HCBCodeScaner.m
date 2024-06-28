//
//  HCBCodeScaner.m
//  HCBCodeScaner
//
//  Created by tp on 20/03/2018.
//

#import "HCBCodeScaner.h"
#import "HCBCodeScaner_Private.h"
#import "HCBCodeScanerRegulation.h"
#import "HCBCodeScanerRegulation_Private.h"
#import "HCBCodeScanerRegulationGroup.h"
#import "UIImage+HCBCodeScanerExtension.h"
@import MBUIKit;

NSString *const HCBCodeScanerDidScanedSuccessNotification =
    @"com.wlqq.HCBCodeScaner.DidScanedSuccessNotification";
NSString *const HCBCodeScanerDidClickAlbumNotification =
    @"com.wlqq.HCBCodeScaner.DidClickAlbumNotification";

__weak HCBCodeScanerViewController *__current_code_scaner_view_controller;

@interface HCBCodeScaner ()

@property (nonatomic, strong) HCBCodeScanerRegulationGroup *regulationGroup;

@end

@implementation HCBCodeScaner

#pragma mark - Overriding

- (instancetype)init {
    self = [super init];
    if (self) {
        _enableScale = YES;
//        _allowedChooseFromAlbum = NO;
        _regulationGroup = [HCBCodeScanerRegulationGroup new];
    }
    return self;
}

#pragma mark - Public

//+ (void)setAllowedChooseFromAlbum:(BOOL)allowedChooseFromAlbum {
//    [HCBCodeScaner sharedScaner].allowedChooseFromAlbum = allowedChooseFromAlbum;
//}

+ (void)setScalingEnabled:(BOOL)scale {
    [HCBCodeScaner sharedScaner].enableScale = scale;
}

+ (void)setUnrecognizedScanResultHandler:(HCBCodeScanerUnrecognizedScanResultHandler)handler {
    [HCBCodeScaner sharedScaner].unrecognizedScanResultHandler = handler;
}

+ (void)setNoResultFoundInTargetImageHandler:(HCBCodeScanerNoResultFoundInTargetImageHandler)handler {
    [HCBCodeScaner sharedScaner].noResultFoundInTargetImageHandler = handler;
}

+ (void)addRegulation:(HCBCodeScanerRegulation *)regulation {
    [[HCBCodeScaner sharedScaner].regulationGroup addRegulation:regulation];
}

+ (HCBCodeScanerViewController *)getCurrentViewController {
    return __current_code_scaner_view_controller;
}

+ (NSString *)scanImage:(UIImage *)image format:(MBCodeScanFormatType)type {
    NSString *result = [image mb_cs_recognizeType:(MBImageScanFormatType)type];
    if (result == nil || result.length <= 0) {
        UIImage *compressImg = [image compressImageToLength:300];
        result = [compressImg mb_cs_recognizeType:(MBImageScanFormatType)type];
    }
    return result;
}

+ (NSString *)scanImage:(UIImage *)image {
    NSString *result = [self scanImageWithoutCallback:image];
    HCBCodeScaner *scaner = [self sharedScaner];
    [scaner handleCodeScanResult:result sender:nil];
    return result;
}

+ (NSString *)scanImageWithoutCallback:(UIImage *)image {
    return [image hcb_cs_recognize];
}

#pragma mark - Private

+ (instancetype)sharedScaner {
    static HCBCodeScaner *scaner;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scaner = [self new];
    });
    return scaner;
}

- (BOOL)handleCodeScanResult:(NSString *)result sender:(id)sender {
    HCBCodeScanerRegulation *regulation;
    if (result && (regulation = [_regulationGroup regulationMathesResult:result])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [regulation handle:result sender:sender];
        });
    } else {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(wself) self = wself;
            __kindof UIViewController *viewController;
            if (sender && [sender isKindOfClass:[UIViewController class]]) {
                viewController = sender;
            }
            if (self.unrecognizedScanResultHandler) {
                self.unrecognizedScanResultHandler(viewController, result);
            }
        });
    }
    return !!regulation;
}

@end
