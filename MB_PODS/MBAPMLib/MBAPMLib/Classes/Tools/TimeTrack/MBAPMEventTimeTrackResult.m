//
//  MBAPMEventTimeTrackResult.m
//  AAChartKit
//
//  Created by xp on 2021/6/15.
//

#import "MBAPMEventTimeTrackResult.h"
#import "MBAPMLogDef.h"

@implementation UIViewController (MBAPMEventTimeTrackContainerProtocol)

@end

@implementation MBAPMEventTimePoint

@end

@implementation MBAPMBaseEventTimeSection


@end

@implementation MBAPMEventNonePointTimeSection


@end

@interface MBAPMEventTimeSection()

- (BOOL)validSectionData;

@end

@implementation MBAPMEventTimeSection

- (UInt64)elapsedTime {
    if (self.beginPoint && self.endPoint
        && self.endPoint.timestamp > self.beginPoint.timestamp) {
        return self.endPoint.timestamp - self.beginPoint.timestamp;
    }
    return 0;
}

- (BOOL)validSectionData {
    if (!self.beginPoint || !self.endPoint) {
        return NO;
    }
    if (self.elapsedTime < 0) {
        return NO;
    }
    return YES;
}

@end

@interface MBAPMEventTimeTrackResult () {
    NSString *_trackID;
}

@property (nonatomic, strong, nonnull) MBAPMEventTimePoint *lastSectionPoint;

@property (nonatomic, assign) BOOL hasSectionPoint;


@end

@implementation MBAPMEventTimeTrackResult
@synthesize trackID = _trackID;

- (instancetype)init {
    if (self = [super init]) {
        _hasSectionPoint = NO;
        _sectionDict = [NSMutableDictionary<NSString *, MBAPMBaseEventTimeSection *> new];
        _trackID = [self generateUUID];
        _readWriteCocurentQueue = dispatch_queue_create("com.mb.apm.track_result", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (BOOL)validData {
    __block BOOL isValid = YES;
    dispatch_barrier_sync(_readWriteCocurentQueue, ^{
        if (!self.wholeSection || ![self.wholeSection validSectionData]) {
            isValid = NO;
        } else {
            if (self.sectionDict) {
                [[self.sectionDict copy] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, MBAPMBaseEventTimeSection * _Nonnull section, BOOL * _Nonnull stop) {
                    if ([section isKindOfClass:[MBAPMEventTimeSection class]]) {
                        if (![(MBAPMEventTimeSection *)section validSectionData]) {
                            [self.sectionDict removeObjectForKey:key];
                        }
                    }
                }];
            }
        }
        isValid = YES;
    });
    return isValid;
}

- (NSDictionary<NSString *,NSNumber *> *)getSectionsDict {
    __block NSDictionary<NSString *,NSNumber *> *returnSectionsDict = nil;
    dispatch_sync(_readWriteCocurentQueue, ^ {
        returnSectionsDict = [self private_getSectionsDict];
    });
    return returnSectionsDict;
}

- (UInt64)getPreSectionElapsedTime {
    return 0;
}

- (NSDictionary *)getSectionsExt:(NSUInteger)preSectionElapsedTime {
    __block NSDictionary<NSString *,NSNumber *> *returnSectionsExt = nil;
    NSDictionary *(^getSectionExtBlock)(void) = ^ {
        NSDictionary *sectionDict = [self.sectionDict copy];
        NSMutableDictionary *sectionExtDict = [NSMutableDictionary new];
        if (sectionDict && sectionDict.count > 0) {
            
            NSInteger prefix = preSectionElapsedTime;
            
            for (MBAPMBaseEventTimeSection * _Nonnull section in sectionDict.allValues) {
                // 尝试fix崩溃
                // YMMDriver __43-[MBAPMEventTimeTrackResult getSectionsExt]_block_invoke (MBAPMEventTimeTrackResult.m:)
                if (![section isKindOfClass:[MBAPMBaseEventTimeSection class]]) {
                    break;
                }
                
                if (section && [section respondsToSelector:@selector(sectionTag)] && section.sectionTag && section.sectionTag.length > 0) {
                    NSMutableDictionary *extDict = [NSMutableDictionary new];
                    if ([section isKindOfClass:[MBAPMEventTimeSection class]]) {
                        MBAPMEventTimeSection *pointSection = (MBAPMEventTimeSection *)section;
                        if (pointSection.beginPoint.extraData) {
                            [extDict addEntriesFromDictionary:pointSection.beginPoint.extraData.mutableCopy];
                        }
                        if (pointSection.endPoint.extraData) {
                            [extDict addEntriesFromDictionary:pointSection.endPoint.extraData.mutableCopy];
                        }
                        long long sectionRelativeTime = pointSection.beginPoint.timestamp - self.wholeSection.beginPoint.timestamp;
                        [extDict setObject:@(sectionRelativeTime + prefix) forKey:@"s_st"];
                        [extDict setObject:@(section.type) forKey:@"s_type"];
                    } else if ([section isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                        MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)section;
                        if (nonePointSection.extraData) {
                            [extDict addEntriesFromDictionary:nonePointSection.extraData.mutableCopy];
                        }
                        if (nonePointSection.beginTimestamp != 0) {
                            long long sectionRelativeTime = nonePointSection.beginTimestamp - self.wholeSection.beginPoint.timestamp;
                            [extDict setObject:@(sectionRelativeTime + prefix) forKey:@"s_st"];
                        }
                        [extDict setObject:@(section.type) forKey:@"s_type"];
                    }
                    [sectionExtDict setObject:extDict.copy forKey:section.sectionTag];
                }
            }
        }
        return sectionExtDict.copy;
    };
    
    dispatch_sync(_readWriteCocurentQueue, ^ {
        returnSectionsExt = getSectionExtBlock();
    });
    return returnSectionsExt;
}

- (NSDictionary *)getSectionsExt {
    return [self getSectionsExt:0];
}

- (NSDictionary *)getWholeExt {
    __block NSDictionary *returnWholeExt = nil;
    NSDictionary *(^getWholeExtBlock)(void) = ^ {
        NSMutableDictionary * ext = [NSMutableDictionary new];
        if (self.wholeSection.beginPoint) {
            if (self.wholeSection.beginPoint.extraData) {
                [ext addEntriesFromDictionary:self.wholeSection.beginPoint.extraData.mutableCopy];
            }
            [ext setObject:@(self.wholeSection.beginPoint.timestamp) forKey:@"metric_startTime"];
        }
        if (self.wholeSection.endPoint.extraData) {
            [ext addEntriesFromDictionary:self.wholeSection.endPoint.extraData.mutableCopy];
        }
        return ext.copy;
    };
    dispatch_sync(_readWriteCocurentQueue, ^ {
        returnWholeExt = getWholeExtBlock();
    });
    return returnWholeExt;
}

- (void)updateAssociatedData:(NSDictionary *)associatedData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        self->_associatedData = associatedData;
    });
}

- (UInt64)getBeginTimestamp {
    __block UInt64 beginTimestamp = 0;
    dispatch_sync(_readWriteCocurentQueue, ^{
        beginTimestamp = self.wholeSection.beginPoint.timestamp;
    });
    return beginTimestamp;
}

- (UInt64)getEndTimestamp {
    __block UInt64 endTimestamp = 0;
    dispatch_sync(_readWriteCocurentQueue, ^{
        endTimestamp = self.wholeSection.endPoint.timestamp;
    });
    return endTimestamp;
}

- (void)begin:(NSDictionary * _Nullable)extData beginAt:(UInt64)beginTimestamp {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        MBAPMEventTimePoint *beginPoint = [MBAPMEventTimePoint new];
        beginPoint.timestamp = beginTimestamp;
        beginPoint.extraData = extData;
        self.lastSectionPoint = beginPoint;
        MBAPMEventTimeSection *wholeSection = [MBAPMEventTimeSection new];
        wholeSection.beginPoint = beginPoint;
        self->_wholeSection = wholeSection;
        MBAPMDebug(@"eventTimeTrack %p begin %llu", self, beginTimestamp);
    });
}

- (void)end:(NSString * _Nonnull)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        MBAPMEventTimePoint *endPoint = [MBAPMEventTimePoint new];
        endPoint.timestamp = endTimeStamp;
        endPoint.extraData = extData;
        self.wholeSection.endPoint = endPoint;
        if (self.hasSectionPoint && self.lastSectionPoint) {
            MBAPMEventTimeSection *lastSection = [MBAPMEventTimeSection new];
            lastSection.beginPoint = endPoint > self.lastSectionPoint ? self.lastSectionPoint : endPoint;
            lastSection.endPoint = endPoint;
            lastSection.sectionTag = lastSectionTag;
            lastSection.type = MBAPMEventTimeSectionType_SERIAL;
            [self.sectionDict setObject: lastSection forKey: lastSectionTag];
        }
        MBAPMDebug(@"eventTimeTrack end trackResult = %@, endTimeStamp = %llu, sections = %@", self, endTimeStamp, [self private_getSectionsDict]);
    });
}

- (void)beginIsolatedSection:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        MBAPMEventTimePoint *sectionBeginPoint = [MBAPMEventTimePoint new];
        sectionBeginPoint.timestamp = beginTimestamp;
        sectionBeginPoint.extraData = extData;
        MBAPMEventTimeSection *section = [MBAPMEventTimeSection new];
        section.beginPoint = sectionBeginPoint;
        section.sectionTag = sectionTag;
        section.type = MBAPMEventTimeSectionType_COCURRENT;
        [self.sectionDict setObject: section forKey:sectionTag];
        MBAPMDebug(@"eventTimeTrack %p beginIsolatedSection section = %@ %llu", self, sectionTag, beginTimestamp);
    });
}

- (void)endIsolatedSection:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        MBAPMEventTimePoint *sectionEndPoint = [MBAPMEventTimePoint new];
        sectionEndPoint.timestamp = endTimestamp;
        sectionEndPoint.extraData = extData;
        MBAPMBaseEventTimeSection *section = [self.sectionDict objectForKey:sectionTag];
        if ([section isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *pointSection = (MBAPMEventTimeSection *)section;
            if (pointSection && pointSection.beginPoint) {
                pointSection.endPoint = sectionEndPoint;
            } else {
                [self.sectionDict removeObjectForKey:sectionTag];
            }
        } else {
        }
        MBAPMDebug(@"eventTimeTrack %p endIsolatedSection section = %@ %llu", self, sectionTag, endTimestamp);
    });
}


- (void)section:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        if ([self.sectionDict.allKeys containsObject:sectionTag]) {
            return;
        }
        MBAPMEventTimePoint *sectionEndPoint = [MBAPMEventTimePoint new];
        sectionEndPoint.timestamp = endTimestamp;
        sectionEndPoint.extraData = extData;
        if (!self.lastSectionPoint) {
            return;
        }
        self.hasSectionPoint = YES;
        MBAPMEventTimeSection *section = [MBAPMEventTimeSection new];
        section.beginPoint = self.lastSectionPoint;
        section.endPoint = sectionEndPoint;
        section.sectionTag = sectionTag;
        section.type = MBAPMEventTimeSectionType_SERIAL;
        [self.sectionDict setObject: section forKey:sectionTag];
        self.lastSectionPoint = sectionEndPoint;
        MBAPMDebug(@"eventTimeTrack %p section = %@ beginAt = %llu, endAt = %llu", self, sectionTag, section.beginPoint.timestamp, endTimestamp);
    });
}

- (void)sectionBeginFromLastPoint:(NSString *)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary *)extData {
    [self section:sectionTag beginAt:self.lastSectionPoint.timestamp endAt:endTimestamp sectionType:MBAPMEventTimeSectionType_SERIAL withExtra:extData];
}

- (void)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        if ([self.sectionDict.allKeys containsObject:sectionTag]) {
            return;
        }
        MBAPMEventNonePointTimeSection *nonePointSection;
        if ([self.sectionDict objectForKey:sectionTag]) {
            if ([[self.sectionDict objectForKey:sectionTag] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                nonePointSection = (MBAPMEventNonePointTimeSection *)[self.sectionDict objectForKey:sectionTag];
            }
        }
        if (!nonePointSection) {
            nonePointSection = [MBAPMEventNonePointTimeSection new];
        }
        if (beginTimestamp > 0) {
            nonePointSection.beginTimestamp = beginTimestamp;
        }
        if (endTimeStamp > 0) {
            nonePointSection.endTimestamp = endTimeStamp;
            
            if (type ==MBAPMEventTimeSectionType_SERIAL && self.lastSectionPoint.timestamp < endTimeStamp) {
                MBAPMEventTimePoint *sectionEndPoint = [MBAPMEventTimePoint new];
                sectionEndPoint.timestamp = endTimeStamp;
                self.lastSectionPoint = sectionEndPoint;
            }
        }
        if (nonePointSection.beginTimestamp > 0
            && nonePointSection.endTimestamp > 0
            && nonePointSection.endTimestamp > nonePointSection.beginTimestamp) {
            nonePointSection.elapsedTime = nonePointSection.endTimestamp - nonePointSection.beginTimestamp;
        } else {
            nonePointSection.elapsedTime = 0;
        }
        nonePointSection.sectionTag = sectionTag;
        nonePointSection.type = type;
        nonePointSection.extraData = extData;
        [self.sectionDict setObject: nonePointSection forKey:sectionTag];
        MBAPMDebug(@"eventTimeTrack %p section = %@ beginAt = %llu, endAt = %llu", self, sectionTag, beginTimestamp, endTimeStamp);
    });
    
}

- (void)section:(NSString *)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary *)extData {
    dispatch_barrier_async(_readWriteCocurentQueue, ^{
        MBAPMEventNonePointTimeSection *nonePointSection = [MBAPMEventNonePointTimeSection new];
        nonePointSection.elapsedTime =  elapsedTime;
        nonePointSection.sectionTag = sectionTag;
        nonePointSection.extraData = extData;
        nonePointSection.type = MBAPMEventTimeSectionType_SERIAL;
        [self.sectionDict setObject: nonePointSection forKey:sectionTag];
        MBAPMDebug(@"eventTimeTrack %p section = %@ costTime = %llu", self, sectionTag, elapsedTime);
    });
}

- (UInt64)getTotalElapsedTime {
    return MIN(self.wholeSection.endPoint.timestamp - self.wholeSection.beginPoint.timestamp, 99999);
}


#pragma mark - private methods

- (NSDictionary<NSString *,NSNumber *> *)private_getSectionsDict {
    NSDictionary *sectionDict = [self.sectionDict copy];
    NSMutableDictionary*sectionElapsedTimeDict = [NSMutableDictionary new];
    if (sectionDict && sectionDict.count > 0) {
        for (MBAPMBaseEventTimeSection * _Nonnull section in sectionDict.allValues) {
            if (section && [section respondsToSelector:@selector(sectionTag)] && section.sectionTag && section.sectionTag.length > 0
                && [section respondsToSelector:@selector(elapsedTime)] && section.elapsedTime >= 0) {
                sectionElapsedTimeDict[section.sectionTag] = @(section.elapsedTime ?: 0);
            }
        }
    }
    return sectionElapsedTimeDict.copy;
}

- (NSString *)generateUUID {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuidString);
    CFRelease(puuid);
    return result;
}

@end
