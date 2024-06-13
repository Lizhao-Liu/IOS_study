//
//  FlutterLogReporter.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "FlutterLogReporter.h"
@import MBDoctorService;
@import MBFoundation;

@interface FlutterLogReporter ()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation FlutterLogReporter

/**
  arguments[0]: pageName
  arguments[1]: className? 没有用到
  arguments[2]: referPageName
  arguments[3]: extra
 */
- (void)pageVisible:(NSArray *)arguments {
    if (!arguments || arguments.count < 3) {
        !self.result ?: self.result(@"入参错误，请传入PV参数");
        return;
    }
    
    NSString *pageName = arguments[0];
    NSString *referPageName = arguments[2];
    double enterTime = [[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *extra = @{@"enterTime":@(enterTime)}.mutableCopy;
    if(arguments.count == 4){
        if([arguments[3] isKindOfClass:[NSDictionary class]]){
            [extra addEntriesFromDictionary:arguments[3]];
        }
    }
    
    NSString *elementId = @"pageview";
    [MBDoctorUtil viewWithPage:pageName referPage:referPageName elementId:elementId extra:extra context:nil];
    !self.result ?: self.result(@"OK");
}

- (void)pageInvisible:(NSArray *)arguments {
    if (!arguments || arguments.count == 0) {
        !self.result ?: self.result(@"入参错误，请传入PV参数");
        return;
    }
    
    NSString *pageName = arguments.firstObject;
    [MBDoctorUtil viewWithPageName:pageName elementId:@"pageview_stay_duration" extra:nil];
    !self.result ?: self.result(@"OK");
}

/**
  arguments[0]: pageName
  arguments[1]: elementId
  arguments[2]: region
  arguments[3]: referPageName
  arguments[4]: extra
 */
- (void)trackView:(NSArray *)arguments {
    if (!arguments || arguments.count < 5) {
        !self.result ?: self.result(@"入参错误");
        return;
    }
    
    NSString *pageName = arguments[0];
    NSString *elementId = arguments[1];
    NSString *region = arguments[2];
    NSString *referPageName = arguments[3];
    
    if (![elementId isKindOfClass:[NSString class]] || ![region isKindOfClass:[NSString class]] || ![pageName isKindOfClass:[NSString class]] || ![referPageName isKindOfClass:[NSString class]] ) {
        !self.result ?: self.result(@"入参错误，请传入字符串类型的elementId region pageName referPageName参数");
        return;
    }
    
    NSDictionary *extra = arguments[4];
    if (![extra isKindOfClass:[NSDictionary class]]) {
        !self.result ?: self.result(@"入参错误，请传入字典类型的extra参数");
        return;
    }
    
    [MBDoctorUtil viewWithPage:pageName referPage:referPageName region:region elementId:elementId referSPM:nil extra:extra context:nil];
}

/**
  arguments[0]: pageName
  arguments[1]: elementId
  arguments[2]: region
  arguments[3]: extra
 */
- (void)trackTap:(NSArray *)arguments{
    if (!arguments || arguments.count < 4) {
        !self.result ?: self.result(@"入参错误，请传入点击埋点参数");
        return;
    }
    NSString *pageName = [arguments mb_stringAt:0];
    NSString *elementId = [arguments mb_stringAt:1];
    NSString *region = [arguments mb_stringAt:2];
    NSDictionary *extra = [arguments mb_dictionaryAt:3];
    if (![pageName isKindOfClass:[NSString class]] || ![elementId isKindOfClass:[NSString class]] || ![region isKindOfClass:[NSString class]] || ![extra isKindOfClass:[NSDictionary class]] ) {
        !self.result ?: self.result(@"入参错误，入参类型错误");
        return;
    }
    [MBDoctorUtil tapWithPage:pageName referPage:nil region:region elementId:elementId extra:extra context:nil];
}

- (void)track2BI:(NSArray *)arguments {
    if (!arguments || arguments.count ==0) {
        !self.result ?: self.result(@"入参错误，请传入上报参数");
    } else {
        id eventID =  arguments.count > 0 ? arguments[0] : nil;
        if (!eventID || ![eventID isKindOfClass:[NSString class]]) {
            !self.result ?: self.result(@"入参类型错误，请传入String类型的eventId");
        }
        !self.result ?: self.result(@"OK");
    }
}

- (void)track2TalkingData:(NSArray *)arguments {
    !self.result ?: self.result(@"OK");
}

@end
