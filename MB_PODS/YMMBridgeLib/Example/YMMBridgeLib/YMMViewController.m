//
//  YMMViewController.m
//  YMMBridgeLib
//
//  Created by wyyincheng@yeah.net on 10/31/2019.
//  Copyright (c) 2019 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMViewController.h"
#import <YMMBridgeLib/YMMPluginRequest.h>
#import <YMMBridgeLib/YMMCommonBridge.h>
#import <YMMBridgeLib/YMMPluginManager.h>
#import <YMMBridgeLib/MBContainerEventCenter.h>
#import <MBBridgeLibDebug/MBBridgeDebugController.h>
#import <MBBridgeLibDebug/MBTestAccessBridge.h>
#import <MBBridgeLibDebug/MBTestAccessBridge2.h>
#import "MBTestTigaBridge.h"
#import "MBTestTigaBridge2.h"
#import "MBTigaTestBridge3.h"

@interface YMMViewController ()<MBBridgeContainer>

@property (nonatomic, strong) YMMCommonBridge *bridge;
@property (nonatomic, strong) MBBridgeContainerListener *listener;

@end

@implementation YMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    MBBridgePluginConfig *config = [[MBBridgePluginConfig alloc] init];
    config.isDebug = YES;
    config.messageHandle = ^(NSString *message) {
        NSLog(@"alert warning!!!!:%@", message);
    };
    [[YMMPluginManager shared] config:config];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotification:) name:@"testNotification" object:nil];
    
    [[MBContainerEventCenter shared] subscribeEvent:@"testNotification"
                                         subscriber:self
                                             action:^(MBContainerEvent *event) {
        NSLog(@"[YMMViewController]eventName:%@, event.params:%@", event.eventName, event.params);
    }];
    
    [[MBContainerEventCenter shared] subscribeEvent:@"YMMReloadUserCenterNotification"
                                         subscriber:self
                                             action:^(MBContainerEvent *event) {
        NSLog(@"[YMMViewController]eventName:%@, event.params:%@", event.eventName, event.params);
    }];
    
    
    [[YMMPluginManager shared] registerTigaPlugin:MBTestTigaBridge.class
                                    supportModule:@"app" bizName:@"tiga"];
    [[YMMPluginManager shared] registerPlugin:MBTestTigaBridge.class
                                supportModule:@"app"
                                      bizName:@"v1"
                                     protocol:MBBridgeRegisterProtocolOption_V1];
    
    
    [[YMMPluginManager shared] registerPlugin:MBTestTigaBridge2.class
                                supportModule:@"app"
                                      bizName:@"v2"
                                     protocol:MBBridgeRegisterProtocolOption_V2];
    
    [[YMMPluginManager shared] registerPlugin:MBTigaTestBridge3.class
                                supportModule:@"app"
                                      bizName:@"all"
                                     protocol:MBBridgeRegisterProtocolOption_V1 | MBBridgeRegisterProtocolOption_V2];
    
}

- (void)testNotification:(NSNotification *)notification {
    NSLog(@"testNotification-----------:%@", notification.object);
}

// 新三段式正常调用测试
- (IBAction)threeStyleNormal:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotification" object:@"1"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testNotification" object:@"2"];
    });
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"user" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"userid":@"123"} forKey:@"params"];
    [params setValue:@"testUser" forKey:@"method"];
    
    [self.bridge performBridge:params callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"新三段式正常调用测试 response:%@", response);
    }];
}

// 三段式异常调用测试
- (IBAction)threeStyleException:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"user" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"userid":@"123"} forKey:@"params"];
    [params setValue:@"testNonemethod" forKey:@"method"];
    
    [self.bridge performBridge:params callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"三段式异常调用测试 response:%@", response);
    }];
}

// 旧两段式正常调用测试
- (IBAction)twoStyleNormal:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"cargo" forKey:@"module"];
    [params setValue:@"" forKey:@"business"];
    [params setValue:@{@"cargoid":@"3333"} forKey:@"params"];
    [params setValue:@"cargodetail" forKey:@"method"];
    
    [self.bridge performBridge:params callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"老跳转方法response:%@", response);
    }];
    
    [self.bridge performBridge:params
                     container:self
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"新跳转方法response:%@", response);
    }];
}

// 两段式异常调用测试
- (IBAction)twoStyleException:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"cargo" forKey:@"module"];
    [params setValue:@"" forKey:@"business"];
    [params setValue:@{@"cargoid":@"3333"} forKey:@"params"];
    [params setValue:@"cargodetailNone" forKey:@"method"];
    
    [self.bridge performBridge:params callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"老跳转方法response:%@", response);
    }];
    
    [self.bridge performBridge:params
                     container:self
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"新跳转方法response:%@", response);
    }];
}

// 带容器参数正常调用测试
- (IBAction)containerStyleNormal:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"user" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"cargoid":@"3333"} forKey:@"params"];
    [params setValue:@"testMore" forKey:@"method"];
    
    [self.bridge performBridge:params
                     container:self
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"container bridge response:%@", response);
    }];
    
}

// 带容器参数异常调用测试
- (IBAction)containerStyleException:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"user" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"cargoid":@"3333"} forKey:@"params"];
    [params setValue:@"testMore" forKey:@"method"];
    
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"container bridge container=nil response:%@", response);
    }];
    
}

// 方法权限调用
- (IBAction)accessMethodEvent:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"trade" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"testtradelist" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradelist, visitor=trade, success, response:%@", response);
    }];
    
    [params setValue:@"trade.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradelist, visitor=trade.ymm, success, response:%@", response);
    }];
    
    [params setValue:@"user" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradelist, visitor=user, need toast tip, response:%@", response);
    }];
    
    [params setValue:@"testtradedetail" forKey:@"method"];
    [params setValue:@"cargo" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradedetail, visitor=cargo, need errorcode=11 response:%@", response);
    }];
    
    [params setValue:@"testtradedetail" forKey:@"method"];
    [params setValue:@"cargo.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradedetail, visitor=cargo.ymm, success response:%@", response);
    }];
    
    [params setValue:@"testtradeInfo" forKey:@"method"];
    [params setValue:@"user" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradeInfo, visitor=user, success response:%@", response);
    }];
    
    [params setValue:@"testtradeInfo" forKey:@"method"];
    [params setValue:@"user.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradeInfo, visitor=user.ymm, success response:%@", response);
    }];
    
    [params setValue:@"testtradeInfo" forKey:@"method"];
    [params setValue:@"trade.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradeInfo, visitor=trade.ymm, need toast tip, response:%@", response);
    }];
    
    [params setValue:@"testtradeInfo" forKey:@"method"];
    [params removeObjectForKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call trade.ymm.testtradeInfo, no visitor, need toast tip, response:%@", response);
    }];
}

- (IBAction)accessOnlyMethodEvent:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"main" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"maintab" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call main.ymm.maintab, visitor=trade, success, response:%@", response);
    }];
    
    [params setValue:@"" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call main.ymm.maintab, no visitor, need toast tip, response:%@", response);
    }];
    
    [params setValue:@"mainicon" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call main.ymm.mainicon, visitor=trade, no accesscontrol, success, response:%@", response);
    }];
    
    [params setValue:@"mainicon" forKey:@"method"];
    [params removeObjectForKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call main.ymm.mainicon, no visitor, no accesscontrol, success, response:%@", response);
    }];
    
}

- (IBAction)accessAllMethodEvent:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"rn" forKey:@"source"];
    [params setValue:@"push" forKey:@"module"];
    [params setValue:@"ymm" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"pushinfo" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call push.ymm.pushinfo, visitor=trade, error no premission, response:%@", response);
    }];
    
    [params setValue:@"pushinfo" forKey:@"method"];
    [params setValue:@"trade.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call push.ymm.pushinfo, visitor=trade.ymm, success, response:%@", response);
    }];
    
    [params setValue:@"pushlist" forKey:@"method"];
    [params setValue:@"user.ymm" forKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call push.ymm.pushlist, visitor=user.ymm, success, response:%@", response);
    }];
    
    [params setValue:@"pushlist" forKey:@"method"];
    [params removeObjectForKey:@"visitor"];
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"call push.ymm.pushlist, no visitor, error no premission, response:%@", response);
    }];
    
}

- (IBAction)transdebugEvent:(id)sender {
    [[YMMPluginManager shared] registerPlugin:MBTestAccessBridge.class supportModule:@"app" bizName:@"test"];
    [[YMMPluginManager shared] registerPlugin:MBTestAccessBridge2.class supportModule:@"app" bizName:@"test"];
    
    MBBridgeDebugController *vc = [[MBBridgeDebugController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mainSendEvent:(id)sender {
    [[MBContainerEventCenter shared] publishEvent:@"testNotification" data:@{@"key":@"123"}];
}

- (IBAction)aysnSendEvent:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"YMMViewController child thread queue");
        [[MBContainerEventCenter shared] publishEvent:@"YMMReloadUserCenterNotification"
                                                 data:@{@"testKey" : @"aaaabbbb"}];
    });
    
}

// tiga调用失败
- (IBAction)testTigaError:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"native" forKey:@"source"];
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"tiga" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"pushinfo" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    
    // v1失败，找不到方法
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v1 call app.tiga.pushinfo, no method, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"tiga" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"testTigaUser" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2 成功，
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.tiga.testTigaUser, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"v1" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"testTigaUser" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    [params setValue:@(1) forKey:@"protocol"];
    
    // v1 成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v1 call app.v1.testTigaUser, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"v1" forKey:@"business"];
    [params setValue:@{@"trade_id":@"3333"} forKey:@"params"];
    [params setValue:@"testnomethod" forKey:@"method"];
    [params setValue:@"trade" forKey:@"visitor"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2 失败
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.v1.testnomethod, no method, response:%@", response);
    }];
}

// tiga 两段式
- (IBAction)testTigaTwoSuccess:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"native" forKey:@"source"];
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"v2" forKey:@"business"];
    [params setValue:@{@"info":@"3333"} forKey:@"params"];
    [params setValue:@"testv2Info" forKey:@"method"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.v2.testv2Info, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"v2" forKey:@"business"];
    [params setValue:@{@"info":@"3333"} forKey:@"params"];
    [params setValue:@"testv2Detail" forKey:@"method"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.v2.testv2Detail, ok, response:%@", response);
    }];
}

// tiga 三段式
- (IBAction)testTigaThreeSuccess:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"native" forKey:@"source"];
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"all" forKey:@"business"];
    [params setValue:@{@"info":@"v1"} forKey:@"params"];
    [params setValue:@"testallInfo" forKey:@"method"];
    
    // v1成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v1 call app.all.testallInfo, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"all" forKey:@"business"];
    [params setValue:@{@"info":@"v1"} forKey:@"params"];
    [params setValue:@"testallDetail" forKey:@"method"];
    
    // v1成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v1 call app.all.testallDetail, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"all" forKey:@"business"];
    [params setValue:@{@"info":@"v2"} forKey:@"params"];
    [params setValue:@"testallInfo" forKey:@"method"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.all.testallInfo, ok, response:%@", response);
    }];
    
    [params setValue:@"app" forKey:@"module"];
    [params setValue:@"all" forKey:@"business"];
    [params setValue:@{@"info":@"v2"} forKey:@"params"];
    [params setValue:@"testallDetail" forKey:@"method"];
    [params setValue:@(2) forKey:@"protocol"];
    
    // v2成功
    [self.bridge performBridge:params
                     container:nil
                      callBack:^(NSDictionary * _Nonnull response) {
        NSLog(@"v2 call app.all.testallDetail, ok, response:%@", response);
    }];
    
}


- (YMMCommonBridge *)bridge {
    if (!_bridge) {
        _bridge = [[YMMCommonBridge alloc] init];
    }
    return _bridge;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addContainerListener:(MBBridgeContainerListener *)listener unique:(NSString *)key {
    self.listener = listener;
    
    if (self.listener.deallocBlock) {
        self.listener.deallocBlock();
    }
}

@end
