//
//  MBDebugSwitchCell.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwitchButtonBlock)(BOOL isOn);

@interface MBDebugSwitchCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, copy) SwitchButtonBlock switchButtonBlock;

@property (nonatomic, assign) BOOL switchBtnOn;
@property (nonatomic, assign) BOOL switchBtnDisabled;

@end

NS_ASSUME_NONNULL_END
