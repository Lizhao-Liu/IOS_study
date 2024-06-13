//
//  MBDebugActivityMonitorCell.m
//  MBDebug
//
//  Created by Lizhao on 2022/11/21.
//

#import "MBDebugMonitorLogCell.h"
#import "MBDebugMonitorLogCellViewModel.h"
@import Masonry;
@import MBUIKit;

#define MBDebugMonitorCellPadding 10
#define MBDebugMonitorCellDefaultLabelHeight 12
#define MBDebugMonitorCellDefaultLabelFontSize 10


@interface MBDebugMonitorLogCell ()

@property (nonatomic, strong) MBDebugMonitorLogCellViewModel *model;

@property (nonatomic, strong) UIView *attributeView;

@end


@implementation MBDebugMonitorLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.sourceLabel];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.attributeView];
    
    [self.timeLabel mas_makeConstraints: ^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(5);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(MBDebugMonitorCellDefaultLabelHeight);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(MBDebugMonitorCellPadding-1);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(MBDebugMonitorCellDefaultLabelHeight);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(MBDebugMonitorCellDefaultLabelHeight);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(5);
        make.left.offset(MBDebugMonitorCellPadding);
        make.right.offset(-MBDebugMonitorCellPadding);
    }];
    [self.attributeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(MBDebugMonitorCellPadding);
        make.right.offset(-MBDebugMonitorCellPadding);
        make.bottom.mas_equalTo(-MBDebugMonitorCellPadding);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(0);
    }];
}

- (void)resetCellData {
    self.tagLabel.text = nil;
    self.contentLabel.text = nil;
    self.timeLabel.text = nil;
    self.sourceLabel.text = nil;
}

- (void)renderCellWithModel:(MBDebugMonitorLogCellViewModel *)model {
    [self resetCellData];
    _model = model;
    self.timeLabel.text = model.timeStr;
    self.contentLabel.text = model.summaryStr;
    if(model.sourceStr.length > 0){
        self.sourceLabel.hidden = NO;
        self.sourceLabel.text = model.sourceStr;
    } else {
        self.sourceLabel.hidden = YES;
    }
    
    if(!model.tagModel){
        self.tagLabel.hidden = YES;
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(MBDebugMonitorCellPadding);
        }];
    } else {
        self.tagLabel.text = model.tagModel.tagName;
        self.tagLabel.textColor = model.tagModel.textColor ?: [UIColor whiteColor];
        self.tagLabel.backgroundColor = model.tagModel.bgColor ?: [UIColor clearColor];
        self.tagLabel.hidden = NO;
        [self.tagLabel sizeToFit];
        CGFloat LabelWidth = 0;
        if(model.tagModel.borderColor){
            self.tagLabel.layer.borderColor = model.tagModel.borderColor.CGColor;
            self.tagLabel.textAlignment = NSTextAlignmentCenter;
            LabelWidth = self.tagLabel.width + 6;
        } else {
            self.tagLabel.layer.borderColor = [UIColor clearColor].CGColor;
            self.tagLabel.textAlignment = NSTextAlignmentLeft;
            LabelWidth = self.tagLabel.width;
        }
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(LabelWidth);
        }];
        [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tagLabel.mas_right).offset(10);
        }];
    }
    [self.attributeView removeAllSubviews];
    if(model.attributes && model.attributes.count > 0){
        CGFloat startX = 0;
        CGFloat width = 40;
        CGFloat height = MBDebugMonitorCellDefaultLabelHeight;
        for(NSString *attribute in model.attributes){
            UILabel *label = [self commonAttributeLabel];
            label.text = attribute;
            [label sizeToFit];
            width = MAX(width, label.width+6);
            [self.attributeView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(0);
                make.left.mas_offset(startX);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
            startX = startX + width + 5;
            [self.attributeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(5);
                make.height.mas_equalTo(MBDebugMonitorCellDefaultLabelHeight);
            }];
        }
    } else {
        [self.attributeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
    }
    
    if(self.model.isError){
        if(self.model.styleModel && self.model.styleModel.errorHighlightColor){
            self.backgroundColor = [self.model.styleModel.errorHighlightColor colorWithAlphaComponent:0.2];
        } else {
            self.backgroundColor = [UIColor mb_colorWithHex:0x8B0000 alpha:0.2];
        }
    } else {
        if(self.model.styleModel && self.model.styleModel.highlightColor){
            self.backgroundColor = [self.model.styleModel.highlightColor colorWithAlphaComponent:0.2];
        } else {
            self.backgroundColor = [UIColor clearColor];
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UILabel *)statusLabel {
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:MBDebugMonitorCellDefaultLabelFontSize];
    }
    return _statusLabel;
}


- (UILabel *)timeLabel {
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:MBDebugMonitorCellDefaultLabelFontSize];
    }
    return _timeLabel;
}

- (UILabel *)sourceLabel {
    if(!_sourceLabel){
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.numberOfLines = 1;
        _sourceLabel.textColor = [UIColor lightGrayColor];
        _sourceLabel.font = [UIFont systemFontOfSize:MBDebugMonitorCellDefaultLabelFontSize];
    }
    return _sourceLabel;
}

- (UILabel *)tagLabel {
    if(!_tagLabel){
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.numberOfLines = 1;
        _tagLabel.font = [UIFont systemFontOfSize:MBDebugMonitorCellDefaultLabelFontSize];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    return _tagLabel;
}

- (UILabel *)commonAttributeLabel {
    UILabel *attrLabel = [[UILabel alloc] init];
    attrLabel.numberOfLines = 1;
    attrLabel.textColor = [UIColor lightGrayColor];
    attrLabel.font = [UIFont systemFontOfSize:MBDebugMonitorCellDefaultLabelFontSize];
    attrLabel.textAlignment = NSTextAlignmentCenter;
    attrLabel.layer.cornerRadius = 2;
    attrLabel.layer.borderWidth = 0.5;
    attrLabel.layer.masksToBounds = YES;
    attrLabel.layer.borderColor = [UIColor grayColor].CGColor;
    attrLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    return attrLabel;
}


- (UILabel *)contentLabel {
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 4;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:10];
    }
    return _contentLabel;
}


- (UIView *)attributeView {
    if(!_attributeView){
        _attributeView = [[UIView alloc] init];
        _attributeView.backgroundColor = [UIColor clearColor];
    }
    return _attributeView;
}


@end
