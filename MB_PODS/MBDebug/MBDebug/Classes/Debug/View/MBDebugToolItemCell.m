//
//  MBDebugToolItemCell.m
//  MBDebug
//
//  Created by Ymm on 2019/11/9.
//  Copyright © 2019 YMM. All rights reserved.
//

#import "MBDebugToolItemCell.h"
#import "MBDebugToolModel.h"
@import Masonry;
@import MBUIKit;

#define kFontSize12 [UIFont systemFontOfSize:12]

@interface MBDebugToolItemCell ()
    
@property (nonatomic, strong) UIView *itemView; // 背景
@property (nonatomic, strong) UILabel *itemLabel; // 工具名称
@property (nonatomic, strong) UILabel *summaryLabel; // 工具相关描述
@property (nonatomic, strong) UIImageView *arrowIV; // 右箭头
@property (nonatomic, strong) MBDebugToolModel *itemModel;

@end

@implementation MBDebugToolItemCell
    
+ (instancetype)createReuseCellForTableView:(UITableView *)tableView
                         withCellIdentifier:(NSString *)cellIdentifier {
    MBDebugToolItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MBDebugToolItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellIdentifier];
    }
    return cell;
}
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor mb_colorWithHex:0xf2f2f2 alpha:1];
        [self initControls];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
    
- (void)setNeedsUpdateConstraints {
    NSString *summary = self.itemModel.summary;
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.contentView);
    }];
    [self.itemLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (summary && summary.length > 0) {
            make.top.mas_equalTo(self.itemView.mas_top).mas_offset(12);
        } else {
            make.top.mas_equalTo(self.itemView.mas_top).mas_offset(14);
        }
        make.left.mas_equalTo(self.itemView.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.arrowIV.mas_left);
        make.height.mas_equalTo(18);
    }];
    [self.summaryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.itemLabel.mas_left);
        make.right.mas_equalTo(self.arrowIV.mas_left);
        if (summary && summary.length > 0) {
            make.top.mas_equalTo(self.itemLabel.mas_bottom).mas_offset(10);
            make.bottom.mas_equalTo(self.itemView.mas_bottom).mas_offset(-12);
        } else {
            make.top.mas_equalTo(self.itemLabel.mas_bottom);
            make.bottom.mas_equalTo(self.itemView.mas_bottom);
        }
    }];
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.right.mas_equalTo(self.itemView.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(self.itemView.mas_centerY);
    }];
    [super setNeedsUpdateConstraints];
}
    
#pragma mark - getter & setter Method
    
- (UIView *)itemView {
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
        _itemView.backgroundColor = [UIColor whiteColor];
    }
    return _itemView;
}
    
- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.font = kFontSize16;
        _itemLabel.textColor = kTextColorNormal;
    }
    return _itemLabel;
}
    
- (UILabel *)summaryLabel {
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.font = kFontSize12;
        _summaryLabel.textColor = kTextColor999;
        _summaryLabel.numberOfLines = 0;
    }
    return _summaryLabel;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_right"]];
    }
    return _arrowIV;
}

#pragma mark - Private Method
    
- (void)initControls {
    [self.itemView addSubview:self.itemLabel];
    [self.itemView addSubview:self.summaryLabel];
    [self.itemView addSubview:self.arrowIV];
    [self.contentView addSubview:self.itemView];
    self.summaryLabel.hidden = YES;
}

#pragma mark - Override Method
    
+ (CGFloat)mb_heightForCellWithItem:(id)item contentWidth:(CGFloat)contentWith {
    CGFloat viewHeight = 44.f;
    if (item && [item isKindOfClass:[MBDebugToolModel class]]) {
        MBDebugToolModel *model = item;
        if (model.summary && model.summary.length > 0) {
            CGFloat contentWidth = kScreenWidth - 30;
            CGFloat height = [model.summary getTextHeight:contentWidth withFont:kFontSize12].height + 3;
            viewHeight = viewHeight + height;
        }
    }
    return viewHeight;
}
    
- (void)mb_configWithItemModel:(id)itemModel {
    if (itemModel && [itemModel isKindOfClass:[MBDebugToolModel class]]) {
        MBDebugToolModel *model = itemModel;
        self.itemModel = itemModel;
        self.itemLabel.text = model.itemTitle;
        if (model.summary) {
            self.summaryLabel.hidden = NO;
            self.summaryLabel.text = model.summary;
        } else {
            self.summaryLabel.hidden = YES;
            self.summaryLabel.text = @"";
        }
    }
    [self setNeedsUpdateConstraints];
}
    
@end
