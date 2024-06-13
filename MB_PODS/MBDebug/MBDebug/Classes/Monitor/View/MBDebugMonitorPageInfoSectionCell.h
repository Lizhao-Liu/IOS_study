//
//  MBDebugMonitorPageInfoSectionCell.h
//  MBDebug
//
//  Created by Lizhao on 2023/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MBDebugMonitorPageInfoModel;

@interface MBDebugMonitorPageInfoSectionCell : UITableViewCell

- (void)configureWithModel:(MBDebugMonitorPageInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
