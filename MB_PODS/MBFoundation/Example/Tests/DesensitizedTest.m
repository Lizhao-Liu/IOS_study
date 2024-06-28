//
//  DesensitizedTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface DesensitizedTest : XCTestCase

@end

@implementation DesensitizedTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// 脱敏姓名 (张三 = 张*)
// 社区脱敏姓名 (张三 = 张师傅)
- (void)testDesensitizedName {
    NSArray *nameArr = @[@"张三", @"张起灵", @"汤姆克鲁斯", @"张"];
    for (NSString *name in nameArr) {
        NSString *name1 = [name hcb_desensitizedName];
        NSString *name2 = [name mb_desensitizedName];
        NSLog(@"desensitizedName---- %@, %@", name1, name2);
        XCTAssertTrue([name1 isEqualToString:name2]);
    }
    
    for (NSString *name in nameArr) {
        NSString *name3 = [name hcb_desensitizedSocialName];
        NSString *name4 = [name mb_desensitizedSocialName];
        NSLog(@"desensitizedSocialName---- %@, %@", name3, name4);
        XCTAssertTrue([name3 isEqualToString:name4]);
    }
}

// 固话脱敏 (只显示前4后1)
// 手机脱敏 (只显示前3后4)
- (void)testDesensitizedNumber {
    NSArray *telArray = @[@"0556-400-8800", @"055-6400-8800"];
    for (NSString *tel in telArray) {
        NSString *tel1 = [tel hcb_desensitizedTelNumber];
        NSString *tel2 = [tel mb_desensitizedTelNumber];
        NSLog(@"desensitizedTelNumber--- %@, %@", tel1, tel2);
        XCTAssertTrue([tel1 isEqualToString:tel2]);
    }
    
    NSArray *phoneArray = @[@"13817554317", @"+86 13817554317", @"+2552 13817554317", @"+86 138-1755"];
    for (NSString *phone in phoneArray) {
        NSString *phone1 = [phone hcb_desensitizedMobleNumber];
        NSString *phone2 = [phone mb_desensitizedMobileNumber];
        NSLog(@"desensitizedMobileNumber---- %@, %@", phone1, phone2);
        XCTAssertTrue([phone1 isEqualToString:phone2]);
    }
}

// IP地址脱敏 (只显示第一地址段)
- (void)testDesensitizedIP {
    NSArray *ipArr = @[@"255.255.255.255", @"0.0.0.0", @"192.168.1.1", @"114.114.114.114"];
    for (NSString *ip in ipArr) {
        NSString *ip1 = [ip hcb_desensitizedIP];
        NSString *ip2 = [ip mb_desensitizedIP];
        NSLog(@"desensitizedIP---- %@, %@", ip1, ip2);
        XCTAssertTrue([ip1 isEqualToString:ip2]);
    }
}

// 邮箱地址脱敏 (只显示前三位，@及@之后全显示，前面不足三位则只显示一位)
- (void)testDesensitizedMail {
    NSArray *mailArray = @[@"wanghao1136@163.com", @"hao.wang24@amh-group.com", @"kq@123.cn", @"1@qq.com"];
    for (NSString *mail in mailArray) {
        NSString *mail1 = [mail hcb_desensitizedMail];
        NSString *mail2 = [mail mb_desensitizedEmail];
        NSLog(@"DesensitizedMail---- %@, %@", mail1, mail2);
        XCTAssertTrue([mail1 isEqualToString:mail2]);
    }
}

// 银行卡号脱敏 (显示后四位，其他隐藏)
- (void)testDesensitizedBankCard {
    NSArray *cardArray = @[@"1234567890", @"6217856100058541423", @"621785 6100058541423", @"6217 8561 0005 8541 423"];
    for (NSString *card in cardArray) {
        NSString *card1 = [card hcb_desensitizedBankCard];
        NSString *card2 = [card mb_desensitizedBankCard];
        NSLog(@"desensitizedBankCard--- %@, %@", card1, card2);
        XCTAssertTrue([card1 isEqualToString:card2]);
    }
}

// 密码脱敏 (全部隐藏)
- (void)testDesensitizedPassword {
    NSArray *psdArray = @[@"1234567890", @"qwertyuiop", @"!@#$%^&*()_=+", @"1q2w3e4r%T^Y&U*I(O)P../", @" ", @"  "];
    for (NSString *psd in psdArray) {
        NSString *psd1 = [psd hcb_desensitizedPassword];
        NSString *psd2 = [psd mb_desensitizedPassword];
        NSLog(@"DesensitizedPassword--- %@, %@", psd1, psd2);
        XCTAssertTrue([psd1 isEqualToString:psd2]);
    }
}

// 账号脱敏 (显示前3位字符，其他隐藏)
- (void)testDesensitizedAccount {
    NSArray *accountArr = @[@"wanghao1136@163.com", @"hao.wang24@amh-group.com", @"13817554317", @"wanghao", @"hao.wang24"];
    for (NSString *account in accountArr) {
        NSString *account1 = [account hcb_desensitizedAccount];
        NSString *account2 = [account mb_desensitizedAccount];
        NSLog(@"DesensitizedAccount--- %@, %@", account1, account2);
        XCTAssertTrue([account1 isEqualToString:account2]);
    }
}

// 驾照号码脱敏 (显示前4位和后4位，其他隐藏)
// 驾驶证档案编号脱敏 (显示前3位和后3位，其他隐藏)
- (void)testDriverLicenseNumber {
    NSArray *arr = @[@"1234567890", @"qwertyuiop", @"!@#$%^&*()_+", @"{}/\ ..: UIOP12345"];
    for (NSString *num in arr) {
        NSString *num1 = [num hcb_desensitizedDrivingLicenseNumber];
        NSString *num2 = [num mb_desensitizedDrivingLicenseNumber];
        NSLog(@"DriverLicenseNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
    
    for (NSString *num in arr) {
        NSString *num1 = [num hcb_desensitizedDrivingLicensedocumentationNumber];
        NSString *num2 = [num mb_desensitizedDrivingLicensedocumentationNumber];
        NSLog(@"DriverLicenseNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
}

// 身份证脱敏 (只显示前三位和后三位)
- (void)testDesensitizedIDCardNumber {
    NSArray *arr = @[@"340822199211191136", @"34082219921119113X"];
    for (NSString *num in arr) {
        NSString *num1 = [num hcb_desensitizedIDCardNumber];
        NSString *num2 = [num mb_desensitizedIDCardNumber];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
}

// ETC卡号脱敏 (显示前4位和后4位，中间隐藏)
// 带空格的ETC卡号脱敏
- (void)testDesensitizedETCCardNumber {
    NSArray *arr = @[@"340822199211191136", @"3408 2219 9211 1911 3XXX", @"3408 2219 9211 1911"];
    for (NSString *num in arr) {
        NSString *num1 = [num hcb_desensitizedETCCardNumber];
        NSString *num2 = [num mb_desensitizedETCCardNumber];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
    
    for (NSString *num in arr) {
        NSString *num1 = [num hcb_desensitizedETCCardNumberTypedLong];
        NSString *num2 = [num mb_desensitizedETCCardNumberTypedLong];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
}

// 车牌号脱敏 (展示前2位和后1位，其他隐藏)
// 车辆识别号脱敏 (展示前3位和后2位，其他隐藏)
// 发动机号脱敏 (展示前2位和后1位，其他隐藏)
- (void)testDesensitizedPlateNumber {
    NSArray *arr1 = @[@"京P-7K028", @"苏A-UA838"];
    for (NSString *num in arr1) {
        NSString *num1 = [num hcb_desensitizedPlateNumber];
        NSString *num2 = [num mb_desensitizedPlateNumber];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
    
    NSArray *arr2 = @[@"123456789", @"!@#$%^&*()_+", @"PL<MKQAZX1234"];
    for (NSString *num in arr2) {
        NSString *num1 = [num hcb_desensitizedVIN];
        NSString *num2 = [num mb_desensitizedVIN];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
    
    for (NSString *num in arr2) {
        NSString *num1 = [num hcb_desensitizedEngineID];
        NSString *num2 = [num mb_desensitizedEngineID];
        NSLog(@"IDCardNumber --- %@, %@", num1, num2);
        XCTAssertTrue([num1 isEqualToString:num2]);
    }
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
