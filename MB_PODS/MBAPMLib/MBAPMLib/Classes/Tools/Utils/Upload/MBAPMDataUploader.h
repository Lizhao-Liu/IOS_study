//
//  MBAPMStackUploader.h
//  device_info
//
//  Created by xp on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDataUploader : NSObject

- (void)uploadData:(NSData *)data success:(void (^)(NSString *_Nullable uri))success failure:(void (^)(NSError *_Nullable errorObj))failure;

- (void)uploadData:(NSData *)data extensionName:(NSString *)extensionName success:(void (^)(NSString *_Nullable uri))success failure:(void (^)(NSError *_Nullable errorObj))failure;

@end

NS_ASSUME_NONNULL_END
