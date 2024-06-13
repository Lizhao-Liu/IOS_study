//
//  MBAPMTimeTrackModel.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import "MBAPMTimeTrackModel.h"

@implementation MBAPMTimeTrackPoint


@end

@implementation MBAPMTimeTrackModel

- (UInt64)getTotalTime {
    return self.endTime - self.beginTime;
}

- (NSArray *)getTimeBetweenPoints:(NSRange)range {
    if(range.length + range.location > self.pointDict.count) {
        return nil;
    }
    if(range.length < 2) {
        return nil;
    }
    NSArray<MBAPMTimeTrackPoint *> *points = [[self.pointDict MBAPMSort_getAllValue] subarrayWithRange:range];
    if(points.count < 2) {
        return nil;
    }
    UInt64 start = [points objectAtIndex:0].pointTime;
    NSMutableArray *timeArray = [NSMutableArray new];
    for(int i = 1; i < points.count; i++) {
        UInt64 time = [points objectAtIndex:i].pointTime - start;
        start = [points objectAtIndex:i].pointTime;
        [timeArray addObject:@(time)];
    }
    return timeArray;
}

- (NSDictionary *)getTimeDividedByPoints{
    NSMutableDictionary<NSString *, NSNumber *> *timeDic = [NSMutableDictionary new];
    __block UInt64 tmpStartTime = 0;
    [self.pointDict MBAPMSort_enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tag = key;
        MBAPMTimeTrackPoint *point = obj;
        if(![tag isEqualToString:kMBAPM_TIMETRACK_POINTTAG_BEGIN]) {
            UInt64 timeInterval = point.pointTime - tmpStartTime;
            [timeDic setObject:@(timeInterval) forKey:tag];
        }
        tmpStartTime = point.pointTime;
    }];
    return timeDic;
}

@end
