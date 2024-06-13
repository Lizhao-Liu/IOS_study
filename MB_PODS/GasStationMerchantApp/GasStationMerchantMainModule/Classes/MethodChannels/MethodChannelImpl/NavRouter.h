//
//  NavRouter.h
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseChannelModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface NavRouter : BaseChannelModule

- (void)goModifyPhone:(NSArray *)arguments;

- (void)goAboutUs:(NSArray *)arguments;

- (void)goHome:(NSArray *)arguments;

- (void)openNativeWebView:(NSArray *)arguments;

- (void)openModifyHostPage:(NSArray *)arguments;

- (void)goPage:(NSArray *)arguments;

- (void)route:(NSArray *)arguments;

- (void)routeForResult:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
