//
//  HCBBetaController.m
//  Runner
//
//  Created by heyAdrian on 2018/10/19.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "HCBBetaController.h"
#import "HCBHostChangeVC.h"

#define k_title @"title"
#define k_detail @"detail"
#define k_arrow @"arrow"
#define k_action @"action"

#define title_0 @"常规功能"
#define title_1 @"临时功能"
@import MBProgressHUD;
@import MBUIKit;
@import HCBWebConsole;

#pragma mark - modelClass
@interface HCBBetaModel : NSObject

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *detail;
@property (nonatomic, assign) BOOL arrow;
@property (nonatomic, assign) SEL action;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end

@implementation HCBBetaModel

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    HCBBetaModel *model = [self new];
    model.title = [dic objectForKey:k_title];
    model.detail = [dic objectForKey:k_detail];
    model.arrow = [[dic objectForKey:k_arrow] boolValue];
    model.action = NSSelectorFromString([dic objectForKey:k_action]);
    return model;
}
@end


#pragma mark - ControllerClass
@interface HCBBetaController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HCBBetaModel *>*bateTestModelArr;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*dicArr;

@end

#define HCBBateTestCellID @"HCBBateTestCellID"

@implementation HCBBetaController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _bateTestModelArr = [NSMutableArray array];
    _dicArr = [NSMutableArray array];
    [self setupNormalsArray];
    [self setupTempsArray];
    for (NSDictionary *dic in _dicArr) {
        HCBBetaModel *model = [HCBBetaModel modelWithDic:dic];
        [_bateTestModelArr addObject:model];
        
    }
    [self.view addSubview:self.tableView];
    self.title = @"内测功能";
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bateTestModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HCBBateTestCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: HCBBateTestCellID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1E2227"];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"92979E"];
    }
    HCBBetaModel *model = self.bateTestModelArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.detail;
    cell.accessoryType = model.arrow ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    if ([model.title isEqualToString:title_0] || [model.title isEqualToString:title_1]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"4FA0FB"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1E2227"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HCBBetaModel *model = self.bateTestModelArr[indexPath.row];
    
    SEL selector = model.action;
    
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:model afterDelay:0.f];
    }else {
        if (!selector) {
            return;
        }
        NSString *msg = [NSString stringWithFormat:@"未实现方法[self %@]",NSStringFromSelector(selector)];
        [MBProgressHUD showToastAddedTo:self.view imageName:nil labelText:msg];
        NSLog(@"%@",msg);
    }
}

#pragma mark - getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 45;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    }
    return _tableView;
}

#pragma mark - 数据和要实现的方法
#pragma mark 拼接常规功能的数据
- (void)setupNormalsArray {
    [_dicArr addObject:@{k_title:title_0,
                         k_detail:@"",
                         k_arrow:@(NO),
                         }
     ];
#if COMBILE_MODE == COMBILE_MODE_Debug
    [_dicArr addObject:@{k_title:@"修改Host",
                         k_detail:@"此功能切换和Jenkins打包不一样,请勿过于依赖此功能",
                         k_arrow:@(YES),
                         k_action:NSStringFromSelector(@selector(changEnv:))
                         }
     ];
    [_dicArr addObject:@{k_title:@"iConsole工具增强",
                         k_detail:@"将log日志输出到PC浏览器的工具",
                         k_arrow:@(YES),
                         k_action:NSStringFromSelector(@selector(iConsoleBig))
                         }
     ];
#endif
     
}
#pragma mark 拼接临时功能的数据
- (void)setupTempsArray {
    
}

#pragma mark 对应的方法
- (void)changEnv:(HCBBetaModel *)model {
    [self.navigationController pushViewController:[HCBHostChangeVC new] animated:YES];
}

- (void)iConsoleBig {
    [[HCBHttpServer sharedHCBHttpServer] showHelpView];
}

@end
