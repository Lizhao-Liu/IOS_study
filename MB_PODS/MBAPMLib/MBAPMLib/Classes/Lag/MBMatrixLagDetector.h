//
//  MBMatrixLagDetector.h
//  MBAPMLib
//
//  Created by 别施轩 on 2021/8/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMLagDetectProtocol.h"

@interface MBMatrixLagDetector : NSObject <MBAPMLagDetectProtocol>

- (void)startLagDetector:(MBAPMLagDetectCallback)callback;

- (void)stopLagDetector;

@end
