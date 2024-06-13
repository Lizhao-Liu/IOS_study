//
//  YMMDebugSchemesCell.h
//  AFNetworking
//
//  Created by yc on 2019/11/21.
//

@import MBUIKit;

NS_ASSUME_NONNULL_BEGIN


@class YMMDebugScheme;

@interface YMMDebugSchemesCell : MBBaseTableViewCell

@property (strong, nonatomic) YMMDebugScheme *scheme;
@property (assign, nonatomic) BOOL hiddenStatus;

@end

NS_ASSUME_NONNULL_END
