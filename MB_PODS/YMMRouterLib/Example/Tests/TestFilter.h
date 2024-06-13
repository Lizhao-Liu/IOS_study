//
//  TestFilter.h
//  YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/4.
//  Copyright © 2019 knop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMMRouterFilterProtocol;

@interface TestFilter : NSObject<YMMRouterFilterProtocol>

@property (nonatomic) BOOL invoked;

@end

NS_ASSUME_NONNULL_END
