//
//  NSRegularExpression+MBGConfiguration.m
//  MBDavinciModule
//
//  Created by gavin on 2020/11/5.
//

#import "NSRegularExpression+MBGConfiguration.h"

@implementation NSRegularExpression (MBGConfiguration)

+ (NSArray<NSTextCheckingResult *> *)matchesRegularExpression:(NSString *)regex checkString:(NSString *)checkString
{
    if (!checkString) {
        return @[];
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                       options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                                                         error:&error];
    
    return [regularExpression matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
}

@end
