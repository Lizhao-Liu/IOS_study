//
//  UIViewController+MBNav.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import <Foundation/Foundation.h>
#import "MBNavPageInfo.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol MBNavPageContainerProtocol <NSObject>

- (void)mbnav_popN:(NSUInteger)delta complete:(void(^)(BOOL))complete;

///  接收页面回传数据
/// @param resultData 需要回传的数据
/// @param error 错误
- (void)mbnav_onResult:(id)resultData withError:(NSError *)error;


/// 接受页面回传数据，支持requestId
/// @param resultData   需要回传的数据
/// @param error 错误
/// @param requestId 路由请求ID
- (void)mbnav_onResult:(id)resultData withError:(NSError *)error withRequestId:(nullable NSString *)requestId;


@end

@interface UIViewController(MBNav) <MBNavPageContainerProtocol>

@property (nonatomic, strong)MBNavPageInfo *mbNavPageInfo;

@end

NS_ASSUME_NONNULL_END
