//
//  MBAPMStackUploader.m
//  device_info
//
//  Created by xp on 2021/10/19.
//

#import "MBAPMDataUploader.h"
@import MBFileTransferLib;

@implementation MBAPMDataUploader
- (void)uploadData:(NSData *)data success:(void (^)(NSString *_Nullable uri))success failure:(void (^)(NSError *_Nullable errorObj))failure {
    [self uploadData:data extensionName:@"" success:success failure:failure];
}

- (void)uploadData:(NSData *)data extensionName:(NSString *)extensionName success:(void (^)(NSString *_Nullable uri))success failure:(void (^)(NSError *_Nullable errorObj))failure {
    
    if (!data || data.length <= 0) {
        
        if(failure) {
            failure(nil);
        }
        return;
    }

    MBUploadRequest *uploadTask = [MBUploadRequest generateWithBiz:@"hubble-applog-stack" data:data contentType:nil fileExtensionName:extensionName progress:nil completion:nil];

    if (!uploadTask) {
        if(failure) {
            failure(NSError.new);
        }
        return;
    }
    
    [[MBUploader sharedUploader] executeUploadWithRequests:@[uploadTask] callback:^(NSArray<MBUploadResponse *> * _Nullable responseArray, MBFileTransferError * _Nullable error) {
        
        if (error) {
            
            NSError *err = [NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
            
            if(failure) {
                failure(err);
            }
        }else {
            if (![responseArray isKindOfClass:NSArray.class]||responseArray.count == 0) {
                
                if (failure) {
                    failure(NSError.new);
                }
                return;
            }
            MBUploadResponse *model = responseArray.firstObject;
            if (success) {
                success(model.uri);
            }
        }
    }];
}

@end
