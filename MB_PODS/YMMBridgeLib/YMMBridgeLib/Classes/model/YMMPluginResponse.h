//
//  YMMPluginResponse.h
//  GoodTransport
//
//  Created by 尹成 on 2019/2/24.
//  Copyright © 2019 Yunmanman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMMMethodResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMPluginResponse : NSObject

/**
 bridge执行结果code
 0:成功
 */
@property (nonatomic, assign) NSInteger code;

/**
 bridge执行结果
 */
@property (nonatomic, copy) NSString *reason;

/**
 bridge执行返回数据
 */
@property (nonatomic, strong) YMMMethodResponse *data;

+ (YMMPluginResponse *)defaultSuccessResponse;
+ (YMMPluginResponse *)defaultErrorResponse;

@end

NS_ASSUME_NONNULL_END
