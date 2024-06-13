//
//  MBDebugAlertStateManager.h
//  MBDebug
//
//  Created by Lizhao on 2023/10/20.
//

#import <Foundation/Foundation.h>
@import MBFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugAlertStateManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(MBDebugAlertStateManager);

@property (nonatomic, assign) BOOL isToastAlertDisabled;

@property (nonatomic, assign) BOOL isRedDotVisible;

- (void)showRedDot:(id)caller;

- (void)hideRedDot:(id)caller;

- (BOOL)shouldShowRedDot:(id)caller;

@end

NS_ASSUME_NONNULL_END
