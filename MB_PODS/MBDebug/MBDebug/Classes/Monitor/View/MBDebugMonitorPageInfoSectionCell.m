//
//  MBDebugMonitorPageInfoSectionCell.m
//  MBDebug
//
//  Created by Lizhao on 2023/9/22.
//

#import "MBDebugMonitorPageInfoSectionCell.h"
#import "MBDebugMonitorLogCellViewModel.h"
@import Masonry;
@import MBUIKit;

@implementation MBDebugMonitorPageInfoSectionCell{
    UILabel *_sectionTitleLabel;
    UIView *_contentViewContainer;
    UIView *_backgroundContainerView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgroundContainerView = [[UIView alloc] init];
        _backgroundContainerView.backgroundColor = [UIColor clearColor];
        _backgroundContainerView.layer.cornerRadius = 10.0; // 设置圆角
        _backgroundContainerView.layer.borderWidth = 0.5;   // 设置边框宽度
        _backgroundContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor; // 设置边框颜色
        _backgroundContainerView.clipsToBounds = YES;
        
        [self.contentView addSubview:_backgroundContainerView];
        
        [_backgroundContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    _sectionTitleLabel = [[UILabel alloc] init];
    _sectionTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    _sectionTitleLabel.textColor = [UIColor whiteColor];
    [_backgroundContainerView addSubview:_sectionTitleLabel];
    
    _contentViewContainer = [[UIView alloc] init];
    [_backgroundContainerView addSubview:_contentViewContainer];
    
    [_sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(10);
    }];
    
    [_contentViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sectionTitleLabel.mas_bottom).mas_offset(5);
        make.bottom.mas_offset(5);
        make.left.right.mas_offset(5);
    }];
}

- (void)configureWithModel:(MBDebugMonitorPageInfoModel *)model {
    _sectionTitleLabel.text = model.sectionTitle;
    [_sectionTitleLabel sizeToFit];
    CGFloat sectionTitleHeight = _sectionTitleLabel.height;
    [_sectionTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sectionTitleHeight);
    }];
    
    // 移除旧的键值对视图
    for (UIView *subview in _contentViewContainer.subviews) {
        [subview removeFromSuperview];
    }
    
    NSArray *allKeys = model.sectionDict.allKeys;

    // 用于跟踪上一个 valueLabel 的变量
    UILabel *lastValueLabel = nil;

    for (int i = 0; i < allKeys.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = model.sectionDict[key];

        UILabel *keyLabel = [[UILabel alloc] init];
        keyLabel.text = key;
        keyLabel.textColor = [UIColor whiteColor];
        keyLabel.font = [UIFont boldSystemFontOfSize:14];
        keyLabel.numberOfLines = 1;
        CGSize optimalSize = [keyLabel sizeThatFits:CGSizeMake(80, MAXFLOAT)];
        CGFloat keyLabelHeight = optimalSize.height;

        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.text = value;
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.numberOfLines = 0;

        [_contentViewContainer addSubview:keyLabel];
        [_contentViewContainer addSubview:valueLabel];

        [keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            // 如果是第一个keyLabel，它的顶部与容器视图对齐，否则，它的顶部位于上一个valueLabel的下面
            if (lastValueLabel) {
                make.top.equalTo(lastValueLabel.mas_bottom).offset(5);
            } else {
                make.top.mas_offset(5);
            }
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(keyLabelHeight);
        }];

        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyLabel.mas_right).mas_offset(10);
            make.top.equalTo(keyLabel);
            make.right.mas_offset(-5);
        }];
        lastValueLabel = valueLabel;
    }

    // 设置最后一个 valueLabel 的底部约束，这样 contentViewContainer 会根据其内容调整高度
    [lastValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
    }];

}


@end
