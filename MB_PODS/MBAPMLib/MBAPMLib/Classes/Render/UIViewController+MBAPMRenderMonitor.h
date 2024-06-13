//
//  UIViewController+MBRenderDetector.h
//  YMMPerformanceModule
//
//  Created by seal on 2020/6/20.
//

#import <UIKit/UIKit.h>

@protocol MBAPMEventTimeTrackContainerProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MBRenderMonitor)

@property (nonatomic, assign) BOOL isLoadedFlag;
@property (nonatomic, copy, nullable) NSString *mbapm_pageTrackId;

@end

NS_ASSUME_NONNULL_END
