//
//  TMSLoginSmsModel.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/8.
//

#import "TMSLoginSmsModel.h"
@import MBFoundation;

@implementation TMSLoginSmsModel

- (BOOL)isValid{
    
    if (_verifyCodeLength == 0 || [NSString mb_isNilOrEmpty:_timestamp]) {
        return NO;
    }
    return YES;
}
@end
