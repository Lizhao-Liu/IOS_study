//
//  YMMMethodResponse.h
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/28.
//  Copyright © 2019 尹成. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMMMethodResponse : NSObject

/**
 bridge执行结果code
 0:成功
 */
@property (nonatomic, assign) NSInteger code;

/**
 bridge执行结果
 */
@property (nonatomic, copy, nullable) NSString *reason;

/**
 bridge执行返回数据
 */
@property (nonatomic, strong, nullable) id data;

+ (YMMMethodResponse *)defaultSuccessResponse;
+ (YMMMethodResponse *)defaultErrorResponse;

@end

NS_ASSUME_NONNULL_END
