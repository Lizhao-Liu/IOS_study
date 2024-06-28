//
//  NSSringTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface NSSringTest : XCTestCase

@end

@implementation NSSringTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - NSString+MBURLQuery
- (void)testAppendingQuery {
    NSString *url = @"www.amh.com";
    NSString *url1 = [url stringByAppendingURLQueryParameters:@{@"name": @"will"}];
    NSString *url2 = [url mb_appendURLQueryParameters:@{@"name": @"will"}];
    NSLog(@"\nurl1: %@\nurl2: %@", url1, url2);
    XCTAssertTrue([url1 isEqualToString:url2]);
    
    NSString *url3 = [url stringByAppendingQueryValue:@"name" forKey:@"will"];
    url3 = [url3 stringByAppendingQueryValue:@"111" forKey:@"222"];
    NSString *url4 = [url mb_appendingQueryValue:@"name" forKey:@"will"];
    url4 = [url4 mb_appendingQueryValue:@"111" forKey:@"222"];
    NSLog(@"\nurl3: %@\nurl4: %@", url3, url4);
    //XCTAssertTrue([url3 isEqualToString:url4]);
}

#pragma mark - NSString+MBExtends
#pragma mark - AES128
- (void)testAES128EncryptAndDecrypt {
    NSString *str = @"qwertyuiop1234567890!@#$%^&*()";
    NSString *en1 = [NSString AES128CBC_PKCS5Padding_EncryptStrig:str key:@"1234567812345678" iv:@"8765432187654321"];
    NSString *en2 = [NSString AES128CBC_PKCS5Padding_EncryptStrig:str keyAndIv:@"1234567812345678"];
    NSString *en3 = [str AES128CBC_PKCS5Padding_EncryptWithKey:@"1234567812345678" withIv:@"1234567812345678"];
    NSString *en4 = [str AES128CBC_PKCS5Padding_EncryptWithKey:@"1234567812345678" withIv:@"8765432187654321"];
    
    NSString *en11 = [NSString mb_aes128EncryptWithString:str key:@"1234567812345678" iv:@"8765432187654321"];
    NSString *en22 = [NSString mb_aes128EncryptWithString:str keyAndIv:@"1234567812345678"];
    NSString *en33 = [str mb_aes128EncryptWithKey:@"1234567812345678" iv:@"1234567812345678"];
    NSString *en44 = [str mb_aes128EncryptWithKey:@"1234567812345678" iv:@"8765432187654321"];
    
    XCTAssertTrue([en1 isEqualToString:en11]);
    XCTAssertTrue([en2 isEqualToString:en22]);
    XCTAssertTrue([en3 isEqualToString:en33]);
    XCTAssertTrue([en4 isEqualToString:en44]);
    
    NSString *de1 = [NSString AES128CBC_PKCS5Padding_DecryptString:en1 key:@"1234567812345678" iv:@"8765432187654321"];
    NSString *de2 = [NSString AES128CBC_PKCS5Padding_DecryptString:en2 keyAndIv:@"1234567812345678"];
    NSString *de3 = [en3 AES128CBC_PKCS5Padding_DecryptWithKey:@"1234567812345678" withIv:@"1234567812345678"];
    NSString *de4 = [en4 AES128CBC_PKCS5Padding_DecryptWithKey:@"1234567812345678" withIv:@"8765432187654321"];
    
    NSString *de11 = [NSString mb_aes128DecryptWithString:en11 key:@"1234567812345678" iv:@"8765432187654321"];
    NSString *de22 = [NSString mb_aes128DecryptWithString:en22 keyAndIv:@"1234567812345678"];
    NSString *de33 = [en33 mb_aes128DecryptWithKey:@"1234567812345678" iv:@"1234567812345678"];
    NSString *de44 = [en44 mb_aes128DecryptWithKey:@"1234567812345678" iv:@"8765432187654321"];
    
    XCTAssertTrue([de1 isEqualToString:de11]);
    XCTAssertTrue([de2 isEqualToString:de22]);
    XCTAssertTrue([de3 isEqualToString:de33]);
    XCTAssertTrue([de4 isEqualToString:de44]);
}

#pragma mark - MD5
- (void)testMD5 {
    NSString *str = @"qwertyuiop1234567890!@#$%^&*()";
    NSString *md51 = [str md5];
    NSString *md52 = [str mb_md5String];
    XCTAssertTrue([md51 isEqualToString:md52]);
    
    NSString *upper32_1 = [str MD5ForUpper32Bate];
    NSString *upper32_2 = [[str mb_md5String] mb_uppercase];
    XCTAssertTrue([upper32_1 isEqualToString:upper32_2]);
    
    NSString *upper16_1 = [str MD5ForUpper16Bate];
    NSString *upper16_2 = [[str mb_md5For16BateString] mb_uppercase];
    XCTAssertTrue([upper16_1 isEqualToString:upper16_2]);
    
    NSString *lower32_1 = [str MD5ForLower32Bate];
    NSString *lower32_2 = [str mb_md5String];
    XCTAssertTrue([lower32_1 isEqualToString:lower32_2]);
    
    NSString *lower16_1 = [str MD5ForLower16Bate];
    NSString *lower16_2 = [[str mb_md5For16BateString] mb_lowercase];
    XCTAssertTrue([lower16_1 isEqualToString:lower16_2]);
}

#pragma mark - sha_1,sha256
- (void)testSha {
    NSString *str = @"qwertyuiop1234567890!@#$%^&*()";
    NSString *sha1_1 = [str sha_1];
    NSString *sha1_2 = [str mb_sha1String];
    XCTAssertTrue([sha1_1 isEqualToString:sha1_2]);
    
    NSString *sha256_1 = [str sha256];
    NSString *sha256_2 = [str mb_sha256String];
    XCTAssertTrue([sha256_1 isEqualToString:sha256_2]);
}

#pragma mark - encode&decode
- (void)testEncodeAndDecode {
    NSString *str = @"qwertyuiopASDFGHJKL1234567890!@#$%^&*()";
    NSString *encodeStr1 = [str encodeString];
    NSString *encodeStr2 = [str mb_encodeString];
    XCTAssertTrue([encodeStr1 isEqualToString:encodeStr2]);
    
    NSString *str1 = @"ymm://app/web?fullscreen=true&url=https%3A%2F%2Fdevstatic.ymm56.com%2Fsd-innovation-promo-h5%2F%23%2F";
    NSString *decodeStr1 = [str1 decodeString];
    NSString *decodeStr2 = [str1 mb_decodeString];
    //XCTAssertTrue([decodeStr1 isEqualToString:decodeStr2]);
    
    NSData *data1 = [str encodedData];
    NSData *data2 = [str data];
    NSData *data3 = [str mb_dataValue];
    NSData *data4 = [str mb_utf8EncodeData];
    XCTAssertTrue([data1 isEqualToData:data3]);
    XCTAssertTrue([data2 isEqualToData:data4]);
    
    NSString *urlEncodeStr1 = [decodeStr2 URLEncodingString];
    NSString *urlEncodeStr2 = [decodeStr2 mb_URLEncodingString];
    NSString *urlEncodeStr3 = [decodeStr2 hmacURLEncodingString];
    NSString *urlEncodeStr4 = [decodeStr2 mb_hmacURLEncodingString];
    XCTAssertTrue([urlEncodeStr1 isEqualToString:urlEncodeStr2]);
    XCTAssertTrue([urlEncodeStr3 isEqualToString:urlEncodeStr4]);
    
    NSString *encodeBase64_1 = [str encodeBase64String];
    NSString *encodeBase64_2 = [str mb_base64EncodedString];
    NSString *decodeBase64_1 = [encodeBase64_1 decodeBase64String];
    NSString *decodeBase64_2 = [encodeBase64_2 mb_base64DecodedString];
    XCTAssertTrue([encodeBase64_1 isEqualToString:encodeBase64_2]);
    XCTAssertTrue([decodeBase64_1 isEqualToString:decodeBase64_2]);
}

#pragma mark - urlWithImageSize
- (void)testUrlWithImageSize {
    
    NSString *str = @"ymm://amh-group.com/1234qwer.png";
    NSString *str1 = [str urlStringWithImageSize:CGSizeMake(50, 50)];
    NSString *str2 = [str mb_OSSUrlStringWithImageSize:CGSizeMake(50, 50)];
    XCTAssertTrue([str1 isEqualToString:str2]);
}

#pragma mark - Utils
- (void)testUtils {
    NSString *str = @"1234😀😃😉qwer";
    NSString *str1 = [str disable_emoji];
    NSString *str2 = [str mb_filterEmoji];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    NSString *phone = @"13817554317";
    NSString *phone1 = [phone telephoneString];
    NSString *phone2 = [phone mb_desensitizedMobileNumber];
    XCTAssertTrue([phone1 isEqualToString:phone2]);
}

- (void)testUrlString {
    NSString *str = @"ymmfile/12345.png";
    YMMString_YMMFileURL = @"123";
    NSString.MBString_MBFileURL = @"123";
    NSString *str1 = [str ymm_absoluteURLString];
    NSString *str2 = [str mb_absoluteURLString];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    [NSString ymm_setAppFileUrlString:@"will.wang"];
    [NSString mb_setAppFileUrlString:@"will.wang"];
    NSURL *url1 = [str ymm_absoluteURL];
    NSURL *url2 = [str mb_absoluteURL];
    XCTAssertTrue([url1.absoluteString isEqualToString:url2.absoluteString]);
    
    str = @"http://123//456//789";
    str1 = [str stringByReplacingRegex:@"//" options:0 withString:@"/"];
    str2 = [str mb_stringByReplacingRegex:@"//" options:0 withString:@"/"];
    XCTAssertTrue([str1 isEqualToString:str2]);
}

#pragma nark - NSStringMBVerify
- (void)testNSStringMBVerify {
    NSString *str = @"123";
    BOOL bool1 = [str match:@"[0-9]*"];
    BOOL bool2 = [str mb_evaluateWithRegx:@"[0-9]*"];
    XCTAssertTrue(bool1 == bool2);
    XCTAssertTrue([str isValidNumber] == [str mb_isNumbers]);
    XCTAssertTrue([str isPureInt] == [str mb_isPureInt]);
    XCTAssertTrue([NSString isNilOrEmpty:str] == [NSString mb_isNilOrEmpty:str]);
    XCTAssertTrue([str isMobileNumber] == [str mb_isMobile]);
    XCTAssertTrue([NSString mb_isNilOrEmpty:nil]);
    
    NSString *str1 = @"1381754317";
    XCTAssertTrue([str1 isMobileNumber] == [str1 mb_isMobile]);
    
    XCTAssertTrue([str isCaptcha] == [str mb_isCaptcha]);
    XCTAssertTrue([str stringContainsEmoji] == [str mb_containsEmoji]);
    
    NSString *str2 = @"1234😀😃😉qwer";
    XCTAssertTrue([str2 stringContainsEmoji] == [str2 mb_containsEmoji]);
    
    XCTAssertTrue([str isValidNumber] == [str mb_isValidNumber]);
    XCTAssertTrue([@"13817554317" isValidMobileNumber] == [@"13817554317" mb_isValidMobileNumber]);
    XCTAssertTrue([@"05564617127" isValidLandlineNumber] == [@"05564617127" mb_isValidLandlineNumber]);
    XCTAssertTrue([@"13817554317" isValidTelephone] == [@"13817554317" mb_isValidTelephone]);
    XCTAssertTrue([@"汤姆克鲁斯" mb_isValidUserName]);
    XCTAssertTrue([@"1234qwer." isValidPassword] == [@"1234qwer." mb_isValidPassword]);
    XCTAssertTrue([@"1234" isValidCaptcha] == [@"1234" mb_isValidCaptcha]);
    XCTAssertTrue([@"苏A12345" isValidTruckNumber] == [@"苏A12345" mb_isValidTruckNumber]);
    XCTAssertTrue([@"340822199211191130" isValidIDNumber] == [@"340822199211191130" mb_isValidIDNumber]);
    XCTAssertTrue([@"13817554317" isChinaMobileNumber] == [@"13817554317" mb_isChinaMobileNumber]);
    XCTAssertTrue([@"willwang" isValidUserNameForAuth] == [@"willwang" mb_isValidUserNameForAuth]);
    XCTAssertTrue([@"3.14" isTwoDecimalFloat] == [@"3.14" mb_isTwoDecimalFloat]);
    XCTAssertTrue([@"1.1" isOneDecimalFloat] == [@"1.1" mb_isOneDecimalFloat]);
    XCTAssertTrue([@"苏qwer1234" isValidAddress] == [@"苏qwer1234" mb_isValidAddress]);
    
    str1 = @"   ";
    str2 = @" 1 2 3 ";
    BOOL b1 = [str1 isNotBlank];
    BOOL b2 = [str1 mb_isNotBlank];
    BOOL b3 = [str2 isNotBlank];
    BOOL b4 = [str2 mb_isNotBlank];
    XCTAssertTrue(b1 == b2);
    XCTAssertTrue(b3 == b4);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
