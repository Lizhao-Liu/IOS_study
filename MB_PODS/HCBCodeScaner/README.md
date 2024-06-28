# HCBCodeScaner

# 简介

`HCBCodeScaner` 组件提供了基础二维码扫描功能。

# 要求

| 组件版本号 | 最低支持 iOS 版本号 | 备注 |
| :----- | :----- | :----- |
| 1.2.0 | iOS 8.0 | N/A |

# 安装

## 通过 CocoaPods 安装

使用 CocoaPods 在 Xcode 项目中集成 `HCBCodeScaner`，在项目 `Podfile` 中集成以下内容：

```ruby
# HCB iOS Gitlab 私有 repo
source 'git@git.56qq.com:iOS-Team/HCBSpecs.git'

target 'TargetName' do
	# 指定 HCBCodeScaner 版本号
	pod 'HCBCodeScaner','~> 1.2.0'
end
```

之后执行安装命令：

```bash
$ pod install
```

# 接入

## 环境配置

在 `info.plist` 文件中加入以下 Key 及对应的内容：

- NSCameraUsageDescription

详细配置及使用方式请参考 `HCBCodeScaner` 仓库中 Example 目录下的 `HCBCodeScaner.xcworkspace` demo 项目。

# 组件结构

- `HCBCodeScaner`
  - `HCBCodeScanerView`
  - `HCBCodeScanerViewController`
  - `HCBCodeScanerRegulation`
  
# 功能

## 配置未识别二维码处理 block

当遇到没有匹配到规则的二维码时，`HCBCodeScaner` 会执行默认的行为 `unrecognizedScanResultHandler`（如果有的话）：

```objective-c
#import <HCBCodeScaner/HCBCodeScaner.h>

- (void)setupCodeScaner {
	[HCBCodeScaner setUnrecognizedScanResultHandler:^(HCBCodeScanerViewController * _Nonnull viewController, NSString * _Nullable result) {
		[viewController.navigationController popViewControllerAnimated:YES];
		[MBProgressHUD showToastAddedTo:nil imageName:nil labelText:@"无效的二维码"];
	}];

}
```

> **注意：**该 block 应由客户端配置（如 `HCBAppBasis` 中对此进行了配置），业务组件一般不需要对此 block 进行配置。

## 注册二维码识别规则及响应

`HCBCodeScaner` 内部本身没有任何二维码识别规则，仅提供基础的二维码识别能力，此时需要外部客户端或业务组件对其注入识别规则及对应的响应方式，才能实现标准的二维码识别流程，二维码识别规则通过 `HCBCodeScanerRegulation` 模块进行注入：

```objective-c
#import <HCBCodeScaner/HCBCodeScaner.h>

- (void)addCodeScanerRegulations {
    // 注册 QrPay 识别规则及响应
	HCBCodeScanerRegulation *qr_pay_regulation = [HCBCodeScanerRegulation regulationWithRule:^BOOL(NSString * _Nonnull result) {
        return [result rangeOfString:@"QrPay"].location != NSNotFound;
    } handler:^(HCBCodeScanerViewController * _Nonnull viewController, NSString * _Nonnull result) {
        NSLog(@"QrPay hit with result: %@, controller: %@", result, viewController);
    }];
    [HCBCodeScaner addRegulation:qr_pay_regulation];
    
	// 注册 retrievecoupon 识别规则及响应
    HCBCodeScanerRegulation *retrieve_coupon_regulation = [HCBCodeScanerRegulation regulationWithRule:^BOOL(NSString * _Nonnull result) {
        return [result rangeOfString:@"retrievecoupon"].location != NSNotFound;
    } handler:^(HCBCodeScanerViewController * _Nonnull viewController, NSString * _Nonnull result) {
	    NSLog(@"retrievecoupon hit with result: %@, controller: %@", result, viewController);
    }];
    [HCBCodeScaner addRegulation:retrieve_coupon_regulation];
}
```

## 进入扫码界面

支持两种方式进入扫码界面。

### 直接 push or present

```objective-c
#import <HCBCodeScaner/HCBCodeScaner.h>

- (void)toScaner {	
	[self.navigationController pushViewController:[HCBCodeScanerViewController new] animated:YES];
}
```

### 统跳

```objective-c
#import <HCBNavigator/HCBNavigator.h>

- (void)toScaner {
	[HCBURLNavigator openURL:@"wlqq://activity/rich_scan"];
}
```

> **注意：**通过统跳进入扫码界面的前提是客户端或业务组件在 `HCBNavigator` 中注册了扫码的统跳事件，否则无法跳转。（`HCBAppBasis` 在 `HCBNavigator` 模块初始化时默认注册了扫码的统跳事件）

## 访问当前的扫码界面实例

```objective-c
#import <HCBNavigator/HCBNavigator.h>

- (HCBCodeScanerViewController *)getCodeScanerViewController {
	return [HCBCodeScaner getCurrentViewController];
}
```

> **注意：**若当前没有展示 `HCBCodeScanerViewController`，那么通过 `HCBCodeScaner` 方法 `- getCurrentViewController` 获取的值是 `nil`。

# 历史版本

## 1.6.0

### 更新内容

#### feat: HCBCodeScanerViewController 新增 headerLabel 属性用于外部配置 扫描框头部的文本


新增方法：

```objective-c
// HCBCodeScanerViewController.h

/**
位于扫码框上端的Label，提供给外部配置
*/
@property (nonatomic, strong) UILabel * headerLabel;

```

使用示例：

```objective-c

HCBCodeScanerViewController * vc = [HCBCodeScanerViewController new];
vc.headerLabel.text = @"货车帮加油\n一省到底";
// vc.headerLabel.attributedText = attributedString
[weakSelf.navigationController pushViewController:vc animated:YES];

```

### 影响范围

N/A

### 测试要点及方式

1. 可以正确显示外部配置的headerLabel


### 发布评级及建议上线方案

本次发布评级：`普通级`

本次发布上线策略为：`主 app 接入，测试通过后方可上线`

## 1.5.0

### 更新内容

#### feat: 新增扫码成功和点击相册的通知


新增方法：

```objective-c
// HCBCodeScaner.h

FOUNDATION_EXPORT NSString * const HCBCodeScanerDidScanedSuccessNotification;
FOUNDATION_EXPORT NSString * const HCBCodeScanerDidClickAlbumNotification;

```

### 影响范围

N/A

### 测试要点及方式

1. 扫码成功和打开相册之后可以收到通知


### 发布评级及建议上线方案

本次发布评级：`普通级`

本次发布上线策略为：`主 app 接入，测试通过后方可上线`

## 1.4.0

### 更新内容

#### feat: 支持相册识别二维码；
#### feat: 跳转界面后自动移除扫码界面。
#### feat: 支持重新激活扫码界面。
#### fix: BUG修复。


新增方法：

```objective-c
// HCBCodeScaner.h

/**
 是否允许从相册中选取照片扫码

 @param allowChooseFromAlbum 默认为NO
 */
+ (void)setAllowedChooseFromAlbum:(BOOL)allowedChooseFromAlbum;

```

```objective-c
// HCBCodeScanerViewController.h

/**
 重新激活扫码
 */
- (void)reActive;

```

### 影响范围

N/A

### 测试要点及方式

1. 可以从相册中选取图片并成功识别二维码；
2. 扫码成功跳转之后，再返回不会再次显示扫码界面。
3. 重新激活扫码功能正常。


### 发布评级及建议上线方案

本次发布评级：`普通级`

本次发布上线策略为：`主 app 接入，测试通过后方可上线`

## 1.2.0

### 更新内容

#### feat: 支持手电筒；
#### feat: 支持二维码放大。

新增方法：

```objective-c
// HCBCodeScaner.h

/**
 是否开启二维码放大功能

 @param scale 默认为 YES
 */
+ (void)setScalingEnabled:(BOOL)scale;
```

### 影响范围

N/A

### 测试要点及方式

1. 手电筒功能是否完整，是否能够正常开启/关闭；
2. 二维码较小时是否能够放大二维码。

### 发布评级及建议上线方案

本次发布评级：`安全级`

本次发布上线策略为：`主 app 接入`

## 1.1.0

### 更新内容

#### feat: 支持识别图片中的二维码

新增方法：

```objective-c
// HCBCodeScaner.h

/**
 识别图片中的二维码，并校验已注册的二维码识别规则执行回调，未命中则会执行默认行为

 @param image 待识别的二维码图片
 @return 识别结果
 */
+ (nullable NSString *)scanImage:(UIImage *)image;

/**
 识别图片中的二维码，不做规则校验和执行回调，直接返回结果
 
 @param image 待识别的二维码图片
 @return 识别结果
 */
+ (nullable NSString *)scanImageWithoutCallback:(UIImage *)image;
```

使用举例：

```objective-c
- (void)scan {
    if (!_imageView.image) { return; }
    NSString *result = [HCBCodeScaner scanImageWithoutCallback:_imageView.image];
    NSLog(@"scan data: %@", result);
}
```

### 影响范围

N/A

### 测试要点及方式

识别图片中的二维码

### 发布评级及建议上线方案

本次发布评级：`安全级`

本次发布上线策略为：`主 app 接入`

## 1.0.0

### 更新内容

### 影响范围

### 测试要点及方式

### 发布评级及建议上线方案

本次发布评级：``

本次发布上线策略为：``

## 0.1.4

### 更新内容

### 影响范围

### 测试要点及方式

### 发布评级及建议上线方案

本次发布评级：``

本次发布上线策略为：``
