//
//  HCBRouterCommonHandler.h
//  AliyunOSSiOS
//
//  Created by yc on 2019/11/22.
//

#import <Foundation/Foundation.h>
@import YMMRouterLib;

NS_ASSUME_NONNULL_BEGIN

// 注意：扫一扫路由注册逻辑，在 扫一扫库 HCBCodeScaner  2.2.x 版本之后，会被迁移到HCBCodeScaner中，此处逻辑可考虑移除
// 参考：https://wiki.amh-group.com/pages/viewpage.action?pageId=814402759

@interface HCBRouterCommonHandler : NSObject <YMMRouterAsyncHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
