//
//  HCBCodeScanerRegulation_Private.h
//  Pods
//
//  Created by tp on 21/03/2018.
//

#import "HCBCodeScanerRegulation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HCBCodeScanerRegulation ()

- (BOOL)matches:(NSString *)str;

- (void)handle:(NSString *)str sender:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
