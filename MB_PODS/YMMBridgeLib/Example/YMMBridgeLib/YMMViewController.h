//
//  YMMViewController.h
//  YMMBridgeLib
//
//  Created by wyyincheng@yeah.net on 10/31/2019.
//  Copyright (c) 2019 wyyincheng@yeah.net. All rights reserved.
//

@import UIKit;

@interface YMMViewController : UIViewController

// 新三段式正常调用测试
- (IBAction)threeStyleNormal:(id)sender;
// 三段式异常调用测试
- (IBAction)threeStyleException:(id)sender;


// 旧两段式正常调用测试
- (IBAction)twoStyleNormal:(id)sender;
// 两段式异常调用测试
- (IBAction)twoStyleNormal:(id)sender;

// 带容器参数正常调用测试
- (IBAction)containerStyleNormal:(id)sender;
// 带容器参数异常调用测试
- (IBAction)containerStyleException:(id)sender;


// 方法权限调用
- (IBAction)accessMethodEvent:(id)sender;

// 方法权限调用
- (IBAction)accessOnlyMethodEvent:(id)sender;

- (IBAction)accessAllMethodEvent:(id)sender;

- (IBAction)transdebugEvent:(id)sender;

- (IBAction)mainSendEvent:(id)sender;

- (IBAction)aysnSendEvent:(id)sender;

// tiga调用失败
- (IBAction)testTigaError:(id)sender;

// tiga 三段式
- (IBAction)testTigaTwoSuccess:(id)sender;

// tiga 三段式
- (IBAction)testTigaThreeSuccess:(id)sender;

@end
