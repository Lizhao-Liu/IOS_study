//
//  MBDebugEntryItemModel.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugEntryItemModel.h"
#import "UIViewController+MBDebug.h"
@import Masonry;


NSString * const kMBDebugEntryItemDefaultPerformanceDetection = @"性能检测";
NSString * const kMBDebugEntryItemDefaultMonitorLog = @"数据监控";
NSString * const kMBDebugEntryItemDefaultDebugTools = @"调试工具";

@interface MBDebugEntryItemModel()

@property (nonatomic, copy) MBDebugHandleBlock handleBlock; // 点击入口事件触发

@end

@implementation MBDebugEntryItemModel

- (instancetype)init {
    self = [super init];
    if(self){
        _priority = MBDebugEntryItemPriorityNormal;
    }
    return self;
}

- (void)setUpBtnView:(UIView *)btnView withHandleBlock:(MBDebugHandleBlock)handleBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = NO;
    button.backgroundColor = [UIColor clearColor];
    btnView.userInteractionEnabled = NO;
    [button addSubview:btnView];
    button.frame = btnView.frame;
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.entryButton = button;
    self.handleBlock = handleBlock;
    [self.entryButton addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpBtnIcon:(UIImage *)btnIcon withHandleBlock:(MBDebugHandleBlock)handleBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = NO;
    button.backgroundColor = [UIColor clearColor];
    UIImageView *btnView = [[UIImageView alloc] initWithImage:btnIcon];
    [button addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.entryButton = button;
    self.handleBlock = handleBlock;
    [self.entryButton addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpDefaultBtnWithHandleBlock:(MBDebugHandleBlock)handleBlock {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = NO;
    button.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.entryTitle;
    [label sizeToFit];
    button.frame = label.frame;
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.entryButton = button;
    self.handleBlock = handleBlock;
    [self.entryButton addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickBtn {
    if(self.handleBlock){
        self.handleBlock([UIViewController topPresentedVC]);
    }
}

@end

