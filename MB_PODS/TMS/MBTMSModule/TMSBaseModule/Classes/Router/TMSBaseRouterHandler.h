//
//  TMSBaseRouterHandler.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/13.
//

#import <Foundation/Foundation.h>
@import YMMRouterLib;

NS_ASSUME_NONNULL_BEGIN

@interface TMSBaseAsyncRouterHandler : NSObject<YMMRouterAsyncHandlerProtocol>

@end

@interface TMSBaseSyncRouterHandler : NSObject<YMMRouterHandlerProtocol>

@end

@interface TMSBaseUserSyncRouterHandler : NSObject<YMMRouterHandlerProtocol>

@end
NS_ASSUME_NONNULL_END
