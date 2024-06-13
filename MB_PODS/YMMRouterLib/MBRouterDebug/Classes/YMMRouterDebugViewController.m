//
//  YMMRouterDebugViewController.m
//  AFNetworking
//
//  Created by yc on 2019/11/21.
//

#import "YMMRouterDebugViewController.h"

@import MBCommonUILib;
@import YMMRouterLib;
#import "YMMDebugSchemesCell.h"
#import "YMMDebugScheme.h"
#import "YMMRouterMapDebugViewController.h"
#import "YMMRouterCenter+RegDebugInfo.h"
@import MBBuildPreLib;
@import MBProjectConfig;
@import MBFoundation;
@import MBLogLib;

typedef NS_ENUM(NSUInteger, YMMDebugSchemeCheckType) {
    YMMDebugSchemeErrorPrefix,
    YMMDebugSchemeErrorInvalidParams,
    YMMDebugSchemeErrorEmptyString,
    YMMDebugSchemeValid
};

static NSString *NAME_OF_DEBUG_SCHEMES_FILE = @"DebugSchemes";
static NSString *CELL_ID_OF_TABLEVIEW = @"GT_DEBUG_SCHEME_CELL_ID";
static CGFloat const DEBUGF_SCHEME_HEADER_HEIGHT = 60.f;

@interface YMMRouterDebugViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    BOOL _oldScheme;
}

@property (strong, nonatomic) NSArray<YMMDebugScheme*> *schemes;
@property (strong, nonatomic) NSArray<YMMDebugScheme*> *oldSchemes;
@property (strong, nonatomic) NSArray<YMMDebugScheme*> *newSchemes;
@property (strong, nonatomic) UITableView *schemesTableView;
@property (strong, nonatomic) UISearchBar *tableHeader;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation YMMRouterDebugViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem.tintColor = self.navigationItem.rightBarButtonItem.tintColor = kTextColorSelected;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: kTextColorNormal,
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    UIBarButtonItem *routerInfoButton = [[UIBarButtonItem alloc]initWithTitle:@"获取路由信息"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(fetchRouterDebugInfo)];
    [routerInfoButton setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = routerInfoButton;
    
    UIBarButtonItem *pulishButton = [[UIBarButtonItem alloc]initWithTitle:@"白名单测试"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(changeSchemes)];
    self.navigationItem.rightBarButtonItem = pulishButton;
    [pulishButton setTintColor:[UIColor redColor]];
}

#pragma mark - Private Methods

- (void)uploadRouterDebugInfoWithBody:(NSData*)data {
    NSString *host = @"https://feutil.amh-group.com";

    if (data.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/schema/update",host]];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:[@(data.length) stringValue] forHTTPHeaderField:@"Content-Length"];
        [req setHTTPBody:data];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                BOOL succeed = [response isKindOfClass:[NSURLResponse class]];
                NSLog(@"RouterDebugInfo upload:{%@}",succeed ? @"success" : @"failure");
        }];
        
        [dataTask resume];
    }
}

- (void)fetchRouterDebugInfo {
    if ([YMMRouterCenter respondsToSelector:@selector(registRouterDebugInfo)]) {
        NSArray *valArray = [YMMRouterCenter performSelector:@selector(registRouterDebugInfo)];
        NSMutableArray *list = [NSMutableArray array];
        NSMutableArray *available = [NSMutableArray array];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dict in valArray) {
                NSString *category = (NSString*)dict.allKeys.firstObject ? : @"";
                if (category && [category respondsToSelector:@selector(length)] && category.length) {
                    NSDictionary *categoryDict = dict[category] ? : @{};
                    NSArray *maps = categoryDict[@"_map"] ? : @[];
                    for (NSString*path in maps) {
                        NSString *paths = [NSString stringWithFormat:@"%@%@",category,path];
                        NSDictionary *dict = @{@"category":category,@"path":paths};
                        [list addObject:dict];
                    }
                }
            }
            
            [available addObject:@{@"platform":@0,@"version":[MBAppDelegate appInfo].appVersion.appVersion,@"type":@([MBAppDelegate projectConfig].appTypeForJournal)}];
            NSLog(@"AllRouterDebugInfo %@\n",list);
            
            NSDictionary *bodyDict = @{@"list":list,@"available":available};
            NSData *data = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
            [self uploadRouterDebugInfoWithBody:data];
        });
    }
}

- (void)changeSchemes {
    YMMRouterMapDebugViewController *debugVC = [[YMMRouterMapDebugViewController alloc] init];
    [self.navigationController pushViewController:debugVC animated:YES];
    return;
    
    _oldScheme = !_oldScheme;
    [self.schemesTableView reloadData];
}

- (void)setupUI {
    self.title = @"路由调试";
    [self.view addSubview:self.schemesTableView];
    self.selectedIndex = NSNotFound;
}

- (void)navigationBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)route:(NSString *)url {
    if([self vaildateURL:url] == YMMDebugSchemeValid) [self schemeRouteToView:url];
}

/**
 通过router会产生三种返回值
 YES/NO为首页tab跳转会在target以及action等文件中直接执行
 ViewController则需在该函数中进行处理
 其余的为H5 调去webView
 */
- (void)schemeRouteToView:(NSString *)url {
    [self.view endEditing:YES];
    [self isManualInput:url];
    if (self.selectedIndex != NSNotFound) {
        if ([self.schemes[self.selectedIndex].isMainTab integerValue]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[YMMRouterCenter shared] performWithURLString:url
                                              completion:^(YMMRouterResponse * _Nullable response) {
                    if ([response.result isKindOfClass:[UIViewController class]]) {
#ifdef DEBUG
                        NSLog(@"success");
#endif
                    }
                }];
            }];
            return ;
        }
    }
    YMM_Weakify(self, weakSelf);
    YMMRouterRequest *request = [[YMMRouterRequest alloc] initWithURLString:url
                                                                     params:@{@"test_key":@"test_value"}
                                                                handleBlock:^(NSError * _Nullable error, id  _Nonnull data) {
        MBSubModuleInfo("app", "MBRouterDebug", @"router handle block data = %@", data);
    }];
    [[YMMRouterCenter shared] perform:request
                                        completion:^(YMMRouterResponse * _Nullable response) {
        if ([response.result isKindOfClass:[UIViewController class]]) {
            YMM_Strongify(weakSelf, strongSelf)
            [strongSelf.navigationController pushViewController:response.result animated:YES];
        }
    }];
    
}

- (NSInteger)isManualInput:(NSString *)input {
    if (self.selectedIndex != NSNotFound) {
        return self.selectedIndex;
    }
    for (YMMDebugScheme *scheme in self.schemes) {
        NSArray<NSString*> *paths = [scheme.url componentsSeparatedByString:@"?"];
        if (paths.count != 0) {
            if ([input hasPrefix:paths.firstObject]) {
                self.selectedIndex = [self.schemes indexOfObject:scheme];
                break ;
            }
        }
    }
    return self.selectedIndex;
}

- (YMMDebugSchemeCheckType)vaildateURL:(NSString *)url {
    if (url.length <= 0) {
        [@"Scheme不能为空" mb_alert];
        return YMMDebugSchemeErrorEmptyString;
    }
    return YMMDebugSchemeValid;
}

#pragma mark - LazyLoad

-(NSArray<YMMDebugScheme*> *)schemes {
    return _oldScheme ? self.oldSchemes : self.newSchemes;
}

- (NSArray<YMMDebugScheme *> *)newSchemes {
    if (!_newSchemes) {
        NSMutableArray *templateSchemes = [NSMutableArray arrayWithCapacity:2];
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"MBRouterDebug" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *path = [bundle pathForResource:NAME_OF_DEBUG_SCHEMES_FILE ofType:@"plist"];
        NSArray<NSDictionary *>*localSchemes = [[NSArray alloc] initWithContentsOfFile:path];
        for (NSDictionary *localScheme in localSchemes) {
            YMMDebugScheme *oneScheme = [[YMMDebugScheme alloc] initWithDict:localScheme];
            [templateSchemes addObject:oneScheme];
        }
        _newSchemes = [NSArray arrayWithArray:templateSchemes];
    }
    return _newSchemes;
}

- (NSArray<YMMDebugScheme *> *)oldSchemes {
    if (!_oldSchemes) {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"MBRouterDebug" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *path = [bundle pathForResource:@"route_mapping" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *routeMappingArray = [NSMutableArray array];
        for (NSString *key in [dict allKeys]) {
            NSArray *values = dict[key];
            for (NSDictionary *value in values) {
                YMMDebugScheme *scheme = [[YMMDebugScheme alloc] init];
                NSString *schemeValue = [value objectForKey:@"scheme"];
                schemeValue = ([schemeValue containsString:@"ymm"] ? @"ymm" : @"wlqq");
                scheme.url = [NSString stringWithFormat:@"%@://%@%@", schemeValue,[value objectForKey:@"host"], [value objectForKey:@"path"]];
                
                
                YMMDebugScheme *newscheme = [[YMMDebugScheme alloc] init];
                newscheme.url = [NSString stringWithFormat:@"%@://%@%@", schemeValue,key, [value objectForKey:@"path"]];
                
                [routeMappingArray addObject:scheme];
                [routeMappingArray addObject:newscheme];
            }
        }
        _oldSchemes = [routeMappingArray copy];
    }
    return _oldSchemes;
}

-(UITableView *)schemesTableView{
    if (!_schemesTableView) {
        _schemesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                          kScreenWidth,
                                                                          kScreenHeight)
                                                         style:UITableViewStylePlain];
        _schemesTableView.delegate = self;
        _schemesTableView.dataSource = self;
        _schemesTableView.backgroundColor = [UIColor whiteColor];
        _schemesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _schemesTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _schemesTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.schemesTableView registerClass:[YMMDebugSchemesCell class]
                      forCellReuseIdentifier:CELL_ID_OF_TABLEVIEW];
    }
    return _schemesTableView;
}

-(UISearchBar *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,
                                                                            CGRectGetWidth(self.schemesTableView.frame),
                                                                            DEBUGF_SCHEME_HEADER_HEIGHT)];
        _tableHeader.backgroundColor = kViewBackgroundColor;
        _tableHeader.delegate = self;
        _tableHeader.placeholder = @"点击或手工输入";
        _tableHeader.showsCancelButton = YES;
        _tableHeader.backgroundImage = [[UIImage alloc] init];
        _tableHeader.returnKeyType = UIReturnKeyRoute;
//        UIButton *cancelButton = [_tableHeader valueForKey:@"_cancelButton"];
//        [cancelButton setTitle:@"跳转" forState:UIControlStateNormal];
    }
    return _tableHeader;
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMMDebugSchemesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID_OF_TABLEVIEW
                                                            forIndexPath:indexPath];
    cell.scheme = self.schemes[indexPath.row];
    cell.hiddenStatus = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YMMDebugSchemesCell mb_heightForCellWithItem:self.schemes[indexPath.row]
                                      contentWidth:CGRectGetWidth(tableView.frame)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tableHeader.text = self.schemes[indexPath.row].url;
    [self.tableHeader becomeFirstResponder];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DEBUGF_SCHEME_HEADER_HEIGHT;
}

#pragma mark - UITableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schemes.count;
}

#pragma mark - UISeachBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self route:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //[self route:searchBar.text];
    [self.tableHeader resignFirstResponder];
}

@end
