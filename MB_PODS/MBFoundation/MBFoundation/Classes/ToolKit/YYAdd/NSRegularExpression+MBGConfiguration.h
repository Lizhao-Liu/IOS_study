//
//  NSRegularExpression+MBGConfiguration.h
//  MBDavinciModule
//
//  Created by gavin on 2020/11/5.
//

#import <Foundation/Foundation.h>


@interface NSRegularExpression (MBGConfiguration)

+ (NSArray<NSTextCheckingResult *> *)matchesRegularExpression:(NSString *)regex checkString:(NSString *)checkString;


@end


