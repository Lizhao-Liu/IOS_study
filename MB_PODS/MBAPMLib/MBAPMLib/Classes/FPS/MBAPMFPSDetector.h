//
//  MBAPMFPSDetector.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBAPMFPSDataResponse;
@class MBModuleInfo;

@protocol MBAPMFPSDetectorDelegate <NSObject>

- (void)pageFpsAvg:(NSString*)pageName fpsData:(MBAPMFPSDataResponse *)fpsData moduleInfo:(MBModuleInfo *)moduleInfo;
- (void)scrollFps:(NSString*)pageName fpsData:(MBAPMFPSDataResponse *)fpsData moduleInfo:(MBModuleInfo *)moduleInfo;

@end

@interface MBAPMFPSDetector : NSObject

- (void)startDetectWithDelegate:(id<MBAPMFPSDetectorDelegate>)delegate;
- (void)stopDetect;
@end

NS_ASSUME_NONNULL_END
