//
//  HCBBaseNavigationViewController.h
//  NewDriver4iOS
//
//  Created by yangtianyin on 15/12/9.
//  Copyright © 2015年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBBaseNavigationViewController : UINavigationController

@property (nonatomic,assign) BOOL viewAnimating;  /**< 之前的push/pop的动画是否在进行中 */

@property (nonatomic, assign) BOOL notConfig;

- (void)configNavgationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController;


@end
