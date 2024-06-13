//
//  MBDebugServiceProtocol.h
//  MBDebugService
//
//  Created by Ymm on 2019/12/30.
//

#import <Foundation/Foundation.h>
@import YMMModuleLib;

/// block事件处理，viewController为需要跳转的vc
typedef void(^MBDebugHandleBlock)(UIViewController *vc);

@protocol MBDebugServiceProtocol <NSObject, YMMServiceProtocol>

@property (nonatomic, copy, readonly) NSString *itemTitle; // 名称
@property (nonatomic, copy, readonly) NSString *summary; // 描述信息
@property (nonatomic, copy, readonly) MBDebugHandleBlock handleBlock; // 点击事件触发（业务方逻辑处理）

@end
