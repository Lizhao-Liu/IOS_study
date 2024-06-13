//
//  TMSLoginSmsModel.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/8.
//

#import "TMSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMSLoginSmsModel : TMSBaseModel

@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *needCheck;
@property (nonatomic, copy) NSString *token;
@property (nonatomic) NSInteger verifyCodeLength;

@property (nonatomic) BOOL isValid;

@end

NS_ASSUME_NONNULL_END
