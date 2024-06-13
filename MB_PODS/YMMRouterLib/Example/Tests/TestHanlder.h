//
//  TestHanlder.h
//  YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/4.
//  Copyright © 2019 knop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMMRouterAsyncHandlerProtocol;

@interface TestHanlder : NSObject<YMMRouterAsyncHandlerProtocol>

@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *path;

@end

NS_ASSUME_NONNULL_END
