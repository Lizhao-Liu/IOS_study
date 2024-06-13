//
//  MBAPMDebugSwitchCell.h
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MBAPMDebugSwitchCellDelegate <NSObject>

- (void)switchChanged:(BOOL)isON cellTag:(NSInteger)tag;

@end

@interface MBAPMDebugSwitchCell : UICollectionViewCell

@property (nonatomic, weak) id<MBAPMDebugSwitchCellDelegate> delegate;

- (void)setLabelText:(NSString *)labelText;

- (void)setSwitchState:(BOOL)isON;

@end

NS_ASSUME_NONNULL_END
