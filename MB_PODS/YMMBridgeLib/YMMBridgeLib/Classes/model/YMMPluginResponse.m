//
//  YMMPluginResponse.m
//  GoodTransport
//
//  Created by 尹成 on 2019/2/24.
//  Copyright © 2019 Yunmanman. All rights reserved.
//

#import "YMMPluginResponse.h"
#import "YMMPluginDefine.h"

@implementation YMMPluginResponse

+ (YMMPluginResponse *)defaultErrorResponse {
    YMMPluginResponse *errorResponse = [[YMMPluginResponse alloc] init];
    errorResponse.code = YMMPluginCode_NoSupport;
    errorResponse.reason = kYMMPluginError_NotFindMethodError;
    return errorResponse;
}

+ (YMMPluginResponse *)defaultSuccessResponse {
    YMMPluginResponse *successResponse = [[YMMPluginResponse alloc] init];
    successResponse.code = YMMPluginCode_Success;
    successResponse.reason = kYMMPluginSuccess;
    return successResponse;
}

@end
