//
//  MBAPMEventPageviewTrackResult.m
//  MBAPMServiceLib
//
//  Created by xp on 2024/1/24.
//

#import "MBAPMEventPageviewTrackResult.h"
#import "MBAPMEventTimeTrackResult.h"

@interface MBAPMEventPageviewTrackResult() {
    MBAPMEventTimeTrackResult *_trackResult;
}

@property (nonatomic, assign) NSInteger appLauchTotoal;
@property (nonatomic, assign) NSInteger appLauchApp;
@property (nonatomic, assign) NSInteger pageTotal;

@end

@implementation MBAPMEventPageviewTrackResult
@dynamic trackID;

- (instancetype)init {
    if (self = [super init]) {
        _trackResult = [MBAPMEventTimeTrackResult new];
    }
    return self;
}

- (NSString *)trackID {
    return _trackResult.trackID;
}


- (void)begin:(NSDictionary * _Nullable)extData beginAt:(UInt64)beginTimestamp {
    [_trackResult begin:extData beginAt:beginTimestamp];
}

- (void)beginIsolatedSection:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult beginIsolatedSection:sectionTag beginAt:beginTimestamp sectionType:type withExtra:extData];
}

- (void)end:(NSString * _Nonnull)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult end:lastSectionTag endAt:endTimeStamp withExtra:extData];
}

- (void)endIsolatedSection:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult endIsolatedSection:sectionTag endAt:endTimestamp withExtra:extData];
}

- (UInt64)getBeginTimestamp {
    return [_trackResult getBeginTimestamp];
}

- (UInt64)getEndTimestamp {
    return [_trackResult getEndTimestamp];
}

- (NSDictionary<NSString *,NSNumber *> * _Nullable)getSectionsDict {
    __block NSDictionary<NSString *,NSNumber *> *returnSectionsDict = nil;
    dispatch_sync(_trackResult.readWriteCocurentQueue, ^ {
        returnSectionsDict = [self private_getSectionsDict];
    });
    return returnSectionsDict;
}

- (UInt64)getPreSectionElapsedTime {
    NSUInteger appLauchTime = [self appLauchApp];
    return appLauchTime > 0?appLauchTime:0;
}

- (NSDictionary * _Nullable)getSectionsExt {
    NSUInteger preSectionElapsedTime = [self getPreSectionElapsedTime];
    NSDictionary *sectionExt = [_trackResult getSectionsExt:preSectionElapsedTime];
    NSMutableDictionary *returnSectionExt = [NSMutableDictionary new];
    dispatch_sync(_trackResult.readWriteCocurentQueue, ^{
        NSMutableDictionary *extDict = [NSMutableDictionary new];
        [extDict setObject:@(preSectionElapsedTime) forKey:@"s_st"];
        [extDict setObject:@(0) forKey:@"s_type"];
        [returnSectionExt setObject:extDict.copy forKey:@"page_launch_app"];
        [returnSectionExt addEntriesFromDictionary:sectionExt];
    });
    return returnSectionExt.copy;
}

- (NSDictionary * _Nullable)getWholeExt {
    return [_trackResult getWholeExt];
}

- (void)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult section:sectionTag beginAt:beginTimestamp endAt:endTimeStamp sectionType:type withExtra:extData];
}

- (void)section:(NSString *)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary *)extData {
    [_trackResult section:sectionTag cost:elapsedTime withExtra:extData];
}

- (void)section:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult section:sectionTag endAt:endTimestamp withExtra:extData];
}

- (void)sectionBeginFromLastPoint:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData {
    [_trackResult sectionBeginFromLastPoint:sectionTag endAt:endTimestamp withExtra:extData];
}

- (void)updateAssociatedData:(NSDictionary *)associatedData {
    [_trackResult updateAssociatedData:associatedData];
}

- (BOOL)validData {
    return [_trackResult validData];
}

#pragma mark - pageview methods
- (NSInteger)appLauchTotoal {
    if (_appLauchTotoal == 0) {
        _appLauchTotoal = [(NSNumber *)_trackResult.associatedData[@"launch_elapsedTime"] unsignedLongLongValue];
    }
    if (_appLauchTotoal > [self launchAppLimit]) {
        return [self launchAppLimit];
    }
    return _appLauchTotoal;
}

- (NSInteger)launchAppLimit {
    return 15000;
}

- (NSInteger)appLauchApp {
    if (_appLauchApp == 0) {
        NSInteger total = [self appLauchTotoal];
        if (total == 0) {
            return 0;
        }
        UInt64 loadTime = _trackResult.wholeSection.beginPoint.timestamp;;
        if ([_trackResult.sectionDict[@"page_native_load"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_native_load"];
            if (section.beginPoint.timestamp > 0) {
                loadTime = section.beginPoint.timestamp;
            }
            
        } else if ([_trackResult.sectionDict[@"page_native_load"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_native_load"];
            if (nonePointSection.beginTimestamp > 0) {
                loadTime = nonePointSection.beginTimestamp;
            }
        } else if ([_trackResult.sectionDict[@"page_view_prepare"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_view_prepare"];
            if (section.beginPoint.timestamp > 0) {
                loadTime = section.beginPoint.timestamp;
            }
        }
        NSInteger appearTime = [(NSNumber *)_trackResult.associatedData[@"launch_endTimestamp"] unsignedLongLongValue];
        NSInteger value = total - (appearTime - loadTime);
        _appLauchApp = MIN(MAX(value, 0), 25000);
    }
    return _appLauchApp;
}

- (UInt64)getTotalElapsedTime {
    return MAX(0, [self pageTotal]);
}

- (NSInteger)pageTotal {
    if (_pageTotal == 0) {
        // 如果存在page_appear分段，matrix value修改
        NSInteger beginTimestamp = _trackResult.wholeSection.beginPoint.timestamp;
        NSInteger endTimestamp = _trackResult.wholeSection.endPoint.timestamp;;
        if ([_trackResult.sectionDict.allKeys containsObject:@"page_appear"]) {
            if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventTimeSection class]]) {
                MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_appear"];
                if (section.beginPoint.timestamp > 0) {
                    beginTimestamp = section.beginPoint.timestamp;
                }
            } else if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_appear"];
                if (nonePointSection.beginTimestamp > 0) {
                    beginTimestamp = nonePointSection.beginTimestamp;
                }
            }
        }
        
        if ([_trackResult.sectionDict.allKeys containsObject:@"page_interactive_prepare"]) {
            if ([_trackResult.sectionDict[@"page_interactive_prepare"] isKindOfClass:[MBAPMEventTimeSection class]]) {
                MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_interactive_prepare"];
                if (section.endPoint.timestamp > 0) {
                    endTimestamp = section.endPoint.timestamp;
                }
            }
            else if ([_trackResult.sectionDict[@"page_interactive_prepare"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_interactive_prepare"];
                if (section.endTimestamp > 0) {
                    endTimestamp = section.endTimestamp;
                }
            }
        }
        else if ([_trackResult.sectionDict.allKeys containsObject:@"page_second_layout"]) {
            if ([_trackResult.sectionDict[@"page_second_layout"] isKindOfClass:[MBAPMEventTimeSection class]]) {
                MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_second_layout"];
                if (section.endPoint.timestamp > 0) {
                    endTimestamp = section.endPoint.timestamp;
                }
            }
            else if ([_trackResult.sectionDict[@"page_second_layout"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_second_layout"];
                if (section.endTimestamp > 0) {
                    endTimestamp = section.endTimestamp;
                }
            }
        }
        else if ([_trackResult.sectionDict.allKeys containsObject:@"page_first_layout"]) {
            if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventTimeSection class]]) {
                MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
                if (section.endPoint.timestamp > 0) {
                    endTimestamp = section.endPoint.timestamp;
                }
            }
            else if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
                MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
                if (section.endTimestamp > 0) {
                    endTimestamp = section.endTimestamp;
                }
            }
        }
        _pageTotal = MIN(endTimestamp - beginTimestamp, 99999);
    }
    return _pageTotal;
}

///  获取页面网络请求开始相对时间戳
- (NSInteger)getNetworkStartRelativeTimestamp {
    UInt64 beginTimestamp = _trackResult.wholeSection.beginPoint.timestamp;
    UInt64 preSectionElapsedTime = [self getPreSectionElapsedTime];
    if ([_trackResult.sectionDict.allKeys containsObject:@"page_network"]) {
        if ([_trackResult.sectionDict[@"page_network"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_network"];
            if (section.beginPoint.timestamp > 0) {
                NSInteger sectionRelativeBeginTimestamp = section.beginPoint.timestamp - beginTimestamp + preSectionElapsedTime;
                return sectionRelativeBeginTimestamp;
            }
            
        } else if ([_trackResult.sectionDict[@"page_network"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_network"];
            if (nonePointSection.beginTimestamp > 0) {
                NSInteger sectionRelativeBeginTimestamp = nonePointSection.beginTimestamp - beginTimestamp + preSectionElapsedTime;
                return sectionRelativeBeginTimestamp;
            }
        }
    }
    return preSectionElapsedTime;
}


- (NSInteger)getPageDurationFirstLayout {
    // 如果存在page_appear分段，matrix value修改
    NSInteger beginTimestamp = _trackResult.wholeSection.beginPoint.timestamp;
    NSInteger endTimestamp = _trackResult.wholeSection.endPoint.timestamp;;
    if ([_trackResult.sectionDict.allKeys containsObject:@"page_appear"]) {
        if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_appear"];
            if (section.beginPoint.timestamp > 0) {
                beginTimestamp = section.beginPoint.timestamp;
            }
            
        } else if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_appear"];
            if (nonePointSection.beginTimestamp > 0) {
                beginTimestamp = nonePointSection.beginTimestamp;
            }
        }
    }
    
    if ([_trackResult.sectionDict.allKeys containsObject:@"page_first_layout"]) {
        if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
            if (section.endPoint.timestamp > 0) {
                endTimestamp = section.endPoint.timestamp;
            }
        }
        else if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
            if (section.endTimestamp > 0) {
                endTimestamp = section.endTimestamp;
            }
        }
    }
    if (endTimestamp > beginTimestamp) {
        return MIN(10000, endTimestamp - beginTimestamp);
    }
    return 0;
}


- (NSInteger)getPageDurationSecondLayout {
    // 如果存在page_appear分段，matrix value修改
    NSInteger beginTimestamp = _trackResult.wholeSection.beginPoint.timestamp;
    NSInteger endTimestamp = _trackResult.wholeSection.endPoint.timestamp;;
    if ([_trackResult.sectionDict.allKeys containsObject:@"page_appear"]) {
        if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_appear"];
            if (section.beginPoint.timestamp > 0) {
                beginTimestamp = section.beginPoint.timestamp;
            }
            
        } else if ([_trackResult.sectionDict[@"page_appear"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *nonePointSection = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_appear"];
            if (nonePointSection.beginTimestamp > 0) {
                beginTimestamp = nonePointSection.beginTimestamp;
            }
        }
    }
    
    if ([_trackResult.sectionDict.allKeys containsObject:@"page_second_layout"]) {
        if ([_trackResult.sectionDict[@"page_second_layout"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_second_layout"];
            if (section.endPoint.timestamp > 0) {
                endTimestamp = section.endPoint.timestamp;
            }
        }
        else if ([_trackResult.sectionDict[@"page_second_layout"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_second_layout"];
            if (section.endTimestamp > 0) {
                endTimestamp = section.endTimestamp;
            }
        }
    }
    else if ([_trackResult.sectionDict.allKeys containsObject:@"page_first_layout"]) {
        if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventTimeSection class]]) {
            MBAPMEventTimeSection *section = (MBAPMEventTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
            if (section.endPoint.timestamp > 0) {
                endTimestamp = section.endPoint.timestamp;
            }
        }
        else if ([_trackResult.sectionDict[@"page_first_layout"] isKindOfClass:[MBAPMEventNonePointTimeSection class]]) {
            MBAPMEventNonePointTimeSection *section = (MBAPMEventNonePointTimeSection *)_trackResult.sectionDict[@"page_first_layout"];
            if (section.endTimestamp > 0) {
                endTimestamp = section.endTimestamp;
            }
        }
    }
    if (endTimestamp > beginTimestamp) {
        return MIN(10000, endTimestamp - beginTimestamp);
    }
    return 0;
}

#pragma mark - private methods

#pragma mark - private methods

- (NSDictionary<NSString *,NSNumber *> *)private_getSectionsDict {
    NSDictionary *sectionDict = [_trackResult.sectionDict copy];
    NSMutableDictionary*sectionElapsedTimeDict = [NSMutableDictionary new];
    if (sectionDict && sectionDict.count > 0) {
        BOOL needPageDuration = NO;
        for (MBAPMBaseEventTimeSection * _Nonnull section in sectionDict.allValues) {
            if (section && [section respondsToSelector:@selector(sectionTag)] && section.sectionTag && section.sectionTag.length > 0
                && [section respondsToSelector:@selector(elapsedTime)] && section.elapsedTime >= 0) {
                sectionElapsedTimeDict[section.sectionTag] = @(section.elapsedTime ?: 0);
                if (needPageDuration == NO && [section.sectionTag isEqualToString:@"page_load"]) {
                    needPageDuration = YES;
                }
            }
        }
        
        if (needPageDuration) {
            [sectionElapsedTimeDict setObject:@([self getPageDurationFirstLayout] ?: 0) forKey:@"page_duration_first_layout"];
            [sectionElapsedTimeDict setObject:@([self getPageDurationSecondLayout] ?: 0) forKey:@"page_duration_second_layout"];
            [sectionElapsedTimeDict setObject:@(([self getPageDurationSecondLayout] ?: 0) - ([self getPageDurationFirstLayout] ?: 0)) forKey:@"page_second_layout"];
        }
        
        NSUInteger launchAppTotoal = [self appLauchTotoal];
        if (launchAppTotoal > 0) {
            [sectionElapsedTimeDict setObject:@(launchAppTotoal) forKey:@"app_launch_total"];
            NSUInteger prefixLaunchApp = [self appLauchApp];
            [sectionElapsedTimeDict setObject:@(prefixLaunchApp) forKey:@"page_launch_app"];
            [sectionElapsedTimeDict setObject:@(prefixLaunchApp + [self getPageDurationSecondLayout]) forKey:@"page_launch_total"];
        }
        if ([sectionDict objectForKey:@"page_network"]) {
            NSInteger networkStartTimestamp = [self getNetworkStartRelativeTimestamp];
            [sectionElapsedTimeDict setObject:@(networkStartTimestamp) forKey:@"page_network_start"];
        }
    }
    return sectionElapsedTimeDict.copy;
}

@end
