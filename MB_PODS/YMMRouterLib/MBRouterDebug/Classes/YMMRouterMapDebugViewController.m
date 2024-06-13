//
//  YMMRouterMapDebugViewController.m
//  AliyunOSSiOS
//
//  Created by yc on 2019/12/2.
//

#import "YMMRouterMapDebugViewController.h"

@import MBCommonUILib;
@import YMMRouterLib;
#import "YMMDebugSchemesCell.h"
#import "YMMDebugScheme.h"
#import "YMMRouterDebugErrorViewController.h"
@import MBFoundation;

typedef NS_ENUM(NSUInteger, YMMDebugSchemeCheckType) {
    YMMDebugSchemeErrorPrefix,
    YMMDebugSchemeErrorInvalidParams,
    YMMDebugSchemeErrorEmptyString,
    YMMDebugSchemeValid
};

static NSString *NAME_OF_DEBUG_SCHEMES_FILE = @"DebugSchemes";
static NSString *CELL_ID_OF_TABLEVIEW = @"GT_DEBUG_SCHEME_CELL_ID";
static CGFloat const DEBUGF_SCHEME_HEADER_HEIGHT = 60.f;

@interface YMMRouterMapDebugViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    BOOL _oldScheme;
}

@property (strong, nonatomic) NSArray<NSArray<YMMDebugScheme*> *> *schemes;
@property (strong, nonatomic) NSArray<NSArray<YMMDebugScheme*> *> *oldSchemes;
@property (strong, nonatomic) NSArray<NSArray<YMMDebugScheme*> *> *newSchemes;
@property (strong, nonatomic) UITableView *schemesTableView;
@property (strong, nonatomic) UISearchBar *tableHeader;
@property (strong, nonatomic, readonly) NSArray<NSString*> *whiteLists;
@property (strong, nonatomic, readonly) NSArray<NSString*> *optionalParamLists;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *errorSchemes;

@end

@implementation YMMRouterMapDebugViewController

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
    UIBarButtonItem *changeButton = [[UIBarButtonItem alloc]initWithTitle:@"切换"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(changeSchemes)];
    
    UIBarButtonItem *errorButton = [[UIBarButtonItem alloc]initWithTitle:@"错误"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(showError)];
    
    UIBarButtonItem *checkButton = [[UIBarButtonItem alloc]initWithTitle:@"404"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(checkError)];
    
    self.navigationItem.rightBarButtonItems = @[changeButton,errorButton,checkButton];
    
    [changeButton setTintColor:[UIColor redColor]];
    [errorButton setTintColor:[UIColor redColor]];
    [checkButton setTintColor:[UIColor redColor]];
}

#pragma mark - Private Methods
- (void)changeSchemes {
    _oldScheme = !_oldScheme;
    [self.schemesTableView reloadData];
}

- (void)showError {
    YMMRouterDebugErrorViewController *errorVC = [[YMMRouterDebugErrorViewController alloc] init];
    errorVC.errorSchemes = [self.errorSchemes copy];
    YMM_Weakify(self, weakSelf);
    [errorVC clearErrorSchemes:^{
        [weakSelf.errorSchemes removeAllObjects];
    }];
    [self.navigationController pushViewController:errorVC animated:YES];
}

- (void)checkError {
    [self.view mb_startLoading];
    for (NSArray<YMMDebugScheme*> * section in self.schemes) {
        for (YMMDebugScheme * scheme in section) {
            scheme.status = ([self checkShcmeSuccess:scheme] ? YMMRouterDebugStatus_Success : YMMRouterDebugStatus_404);
        }
    }
    [self.schemesTableView reloadData];
    [self.view mb_endLoading];
}

- (BOOL)checkShcmeSuccess:(YMMDebugScheme *)scheme {
    YMMRouterRequest *request = [[YMMRouterRequest alloc] initWithURLString:scheme.url];
    if ([[YMMRouterCenter shared] routerShouldHandle:request]) {
        YMMRouterResponse *response = [[YMMRouterCenter shared] match:request];
        if (response.status == YMMRouterStatusSuccess) {
            return YES;
        }
    }
    if (![self.errorSchemes containsObject:scheme.url]) {
        [self.errorSchemes addObject:scheme.url];
    }
    return NO;
}

- (void)setupUI {
    self.title = @"路由调试";
    [self.view addSubview:self.tableHeader];
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
    YMM_Weakify(self, weakSelf);
    [[YMMRouterCenter shared] performWithURLString:url
                                        completion:^(YMMRouterResponse * _Nullable response) {
        if (response.status != YMMRouterStatusSuccess) {
            [[NSString stringWithFormat:@"404: %@",url] mb_toast];
            if (![self.errorSchemes containsObject:url]) {
                [self.errorSchemes addObject:url];
            }
        }
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
    if (![self isValidPrefix:url]) {
        [@"请输入有效的scheme" mb_alert];
        return YMMDebugSchemeErrorPrefix;
    }
//    if (![url containsString:@"?"]) {
//        return YMMDebugSchemeValid;
//    }
    NSString *queryString = [url componentsSeparatedByString:@"?"].lastObject;
    NSMutableDictionary *queryParam = [NSMutableDictionary dictionaryWithCapacity:2];
    BOOL isValid = YES;
    for (NSString *param in [queryString componentsSeparatedByString:@"&"]) {
        NSArray<NSString*> *query = [param componentsSeparatedByString:@"="];
        
        if(([query count] < 2 || [query lastObject].length <= 0)
           && ![self.optionalParamLists containsObject:query.firstObject]) {
            isValid = NO;
            [[NSString stringWithFormat:@"请输入【%@】参数", [query firstObject]] mb_alert];
            break ;
        }
        [queryParam setObject:[[query lastObject] stringByRemovingPercentEncoding]
                       forKey:[query firstObject]];
    }
    return (isValid) ? YMMDebugSchemeValid : YMMDebugSchemeErrorInvalidParams;
}

- (BOOL)isValidPrefix:(NSString *)url {
//    BOOL flag = NO;
//    for (NSString *prefix in self.whiteLists) {
//        if([url hasPrefix:prefix]) {
//            flag = YES;
//            break ;
//        }
//    }
    return YES;
}

#pragma mark - LazyLoad
- (NSArray<NSArray<YMMDebugScheme *> *> *)schemes {
    return _oldScheme ? self.oldSchemes : self.newSchemes;
}

- (NSArray<NSArray<YMMDebugScheme *> *> *)newSchemes {
    if (!_newSchemes) {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"YMMRouterModule" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *path = [bundle pathForResource:@"route_mapping" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *routeMappingArray = [NSMutableArray array];
        for (NSString *key in [dict allKeys]) {
            NSMutableArray *paths = [NSMutableArray array];
            NSArray *values = dict[key];
            for (NSDictionary *value in values) {
                YMMDebugScheme *scheme = [[YMMDebugScheme alloc] init];
                NSString *schemeValue = [value objectForKey:@"scheme"];
                schemeValue = ([schemeValue containsString:@"ymm"] ? @"ymm" : @"wlqq");
                scheme.url = [NSString stringWithFormat:@"%@://%@%@", schemeValue,key, [value objectForKey:@"path"]];
                scheme.name = [value objectForKey:@"description"];
                [paths addObject:scheme];
            }
            [routeMappingArray addObject:paths];
        }
        _newSchemes = [routeMappingArray copy];
    }
    return _newSchemes;
}

- (NSArray<NSArray<YMMDebugScheme *> *> *)oldSchemes {
    if (!_oldSchemes) {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"YMMRouterModule" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *path = [bundle pathForResource:@"route_mapping" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSMutableArray *routeMappingArray = [NSMutableArray array];
        for (NSString *key in [dict allKeys]) {
            NSMutableArray *paths = [NSMutableArray array];
            NSArray *values = dict[key];
            for (NSDictionary *value in values) {
                YMMDebugScheme *scheme = [[YMMDebugScheme alloc] init];
                NSString *schemeValue = [value objectForKey:@"scheme"];
                schemeValue = ([schemeValue containsString:@"ymm"] ? @"ymm" : @"wlqq");
                scheme.url = [NSString stringWithFormat:@"%@://%@%@", schemeValue,[value objectForKey:@"host"], [value objectForKey:@"path"]];
                scheme.name = [value objectForKey:@"description"];
                [paths addObject:scheme];
            }
            [routeMappingArray addObject:paths];
        }
        _oldSchemes = [routeMappingArray copy];
    }
    return _oldSchemes;
}

-(UITableView *)schemesTableView{
    if (!_schemesTableView) {
        _schemesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60,
                                                                          kScreenWidth,
                                                                          kScreenHeight)
                                                         style:UITableViewStyleGrouped];
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

-(NSArray<NSString *> *)whiteLists{
    return @[@"ymm-driver", @"ymm", @"http", @"https", @"ymm-consignor"];
}

/**
 选填key
 */
- (NSArray<NSString *> *)optionalParamLists {
    return @[@"group_id", @"group_name", @"status", @"search_key", @"cargo_id", @"biz_type", @"around"];
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMMDebugSchemesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID_OF_TABLEVIEW
                                                            forIndexPath:indexPath];
    cell.scheme = self.schemes[indexPath.section][indexPath.row];
    cell.hiddenStatus = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YMMDebugSchemesCell mb_heightForCellWithItem:self.schemes[indexPath.section][indexPath.row]
                                      contentWidth:CGRectGetWidth(tableView.frame)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tableHeader.text = self.schemes[indexPath.section][indexPath.row].url;
    [self.tableHeader becomeFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

#pragma mark - UITableDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *urlString = ((YMMDebugScheme *)self.newSchemes[section][0]).url;
    return [NSURL URLWithString:urlString].host.lowercaseString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.schemes.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schemes[section].count;
}

#pragma mark - UISeachBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self route:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //[self route:searchBar.text];
    [self.tableHeader resignFirstResponder];
}

- (NSMutableArray *)errorSchemes {
    if (!_errorSchemes) {
        _errorSchemes = [NSMutableArray array];
    }
    return _errorSchemes;
}

@end
