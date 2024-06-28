//
//  ToolsTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/17.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface ToolsTest : XCTestCase

@end

@implementation ToolsTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDateFormatter {
    //yyyy-MM-dd HH:mm:ss
    NSDateFormatter *dateFormatter1 = [MBDateFormatterManager dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date1 = [dateFormatter1 stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter2 = [HCBDateFormatterManager dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date2 = [dateFormatter2 stringFromDate:[NSDate date]];
    XCTAssertTrue([date1 isEqualToString:date2]);
    
    NSDateFormatter *dateFormatter3 = [MBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date3 = [dateFormatter3 stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter4 = [HCBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date4 = [dateFormatter4 stringFromDate:[NSDate date]];
    XCTAssertTrue([date3 isEqualToString:date4]);
    
    [MBDateFormatterManager removeFormatterWithFormat:@"yyyy-MM-dd"];
    [HCBDateFormatterManager removeFormatterWithFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter5 = [MBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *dateFormatter6 = [HCBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    XCTAssertNotNil(dateFormatter5);
    XCTAssertNotNil(dateFormatter6);
    
    [MBDateFormatterManager removeAllFormatters];
    [HCBDateFormatterManager removeAllFormatters];
    NSDateFormatter *dateFormatter7 = [MBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter8 = [HCBDateFormatterManager temporaryDateFormatterWithFormat:@"yyyy-MM-dd"];
    XCTAssertNotNil(dateFormatter7);
    XCTAssertNotNil(dateFormatter8);
}

- (void)testNetworkInfoProvider {
    
//    NSString *carrierName1 = [MBNetworkInfoProvider sharedNetworkInfoProvider].carrierName;
//    NSString *carrierName2 = [NetworkInfoProvider sharedNetworkInfoProvider].carrierName;
//    NSLog(@"carrierName ---- %@, %@", carrierName1, carrierName2);
//
//    NSString *carrierType1 = [MBNetworkInfoProvider sharedNetworkInfoProvider].carrierType;
//    NSString *carrierType2 = [NetworkInfoProvider sharedNetworkInfoProvider].carrierType;
//    NSLog(@"carrierType ---- %@, %@", carrierType1, carrierType2);
//
//    NSString *networkType1 = [MBNetworkInfoProvider sharedNetworkInfoProvider].networkType;
//    NSString *networkType2 = [NetworkInfoProvider sharedNetworkInfoProvider].networkType;
//    NSLog(@"networkType ---- %@, %@", networkType1, networkType2);
//
//    XCTAssertTrue([carrierName1 isEqualToString:carrierName2]);
//    // MBToolKit原来的方法有问题，mnc为nil时，取整会返回0，从而返回"China_Mobile"
//    //XCTAssertTrue([carrierType1 isEqualToString:carrierType2]);
//    XCTAssertTrue([networkType1 isEqualToString:networkType2]);
    NSString *str1 = [UIDevice hcb_carrierName];
    NSString *str2 = [MBNetworkInfoProvider sharedNetworkInfoProvider].carrierType;
//    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [UIDevice hcb_networkTypeName];
    str2 = [MBNetworkInfoProvider sharedNetworkInfoProvider].hcbNetworkTypeName;
    XCTAssertTrue([str1 isEqualToString:str2]);


}

- (void)testPluginInfo {
    NSString * number = [[[[MBPluginInfos infos] allValues] firstObject] versionNumber];
    XCTAssertTrue([number containsString:@"."]);
    XCTAssertTrue(![number containsString:@"dev"]);
    XCTAssertTrue(![number containsString:@"beta"]);
    XCTAssertTrue(![number containsString:@"alpha"]);
    
    NSLog(@"HCBPluginInfo----- %@", [HCBPluginInfo infos]);
    NSLog(@"MBPluginInfos----- %@", [MBPluginInfos infos]);
    XCTAssertEqual([HCBPluginInfo infos].count, [MBPluginInfos infos].count);
    
    NSLog(@"MBPluginInfos manfiestContent---- %@", [MBPluginInfos manfiestContent]);
    NSLog(@"MBPluginInfo manfiestContent---- %@", [MBPluginInfo manfiestContent]);
    XCTAssertNotNil([MBPluginInfos manfiestContent]);
    XCTAssertNotNil([MBPluginInfo manfiestContent]);
    
    NSLog(@"MBPluginInfos podfileContent---- %@", [MBPluginInfos podfileContent]);
    NSLog(@"MBPluginInfo podfileContent---- %@", [MBPluginInfo podfileContent]);
    XCTAssertNotNil([MBPluginInfos podfileContent]);
    XCTAssertNotNil([MBPluginInfo podfileContent]);
}

- (void)testToolKitManager {
    [MBToolKitManager setupWithCompany:YES];
    [MBToolsManager setupWithCompany:YES];
    XCTAssertEqual([MBToolsManager isHCB], [MBToolKitManager isHCB]);
    
    [MBToolKitManager setupWithCompany:YES];
    [MBToolsManager setupWithCompany:NO];
    XCTAssertNotEqual([MBToolsManager isHCB], [MBToolKitManager isHCB]);
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
