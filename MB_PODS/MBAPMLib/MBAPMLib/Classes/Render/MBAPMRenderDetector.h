//
//  MBAPMRenderDetector.h
//  MBAPMLib
//
//  Created by Seal on 2020/4/9.
//

#import <Foundation/Foundation.h>
#import "MBAPMViewPageContext.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@class MBAPMPageRenderMetric;

@protocol MBRenderDetectDelegate <NSObject>

@required

- (void)onRenderDetectFinish:(MBAPMPageRenderMetric *)metric;

@end

@interface MBAPMRenderDetector : NSObject <MBAPMEventTrack>

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithPageContext:(MBAPMViewPageContext *)context NS_DESIGNATED_INITIALIZER;

- (void)setDetectDelegate:(id<MBRenderDetectDelegate>)delegate;

@end


@interface MBAPMRenderPageInfo : MBAPMRenderDetector

- (instancetype)createOne;

- (void)getViewMeshingHitCount:(UIView *)view completion:(void(^)(NSUInteger current, NSUInteger total))completion;

@end


NS_ASSUME_NONNULL_END
