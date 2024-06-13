//
//  UIView+TMSLoading.m
//  TMSBaseModule
//
//  Created by zht on 2021/6/1.
//

#import "NSURL+TMSURL.h"

@implementation NSURL (TMSURL)

+ (nullable instancetype)tms_URLWithString:(NSString *)URLString {
    NSURL *url;
    if (@available(iOS 17.0, *)) {
        url = [NSURL URLWithString:URLString encodingInvalidCharacters:NO];
    } else {
        url = [NSURL URLWithString:URLString];
    }
    return url;
}

@end
