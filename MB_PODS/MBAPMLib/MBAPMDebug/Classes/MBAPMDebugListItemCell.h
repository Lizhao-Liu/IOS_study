//
//  MBAPMDebugListItemCell.h
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDebugListItemCell : UICollectionViewCell

- (void)updateCell:(NSString *)name value1:(NSString *)value1 value2:(NSString *)value2;

@end

NS_ASSUME_NONNULL_END
