//
//  HCBCodeScanView.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 16/1/13.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Utils.h"
#import "HCBScanMaskView.h"

@protocol HCBCodeScanViewDelegate <NSObject>
@required
-(void)codeScanResult:(NSString *)scanCode;

@end

@interface HCBCodeScanView : UIView
@property (nonatomic, weak) id<HCBCodeScanViewDelegate> delegate;

//-(void)showScanView;
//启动扫码
-(void)beginScanLine;
-(void)removeScanLine;

+(BOOL)checkCameraIsVisible;
@end
