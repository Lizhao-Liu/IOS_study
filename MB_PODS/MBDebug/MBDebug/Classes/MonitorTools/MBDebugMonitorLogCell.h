//
//  MBDebugActivityMonitorCell.h
//  MBDebug
//
//  Created by Lizhao on 2022/11/21.
//

#import <UIKit/UIKit.h>
#import "MBDebugActivityMonitorDefaultViewController.h"
#import "MBDebugMonitorDefine.h"

@class MBDebugMonitorLogCellViewModel;
@class MBDebugMonitorLogExpandableCellViewModel;

NS_ASSUME_NONNULL_BEGIN


@interface MBDebugMonitorLogCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *statusLabel;

- (void)renderCellWithModel:(MBDebugMonitorLogCellViewModel *)model;

@end


NS_ASSUME_NONNULL_END
