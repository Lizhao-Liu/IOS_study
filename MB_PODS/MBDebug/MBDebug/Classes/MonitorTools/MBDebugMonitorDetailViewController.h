//
//  MBDebugMonitorDetailViewController.h
//  MBDebug
//
//  Created by Lizhao on 2023/8/7.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorLogCellViewModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugMonitorDetailViewController : UIViewController

@property (nonatomic, strong) MBDebugMonitorLogCellViewModel *model;

@end

NS_ASSUME_NONNULL_END
