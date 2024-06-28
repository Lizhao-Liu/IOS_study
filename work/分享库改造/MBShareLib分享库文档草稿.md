# MBShareLib分享库





## SDK集成

按需要在Podfile 文件中添加命令：

```
pod 'MBShareLib'
```

执行 `pod update`



## 第三方平台配置

### 配置SSO白名单

如果你的应用使用了如SSO授权登录或跳转到第三方分享功能，在iOS9/10下就需要增加一个可跳转的白名单，即`LSApplicationQueriesSchemes`，否则将在SDK判断是否跳转时用到的canOpenURL时返回NO，进而只进行webview授权或授权/分享失败。

在项目中的info.plist中加入应用白名单:

![LSApplicationQueriesSchemes](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n6.png)

#### 

### 配置URL Scheme

- URL Scheme是通过系统找到并跳转对应app的一类设置，通过向项目中的info.plist文件中加入`URL types`可使用第三方平台所注册的appkey信息向系统注册你的app，当跳转到第三方应用授权或分享后，可直接跳转回你的app。
- 添加URL Types可工程设置面板设置

![URL Scheme配置](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n0.png)



### 权限配置

分享的图片通过相册进行跨进程共享手段，还需要填相册访问权限，在 info 标签栏中添加 Privacy - Photo Library Usage Description

---

### 微信相关配置：

#### 配置应用Universal Link

如果需要接入微信分享/微信支付等功能，需要配置Universal Link

##### 1. 配置universal link文件

提工单，联系@陈海波进行，对应的文件地址： https://unlink.ymm56.com/apple-app-site-association

对Universal Links配置要求
a）Universal Links必须支持https
b）Universal Links配置的paths不能带query参数
c）微信使用Universal Links拉起第三方App时，会在Universal Links末尾拼接路径和参数，因此App配置的paths必须加上通配符/*

示例：

```json
{
    "applinks": {
        "apps": [],
        "details": [
        	{ 
				"appID": "RE8QQ53ZV2.com.xiwei.yunmanman",
				"paths": ["/ymmdriver/*"]
			},
			{ 
				"appID": "RE8QQ53ZV2.com.xiwei.ymmshipper",
				"paths": ["/ymmshipper/*"]
			}
        ]
    }
}
```



##### 2. AppId能力配置

![identifier配置](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n3.png)

##### 3. Unlink工程配置

![工程配置unlink](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n2.png)

##### 4. LSApplicationQueriesSchemes

![LSApplicationQueriesSchemes](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n6.png)

##### 5. 微信开放平台配置

到对应的开发者应用进行设置 [微信开放平台](https://open.weixin.qq.com/)

![开放平台应用配置](https://image.ymm56.com/ymmfile/ps-temporary/1eb3ch2n4.png)





## 初始化设置

### 初始化MBShareLib

app启动的时候，需在application:didFinishLaunchingWithOptions:中完成MBShareLib分享功能的初始化工作

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // 完成MBShareLib内部初始化工作
  [MBShareManager mbsharelib_application:application didFinishLaunchingWithOptions:launchOptions];
}
```



### 初始化第三方平台

以下是第三方平台初始化工作，通常都是启动的时候在 application:didFinishLaunchingWithOptions:中添加初始化方法，也可注册在分享的业务执行之前

```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // 以qq平台初始化为例
  MBShareChannelConfig *qqConfig = [MBShareChannelConfig qqConfigWithAppID:YOUR_APP_ID 
                                                             universalLink:YOUR_APP_UNIVERSALLINK  
                                                isCrossAppMessageResponder:YES]; // 是否作为其他app返回响应信息的接收者

[MBShareManager registerPlatform:MBSharePlatformQQ withConfiguration:qqConfig];
  
}
```



## 设置系统回调

### 设置openUrl系统回调

```objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if([MBShareManager mbsharelib_application:app openURL:url options:options]){
        return YES;
    }
    ...
    return result;
}
```

### 设置Universal Links系统回调

```objc
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if([MBShareManager mbsharelib_application:application continueUserActivity:userActivity restorationHandler:restorationHandler]){
        return YES;
    }
    ... 
    return result;
}
```









## 分享库支持分享渠道与内容

| 渠道         | 纯文本 | 图片 | web 链接 | 视频 | 小程序 |
| ------------ | ------ | ---- | -------- | ---- | ------ |
| 短信         | √      | ×    | ×        | ×    | ×      |
| 电话         | √      | ×    | ×        | ×    | ×      |
| 本地保存图片 | ×      | √    | ×        | ×    | ×      |
| 本地保存视频 | ×      | ×    | ×        | √    | ×      |
| 微信聊天     | √      | √    | √        | ×    | √      |
| 微信朋友圈   | √      | √    | √        | ×    | ×      |
| qq聊天       | √      | √    | √        | ×    | ×      |
| qq朋友圈     | √      | √    | √        | ×    | ×      |
| 抖音         | ×      | ×    | ×        | √    | ×      |
| 快手         | ×      | ×    | ×        | √    | ×      |



## 接入方案：

### 一. 接入集成

#### 1. 集成（cocoapods自动集成）

##### 按需要在Podfile 文件中添加命令：

```objective-c
pod 'MBShareLib'
```



##### 项目中导入头文件

```
@import MBShareLib;
```



#### 2. 第三方平台配置

##### 配置SSO白名单 （略）

##### 配置URL Scheme（略）

##### 权限配置

分享的图片通过相册进行跨进程共享手段，还需要填相册访问权限，在 info 标签栏中添加 Privacy - Photo Library Usage Description



#### 3. 初始化设置

app启动的时候，需在application:didFinishLaunchingWithOptions:中完成MBShareLib分享功能的初始化工作

###### 示例代码

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // 完成MBShareLib内部初始化工作
  [MBShareManager mbsharelib_application:application didFinishLaunchingWithOptions:launchOptions];
}
```



#### 4. 初始化第三方平台

以下是第三方平台初始化工作，通常都是启动的时候在 application:didFinishLaunchingWithOptions:中添加初始化方法，也可注册在分享的业务执行之前

###### 示例代码

```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // 以qq平台初始化为例
  MBShareChannelConfig *qqConfig = [MBShareChannelConfig qqConfigWithAppID:YOUR_APP_ID 
                                                             universalLink:YOUR_APP_UNIVERSALLINK  
                                                isCrossAppMessageResponder:YES]; // 是否作为其他app返回响应信息的接收者

[[MBShareChannelManager defaultManager] registerPlatform:MBSharePlatformQQ withConfiguration:qqConfig];
  
}

```



#### 5.设置系统回调

###### 示例代码

```objc
// 设置openUrl系统回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if([MBShareManager mbsharelib_application:app openURL:url options:options]){ // 处理分享平台第三方回调
        return YES;
    }
    ...
    return result;
}

//设置Universal Links系统回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if([MBShareManager mbsharelib_application:application continueUserActivity:userActivity restorationHandler:restorationHandler]){ // 处理分享平台第三方回调
        return YES;
    }
    ... 
    return result;
}
```



### 二. API接口



#### 1. 无UI分享（直接分享）

MBShareManager.h

```objc
/// 直接分享
/// @param shareChannelType 目标分享渠道 渠道类型 @see MBShareChannelType
/// @param shareObject 分享的内容 @see MBShareObject
/// @note shareObject 电话分享场景则不需要传入分享内容object
/// @param currentViewController 只针对sms,motorcade等需要传入viewcontroller的渠道, 非必填, 默认使用当前正在展示的vc
/// @param context 分享的context信息, 用于埋点上报使用 @see MBShareContextModel
/// @param successBlock 分享成功的回调
/// @param cancelBlock 分享取消的回调
/// @param errorBlock 分享失败的回调
+ (void)shareToChannel:(MBShareChannelType)shareChannelType
       withShareObject:(nullable MBShareObject *)shareObject
 currentViewController:(nullable UIViewController *)currentViewController
      withShareContext:(MBShareContextModel *)context
      withSuccessBlock:(ShareSuccessBlock)successBlock
       withCancelBlock:(ShareCancelBlock)cancelBlock
        withErrorBlock:(ShareErrorBlock)errorBlock;
```

###### 示例代码

```objc
// 1. 设置分享内容object
MBShareImageObject *imageObj = [[MBShareImageObject alloc] init];
imageObj.shareImage = [UIImage imageNamed:@"shareImage.png"];
imageObj.shareTitle = @"share image";

// 2. 调用分享接口
[MBShareManager shareToChannel:MBShareChannelTypeWechatSession
               withShareObject:imageObj
              withShareContext:nil
              withSuccessBlock:^(MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@ %@", title, msg);
}
               withCancelBlock:^(MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@ %@", title, msg);
}
                withErrorBlock:^(MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
    NSLog(@"%@ %@", title, error.localizedDescription)
}];
```



#### 2. 弹出分享菜单分享（多渠道分享）

##### 不同渠道分享内容一致

MBShareManager.h

```objc
/// 弹出分享菜单并分享 （不同分享渠道分享同样内容）
/// @param channels channels 开发者预定义显示在分享菜单上的分享渠道类型@see MBShareChannelType 数组, 非必填, 传入nil默认显示当前设备所有可分享渠道
/// @note channels 传入的分享渠道需要是core模块已经检测到的当前用户设备支持分享的渠道，不然会被过滤
/// @param object 分享的内容 @see MBShareObject
/// @param config 分享菜单视图样式配置类，@see MBShareUIConfig, 非必填，传入nil显示默认样式
/// @param viewController 分享菜单需要嵌入展示的vc, 非必填, 传入nil默认嵌入到当前window
/// @param context 分享行为发生的context，@see MBShareContextModel 用于上报埋点使用
/// @param successBlock 通过菜单分享成功返回的block
/// @param cancelBlock 通过菜单分享取消返回的block
/// @param errorBlock 通过菜单分享失败返回的block
+ (void)shareToChannels:(NSArray*)channels
        withShareObject:(MBShareObject *)object
      withConfiguration:(nullable MBShareUIConfig *)config
     withViewController:(nullable UIViewController *)viewController
       withShareContext:(nullable MBShareContextModel *)context
       withSuccessBlock:(MenuShareSuccessBlock)successBlock
        withCancelBlock:(MenuShareCancelBlock)cancelBlock
         withErrorBlock:(MenuShareErrorBlock)errorBlock;
```

###### 示例代码

```objc
    MBShareMessageObject *messageObject = [[MBShareMessageObject alloc] init];
    object.shareTitle = @"Test Title";
    object.shareTitle = @"Test Content";
    
    MBShareContextModel *testContext =  [[MBShareContextModel alloc] init];
    testContext.shareSceneValue = ShareSceneShipperAuth;
    
    NSArray *shareChannels = @[@(MBShareChannelTypeQQ),@(MBShareChannelTypeWechatSession),@(MBShareChannelTypeWechatTimeline)];
    
    [MBShareManager shareToChannels:shareChannels
                    withShareObject:messageObject
                  withConfiguration:nil
                 withViewController:nil
                   withShareContext:testContext
                   withSuccessBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
        [self showAlertWithTitle: title withMessage:msg];
    }
                    withCancelBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
        [self showAlertWithTitle: title withMessage:msg];
    }
                     withErrorBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
        [self showAlertWithTitle: title withMessage:error.localizedDescription];
    }];
```





##### 不同渠道分享内容不同

MBShareManager.h

```objc
/// 弹出分享菜单并分享 （渠道不同，分享的内容不同）
/// @param channelObjectWrappers 分享渠道与内容绑定的wrapper数组 @see MBShareChannelObjectWrapper， 开发者预定义显示在分享菜单上的分享渠道类型和渠道对应的分享内容
/// @param config 分享菜单视图样式配置类，@see MBShareUIConfig, 非必填，传入nil显示默认样式
/// @param viewController 分享菜单需要嵌入展示的vc, 非必填, 传入nil默认嵌入到当前window
/// @param context 分享行为发生的context，@see MBShareContextModel 用于上报埋点使用
/// @param successBlock 通过菜单分享成功返回的block
/// @param cancelBlock 通过菜单分享取消返回的block
/// @param errorBlock 通过菜单分享失败返回的block
+ (void)shareWithChannelObjectWrappers:(NSArray <MBShareChannelObjectWrapper *> *)channelObjectWrappers
                     withConfiguration:(nullable MBShareUIConfig *)config
                    withViewController:(nullable UIViewController *)viewController
                      withShareContext:(MBShareContextModel *)context
                      withSuccessBlock:(MenuShareSuccessBlock)successBlock
                       withCancelBlock:(MenuShareCancelBlock)cancelBlock
                        withErrorBlock:(MenuShareErrorBlock)errorBlock;

//  MBShareChannelObjectWrapper
@interface MBShareChannelObjectWrapper : NSObject

/// 需要绑定的分享渠道
@property (nonatomic, assign) MBShareChannelType targetShareChannel;
/// 需要绑定的分享内容
@property (nonatomic, strong) MBShareObject *targetShareObject;

+ (instancetype)shareWrapperWithChannel:(MBShareChannelType)channel shareObject:(MBShareObject *)object;

@end
```

###### 示例代码

```objc
    MBShareChannelObjectWrapper *ks = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeKS shareObject:self.videoModel];
    MBShareChannelObjectWrapper *wechat = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeWechatSession shareObject:miniAppModel];
    MBShareChannelObjectWrapper *wechatTimeline = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeWechatTimeline shareObject:messageModel];
    MBShareChannelObjectWrapper *qq = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeQQ shareObject:self.imageModel];
    MBShareChannelObjectWrapper *qqZone = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeQzone shareObject:messageModel];
    MBShareChannelObjectWrapper *dy = [MBShareChannelObjectWrapper shareWrapperWithChannel:MBShareChannelTypeDY shareObject:self.videoModel];
    
    [MBShareManager shareWithChannelObjectWrappers:@[ks, wechat, wechatTimeline, qq, qqZone, dy]
                                 withConfiguration:nil
                                withViewController:nil
                                  withShareContext:testContext
                                  withSuccessBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
        [self showAlertWithTitle: title withMessage:msg];
    }
                                   withCancelBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
        [self showAlertWithTitle: title withMessage:msg];
    }
                                    withErrorBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
        [self showAlertWithTitle: title withMessage:error.localizedDescription];
    }];
```





##### 分段式分享(首先弹出菜单，然后进行分享)

MBShareManager.h

弹出分享菜单并返回用户点击的分享渠道，开发者自行决定是否执行分享和是否关闭分享弹窗等逻辑

```objc
/// 显示分享菜单
/// @param channels 开发者预定义显示在分享菜单上的分享渠道类型@see MBShareChannelType 数组, 非必填, 传入nil默认显示当前设备所有可分享渠道
/// @note channels 传入的分享渠道需要是core模块已经检测到的当前用户设备支持分享的渠道，不然会被过滤
/// @param config 分享菜单视图样式配置类，@see MBShareUIConfig, 非必填，传入nil显示默认样式
/// @param viewController 分享菜单需要嵌入展示的vc, 非必填, 传入nil默认嵌入到当前window
/// @param context 分享行为发生的context @see MBShareContextModel, 用于上报埋点使用
/// @param failBlock 分享菜单弹出错误block，一般发生于传入的分享渠道当前用户设备没有安装或版本太旧
/// @param stateChangedBlock 分享弹窗状态变更回调
+ (void)showShareMenuViewWithShareChannels:(nullable NSArray*)channels
                         withConfiguration:(nullable MBShareUIConfig *)config
                        withViewController:(nullable UIViewController *)viewController
                          withShareContext:(MBShareContextModel *)context
                     withShowMenuFailBlock:(ShowMenuFailBlock)failBlock
                     withStateChangedBlock:(StateChangedBlock)stateChangedBlock;

/// 关闭分享弹窗
+ (void)dismissShareMenu;
```

###### 示例代码

```objc
//1. 设置分享内容
MBShareImageObject *imageObj = [[MBShareImageObject alloc] init];
imageObj.shareImage = [UIImage imageNamed:@"shareImage.png"];
imageObj.shareTitle = @"share image";

//2. 设置分享渠道
NSArray *shareChannels = @[@(MBShareChannelTypeQQ),@(MBShareChannelTypeWechatSession),@(MBShareChannelTypeWechatTimeline)];

UIViewController *currentVC = [UIViewController mb_currentViewController];
[MBShareManager showShareMenuViewWithShareChannels:shareChannels
                                 withConfiguration:nil
                                withViewController:currentVC
                                  withShareContext:testContext
                             withShowMenuFailBlock:^(NSError * _Nonnull error) {
    [self showAlertWithTitle:@"分享失败" withMessage:error.localizedDescription];
}
                            withStateChangedBlock:^(MBShareMenuState state, MBShareChannelType selectedChannel) {
    if(state == ShareMenuCancelled){
        // 用户关闭了分享菜单
        [self showAlertWithTitle:@"取消分享" withMessage:@"分享弹窗被取消"];
    } else {
        // 分享给用户所选渠道
        [MBShareManager shareToChannel:selectedChannel
                       withShareObject:imageObj
                      withShareContext:testContext
                      withSuccessBlock:^(MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@ %@", title, msg);
}
                       withCancelBlock:^(MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@ %@", title, msg);
}
                        withErrorBlock:^(MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
    NSLog(@"%@ %@", title, error.localizedDescription)
}];
        // 关闭分享弹窗
        [MBShareManager dismissShareMenu];
    }
}];
```





#### 3. 判断是否安装客户端

```objc
+ (BOOL)isInstalled:(MBShareChannelType)channelType;
```



#### 4. 分享类数据结构

##### 1. 分享内容基类（不同分享内容共用属性）

```objc
@interface MBShareObject : NSObject
/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (copy,nonatomic) NSString *shareTitle;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (copy,nonatomic) NSString *shareDescription;

@end
```

##### 2. 分享文本类

```objc
/// 分享文本类
@interface MBShareMessageObject : MBShareObject

/// shareContent 文本内容 必填
@property (copy,nonatomic) NSString *shareContent;

@end
```

##### 3. 分享图片类

```objc
/// 分享图片类
@interface MBShareImageObject : MBShareObject

//分享图片地址 (与分享图片二选一即可）
@property (copy,nonatomic) NSString *shareImageUrl;

//分享图片(与分享图片地址二选一即可）
@property (strong,nonatomic) UIImage *shareImage;

//缩略图，非必填，如果不填默认压缩分享图片展示
@property (nonatomic, strong) UIImage *thumbImage;

@end
```

##### 4. 分享视频类

```objc
/// 分享视频类
@interface MBShareVideoObject : MBShareObject

/// 视频下载地址 必填
@property (copy, nonatomic) NSString *downloadUrl;

/// 视频文件大小 必填
@property (copy, nonatomic) NSString *fileSize;

/// 视频下载失败转入链接
@property (copy, nonatomic) NSString *failActionUrl;

/// 视频下载成功转入链接
@property (copy, nonatomic) NSString *successActionUrl;

/// 视频文件名称
@property (copy, nonatomic) NSString *fileName;

@end
```

##### 5. 分享链接类/页面跳转类

```objc
/// 分享链接类 （页面跳转类）
@interface MBShareWebpageObject : MBShareObject

/** 网页的url地址 必填 如果分享渠道是MBShareChannelTypeMotorcade，即表示路由地址
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

// 链接分享缩略图 非必填 默认显示app图标
@property (nonatomic, strong) UIImage *thumbImage;
// 链接分享缩略图地址 非必填 默认显示app图标
@property (nonatomic, strong) NSString *thumbImageUrl;

@end
```

##### 6. 分享小程序类

```objc
/// 分享小程序类
@interface MBShareMiniProgramObject : MBShareObject
/**
 小程序username 必填
 */
@property (nonatomic, strong) NSString *userName;

/**
 小程序页面的路径
 */
@property (nonatomic, strong) NSString *path;

/**
 小程序新版本的预览图 128k  制大小不超过128KB(shareLib内部会压缩)，自定义图片建议长宽比是 5:4 预览图
 */
@property (nonatomic, strong) UIImage *hdImage;

/**
 低版本微信网页链接
 */
@property (nonatomic, strong) NSString *webpageUrl;

@end
```

##### 7. 自动识别分享内容类

```objc
// 分享自动匹配类型类（为兼容旧版本分享库设置，与原MBShareInfoModel数据结构一致，可自动转换）
@interface MBShareAutoTypeObject : MBShareObject

//分享内容
@property (copy,nonatomic) NSString *shareContent;
//分享图片地址
@property (copy,nonatomic) NSString *shareImageUrl;
//分享页面地址，如果分享渠道是MBShareChannelTypeMotorcade，sharePageUrl表示路由地址
@property (copy,nonatomic) NSString *sharePageUrl;
//分享图片
@property (strong,nonatomic) UIImage *shareImage;

/* 以下为小程序特有字段 */
@property (copy,nonatomic) NSString *path;          // 小程序页面路径
@property (copy,nonatomic) NSString *userName;      // 小程序原始id
@property (strong,nonatomic) UIImage *miniAppImage; // 小程序自定义图片 使用该字段!!! 限制大小不超过128KB(shareLib内部会压缩)，自定义图片建议长宽比是 5:4。

/* 以下为下载视频特有字段 */
@property (copy, nonatomic) NSString *downloadUrl;  // 视频下载地址 必填
@property (copy, nonatomic) NSString *fileSize;     // 视频文件大小 必填
@property (copy, nonatomic) NSString *failActionUrl;
@property (copy, nonatomic) NSString *successActionUrl;
@property (copy, nonatomic) NSString *fileName;

@end
```



#### 5. 分享回调

1. 直接分享（无ui分享）结果回调

   ```objc
   // title: 返回分享渠道标题 @see MBShareResponseTitle
   // msg: 分享结果提示信息
   typedef void (^ShareSuccessBlock) (MBShareResponseTitle title, NSString *msg);
   typedef void (^ShareCancelBlock) (MBShareResponseTitle title, NSString *msg);
   
   // title: 返回分享渠道标题 @see MBShareResponseTitle 
   // error: 返回分享错误，错误码@see MBShareErrorCode
   typedef void (^ShareErrorBlock) (MBShareResponseTitle title, NSError *error);
   
   ```



```objc
__weak typeof(self) weakSelf = self;

[self.customShare setBlockWithReturnBlock:^(id returnValue) {
    if (weakSelf.returnBlock) {
        weakSelf.returnBlock(@{@"title":kSaveImage,
                               @"result":@"保存图片成功",
                               @"shareChannel":@"saveImgModel",
                               @"statuscode":@(kSharedStatusSuccess)});
    }
} WithErrorBlock:^(id errorCode) {
    // 分享失败
    if (weakSelf.errorBlock) {
        weakSelf.errorBlock(@{@"title":kSaveImage,
                              @"result":@"保存图片失败",
                              @"shareChannel":@"saveImgModel",
                              @"statuscode":@(kSharedStatusFailed)});
    }
}];
```



2. 多渠道分享(弹出菜单分享)结果回调

   ```objc
   // selectedChannelTypeStr: @see MBShareResponseChannelStr, 返回用户选择的分享渠道（字符串）
   // title: @see MBShareResponseTitle 分享渠道类目标题
   // msg: 分享结果提示信息
   typedef void (^MenuShareSuccessBlock) (MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSString *msg);
   typedef void (^MenuShareCancelBlock) (MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSString *msg);
   
   // selectedChannelTypeStr: @see MBShareResponseChannelStr 返回用户选择的分享渠道字符串
   // title: @see MBShareResponseTitle 返回分享渠道类目标题
   // error: 返回分享错误，错误码详见@see MBShareErrorCode
   typedef void (^MenuShareErrorBlock) (MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSError *error);
   ```

   

3. 错误码



```objc
  // 错误码:
  typedef NS_ENUM(NSInteger, MBShareErrorCode) {
    // 分享渠道错误
    MBShareErrorType_NotInstall = 2000,  // 相关分享平台未安装
    MBShareErrorType_NotSupport = 2001,  // 相关分享平台版本不支持 或设备不支持
    MBShareErrorType_NotRegistered = 2002,  // 未向相关平台注册app
    MBShareErrorType_NoGetShareChannel  = 2003,  // 未发现对应渠道

    //分享内容错误
    MBShareErrorType_shareObjectIncomplete = 2004,  // 分享内容object不完整
    MBShareErrorType_shareObjectNil = 2005,  // 分享内容object未传入
    MBShareErrorType_shareObjectTypeIllegal = 2006,  // 分享内容object类型不匹配

    //视频、图片保存错误
    MBShareErrorType_PermissionDenied = 2007,  // 无相关权限
    MBShareErrorType_DownloadFail = 2008,  // 下载失败(视频)

    //分享请求已发送，第三方返回错误
    MBShareErrorType_ShareFailed  = 2009,  // 分享请求已发送，第三方分享平台返回分享错误信息
    //服务器错误
    MBShareErrorType_NoNetwork = 2011,
  };
```





#### 6. 服务端根据场景值返回分享数据并分享

如果需要处理的分享需要从服务端通过分享场景值(shareScene)获取分享内容数据并进行分享，需要通过获取MBShareModule分享service接口，调用相关方法：

###### 从服务端获取分享内容并分享接口:

```objc
/// 获取分享渠道（包括渠道的内容）列表,并弹出分享框(如果只有一个渠道会直接分享)
/// @param shareScene 分享的场景
/// @param businessId 业务id（裂变红包等，如果没有传空nil）
/// @param currentVC 当前页面vc，如果传nil将自动取topVC
/// @param dataFetchedBlock 返回从服务端读取的分享渠道数据结果
/// @param successBlock 分享成功回调
/// @param cancelBlock 分享取消回调
/// @param errorBlock 分享失败回调，包括从服务端读取数据错误
- (void)shareByScence:(ShareSceneType)shareScene
           businessId:(NSString *)businessId
            currentVC:(UIViewController *)currentVC
 withDataFetchedBlock:(ShareDataFetchedBlock)dataFetchedBlock
     withSuccessBlock:(MenuShareSuccessBlock)successBlock
      withCancelBlock:(MenuShareCancelBlock)cancelBlock
       withErrorBlock:(MenuShareErrorBlock)errorBlock;
```

###### 示例代码

```objc
id<MBShareServiceProtocol> shareService = BIND_SERVICE([YMMUserAuditModule getContext], MBShareServiceProtocol);

[shareService shareByScence:shareSceneCode
                 businessId:businessId
                  currentVC:currentVC
       withDataFetchedBlock:^(NSArray* shareChannelWrappers) {
    NSLog(@"request share info successfully");
}
           withSuccessBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@: %@", title, msg);
}
            withCancelBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {
    NSLog(@"%@: %@", title, msg);
}
             withErrorBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
    NSLog(@"%@: %@", title, error.localizedDescription);
}];

```







### 第三方平台分享参数规则

##### 微信（好友、朋友圈）分享规则



qq平台

支持网页链接分享 必填网页链接 title

文字分享 必填文本内容 title











## 迁移方案：

 

#### 分享接口选择

1. 判断是否需要从服务端读取分享数据进行分享

   如果需要，请跳至【】

   如果不需要，请判断下一条

2. 判断是否存在多个分享渠道，需要弹起分享菜单根据用户选择渠道进行分享

   如果需要，请判断下一条

   如不需要，即直接分享给指定渠道，请跳至【】

   

3. 判断是否需要分段式执行分享： 1. 弹出分享面板，获取用户所选择的渠道；2. 根据返回渠道自定义后续分享行为，(比如: 决定是否需要执行分享，是否关闭分享弹窗等)

   如果需要，请跳至【】

   如果不需要，请跳至【】

   

   

   

请根据您的分享场景需求选择合适的api接口，如下图所示:

![截屏2022-11-07 16.52.52](/Users/admin/Desktop/截屏2022-11-07 16.52.52.png)





分享菜单分享：

调用接口

```objc
/// 弹出分享菜单并分享 （渠道不同，分享的内容不同）
/// @param channelObjectWrappers 分享渠道与内容绑定的wrapper数组 @see MBShareChannelObjectWrapper， 开发者预定义显示在分享菜单上的分享渠道类型和渠道对应的分享内容
/// @param config 分享菜单视图样式配置类，@see MBShareUIConfig, 非必填，传入nil显示默认样式
/// @param viewController 分享菜单需要嵌入展示的vc, 非必填, 传入nil默认嵌入到当前window
/// @param context 分享行为发生的context，@see MBShareContextModel 用于上报埋点使用
/// @param successBlock 通过菜单分享成功返回的block
/// @param cancelBlock 通过菜单分享取消返回的block
/// @param errorBlock 通过菜单分享失败返回的block
+ (void)shareWithChannelObjectWrappers:(NSArray <MBShareChannelObjectWrapper *> *)channelObjectWrappers
                     withConfiguration:(nullable MBShareUIConfig *)config
                    withViewController:(nullable UIViewController *)viewController
                      withShareContext:(MBShareContextModel *)context
                      withSuccessBlock:(MenuShareSuccessBlock)successBlock
                       withCancelBlock:(MenuShareCancelBlock)cancelBlock
                        withErrorBlock:(MenuShareErrorBlock)errorBlock;
```

迁移方式：

1. 原代码调用以 `shareStart:` 方法，并传入YMMShareListModel数据模型进行分享，不同分享渠道分享不同的内容的场景：

首先，需要拆分传入的YMMShareListModel数据模型

![截屏2022-11-07 17.04.42](/Users/admin/Desktop/截屏2022-11-07 17.04.42.png)

1. **分享内容部分**，根据分享渠道与对应的分享内容组装成成channelObjectWrappers数组

```objc
@interface MBShareChannelObjectWrapper : NSObject
/// 需要绑定的分享渠道
@property (nonatomic, assign) MBShareChannelType targetShareChannel;
/// 需要绑定的分享内容
@property (nonatomic, strong) MBShareObject *targetShareObject;

+ (instancetype)shareWrapperWithChannel:(MBShareChannelType)channel shareObject:(MBShareObject *)object;

@end
```

注意：组建MBShareChannelObjectWrapper时，如果未知其分享内容类型，可使用`MBShareAutoTypeObject`类型

`YMMShareInfoModel`模型结构与 `MBShareAutoTypeObject`数据结构一致，可借助YYModel直接转换 (数据结构见接入文档 ->  分享类数据结构 -> 自动识别分享内容类）



2. **分享菜单配置部分**，如果您需要设置分享菜单显示界面部分样式，需组装成MBUIConfig类传入

```objc
/// 分享菜单样式配置类
@interface MBShareUIConfig : NSObject

// 预览内容数据
@property (nonatomic, strong) UIImage *previewImage;              // 预览图片
@property (nonatomic, copy) NSString *preImageUrl;                // 预览图片网络url

@property (nonatomic, strong) UIView *headerView;                 // 头部卡片视图
@property (nonatomic, strong) UIView *bottomView;                 // 底部卡片视图

// 即YMMShareHomeModel shareTitle
@property (nonatomic, copy) NSString *shareMenuTitle;             // 主标题，即原YMMShareHomeModel中shareTitle字段
// 即YMMShareHomeModel content
@property (nonatomic, copy) NSString *shareMenuSubTitle;          // 副标题，即原YMMShareHomeModel中shareContent字段
// 即原YMMShareHomeModel btn
@property (nonatomic, strong) MBShareMenuLinkBtnModel *linkBtn;   // 链接跳转按钮，即原YMMShareHomeModel中btn字段

+ (instancetype)defaultShareUIConfig;

@end
```

3. **分享context部分**，如果您设置了原YMMShareHomeModel中otherParams字段，需将其与方法中的参数businessid，shareScene共同组装成MBShareContextModel，传入方法中作为context参数，为后续埋点使用

```objc
@interface MBShareContextModel : NSObject
/** 业务id */
@property (strong, nonatomic) NSString *businessId;
/** 分享场景名称（打点的 elementId 字段),非必填，如果不填默认根据分享场景枚举值读取默认分享场景名称 */
@property (strong, nonatomic) NSString *shareSceneName;
/** 分享场景枚举 */
@property (assign, nonatomic) ShareSceneType shareSceneValue;
/** 业务埋点参数 即原YMMShareHomeModel中otherParams字段*/
@property (nonatomic, strong) NSDictionary *otherParams;
@end
```





2. 调用 `shareChannelModel:`方法，传入`NSArray<YMMShareInfoModel *> *` 数组进行分享，不同分享渠道分享不同的内容的场景：

##### 根据分享渠道与对应的分享内容组装成成channelObjectWrappers数组

```objc
@interface YMMShareInfoModel : YMMCommonModel
/*
 分享渠道
 */
@property (assign,nonatomic) ShareChannel channel;

//分享标题
@property (copy,nonatomic) NSString *shareTitle;
//分享内容
@property (copy,nonatomic) NSString *shareContent;
//分享图片地址
@property (copy,nonatomic) NSString *shareImageUrl;
//分享页面地址，如果分享渠道是kShareChannelCustom，sharePageUrl表示路由地址
@property (copy,nonatomic) NSString *sharePageUrl;
//add by zgt for task2705 20170521 start
//分享图片
@property (strong,nonatomic) UIImage *shareImage;
//add by zgt for task2705 20170521 end

/* 以下为小程序特有字段 */
@property (copy,nonatomic) NSString *path;          // 小程序页面路径
@property (copy,nonatomic) NSString *userName;      // 小程序原始id
@property (strong,nonatomic) UIImage *miniAppImage; // 小程序自定义图片 使用该字段!!! 限制大小不超过128KB(shareLib内部会压缩)，自定义图片建议长宽比是 5:4。

/* 以下为下载视频特有字段 */
@property (copy, nonatomic) NSString *downloadUrl;
@property (copy, nonatomic) NSString *fileSize;
@property (copy, nonatomic) NSString *failActionUrl;
@property (copy, nonatomic) NSString *successActionUrl;
@property (copy, nonatomic) NSString *fileName;

/*
 额外参数传递
 1. shareMode: String 0：普通分享 2：截图分享
 场景: new_driver_cargos 分享组件点击/曝光埋点增加shareMode参数
 */
@property (nonatomic, strong) NSDictionary *otherParams;
@end
```



```objc
@interface MBShareChannelObjectWrapper : NSObject
/// 需要绑定的分享渠道
@property (nonatomic, assign) MBShareChannelType targetShareChannel;
/// 需要绑定的分享内容
@property (nonatomic, strong) MBShareObject *targetShareObject;

+ (instancetype)shareWrapperWithChannel:(MBShareChannelType)channel shareObject:(MBShareObject *)object;

@end
```

注意：组件MBShareChannelObjectWrapper时，如果未知其具体分享内容类型，可使用`MBShareAutoTypeObject`类型

`YMMShareInfoModel`模型结构与 `MBShareAutoTypeObject`数据结构一致，可借助YYModel直接转换 (数据结构见接入文档 ->  分享类数据结构 -> 自动识别分享内容类）



##### 方法中的参数businessid，shareScene共同组装成MBShareContextModel，传入方法中作为context参数，为后续埋点使用

```objc
@interface MBShareContextModel : NSObject
/** 业务id */
@property (strong, nonatomic) NSString *businessId;
/** 分享场景名称（打点的 elementId 字段),非必填，如果不填默认根据分享场景枚举值读取默认分享场景名称 */
@property (strong, nonatomic) NSString *shareSceneName;
/** 分享场景枚举 */
@property (assign, nonatomic) ShareSceneType shareSceneValue;
/** 业务埋点参数 即原YMMShareHomeModel中otherParams字段*/
@property (nonatomic, strong) NSDictionary *otherParams;
@end
```





```objc
- (MBAutoTypeObject)shareObjectWithShareInfoModel:(YMMShareInfoModel *)originalModel {
  NSDictionary *dict = [originalModel yy_modelToJSONObject];
  MBShareAutoTypeObject *result = [MBShareAutoTypeObject yy_modelWithDictionary:dict];
  return result;
}
```





改造前：

```objc
YMMShareListModel *model = [YMMShareListModel new];
YMMShareInfoModel *wechatModel = [YMMShareInfoModel new];
model.wechat = wechatModel;
wechatModel.shareImage = image;
id<YMMShareServiceProtocol> shareService = (id<YMMShareServiceProtocol>)[[YMMModuleManager sharedManager] takeOneServiceForProtocol:@protocol(YMMShareServiceProtocol)];
            
[shareService shareStart:model CurrentVC:currentViewController ShareScene:@(ShareSceneShipperPayByQRCode) BusinessId:nil BlockWithReturnBlock:^(id returnValue) {
} WithErrorBlock:^(id error) {
    if ([error isKindOfClass:[NSDictionary class]]) {
        if ([error[@"statuscode"] isKindOfClass:[NSNumber class]]) {
            if ([error[@"statuscode"] longLongValue] != 3) {
                NSString *title = error[@"title"];
                NSString *msg = error[@"result"];

                MBGAlertView *alert = [MBGAlertView tipsViewWithTitle:YMM_EMPTYSTRING(title)
                                                              message:YMM_EMPTYSTRING(msg)];
                [alert show];
            }
        }
    }
}];
```

改造后：

```objc
MBShareAutoTypeModel *model = [[MBShareAutoTypeModel alloc] init];
wechatModel.shareImage = image; 
MBShareContextModel *context = [[MBShareContextModel alloc] init];
context.shareSceneValue = ShareSceneShipperPayByQRCode;

[MBShareManager shareToChannel:MBShareChannelTypeWechatSession withShareObject:model withShareContext: context withSuccessBlock:^(MBShareResponseTitle title, NSString * _Nonnull msg) {} withCancelBlock:^(MBShareResponseTitle title, NSString * _Nonnull msg) {} 
withErrorBlock:^(MBShareResponseTitle title, NSError * _Nonnull error) {
        MBGAlertView *alert = [MBGAlertView tipsViewWithTitle:YMM_EMPTYSTRING(title)
                                                      message:YMM_EMPTYSTRING(error.localizedDescription)];
        [alert show];
}];
```



改造前：

```objc
UIImage *shotImage = [self screenshotsFromView:self];
    NSMutableArray *channelArr = [NSMutableArray array];
    YMMShareInfoModel *weChatModel = [YMMShareInfoModel alloc];
    weChatModel.channel = kShareChannelWeChat;
    weChatModel.shareTitle = @"微信好友";
    weChatModel.shareImage = shotImage;
    [channelArr addObject:weChatModel];
    
    YMMShareInfoModel *friendShip = [YMMShareInfoModel alloc];
    friendShip.channel = kShareChannelWeChatFirend;
    friendShip.shareTitle = @"朋友圈";
    friendShip.shareImage = shotImage;
    [channelArr addObject:friendShip];
    
    YMMShareInfoModel *saveModel = [YMMShareInfoModel alloc];
    saveModel.channel = kShareChannelSaveImage;
    saveModel.shareTitle = @"保存图片";
    saveModel.shareImage = shotImage;
    [channelArr addObject:saveModel];
    
    YMMShareHomeModel *homeModel = [YMMShareHomeModel alloc];
    if (![NSString mb_isNilOrEmpty:self.receiveModel.shareTip]) {
        homeModel.shareContent = self.receiveModel.shareTip;
    }
    UIViewController *currentViewController = [UIViewController mb_currentViewController];
    YMM_Weakify(self, weakSelf);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id<YMMShareServiceProtocol> shareService = GET_SERVICE(YMMComplaintModule.class, YMMShareServiceProtocol);
#pragma clang diagnostic pop
    [shareService shareChannelModel:channelArr scence:50 businessId:@"haopinglvxuanyao" previewImg:shotImage preImgUrl:nil descModel:homeModel currentVC:currentViewController successBlock:^(id returnValue) {

        } errorBlock:^(id errorCode) {
            YMM_Strongify(weakSelf, strongSelf);
            [strongSelf journalElementId:@"guanbifenxiang" eventType:@"tap"];
        }];
```





改造后

```objc
UIImage *shotImage = [self screenshotsFromView:self];
NSMutableArray *channelArr = [NSMutableArray array];

MBShareImageObject *imageObject = [[MBShareImageObject alloc] init];
imageObject.shareImage = shotImage;

MBShareContextModel *context = [[MBShareContextModel alloc] init];
context.businessId = @"haopinglvxuanyao";
MBShareUIConfig *config = [[MBShareUIConfig alloc] init];
config.previewImage = shotImage;
if (![NSString mb_isNilOrEmpty:self.receiveModel.shareTip]) {
      config.shareMenuSubTitle = self.receiveModel.shareTip;
}
UIViewController *currentViewController = [UIViewController mb_currentViewController];
YMM_Weakify(self, weakSelf);
[MBShareManager shareToChannels:@[@(MBShareChannelTypeSaveImage),@(MBShareChannelTypeWechatSession),@(MBShareChannelTypeWechatTimeline)]
              withShareObject:imageObject
            withConfiguration:config
           withViewController:currentViewController
             withShareContext:context
             withSuccessBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {}
              withCancelBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSString * _Nonnull msg) {}
               withErrorBlock:^(MBShareResponseChannelStr  _Nonnull selectedChannelTypeStr, MBShareResponseTitle  _Nonnull title, NSError * _Nonnull error) {
          YMM_Strongify(weakSelf, strongSelf);
          [strongSelf journalElementId:@"guanbifenxiang" eventType:@"tap"];
}];

```



直接分享：



###### 示例代码

改造前：



改造后：









方法



回调











改造范围：

1. 原使用YMMShareModuleService 调用以 `shareStart:` 、 `shareChannelModel:`开头的分享方法进行分享的场景 
2. 原使用YMMShareModuleService 调用以`shareUpdateCargoShareList:`、 `shareFetchShareList:` 、`shareByScence: `开头的分享方法从服务端请求分享数据的场景，（需要在MBShareModule完成后进行改造）



| 序号 | 库                    | 类                                    | 方法                                  | 模块负责人 | 开发负责人 | 完成情况 | 测试负责人 | 测试情况 | 计划上线时间 | 实际上线时间 | 备注                                    |
| :--- | :-------------------- | :------------------------------------ | :------------------------------------ | :--------- | :--------- | :------- | :--------- | :------- | :----------- | ------------ | --------------------------------------- |
| 1    | MBCargoModule         | YMMCargoListShareManager              | shareCargoWithModel:                  | 许峰源     |            |          |            |          |              |              |                                         |
| 2    | MBCargoModule         | YMMCargoListShareManager              | do_disMiss                            | 许峰源     |            |          |            |          |              |              |                                         |
| 3    | MBMarketingModule     | MBShotScreenManager                   | screenShot                            | 常贤明     |            |          |            |          |              |              |                                         |
| 4    | MBMarketingModule     | MBShotScreenManager                   | shareList:                            | 常贤明     |            |          |            |          |              |              |                                         |
| 5    | MBRNLib               | MBRNUtilsPlugin                       | openShareView:                        | 周勇       |            |          |            |          |              |              | shareStartWithDict:params[@"listModel"] |
| 6    | MBRNLib               | YMMRNUtil                             | rn_ios_openShareView                  | 周勇       |            |          |            |          |              |              |                                         |
| 7    | MBShortDistanceModule | MBShortDistanceRNListView             | shareTitle:path:miniAppImage:         | 魏根       |            |          |            |          |              |              |                                         |
| 8    | MBWebView             | MBWebBridgeV1Share                    | h5ShareStart:                         | 洪汉军     |            |          |            |          |              |              |                                         |
| 9    | MBWebView             | MBWebBridgeV2Share                    | shareStart:CallBak:                   | 洪汉军     |            |          |            |          |              |              |                                         |
| 10   | YMMComplaintModule    | MBCommentShareReceiveView             | showShareView                         | 李振振？   |            |          |            |          |              |              |                                         |
| 11   | YMMComplaintModule    | MBCommentShareCompleteView            | showShareView                         | 李振振？   |            |          |            |          |              |              |                                         |
| 12   | YMMIMCenter           | YMMChatPresenter                      | onMessageCellActionDidClickWithModel: | 王文磊     |            |          |            |          |              |              |                                         |
| 13   | YMMMainModule         | MBMainModule                          | monitorShareLocalPush                 | 向平       |            |          |            |          |              |              | touchPushBlock                          |
| 14   | YMMMainModule         | MBSchemeOpenedApp                     | applicationHandleOpenURL              | 向平       |            |          |            |          |              |              |                                         |
| 15   | YMMMainModule         | MBSchemeOpenedApp                     | applicationHandleOpenUniversalLink:   | 向平       |            |          |            |          |              |              |                                         |
| 16   | YMMMainModule         | MBSchemeOpenedApp                     | onResp:                               | 向平       |            |          |            |          |              |              | 微信消息回调                            |
| 17   | YMMMineModule         | YMMUserMineBridge                     | shareToOther:callBack:                | 赵新成     |            |          |            |          |              |              | shareFetchShareList                     |
| 18   | YMMMineModule         | YMMUserMineBridge                     | shareStart:sceneType:callBack:        | 赵新成     |            |          |            |          |              |              |                                         |
| 19   | YMMPublishModule      | YMMPublishModuleService               | shareWithResult:callBack:             | 赵文超     |            |          |            |          |              |              | isWXAppInstalled                        |
| 20   | YMMPublishModule      | MBCargoDetailModuleService            | shareWithResult:callBack:             | 赵文超     |            |          |            |          |              |              | isWXAppInstalled                        |
| 21   | YMMPublishModule      | YMMCargoDetailOuterShareManager       | shareCargoWithModel:                  | 赵文超     |            |          |            |          |              |              | setUserSelectedChannelCallBack:         |
| 22   | YMMPublishModule      | YMMCargoDetailRNBridgeModule          | rn_ios_openCargoShare                 | 赵文超     |            |          |            |          |              |              |                                         |
| 23   | YMMPublishModule      | YMMCargoDetailShareManager            | shareCargoWithModel:                  | 赵文超     |            |          |            |          |              |              |                                         |
| 24   | YMMPublishModule      | YMMShareHeaderTopView                 | do_disMiss                            | 赵文超     |            |          |            |          |              |              |                                         |
| 25   | YMMTransactionModule  | GTShareLuckMoneyManager               | shareLuckMoneyViewClicked:            | 高渊       |            |          |            |          |              |              |                                         |
| 26   | YMMTransactionModule  | MBOrderTrajectoryVC                   | newShareWithStart:                    | 高渊       |            |          |            |          |              |              |                                         |
| 27   | YMMTransactionModule  | MBOrderTrajectoryVC                   | shareTrajectoryWithShortUrl:          | 高渊       |            |          |            |          |              |              |                                         |
| 28   | YMMTransactionModule  | MBOrderTrajectoryVC                   | shareToWXMiniAppWithPath:             | 高渊       |            |          |            |          |              |              |                                         |
| 29   | YMMTransactionModule  | MBTradePlugin                         | openShareView:                        | 高渊       |            |          |            |          |              |              | shareByScence:                          |
| 30   | YMMTransactionModule  | MBTradePlugin                         | photoAction:                          | 高渊       |            |          |            |          |              |              | 单独分享给微信 可调用直接分享           |
| 31   | YMMTransactionModule  | YMMTransactionPlugin                  | openShareView:                        | 高渊       |            |          |            |          |              |              | shareByScence:                          |
| 32   | YMMTransactionModule  | YMMTransactionPlugin                  | photoAction:                          | 高渊       |            |          |            |          |              |              | 单独分享给微信 可调用直接分享           |
| 33   | YMMTransactionModule  | YMMAssignDriverVC                     | assignWithWechat                      | 高渊       |            |          |            |          |              |              |                                         |
| 34   | YMMTruckModule        | YMMTruckAddDriverViewController       | addShareView                          | 赵新成     |            |          |            |          |              |              | isWXAppInstalled                        |
| 35   | YMMTruckModule        | YMMTruckAddDriverViewController       | shared:                               | 赵新成     |            |          |            |          |              |              |                                         |
| 36   | YMMUserAuditModule    | YMMAuditCommitSuccessViewController   | shareContentInit                      | 赵新成     |            |          |            |          |              |              | shareFetchShareList + shareStart        |
| 37   | YMMUserAuditModule    | YMMAuditCommitSuccessViewController   | shareStart:                           | 赵新成     |            |          |            |          |              |              |                                         |
| 38   | YMMUserAuditModule    | YMMShipperCommitSuccessViewController | shareContentInit                      | 赵新成     |            |          |            |          |              |              |                                         |
| 39   | YMMUserAuditModule    | YMMShipperCommitSuccessViewController | shareStart:                           | 赵新成     |            |          |            |          |              |              |                                         |
| 40   | YMMMainModule         | MBWXMinProgramRouter                  | handle:                               | 向平       |            |          |            |          |              |              | mb_sendMiniProgramUsername:             |
| 41   | MBWebView             | MBWebWLShare                          | shareWithInfo:                        | 洪汉军     |            |          |            |          |              |              | 调用YMMHToYShareWrapper 方法            |
| 42   | MBWebView             | MBWebWLShare                          | shareStartWithConfig:                 | 洪汉军     |            |          |            |          |              |              | 调用YMMHToYShareWrapper 方法            |
|      |                       |                                       |                                       |            |            |          |            |          |              |              |                                         |

// 提供一个selected channelblock？



// sharesheetheight方法提供

// 提供isSharing方法 是否正在显示分享弹窗



```objc
typedef NS_ENUM(NSInteger, ShareSceneType){
    ShareSceneUnknown = -1,
    ShareSceneDriverAuth = 1,       // 司机审核
    ShareSceneShipperAuth = 2,       // 货主审核
    ShareSceneShark = 4,              // 摇一摇 （h5）
    ShareSceneDriverShare = 5,       // YMM司机端告诉好友
    ShareSceneShipperShare = 6,       // YMM货主端告诉好友
    ShareSceneH5Shared = 7,          // 分享送积分
    ShareSceneGoodsShare = 8,        // 分享货源
    ShareSceneDriverBusinessCard = 9,     //分享司机名片
    ShareSceneUserCenterRecommend = 10,     // 司机端+货主端 个人中心推荐有奖（h5）
    ShareScenePaySuccessNewUser = 11,   // 司机端支付成功后的新用户领奖活动分享页面 （h5）
    ShareSceneGoodsShareHtml = 12,      // 货主端分享货源Html样式，小黑板
    ShareSceneGTGoodsShareHtml = 13,    // 司机端分享货源Html样式
    ShareSceneGTGoodsDetailShare = 15,  // 货主端货源详情分享(货主第一人称的详情)
    ShareSceneGTOrderDetailShare = 16,  // 订单详情分享
    ShareSceneGTDepositPayResultShare = 17,  // 订金支付完成分享
    ShareSceneIMShipperImgShare = 18,   // 司机审核
    ShareSceneHCBDriverAuthShare = 27,  // HCB司机审核
    ShareSceneHCBShipperAuthShare = 28, // HCB货主审核
    ShareSceneTruckNaviTrackShare = 29, // 货车导航轨迹分享
    ShareSceneOilDetailShare = 30,      // 加油站详情分享
    ShareSceneHCBShipperRecommendShare = 31, // HCB货主端推荐给朋友
    ShareSceneShipperPayByQRCode = 32,  // 司机分享二维码给货主支付
    ShareSceneHCBDriverToFriend = 41,   // HCB司机端告诉好友
    ShareSceneCargoDetailWholeCar = 201,// 整车货源分享
    ShareSceneRedEnvelope = 300,        // 裂变红包分享
    ShareSceneHCBWebPageShare = 9999,   // 货车h5页面分享场景
    ShareSceneCargoList = 1001,        // 司机货源列表分享货源
    ShareSceneCargoUserService = 1002,   // 货主我的服务分享货源
};

```



```objc
@interface MBShareContextModel : NSObject
/** 业务id cxm ps:看来只有上传分享结果和埋点用到*/
@property (strong, nonatomic) NSString *businessId;
/** 分享场景名称（打点的 elementId 字段） */
@property (strong, nonatomic) NSString *shareSceneName;
/** 分享场景枚举  */
@property (assign, nonatomic) ShareSceneType shareSceneValue;
/** 业务埋点参数  */
@property (nonatomic, strong) NSDictionary *otherParams;

@end
```





```objc
@interface MBShareUIConfig : NSObject

// 预览内容数据
@property (nonatomic, strong) UIImage *previewImage;              // 预览图片
@property (nonatomic, copy) NSString *preImageUrl;                // 预览图片网络url

@property (nonatomic, strong) UIView *headerView;                 // 头部卡片视图
@property (nonatomic, strong) UIView *bottomView;                 // 底部卡片视图

// 即YMMShareHomeModel shareTitle
@property (nonatomic, copy) NSString *shareMenuTitle;             // 主标题
// 即YMMShareHomeModel content
@property (nonatomic, copy) NSString *shareMenuSubTitle;          // 副标题
// 即原YMMShareHomeModel btn
@property (nonatomic, strong) MBShareMenuLinkBtnModel *linkBtn;       // 链接跳转按钮

+ (instancetype)defaultShareUIConfig;

@end
  
  
/// 分享菜单链接按钮model
@interface MBShareMenuLinkBtnModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *scheme;

@end
```



```objc
// 分享自动匹配类型类（为兼容旧版本分享库设置，与原MBShareInfoModel数据结构相似，可直接转换）
@interface MBShareAutoTypeObject : MBShareObject

//分享内容
@property (copy,nonatomic) NSString *shareContent;
//分享图片地址
@property (copy,nonatomic) NSString *shareImageUrl;
//分享页面地址，如果分享渠道是MBShareChannelTypeMotorcade，sharePageUrl表示路由地址
@property (copy,nonatomic) NSString *sharePageUrl;
//分享图片
@property (strong,nonatomic) UIImage *shareImage;

/* 以下为小程序特有字段 */
@property (copy,nonatomic) NSString *path;          // 小程序页面路径
@property (copy,nonatomic) NSString *userName;      // 小程序原始id
@property (strong,nonatomic) UIImage *miniAppImage; // 小程序自定义图片 使用该字段!!! 限制大小不超过128KB(shareLib内部会压缩)，自定义图片建议长宽比是 5:4。

/* 以下为下载视频特有字段 */
@property (copy, nonatomic) NSString *downloadUrl;  // 视频下载地址 必填
@property (copy, nonatomic) NSString *fileSize;     // 视频文件大小 必填
@property (copy, nonatomic) NSString *failActionUrl;
@property (copy, nonatomic) NSString *successActionUrl;
@property (copy, nonatomic) NSString *fileName;

@end
```



```objc
BOOL isNewShareLibOn = [[MBConfigCenter getStringConfig:@"" key:@""] boolValue];

if(isNewShareLibOn) {
    UIImage *shotImage = [self screenshotsFromView:self];
    NSMutableArray *channelArr = [NSMutableArray array];
    MBShareImageObject *imageObject = [[MBShareImageObject alloc] init];
    imageObject.shareImage = shotImage;
    MBShareContextModel *context = [[MBShareContextModel alloc] init];
    context.businessId = @"haopinglvxuanyao";
    MBShareUIConfig *config = [[MBShareUIConfig alloc] init];
    config.previewImage = shotImage;
    if (![NSString mb_isNilOrEmpty:self.receiveModel.shareTip]) {
          config.shareMenuSubTitle = self.receiveModel.shareTip;
    }
    UIViewController *currentViewController = [UIViewController mb_currentViewController];
    YMM_Weakify(self, weakSelf);
    [MBShareManager shareToChannels:@[@(MBShareChannelTypeSaveImage),@(MBShareChannelTypeWechatSession),@(MBShareChannelTypeWechatTimeline)]
                  withShareObject:imageObject
                withConfiguration:config
               withViewController:currentViewController
                 withShareContext:context
                 withSuccessBlock:^(MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSString *msg) {}
                  withCancelBlock:^(MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSString *msg) {}
                   withErrorBlock:^(MBShareResponseChannelStr selectedChannelTypeStr, MBShareResponseTitle title, NSError *error) {
              YMM_Strongify(weakSelf, strongSelf);
              [strongSelf journalElementId:@"guanbifenxiang" eventType:@"tap"];
    }];
} else {
  // 保留旧分享库原有分享逻辑
    UIImage *shotImage = [self screenshotsFromView:self];
    NSMutableArray *channelArr = [NSMutableArray array];
    YMMShareInfoModel *weChatModel = [YMMShareInfoModel alloc];
    weChatModel.channel = kShareChannelWeChat;
    weChatModel.shareTitle = @"微信好友";
    weChatModel.shareImage = shotImage;
    [channelArr addObject:weChatModel];
    
    YMMShareInfoModel *friendShip = [YMMShareInfoModel alloc];
    friendShip.channel = kShareChannelWeChatFirend;
    friendShip.shareTitle = @"朋友圈";
    friendShip.shareImage = shotImage;
    [channelArr addObject:friendShip];
    
    YMMShareInfoModel *saveModel = [YMMShareInfoModel alloc];
    saveModel.channel = kShareChannelSaveImage;
    saveModel.shareTitle = @"保存图片";
    saveModel.shareImage = shotImage;
    [channelArr addObject:saveModel];
    
    YMMShareHomeModel *homeModel = [YMMShareHomeModel alloc];
    if (![NSString mb_isNilOrEmpty:self.receiveModel.shareTip]) {
        homeModel.shareContent = self.receiveModel.shareTip;
    }
    UIViewController *currentViewController = [UIViewController mb_currentViewController];
    YMM_Weakify(self, weakSelf);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id<YMMShareServiceProtocol> shareService = GET_SERVICE(YMMComplaintModule.class, YMMShareServiceProtocol);
#pragma clang diagnostic pop
    [shareService shareChannelModel:channelArr scence:50 businessId:@"haopinglvxuanyao" previewImg:shotImage preImgUrl:nil descModel:homeModel currentVC:currentViewController successBlock:^(id returnValue) {
        } errorBlock:^(id errorCode) {
            YMM_Strongify(weakSelf, strongSelf);
            [strongSelf journalElementId:@"guanbifenxiang" eventType:@"tap"];
        }];
}
```



```objc
// 分段式分享回调
// 分段式菜单显示失败回调
typedef void (^ShowMenuFailBlock) (NSError *error);
// 分段式回调状态
typedef NS_ENUM(NSInteger, MBShareMenuState){
    ShareMenuCancelled = 0,
    ShareChannelSelected = 1
};
// 分段式菜单状态变更回调
typedef void (^StateChangedBlock) (MBShareMenuState state, MBShareChannelType selectedChannel);

```





#### A/B方案