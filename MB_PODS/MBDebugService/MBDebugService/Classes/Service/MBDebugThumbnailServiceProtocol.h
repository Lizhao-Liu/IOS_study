//
//  MBDebugThumbnailServiceProtocol.h
//  MBDebugService
//
//  Created by xiaoyadong on 2021/09/07.
//

#import <Foundation/Foundation.h>
@import YMMModuleLib;

/// block事件处理，viewController为需要跳转的vc
typedef void(^MBDebugHandleBlock)(UIViewController *vc);

@protocol MBDebugThumbnailServiceProtocol <NSObject, YMMServiceProtocol>

@property (nonatomic, copy, readonly) NSString *title; // 名称
@property (nonatomic, copy, readonly) NSString *module; // 业务模块名，唯一标识
@property (nonatomic, copy, readonly) MBDebugHandleBlock handleBlock; // 点击事件触发（业务方逻辑处理）

- (void)showThumbnailViewBlock:(void(^)(BOOL show))block;

@end
