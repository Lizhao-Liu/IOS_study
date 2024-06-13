//
//  TMSColdLaunchManger.m
//  MBTMSModule
//
//  Created by ymm_lzz on 2022/9/5.
//

#import "TMSColdLaunchManger.h"
#import "TMSNetwork.h"
#import "MBTMSModule-Swift.h"
@import MBFoundation;
@import MBNetworkLib;

@implementation TMSColdLaunchManger

DEFINE_SINGLETON_FOR_CLASS(TMSColdLaunchManger)

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

// 冷启动弹框接口
- (void)handleClodLaunchTaskRequest {
    if (self.hasLoadCommonPopupRequest){
        return;
    }
    self.hasLoadCommonPopupRequest = YES;
    
    [TMSNetwork postWithPath:@"/yzg-saas-trans-app/yzgApp/index/commonPopup" params:nil expectClass:nil onSuccess:^(id  _Nullable result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            NSString *code = result[@"code"];

            id data = result[@"data"];
            if (data && [data isKindOfClass:[NSNull class]]) {
                return;
            }
            NSString *schame = YMM_EMPTYSTRING(result[@"data"]);
            if ([code isEqualToString:@"10000"] && schame.length > 0) {
                [self handleCommonPopupSchame:schame];
            }
        }
    } onFailed:^(MBGNetworkError * _Nonnull error) {
        NSInteger code  = error.code;
        NSString *errorMsg = YMM_EMPTYSTRING(error.message);
        TMSNetworkLog_Error(@"commonPopup error code: %ld errorMsg:%@",(long)code,errorMsg);
    }];
}

- (void)handleCommonPopupSchame:(NSString *)schame {
    [TMSRouterCenter tms_performWithURLString:schame params:nil];
}

@end
