//
//  MBAPMPageLaunchDivideCenter.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBDoctorEventPerformance;
@class MBModuleInfo;
@class MBAPMViewPageContext;
@class MBAPMConfiguration;
@protocol MBAPMEventTimeTrack;

typedef void(^MBAPMPageLaunchDivideCenterReportBlock)(MBDoctorEventPerformance *performance, MBModuleInfo *moduleInfo);

@protocol MBAPMPageLaunchDivideCenterProtocal <NSObject>

- (void)pageDidEndLaunchMonitor:(nonnull NSString *)pageName controller:(UIViewController *)controller moduleInfo:(MBModuleInfo *)moduleInfo duration:(NSUInteger)duration;

@end

@interface MBAPMPageLaunchDivideCenter : NSObject

@property (nonatomic, copy) MBAPMPageLaunchDivideCenterReportBlock reportBlock;
@property (nonatomic, strong) MBAPMConfiguration *apmConfiguration;

- (void)startMonitor;

- (void)stopMonitor;

- (void)startFirstLayoutCheck:(id<MBAPMEventTimeTrack>)trackTask;

- (void)beginRouterWithViewController:(UIViewController *)controller;

- (BOOL)currentPageIsLoading;

@property (nonatomic, weak) id<MBAPMPageLaunchDivideCenterProtocal> delegate;

+ (MBAPMPageLaunchDivideCenter *)sharedInstance;

+ (BOOL)shouldIgnore:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
