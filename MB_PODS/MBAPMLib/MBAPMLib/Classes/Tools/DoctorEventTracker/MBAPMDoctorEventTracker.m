//
//  MBAPMDoctorEventTracker.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/2/20.
//

#import "MBAPMDoctorEventTracker.h"
#import "MBAPMDataCacheQueue.h"
#import "MBAPMDoctorEventCacheQueue.h"
@import MBDoctorService;
@import MBFoundation;


@interface MBAPMDoctorEventTracker ()

@property (nonatomic, strong) MBAPMDoctorEventCacheQueue *recentEvents;

@property (nonatomic, strong) dispatch_queue_t trackQueue;

@end

@implementation MBAPMDoctorEventTracker

+ (instancetype)sharedInstance {
    static MBAPMDoctorEventTracker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMDoctorEventTracker alloc] init];
    });
    return instance;
}

- (void)trackEvent:(__kindof id<MBDoctorEventProtocol>)event context:(id<MBContextProtocol>)context {
    if ([event isKindOfClass:MBDoctorEventPV.class]) {
        [self trackPVEvent:(MBDoctorEventPV *)event context:context];
    } else if ([event isKindOfClass:MBDoctorEventTouch.class]) {
        [self trackClickEvent:(MBDoctorEventTouch *)event context:context];
    } else if ([event isKindOfClass:MBDoctorEventCustom.class]) {
        [self trackCustomEvent:(MBDoctorEventCustom *)event context:context];
    }
}

- (void)trackPVEvent:(MBDoctorEventPV *)event context:(id<MBContextProtocol>)context {
//    NSLog(@"wakeups debug 采集到一条PV数据 %@", ((MBDoctorEventPV*)event).pageName);
    NSTimeInterval default_timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    MBAPMDoctorEventModel *model = [MBAPMDoctorEventModel new];
    if([event.pageName isEqualToString:@"enter_foreground"]){
        model.eventType = MBAPMDoctorEventTypeEnterForeground;
    } else {
        model.eventType = MBAPMDoctorEventTypePageView;
    }
    model.eventFeature = event.pageName;
    model.timestamp = event.timestamp ?: default_timestamp;
    [self.recentEvents enqueue:model];
}


- (void)trackClickEvent:(MBDoctorEventTouch *)event context:(id<MBContextProtocol>)context {
//    NSLog(@"wakeups debug 采集到一条Click数据 %@", (MBDoctorEventTouch *)event.elementName);
    NSTimeInterval default_timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    MBAPMDoctorEventModel *model = [MBAPMDoctorEventModel new];
    model.eventType = MBAPMDoctorEventTypeClick;
    NSString *pageName = event.pageName ?: @"unknown";
    NSString *elementName = event.elementName ?: @"unknown";
    model.eventFeature = [NSString stringWithFormat:@"%@.%@", pageName, elementName];
    model.timestamp = event.timestamp ?: default_timestamp;
    [self.recentEvents enqueue:model];
}

- (void)trackCustomEvent:(MBDoctorEventCustom *)event context:(id<MBContextProtocol>)context {
    if([event.metricName isEqualToString:@"messagecenter_online_event"]){ // push or 长链接
//        NSLog(@"wakeups debug 采集到一条长链接数据");
        NSTimeInterval default_timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        MBAPMDoctorEventModel *model = [MBAPMDoctorEventModel new];
        model.eventType = MBAPMDoctorEventTypeMessage;
        NSString *channelType = [event.tags mb_stringForKey:@"channel_type"] ?: @"unknown"; //0表示长链消息，1表示push
        NSString *messageType = [event.tags mb_stringForKey:@"messageType"] ?: @"unknown"; //长链业务类型
        model.eventFeature = [NSString stringWithFormat:@"%@.%@", channelType, messageType];
        model.timestamp = event.timestamp ?: default_timestamp;
        [self.recentEvents enqueue:model];
    }
}

- (MBAPMDoctorEventModel *)getActionEvent {
    NSArray<MBAPMDoctorEventModel *> *recentEvents = [self.recentEvents getAllEvents];
    if(![self haveRecentActionEvent]){
        return [self unknownAction];
    }
    
    // 存在优先级：进入前台 > pv = click > 其他（长链接/push）
    for(MBAPMDoctorEventModel *event in [recentEvents reverseObjectEnumerator]){
        if(event.eventType == MBAPMDoctorEventTypeEnterForeground){
            return event;
        }
    }
    
    for(MBAPMDoctorEventModel *event in [recentEvents reverseObjectEnumerator]){
        if(event.eventType == MBAPMDoctorEventTypePageView || event.eventType == MBAPMDoctorEventTypeClick ){
            return event;
        }
    }
    
    return recentEvents.lastObject;
}

- (MBAPMDoctorEventModel *)unknownAction {
    MBAPMDoctorEventModel *model = [MBAPMDoctorEventModel new];
    model.eventType = MBAPMDoctorEventTypeUnknown;
    model.eventFeature = @"unknown";
    return model;
}


- (BOOL)haveRecentActionEvent {
    if([self.recentEvents isEmpty]){
        return NO;
    }
    long long now = [[NSDate new] timeIntervalSince1970] * 1000;
    MBAPMDoctorEventModel *event = [self.recentEvents getLatestEvent];
    long long lastEventTimestamp = event.timestamp;
    return ((now - lastEventTimestamp) < 5 * 1000); // 5s
}


- (MBAPMDoctorEventCacheQueue *)recentEvents {
    if(!_recentEvents){
        _recentEvents = [MBAPMDoctorEventCacheQueue loopQueueWithCapacity:5];
    }
    return _recentEvents;
}

@end
