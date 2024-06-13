//
//  MBDebugMonitorPageInfoViewController.h
//  MBDebug
//
//  Created by Lizhao on 2023/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBDebugActivityMonitorVCProtocol;

@interface MBDebugMonitorPageInfoViewController : UIViewController<MBDebugActivityMonitorVCProtocol>

- (instancetype)initPageInfoVCWithPageVC:(UIViewController *)pageVC;

@end

NS_ASSUME_NONNULL_END
