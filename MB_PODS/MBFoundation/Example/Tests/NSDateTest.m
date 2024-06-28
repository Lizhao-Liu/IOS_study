//
//  NSDateTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface NSDateTest : XCTestCase

@end

@implementation NSDateTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testProperties {
    NSDate *date = [NSDate dateWithDaysFromNow:-7];
    XCTAssertTrue(date.ymm_year == date.mb_year);
    XCTAssertTrue(date.year == date.mb_year);
    XCTAssertTrue(date.month == date.mb_month);
    XCTAssertTrue(date.ymm_month == date.mb_month);
    XCTAssertTrue(date.ymm_day == date.mb_day);
    XCTAssertTrue(date.day == date.mb_day);
    XCTAssertTrue(date.hour == date.mb_hour);
    XCTAssertTrue(date.ymm_hour == date.mb_hour);
    XCTAssertTrue(date.ymm_minute == date.mb_minute);
    XCTAssertTrue(date.minute == date.mb_minute);
    XCTAssertTrue(date.second == date.mb_second);
    XCTAssertTrue(date.ymm_second == date.mb_second);
    XCTAssertTrue(date.weekday == date.mb_weekDay);
    XCTAssertTrue(date.ymm_weekday == date.mb_weekDay);
    
    NSInteger a = date.mb_weekOfYear;
    NSInteger b = date.weekOfYear;
    
    XCTAssertTrue(date.weekOfYear == date.mb_weekOfYear);
    XCTAssertTrue(date.dayOfYear == date.mb_dayOfYear);
    XCTAssertTrue(date.dayOfMonth == date.mb_dayOfMonth); // 原分类该属性为当月天数，而不是当月第几天
    XCTAssertTrue([date.ymm_weekday_cn isEqualToString:date.mb_weekday_cn]);
    XCTAssertTrue(date.ymm_yyyyMMdd == date.mb_yyyyMMdd);
}

- (void)testMethods {
    NSDate *date = [NSDate date];
    NSDate *localDate1 = [NSDate ymm_convertToLocalTimeZone:date];
    NSDate *localDate2 = [NSDate mb_convertToLocalTimeZone:date];
    XCTAssertNotNil(localDate2);
    
    NSDate *now1 = [NSDate ymm_getNow];
    NSDate *now2 = [NSDate mb_getNowLocalTimeZone];
    XCTAssertNotNil(now2);
    
    NSDate *date1 = [NSDate ymm_getDateWithString:@"2021-11-26" format:@"yyyy-MM-dd"];
    NSDate *date2 = [NSDate mb_formatWithDateString:@"2021-11-26" format:@"yyyy-MM-dd"];
    XCTAssertNotNil(date2);
    
    NSDate *date3 = [NSDate ymm_dateWithYear:2020 month:11 day:26];
    NSDate *date4 = [NSDate mb_dateWithYear:2022 month:11 day:26];
    XCTAssertNotNil(date4);
 
    NSDate *date5 = [NSDate ymm_dateWithTimestamp:@"1637922440486"]; // 不是单纯的转化时间戳，方法意义不明，无实际调用
    
    NSString *str1 = [date ymm_stringWithFormat:@"yyyy-MM-dd"];
    NSString *str2 = [date mb_stringFrom:@"yyyy-MM-dd"];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    NSDate *convert1 = [date ymm_convertToDayMode];
    NSDate *convert2 = [date mb_convertToDayMode];
    XCTAssertNotNil(convert2);
    
    NSDate *day1 = [date ymm_getDateAfterDays:5];
    NSDate *day2 = [date mb_addDays:5];
    XCTAssertNotNil(day2);
    
    NSInteger dif1 = [date3 ymm_getDayIntervalSinceDate:date];
    NSInteger dif2 = [date3 mb_getDayIntervalSinceDate:date];
    XCTAssertTrue(dif1 == dif2);
    
    BOOL b1 = [date ymm_isSameDayWithDate:[NSDate date]];
    BOOL b2 = [date mb_isSameDayWith:[NSDate date]];
    XCTAssertTrue(b1 == b2);
    
    b1 = [date ymm_isToday];
    b2 = [date mb_isToday];
    XCTAssertTrue(b1 == b2);
    
    b1 = [[NSDate date] isToday];
    b2 = [[NSDate date] mb_isToday];
    XCTAssertTrue(b1 == b2);
    
    NSDate *d = [NSDate ymm_getDateWithString:@"2021-12-20" format:@"yyyy-MM-dd"];
    b1 = [d isInPast];
    b2 = [d isEarlierThanDate:[NSDate date]];
    XCTAssertTrue(b1 == b2);
    
    b1 = [d isYesterday];
    b2 = [d mb_isYesterday];
    XCTAssertTrue(b1 == b2);
    
    NSDate *d2 = [NSDate ymm_getDateWithString:@"2021-12-22" format:@"yyyy-MM-dd"];
    b1 = [d2 isInFuture];
    b2 = [d2 mb_isLaterWithThan:[NSDate date]];
    XCTAssertTrue(b1 == b2);
    
    b1 = [d2 isTomorrow];
    b2 = [d2 mb_isTomorrow];
    XCTAssertTrue(b1 == b2);
    
    date1 = [[NSDate date] dateBySubtractingYears:100];
    date2 = [[NSDate date] mb_subtractYears:100];
    XCTAssertTrue(date1.mb_year == date2.mb_year);
    
    date1 = [[NSDate date] mb_floorIntegerDate];
    date2 = [[NSDate date] floorIntegerDate];
    XCTAssertTrue(date1.mb_year == date2.mb_year);
    
    date1 = [NSDate dateWithYear:2021 month:12 day:22 hour:@"8" minute:@"30"];
    date2 = [NSDate mb_dateWithYear:2021 month:12 day:22 hour:@"8" minute:@"30"];
    XCTAssertTrue(date1.mb_year == date2.mb_year);
    
    date1 = [date ymm_dateByAddingMonths:2];
    date2 = [date mb_addMonths:2];
    XCTAssertTrue(date2.mb_month == date1.mb_month);
    
    date1 = [date ymm_dateBySubtractingMonths:2];
    date2 = [date mb_subtractMonths:2];
    XCTAssertTrue(date2.mb_month == date1.mb_month);
    
    date1 = [date ymm_dateByAddingDays:5];
    date2 = [date mb_addDays:5];
    XCTAssertTrue(date2.mb_day == date1.mb_day);
    
    date1 = [date ymm_dateBySubtractingDays:5];
    date2 = [date mb_subtractDays:5];
    XCTAssertTrue(date2.mb_day == date1.mb_day);
    
    date1 = [date ymm_dateByAddingWeeks:2];
    date2 = [date mb_addWeeks:2];
    XCTAssertTrue(date1.mb_weekDay == date2.mb_weekDay);
    
    date1 = [date ymm_dateBySubtractingWeeks:2];
    date2 = [date mb_subtractWeeks:2];
    XCTAssertTrue(date1.mb_weekDay == date2.mb_weekDay);
    
    dif1 = [date3 ymm_yearsFrom:date];
    dif2 = [date3 mb_getYearsSinceDate:date];
    XCTAssertTrue(dif1 == dif2);
    
    dif1 = [date3 ymm_monthsFrom:date];
    dif2 = [date3 mb_getMonthsSinceDate:date];
    XCTAssertTrue(dif1 == dif2);
    
    dif1 = [date ymm_daysFrom:date3];
    dif2 = [date mb_getDaysSinceDate:date3];
    XCTAssertTrue(dif1 == dif2);
    
    dif1 = [date3 ymm_weeksFrom:date];
    dif2 = [date3 mb_getWeeksSinceDate:date];
    XCTAssertTrue(dif1 == dif2);
    
    b1 = [date ymm_isWithinDate:date3 toDate:date4];
    b2 = [date mb_isInStartDate:date3 endDate:date4];
    XCTAssertTrue(b1 == b2);
    
    date1 = [date midnightDate];
    date2 = [date mb_zeroTime];
    XCTAssertTrue(date1.hour == date2.hour);
    
    NSNumber *num1 = [NSDate ymm_Date];
    NSNumber *num2 = [NSDate mb_millSecondsNumberSince1970];
    XCTAssertTrue(num1.longLongValue/1000 == num2.longLongValue/1000);
    
    str1 = [date stringWithFormat:@"yyyy-MM-dd"];
    str2 = [date mb_stringWithFormat:@"yyyy-MM-dd"];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [date halfDayString];
    str2 = [date mb_halfDayFromatString];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    num1 = [date numberValue];
    num2 = [date mb_numberValue];
    XCTAssertTrue(num1.longLongValue == num2.longLongValue);
    
    str1 = [date timeStringFromDate];
    str2 = [date mb_historyStringWithType:MBFoundationHistoryDateFromatTypeA];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [date historyString];
    str2 = [date mb_historyStringWithType:MBFoundationHistoryDateFromatTypeB];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [date dateHistoryString];
    str2 = [date mb_historyStringWithType:MBFoundationHistoryDateFromatTypeC];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    XCTAssertTrue([date isMorning] == [date mb_isAM]);
    
    str1 = [NSDate formatDateTime:date setDateFORMAT:@"yyyy-MM-dd"];
    str2 = [NSDate mb_formatWithDate:date format:@"yyyy-MM-dd"];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [NSDate formatTimeInterval:1637922440486 setDateFORMAT:@"yyyy-MM-dd"];
    str2 = [NSDate mb_formatWithTimeIntervalWithSicence1970:1637922440486 format:@"yyyy-MM-dd"];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    date1 = [NSDate parseDateTime:str1 setDateFORMAT:@"yyyy-MM-dd"];
    date2 = [NSDate mb_parseDateTime:str1 format:@"yyyy-MM-dd"];
    XCTAssertTrue(date1.day == date2.day);
    
    dif1 = [NSDate DateDiff:date3 endDate:date dateDiffType:NSCalendarUnitDay];
    dif2 = [NSDate mb_getDayDiffWithStartDate:date3 endDate:date];
    XCTAssertTrue(dif1 == dif2);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
