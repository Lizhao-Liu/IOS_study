//
//  HCBHostChangeCell.m
//  Runner
//
//  Created by heyAdrian on 2018/10/22.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "HCBHostChangeCell.h"
@import MBProgressHUD;
@import MBUIKit;

@interface HCBHostChangeCell(){
    
    __weak IBOutlet UILabel *_servicesNameLabel;
    __weak IBOutlet UILabel *_currentHostUrlLabel;
    __weak IBOutlet UITextField *_newHostUrlTF;
    __weak IBOutlet UIButton *_changeBtn;
    __weak IBOutlet UIButton *_changeDefultBtn;
    
    HCBHostChangeModel *_hostModel;
}

@end

@implementation HCBHostChangeCell

+ (NSString *)reuseID {
    return @"HCBHostChangeCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _changeBtn.layer.masksToBounds = YES;
    _changeBtn.layer.cornerRadius = 5.0f;
    
    _changeDefultBtn.layer.masksToBounds = YES;
    _changeDefultBtn.layer.cornerRadius = 5.0f;
    
}

- (void)setupWithHostModel:(HCBHostChangeModel *)model {
    _hostModel = model;
    _servicesNameLabel.text = [NSString stringWithFormat:@"服务名：%@", _hostModel.hostName.uppercaseString];
    _currentHostUrlLabel.text = [_hostModel.hostUrl copy];
    _newHostUrlTF.text = [_hostModel.hostUrl copy];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)changeHost:(UIButton *)sender {
    NSString *newHostUrl = _newHostUrlTF.text;
    if ([newHostUrl isEqualToString:_hostModel.hostUrl]) {
        return;
    }
    if (![self isHostUseable: newHostUrl]) {
        return;
    }
    !_changeHostHandler ?: _changeHostHandler(_hostModel.hostName, newHostUrl);
}

- (IBAction)changeDefault:(UIButton *)sender {
    !_changeDefaultHostHandler ?: _changeDefaultHostHandler();
}


- (BOOL)isHostUseable:(NSString *)url {
    if (url.length == 0) {
        [MBProgressHUD showToastAddedTo:self.superview imageName:nil labelText:@"请输入新服务地址！"];
        return NO;
    }
    return YES;
}

@end

@implementation HCBHostChangeModel

- (instancetype)initWithHostName:(NSString *)hostName hostUrl:(NSString *)hostUrl {
    self = [super init];
    if (self) {
        _hostName = [hostName copy];
        _hostUrl = [hostUrl copy];
    }
    return self;
}

@end
