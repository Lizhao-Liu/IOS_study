//
//  YMMDebugSchemesCell.m
//  AFNetworking
//
//  Created by yc on 2019/11/21.
//

#import "YMMDebugSchemesCell.h"
#import "YMMDebugScheme.h"
@import MBUIKit;
@import Masonry;

static CGFloat const DebugSchemeCellNormalHeight = 60.f;

@interface YMMDebugSchemesCell ()

@property (strong, nonatomic) UIView *statusView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *urlLabel;

@end



@implementation YMMDebugSchemesCell

#pragma mark - LifyCycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self.contentView addSubview:self.statusView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.urlLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints {
    CGFloat originX = 5.f;
    [self.statusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(originX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(originX);
        make.leading.mas_equalTo(self.statusView.mas_trailing).offset(originX);
        make.trailing.mas_equalTo(self.contentView).offset(originX);
        make.height.equalTo(@(DebugSchemeCellNormalHeight/2));
    }];
    [self.urlLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.leading.equalTo(self.titleLabel);
        make.trailing.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.contentView).offset(0);
    }];
    [super updateConstraints];
}

#pragma mark - Properties
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.layer.masksToBounds = YES;
        _statusView.layer.cornerRadius = 12;
    }
    return _statusView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kTextColorNormal;
    }
    return _titleLabel;
}

-(UILabel *)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.numberOfLines = 0;
        _urlLabel.textColor = kTextColorNormal;
    }
    return _urlLabel;
}

- (void)setHiddenStatus:(BOOL)hiddenStatus {
    self.statusView.hidden = hiddenStatus;
}

-(void)setScheme:(YMMDebugScheme *)scheme {
    _scheme = scheme;
    self.titleLabel.text = _scheme.name;
    self.urlLabel.text   = _scheme.url;
    switch (scheme.status) {
        case YMMRouterDebugStatus_Success:
            self.statusView.backgroundColor = [UIColor greenColor];
            break;
        case YMMRouterDebugStatus_404:
            self.statusView.backgroundColor = [UIColor redColor];
            break;
        default:
            self.statusView.backgroundColor = [UIColor lightGrayColor];
            break;
    }
}

#pragma mark - Public Methods

+(CGFloat)mb_heightForCellWithItem:(id)item
                       contentWidth:(CGFloat)contentWith{
    YMMDebugScheme *scheme = (YMMDebugScheme *)item;
    CGSize sizeUrl = [scheme.url sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.f]}];
    CGFloat urlLength = sizeUrl.width;
    if (urlLength > contentWith) {
        return sizeUrl.height + DebugSchemeCellNormalHeight;
    }
    return DebugSchemeCellNormalHeight;
}

@end
