//
//  HCBBaseViewController.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 15/12/8.
//  Copyright © 2015年 苼茹夏花. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIView+Utils.h"
@import MBDoctorService;

//#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]  //设置颜色
//#define kSystemColor [UIColor colorWithRed:255/255.0 green:123/255.0 blue:72/255.0 alpha:1]//主题颜色
//#define kLineColor   [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]//分割线颜色
//#define kViewBGColor [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]//页面背景颜色


#define hNavigationBarHeight 64
#define hFooterTabBarHeight 49


@interface HCBBaseViewController : UIViewController <MBDoctorPVJournalDelegate>
@property(nonatomic,strong)UIView *topView __deprecated_msg("Property is deprecated. Use original navigation bar instead!"); //状态栏和头部
@property(nonatomic,assign)CGSize viewSize;//页面size
@property(nonatomic,strong)UILabel *titleLabel;//页面标题
@property(nonatomic,strong)UIButton *backButton;//返回按钮
@property(nonatomic,strong)UIButton *rightButton;//右边按钮
@property(nonatomic,strong)UIButton *leftButton; //左边按钮
#pragma mark init view

/*
 * @breif 初始化标题栏右按钮名称
 */
- (void)initRightButton:(NSString *)btnTitle;

/*
 * @breif 初始化标题栏名称
 */
- (void)initTitle:(NSString *)title;

/*
 * @breif 初始化标题栏返回按钮
 */
- (void)initBackButton:(NSString *)imgName;

/*
 *  @breif 初始化标题栏右按钮
 */
- (void)initRightButtonWithImage:(UIImage*)image;

/*
 * @breif 初始化左边按钮
 */
- (void)initLeftButton:(NSString *)btnTitle;
/*
 * @breif 初始化标题栏右按钮,按钮右上角显示红点
 */
- (void)initRightButtonWithImage:(UIImage*)image redDotWithNumber:(int)redNumber;
/*
 * @breif 用图片初始化导航栏
 */
- (void)initTitleWithAlphaImage:(UIImage*)image;

/**
 *  pv page name
 */
- (NSString *)setupPVCurrentPageName;

/**
 *  pv page values
 */
- (NSDictionary *)setupPVPageValues;

/*
 * @breif 更新消息红点数目
 */
//- (void)updateRedPoint:(NSUInteger)count;


//- (void)initTxtImageRightButton:(NSString*)txt imageName:(NSString*)imageName;
#pragma button events
- (void)clickBackButton:(UIButton *)btn;
- (void)clickRightButton:(UIButton *)btn;
- (void)clickLeftButton:(UIButton *)btn;


@end
