



分享平台枚举

qq / weixin / kwai /douyin





```javascript

'saveImage'
'saveVideo'
'phoneCall'
'sms'

'wechatSession'
'wechatTimeline'
'qq'
'qzone'
'kwai'
'douyin'
```





待确认问题：



这些系统功能是不是要调用其他的原子bridge，还是在分享bridge里实现？

看了下现有的bridge设计，应该还不能满足分享的功能





saveVideo：（弹起下载提示框）+ 下载网络视频 + 保存视频到相册 

saveImage：下载一个网络图片 + 保存到相册



kwai/douyin: （弹起下载提示框）+ 下载网络视频, 拿到本地文件路径 + 保存视频到相册 + 推送一个保存视频成功的push消息点击重新选择分享，通过本地路径获取本地local identifier ，传递给三方分享api





### Tiga.share(Options)

#### 描述

直接分享

#### 参数

options

| 参数名      | 类型     | 必填 | 说明                                                         |
| :---------- | :------- | :--- | :----------------------------------------------------------- |
| channel     | String   | 是   | 分享渠道 包括三方平台渠道或者手机内置渠道 "phoneCall""sms""wechatSession""wechatTimeline""qq""qzone""kwai""douyin" |
| type        | Number   | 是   | 分享形式，如图文、纯文字、纯图片、视频、小程序等。不同分享渠道支持的形式不同，参考备注说明。 |
| title       | String   |      | 分享内容的标题                                               |
| summary     | String   |      | 分享内容的摘要                                               |
| href        | String   |      | 跳转链接                                                     |
| imageUrl    | String   |      | 分享图片地址。type为0时，推荐使用小于20Kb的图片              |
| video       | Object   |      | 分享音视频必要参数                                           |
| miniProgram | Object   |      | 分享小程序必要参数                                           |
| success     | Function | 否   | 接口调用成功的回调                                           |
| fail        | Function | 否   | 接口调用失败的回调函数                                       |
| complete    | Function | 否   | 接口调用结束的回调函数（调用成功、失败都会执行）             |





返回状态码 

| code | 说明                                     |
| :--- | :--------------------------------------- |
| 0    | 分享成功                                 |
| 1    | 分享失败                                 |
| 2    | 分享取消                                 |
| 10   | 未找到指定分享渠道（相关分享平台未安装） |
| 11   | 相关分享平台版本不支持 或设备不支持分享  |
| 12   | 未向相关平台注册当前app                  |
| 20   | 分享内容参数错误                         |
| 21   | 不支持传入的分享内容类型                 |

reason



### Tiga.showShareMenu(Options)

#### 描述

显示底部分享菜单

#### 参数

options

| 参数名       | 类型      | 必填 | 说明                                                         |
| :----------- | :-------- | :--- | :----------------------------------------------------------- |
| title        | String    | 否   | 分享菜单标题，默认值"分享到"                                 |
| channels     | String [] | 否   | 指定分享渠道 传入则展示当前app支持的指定分享渠道 不传则展示当前app支持的所有分享渠道 "saveImage": 保存图片到本地 "saveVideo": 保存视频到本地 "phoneCall": 打电话 "sms": 发短信 "wechatSession": 微信聊天 "wechatTimeline": 微信朋友圈 "qq": qq "qzone": qq空间 "kwai": 快手 "douyin": 抖音 |
| previewImage | String    | 否   | 分享菜单上方预览图url                                        |
| shareScene   | String    | 否   | 分享的场景名称 传入则作为分享菜单埋点share_scene参数埋入     |
| success      | Function  | 否   | 接口调用成功的回调                                           |
| fail         | Function  | 否   | 接口调用失败的回调函数                                       |
| complete     | Function  | 否   | 接口调用结束的回调函数（调用成功、失败都会执行）             |



## 返回数据

|         | 类型   | 必填   | 默认值 | 备注                                                         |
| :------ | :----- | :----- | :----- | :----------------------------------------------------------- |
| reason  | string | 非必须 |        | 错误原因                                                     |
| code    | string | 必须   |        | 返回code  0 成功  1 未发现可用分享渠道（当前app不支持分享到指定的渠道） 2 点击了取消 |
| data    | object | 非必须 |        | 成功时返回的数据                                             |
| channel | string | 非必须 |        | 选择的分享渠道名称                                           |

返回状态码 

| code | 说明                                     |
| :--- | :--------------------------------------- |
| 0    | 分享成功                                 |
| 1    | 分享失败                                 |
| 2    | 分享取消                                 |
| 10   | 未找到指定分享渠道（相关分享平台未安装） |
| 11   | 相关分享平台版本不支持 或设备不支持分享  |
| 12   | 未向相关平台注册当前app                  |
| 20   | 分享内容参数错误                         |
| 21   | 不支持传入的分享内容类型                 |

reason







### Tiga.isAppInstalled(Options)

#### 描述

通过场景值分享

#### 依赖bridge

网络请求，分享菜单，分享

#### 参数

options

| 参数名  | 类型   | 必填 | 说明 |
| :------ | :----- | :--- | :--- |
| appType | String | 是   |      |



|        | 类型   | 是否必须 | 默认值 | 备注              | 其他信息 |
| :----- | :----- | :------- | :----- | :---------------- | :------- |
| code   | string | 必须     |        | 返回状态码 0成功  |          |
| data   | object | 必须     |        |                   |          |
| status | number | 必须     |        | 0:未安装 1:已安装 |          |

| 名称   |
| :----- |
| code   |
| data   |
| status |





### Tiga.shareByScene(Options)

#### 描述

通过场景值分享

#### 依赖bridge

网络请求，分享菜单，分享

#### 参数

options

| 参数名       | 类型      | 必填 | 说明                                                         |
| :----------- | :-------- | :--- | :----------------------------------------------------------- |
| title        | String    | 否   | 分享菜单标题，默认值"分享到"                                 |
| channels     | String [] | 否   | 指定分享渠道 传入则展示当前app支持的指定分享渠道 不传则展示当前app支持的所有分享渠道 "saveImage": 保存图片到本地 "saveVideo": 保存视频到本地 "phoneCall": 打电话 "sms": 发短信 "wechatSession": 微信聊天 "wechatTimeline": 微信朋友圈 "qq": qq "qzone": qq空间 "kwai": 快手 "douyin": 抖音 |
| previewImage | String    | 否   | 分享菜单上方预览图url                                        |
| shareScene   | String    | 否   | 分享的场景名称 传入则作为分享菜单埋点share_scene参数埋入     |
| success      | Function  | 否   | 接口调用成功的回调                                           |
| fail         | Function  | 否   | 接口调用失败的回调函数                                       |
| complete     | Function  | 否   | 接口调用结束的回调函数（调用成功、失败都会执行）             |











有两个问题想确认下：

1 有一个在特定场景值分享的bridge，根据业务传入的场景值请求分享数据再进行分享？https://yapi.amh-group.com/#/project/1649/interface/api/109542

调用的是ymm-uc-app/share/getShareDocs这个接口，我记得你之前说android这个接口不是分享来维护的，所以这个bridge是你这边维护的吗？



2 我看之前做了抖音和快手视频分享的处理逻辑，因为抖音和快手sdk只支持本地路径视频的分享，所以之前的处理方式是先将远程视频链接下载到本地然后再弹起一个push









​       



是否安装客户端

打开微信小程序





