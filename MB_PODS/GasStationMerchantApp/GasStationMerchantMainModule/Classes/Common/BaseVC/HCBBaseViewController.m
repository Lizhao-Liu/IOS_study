//
//  HCBBaseViewController.m
//  NewDriver4iOS
//
//  Created by yangtianyin on 15/12/8.
//  Copyright © 2015年 苼茹夏花. All rights reserved.
//


#import "HCBBaseViewController.h"
//#import "config.h"
#import "UIButton+Extends.h"
@import MBFoundation;



//#import "AppDelegate.h"
#import "HCBBaseNavigationViewController.h"


typedef NS_ENUM(NSUInteger, HCBEncodingType) {
    
    HCBEncodingTypeUnknown    = 0, ///< unknown
    HCBEncodingTypeBool       = 2, ///< bool
    HCBEncodingTypeInt8       = 3, ///< char / BOOL
    //    HCBEncodingTypeUInt8      = 4, ///< unsigned char
    HCBEncodingTypeInt16      = 5, ///< short
    HCBEncodingTypeUInt16     = 6, ///< unsigned short
    HCBEncodingTypeInt32      = 7, ///< int
    HCBEncodingTypeUInt32     = 8, ///< unsigned int
    HCBEncodingTypeInt64      = 9, ///< long long
    HCBEncodingTypeUInt64     = 10, ///< unsigned long long
    HCBEncodingTypeFloat      = 11, ///< float
    HCBEncodingTypeDouble     = 12, ///< double
    HCBEncodingTypeObject     = 14, ///< id
    HCBEncodingTypeNSString   = 15, //NSString
    HCBEncodingTypeNSNumber   = 16, //NSNumber
};

static const int TITLE_BAR_HEIGHT = 44;
@interface HCBBaseViewController ()

@property (nonatomic, assign) BOOL viewDidLoaded;

@end

@implementation HCBBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.viewSize = [[UIScreen mainScreen] bounds].size;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if (rectStatus.size.height > 20) {
        self.viewSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
    }
    _viewDidLoaded = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSString *)setupPVCurrentPageName {
    return nil;
}

- (NSDictionary *)setupPVPageValues {
    return nil;
}

- (void)initRightButton:(NSString *)btnTitle {
    
    if (btnTitle.length < 1) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (!_rightButton) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.layer.masksToBounds = YES;
        self.rightButton.layer.cornerRadius = 8;
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    [self.rightButton setTitle:btnTitle forState:UIControlStateNormal];
    [self.rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)initRightButtonWithImage:(UIImage*)image {
    
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setFrame:CGRectMake(self.viewSize.width - 60, 20, 60, TITLE_BAR_HEIGHT)];
    [self.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:image forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

- (void)initRightButtonWithImage:(UIImage*)image redDotWithNumber:(int)redNumber {
    
    if (!self.rightButton) {
        self.rightButton = [[UIButton alloc] init];
        [self.rightButton setFrame:CGRectMake(self.viewSize.width - 60 - 40, 20, 60, TITLE_BAR_HEIGHT)];
        [self.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        self.rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:image forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    }
}

- (void)initTitle:(NSString *)title {
    self.title = title;
}

- (void)initTitleWithAlphaImage:(UIImage*)image {

}

- (void)initBackButton:(NSString *)imgName {
    UIImage *normalImage = [UIImage imageNamed:@"back"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:normalImage forState:UIControlStateNormal];
    backBtn.frame = (CGRect){CGPointZero, normalImage.size};
    [backBtn addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn extendResponseAreaWithExtendEdge:UIEdgeInsetsMake(10, 0, 10, 20)];
    self.backButton = backBtn;
    
    UIBarButtonItem *spaceA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceA.width = -6;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItems = @[spaceA, barButtonItem];
    
}

- (void)initLeftButton:(NSString *)btnTitle {
    if (!_leftButton) {
        self.leftButton = [[UIButton alloc] init];
        [self.leftButton setFrame:CGRectMake(20, 20, TITLE_BAR_HEIGHT, TITLE_BAR_HEIGHT)];
        self.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.leftButton setTitle:btnTitle forState:UIControlStateNormal];
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    }
    
    [self.leftButton setTitle:btnTitle forState:UIControlStateNormal];
}


- (void)clickBackButton:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightButton:(UIButton *)btn {
    
}

- (void)clickLeftButton:(UIButton *)btn {
    
}

-(void)clickTxtImageRightBtn:(UIButton *)btn {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)setupVcMappingValueWithEncodingType:(HCBEncodingType)eType targetData:(NSDictionary*)tDic targetParamName:(NSString*)tParamName {
    
    id tId = [tDic mb_objectForKeyIgnoreNil:tParamName];
    if (tId == nil) {
        return NO;
    }
    
    id resultId = nil;
    switch (eType) {
        case HCBEncodingTypeUnknown:
            break;
        case HCBEncodingTypeBool:
        case HCBEncodingTypeInt8:
            resultId = @([tId boolValue]);
            break;
        case HCBEncodingTypeInt16:
            resultId = @([tId shortValue]);
            break;
        case HCBEncodingTypeUInt16:
            resultId = @([tId unsignedShortValue]);
            break;
        case HCBEncodingTypeInt32:
            resultId = @([tId intValue]);
            break;
        case HCBEncodingTypeUInt32:
            resultId = @([tId unsignedIntValue]);
            break;
        case HCBEncodingTypeInt64:
            resultId = @([tId longLongValue]);
            break;
        case HCBEncodingTypeUInt64:
            resultId = @([tId unsignedLongLongValue]);
            break;
        case HCBEncodingTypeFloat:
            resultId = @([tId floatValue]);
            break;
        case HCBEncodingTypeDouble:
            resultId = @([tId doubleValue]);
            break;
        case HCBEncodingTypeNSString:
        case HCBEncodingTypeNSNumber:
            resultId = tId;
            break;
        default:
            resultId = nil;
            break;
    }
    
    if (resultId == nil) {
        
        return NO;
    } else {
        
        [self setValue:resultId forKey:tParamName];
        return YES;
    }
}



- (HCBEncodingType)getEncodingType:(const char*)typeEncoding {

    char *type = (char*)typeEncoding;
    switch (*type) {
        case 'B'://bool
            return HCBEncodingTypeBool;
        case 'c'://char
            return HCBEncodingTypeInt8;
        case 'd':
            return HCBEncodingTypeDouble;
        case 'i'://int
            return HCBEncodingTypeInt32;
        case 's'://short
            return HCBEncodingTypeInt16;
        case 'l'://long
            return HCBEncodingTypeInt32;
        case 'q'://long long
            return HCBEncodingTypeInt64;
        case 'I'://unsigned int
            return HCBEncodingTypeUInt32;
        case 'S'://unsigned short
            return HCBEncodingTypeUInt16;
        case 'L'://unsigned long
            return HCBEncodingTypeUInt32;
        case 'Q'://unsigned long long
            return HCBEncodingTypeUInt64;
        case '@':{//obj
            
            NSString *strType = [NSString  stringWithCString:type encoding:NSUTF8StringEncoding];

            if ([strType rangeOfString:@"NSString"].location == NSNotFound){
                
                return HCBEncodingTypeNSString;
            } else if ([strType rangeOfString:@"NSNumber"].location == NSNotFound) {
                
                return HCBEncodingTypeNSNumber;
            }
        }
        default://unknow type
            return HCBEncodingTypeUnknown;
    }
}

#pragma mark - MBDoctorPVJournalDelegate

- (NSString *)mb_pageName {
    return nil;
}

- (NSString *)mb_moduleName {
    return @"GasStationBiz";
}

- (BOOL)mb_isAutoPV {
    return YES;
}

- (NSDictionary *)mb_journalExtraParams {
    return nil;
}

@end
