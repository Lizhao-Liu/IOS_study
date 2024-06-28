//
//  HCBCodeScaner_Private.h
//  HCBCodeScaner
//
//  Created by tp on 21/03/2018.
//

#import "HCBCodeScaner.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCBCodeScaner ()

@property (nonatomic, assign) BOOL enableScale;
//@property (nonatomic, assign) BOOL allowedChooseFromAlbum;
@property (nonatomic, copy, nullable) HCBCodeScanerUnrecognizedScanResultHandler unrecognizedScanResultHandler;
@property (nonatomic, copy, nullable) HCBCodeScanerNoResultFoundInTargetImageHandler noResultFoundInTargetImageHandler;

+ (instancetype)sharedScaner;

- (BOOL)handleCodeScanResult:(NSString *)result sender:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
