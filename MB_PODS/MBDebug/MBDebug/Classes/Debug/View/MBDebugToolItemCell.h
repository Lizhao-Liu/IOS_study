//
//  MBDebugToolItemCell.h
//  MBDebug
//
//  Created by Ymm on 2019/11/9.
//  Copyright © 2019 YMM. All rights reserved.
//

@import MBUIKit;

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugToolItemCell : MBBaseTableViewCell

+ (instancetype)createReuseCellForTableView:(UITableView *)tableView
                         withCellIdentifier:(NSString *)cellIdentifier;
+ (CGFloat)mb_heightForCellWithItem:(id)item contentWidth:(CGFloat)contentWith;
- (void)mb_configWithItemModel:(id)itemModel;

@end

NS_ASSUME_NONNULL_END
