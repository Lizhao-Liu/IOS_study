//
//  HCBCodeScanerViewController.h
//  ios4driver
//
//  Created by yangtianyin on 16/1/4.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBBaseViewController.h"

typedef NS_ENUM(NSInteger, HCBScanResultType) {
    HCBScanResultType_Person = 0,//个人支付
    HCBScanResultType_Enterprise = 1, //企业支付
    HCBScanResultType_OilCard = 2, //物资卡支付HCBCodeScanerViewController
    HCBScanResultType_None = 100, //其他
};

typedef void(^actionAfterScanBlock)(HCBScanResultType scanType, NSString *msg);

@interface HCBCodeScanerViewControllerPetrol : HCBBaseViewController
@property (nonatomic, assign) BOOL isShowBackBtn;
@property (nonatomic, copy) actionAfterScanBlock actionAfterScan;
@end
