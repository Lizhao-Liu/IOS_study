//
//  MBBridgeDebugController.m
//  Pods
//
//  Created by 常贤明 on 2022/1/6.
//

#import "MBBridgeDebugController.h"
@import Masonry;
@import YMMBridgeLib;

#define TEST_FONT [UIFont systemFontOfSize:14.]

@interface MBBridgeDebugController ()<MBBridgeNativeContainerHandle>

@property (nonatomic, strong) UITextField *moduleField;
@property (nonatomic, strong) UITextField *bizField;

@property (nonatomic, strong) UITextField *methodField;
@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) YMMCommonBridge *bridge;

@property (nonatomic, strong) MBNativeBridge *nativeBridge;

@end

@implementation MBBridgeDebugController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"bridge基础能力测试";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"sendEvent"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(rightEvent:)];
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"clearEvent"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clearEvent:)];
    
    self.navigationItem.rightBarButtonItems = @[rightItem, clearItem];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(performSegueToReturnBack)];
    
    [[MBContainerEventCenter shared] subscribeEventOnMainThread:@"YMMReloadUserCenterNotification"
                                                     subscriber:self
                                                         action:^(MBContainerEvent *event) {
        
        NSLog(@"[MBBridgeDebugController]eventName:%@, event.params:%@", event.eventName, event.params);
    }];
    
    [[MBContainerEventCenter shared] subscribeEvent:@"release"
                                         subscriber:self
                                             action:^(MBContainerEvent *event) {
        NSLog(@"[MBBridgeDebugController]eventName:%@, event.params:%@", event.eventName, event.params);
    }];
    
    [[MBContainerEventCenter shared] subscribeAllEvent:self
                                                action:^(MBContainerEvent *event) {
        NSLog(@"[MBBridgeDebugController][subscribeAllEvent]eventName:%@, event.params:%@", event.eventName, event.params);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.moduleField];
    [self.view addSubview:self.bizField];
    
    [self.moduleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(74.);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(37.);
    }];
    
    [self.bizField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moduleField.mas_top);
        make.left.mas_equalTo(self.moduleField.mas_right).mas_offset(8.);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(37.);
    }];
    
    UILabel *methodlabel = [[UILabel alloc] init];
    methodlabel.font = TEST_FONT;
    methodlabel.text = @"当前方法：app.test.apptestbridge";
    [self.view addSubview:methodlabel];
    [methodlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moduleField.mas_bottom).mas_offset(10.);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.methodField];
    [self.methodField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(methodlabel.mas_top).mas_offset(-10);
        make.left.mas_equalTo(methodlabel.mas_right).mas_offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(37.);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"调用方法" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transferEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(methodlabel.mas_bottom).mas_offset(30.);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(37.);
    }];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"debug", @"release"]];
    //segment.frame = CGRectMake(0, 300, 130., 44.);
    segment.selectedSegmentIndex=0;
    [segment addTarget:self action:@selector(titlechangeIndex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_top);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(37.);
    }];
    
    [self titlechangeIndex:segment];
    
    [self.view addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).mas_offset(15.);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    UITextView *descView = [[UITextView alloc] init];
    descView.editable = NO;
    descView.font = TEST_FONT;
    descView.text = @"方法 app.test.apptestbridgeA，白名单：trade、trade.xx、user.base、app、app.xx；level=Warning \
    \n方法 app.test.apptestbridgeB，白名单：trade、trade.xx、cargo.base、user.base、app、app.xx；level=Error \
    \n方法 app.test.apptestbridgeC，白名单：user、user.base、cargo.base、app、app.xx；level=Warning \
    \n方法 app.test.apptestbridgeD，白名单为空(算作未设置白名单)；level=Warning \
    \n方法 app.test.apptestbridgeE，未设置白名单 \
    ";
    [self.view addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultLabel.mas_bottom).mas_offset(15.);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.nativeBridge = [[MBNativeBridge alloc] initWithHandle:self];
    [self.nativeBridge performBridge:@"app.ui.addAbortPopInteractive"
                              params:nil
                             visitor:nil
                            callBack:^(MBBridgeResponse * _Nonnull response) {
        NSLog(@"111test native bridge response.code:%ld, response.reason:%@, response.data:%@", response.code, response.reason, response.data);
    }];
    
    [self.nativeBridge performBridge:@"app.event.subscribe"
                              params:@{@"eventName":@"YMMReloadUserCenterNotification"}
                             visitor:nil
                            callBack:^(MBBridgeResponse * _Nonnull response) {
        NSLog(@"订阅跨技术栈通知消息+++++");
    }];
    
    MBNativeBridge *native = [[MBNativeBridge alloc] init];
    [native performBridge:@"app.ui.addAbortPopInteractive"
                  params:nil
                 visitor:nil
                callBack:^(MBBridgeResponse * _Nonnull response) {
        NSLog(@"222test native bridge response.code:%ld, response.reason:%@, response.data:%@", response.code, response.reason, response.data);
    }];
}

#pragma mark - private method
- (void)transferEvent:(id)sender {
    [self.view endEditing:YES];
    NSString *methodName = [NSString stringWithFormat:@"apptestbridge%@", self.methodField.text];
    NSString *visitor = nil;
    if (self.moduleField.text.length > 0) {
        if (self.bizField.text.length > 0) {
            visitor = [NSString stringWithFormat:@"%@.%@", self.moduleField.text, self.bizField.text];
        } else {
            visitor = [NSString stringWithFormat:@"%@", self.moduleField.text];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"test" forKey:@"business"];
    [params setValue:@{@"app_id":@"3333"} forKey:@"params"];
    [params setValue:methodName forKey:@"method"];
    [params setValue:visitor forKey:@"visitor"];
    [params setValue:@"rn-cargo" forKey:@"bundleName"];
    [params setValue:@"1.2.0" forKey:@"bundleVersion"];
    
    NSString *caller = [NSString stringWithFormat:@"app.test.apptestbridge%@", self.methodField.text];
    __weak typeof(self)weakSelf = self;
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSString *result =[NSString stringWithFormat:@"call %@,\nvisitor=%@,\nresponse:%@", caller, visitor, response];
        NSLog(@"%@", result);
        weakSelf.resultLabel.text = result;
    }];
}

- (void)titlechangeIndex:(UISegmentedControl *)segment {
    NSInteger index=segment.selectedSegmentIndex;
    MBBridgePluginConfig *config = [[MBBridgePluginConfig alloc] init];
    __weak typeof(self)weakSelf = self;
    config.messageHandle = ^(NSString * _Nonnull message) {
        if (message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
            });
        }
    };
    if (index == 0) {
        config.isDebug = YES;
    } else {
        config.isDebug = NO;
    }
    [[YMMPluginManager shared] config:config];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)rightEvent:(UIBarButtonItem *)item {
    NSString *eventName = @"YMMReloadUserCenterNotification";
    [self.nativeBridge performBridge:@"app.container.sendEvent"
                              params:@{@"eventName":eventName, @"data":@{}}
                             visitor:nil
                            callBack:^(MBBridgeResponse * _Nonnull response) {
        NSLog(@"rightEvent----sendEvent:%@", eventName);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"child thread queue");
        [[MBContainerEventCenter shared] publishEvent:@"YMMReloadUserCenterNotification"
                                                 data:@{@"testKey" : @"aaaabbbb"}];
    });
    
    [[MBContainerEventCenter shared] publishEvent:@"testNotification" data:@{@"key":@"123"}];
}

- (void)clearEvent:(UIBarButtonItem *)item {
    [[MBContainerEventCenter shared] unsubscribeAllEvent:self];
}

- (void)performSegueToReturnBack {
    if(self.navigationController.childViewControllers.count == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

#pragma mark - property method
- (UITextField *)moduleField {
    if (!_moduleField) {
        _moduleField = [[UITextField alloc] init];
        _moduleField.font = TEST_FONT;
        _moduleField.placeholder = @"visitor,module参数";
        _moduleField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _moduleField;
}

- (UITextField *)bizField {
    if (!_bizField) {
        _bizField = [[UITextField alloc] init];
        _bizField.font = TEST_FONT;
        _bizField.borderStyle = UITextBorderStyleRoundedRect;
        _bizField.placeholder = @"visitor,biz参数";
    }
    return _bizField;
}

- (UITextField *)methodField {
    if (!_methodField) {
        _methodField = [[UITextField alloc] init];
        _methodField.font = TEST_FONT;
        _methodField.placeholder = @"方法名";
        _methodField.text = @"A";
        _methodField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _methodField;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = TEST_FONT;
        _resultLabel.numberOfLines = 0;
        _resultLabel.text = @"调用结果";
    }
    return _resultLabel;
}

- (YMMCommonBridge *)bridge {
    if (!_bridge) {
        _bridge = [[YMMCommonBridge alloc] init];
    }
    return _bridge;
}

- (void)dealloc {
    [[MBContainerEventCenter shared] unsubscribeAllEvent:self];
    NSLog(@"MBBridgeDebugController---dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
