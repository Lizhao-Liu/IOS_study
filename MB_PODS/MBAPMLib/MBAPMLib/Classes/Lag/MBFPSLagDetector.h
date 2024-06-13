//
//  MBFPSLagDetector.h
//  MBAPMLib
//
//  Created by xp on 2020/11/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMLagDetectProtocol.h"

NS_ASSUME_NONNULL_BEGIN


/// 通过FPS两帧之间的时间间隔来检测卡顿，主要针对短时频繁卡顿
/// 卡顿时长定义为200~400m之间，卡顿频率定义为3s内出现5次卡顿
@interface MBFPSLagDetector : NSObject <MBAPMLagDetectProtocol>

@end

NS_ASSUME_NONNULL_END
