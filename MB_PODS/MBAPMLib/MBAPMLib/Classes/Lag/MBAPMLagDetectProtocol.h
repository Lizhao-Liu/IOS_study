//
//  MBAPMLagDetectProtocol.h
//  MBAPMLib
//
//  Created by xp on 2020/8/17.
//

#ifndef MBAPMLagDetectProtocol_h
#define MBAPMLagDetectProtocol_h

#import "MBAPMLagMetric.h"

typedef void(^MBAPMLagDetectCallback)(MBAPMReportChannel reportChannel, MBAPMLagType lagType, NSString *stack, NSString *keyFunction, NSTimeInterval startTime, NSTimeInterval duration, NSDictionary *systemInfo, NSInteger dumpTpye);

@protocol MBAPMLagDetectProtocol <NSObject>

- (void)startLagDetector:(MBAPMLagDetectCallback)callback;

- (void)stopLagDetector;

@end


#endif /* MBAPMLagDetectProtocol_h */
