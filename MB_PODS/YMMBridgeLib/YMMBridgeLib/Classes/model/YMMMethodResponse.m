//
//  YMMMethodResponse.m
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/28.
//  Copyright © 2019 尹成. All rights reserved.
//

#import "YMMMethodResponse.h"
#import "YMMPluginDefine.h"

@implementation YMMMethodResponse

+ (YMMMethodResponse *)defaultErrorResponse {
    YMMMethodResponse *errorResponse = [[YMMMethodResponse alloc] init];
    errorResponse.code = YMMPluginCode_CustomError;
    errorResponse.reason = kYMMPluginError_CustomError;
    return errorResponse;
}

+ (YMMMethodResponse *)defaultSuccessResponse {
    YMMMethodResponse *successResponse = [[YMMMethodResponse alloc] init];
    successResponse.code = YMMPluginCode_Success;
    successResponse.reason = kYMMPluginSuccess;
    return successResponse;
}

@end
