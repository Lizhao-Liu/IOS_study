//
//  HCBCodeScanerView.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class HCBCodeScanerMaskView;

NS_ASSUME_NONNULL_BEGIN

@protocol HCBCodeScanerViewDelegate <NSObject>

- (void)codeScanResult:(NSString *)scanCode;

@end

typedef NS_ENUM(NSInteger, MBScanViewFormatType) {
    MBScanViewFormatTypeTypeQR = 0,         // 二维码
    MBScanViewFormatTypeQRAndBar = 1       // 二维码、条形码
};

@interface HCBCodeScanerView : UIView

@property (nonatomic, weak, nullable) id<HCBCodeScanerViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableScale;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong, nullable) NSArray<AVMetadataObjectType> *metadataObjectTypes;

- (instancetype)initWithFrame:(CGRect)frame
                     withType:(MBScanViewFormatType)type;

- (void)torchOff;
- (void)beginScanLine;
- (void)pauseScanSession;
- (void)restartScanSession;
- (void)removeScanLine;
+ (BOOL)checkCameraIsVisible;
+ (void)checkPhotoLibraryIsVisibleWithCompletion:(void (^)(BOOL allowed))completion;

@end

NS_ASSUME_NONNULL_END
