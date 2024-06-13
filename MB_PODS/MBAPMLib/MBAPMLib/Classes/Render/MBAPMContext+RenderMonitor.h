//
//  MBAPMContext+RenderMonitor.h
//  MBAPMLib
//
//  Created by xp on 2024/1/26.
//

#import <Foundation/Foundation.h>
#import "MBAPMContext.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary *(^MBAPMGetAppLaunchTimeForFistPageRenderBlock)(void);

@interface MBAPMContext(RenderMonitor)

@property (nonatomic, copy, nullable)MBAPMGetAppLaunchTimeForFistPageRenderBlock getLaunchTimeBlock;

@end

NS_ASSUME_NONNULL_END
