//
//  Test.m
//  MBFoundation_Example
//
//  Created by FDW on 2021/4/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "Test.h"
@import MBFoundation;
@import UIKit;
@import CommonCrypto;

UIWindow *_window1;
UIWindow *_window2;
UIWindow *_window3;

@interface Test () {
}

@end

@implementation Test

- (NSString *)md5WithFilePath:(NSString *)path {

    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        @autoreleasepool {
            NSData* fileData = [handle readDataOfLength: 1024 ];
            CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
            if( [fileData length] == 0 ) done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];

    return s;

}

- (long long)currentTimestamp {
    struct timeval t;
    gettimeofday(&t,NULL);
    long long dwTime = ((long long)1000000 * t.tv_sec + (long long)t.tv_usec)/1000;
    return dwTime;
}

- (void)test01:(NSString *)filePath {
    NSMutableString *str = [NSMutableString new];
//
    
    [str appendString:@"\n"];
    [str appendString:[MBFileUtil md5StringAtPath:filePath]];
    [str appendString:@"\n"];
    [str appendString:[self md5WithFilePath:filePath]];
    [str appendString:@"\n"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [str appendString:[data md5String]];
    
    long long timeT1 = [self currentTimestamp];
    for (int i = 0; i < 100; i++) {
        [MBFileUtil md5StringAtPath:filePath];
    }
    
    long long timeT2 = [self currentTimestamp];
    for (int i = 0; i < 100; i++) {
        [self md5WithFilePath:filePath];
    }
    
    
    long long timeT3 = [self currentTimestamp];
    for (int i = 0; i < 100; i++) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [data md5String];
    }
    long long timeT4 = [self currentTimestamp];
    
    NSLog(@"res: %@ \ntime1: %llu  time2: %llu  time3: %llu", str, timeT2 - timeT1, timeT3 - timeT2, timeT4 - timeT3);
    return;
    
//   UIImage *image = [UIImage imageWithData:nil];
//    NSLog(image);
//    
    
    UInt64 old = -10000000000;
    UInt64 v = MIN(MAX(0, old), 10000);
    NSLog(@"😁%s: %d %s😁\n%llu", __FILE_NAME__, __LINE__, __FUNCTION__, v);
    
    [MBCoreTelephony callWith:@"17521011668" durationClosure:nil];
//    NSString *str = @"https://www.baidu.com/";
    NSString *m;
//    NSUInteger a;
    //    [[NSUUID UUID] UUIDString];
    NSLog(@"%@", m);
    NSLog(@"%@", kMBAppType());
//    NSDictionary * dic = @{@"sLat": @(29.9463666).stringValue};
    
    NSString *str1 = @"29.946";
    NSString *str2 = @"120.138358294629";
    NSString *str3 = @"120";
    NSNumber *num1 = str1.numberValue;
    NSNumber *num2 = str2.numberValue;
    NSNumber *num3 = str3.numberValue;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    NSNumber *numFormat1 = [formatter numberFromString:str1];
    NSNumber *numFormat2 = [formatter numberFromString:str2];
    NSNumber *numFormat3 = [formatter numberFromString:str3];
    
    
    NSNumber *numDouble1 = [[NSNumber alloc] initWithDouble:[str1 doubleValue]];
    NSNumber *numDouble2 = [[NSNumber alloc] initWithDouble:[str2 doubleValue]];
    NSNumber *numDouble3 = [[NSNumber alloc] initWithDouble:[str3 doubleValue]];
    
    
    NSString *desp = [NSString stringWithFormat:@"str1 %@,str2 %@,str3 %@,/,num1 %@,num2 %@,num3 %@,/,numFormat1 %@,numFormat2 %@,numFormat3 %@,/,numDouble1 %@,numDouble2 %@,numDouble3 %@,", str1, str2, str3, num1, num2, num3, numFormat1, numFormat2, numFormat3, numDouble1, numDouble2, numDouble3];
    
    NSLog(@"%@", desp);
}

- (void)testwindow {
    
    
    if (@available(iOS 13.0, *)) {
        NSDate *date = [NSDate now];
        NSLog(@"date now is am?  %d", [date mb_isAM]);
    } else {
        // Fallback on earlier versions
    }
    NSNumber *loadingTime = @([NSDate timeIntervalSinceReferenceDate]);
    NSDate *loadingDate = [loadingTime mb_formatToSince1970Date];
    NSLog(@"loadingDate is am?  %d", [loadingDate mb_isAM]);
//
//    UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;
//    UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;
//    UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar API_UNAVAILABLE(tvos);

    NSLog(@"%f", UIWindowLevelNormal);
    NSLog(@"%f", UIWindowLevelAlert);
    NSLog(@"%f", UIWindowLevelStatusBar);
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        window.windowLevel = UIWindowLevelAlert-10;
        window.backgroundColor = UIColor.redColor;
        window.hidden = false;
        _window1 = window;
    }
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
        window.windowLevel = UIWindowLevelAlert+10;
        window.backgroundColor = UIColor.greenColor;
        window.hidden = false;
        [window setHidden:NO];
        [window  makeKeyAndVisible];
        _window2 = window;
    }
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
        window.windowLevel = UIWindowLevelStatusBar+10;
        window.backgroundColor = UIColor.blueColor;
        window.hidden = false;
        [window setHidden:NO];
        [window  makeKeyAndVisible];
        _window3 = window;
    }
    
}
@end
