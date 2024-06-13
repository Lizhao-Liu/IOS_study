//
//  MBRenderWeakTimer.h
//  AliyunOSSiOS
//
//  Created by seal on 2020/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBRenderWeakTimer : NSObject

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        start:(NSTimeInterval)startTimeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id _Nullable)userInfo
                                       repeats:(BOOL)repeats;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
