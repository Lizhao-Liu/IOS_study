//
//  MBDebugOscillogramWindow.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBDebugOscillogramViewController.h"

NS_ASSUME_NONNULL_BEGIN


@protocol MBDebugOscillogramWindowDelegate <NSObject>

- (void)MBDebugOscillogramWindowClosed;

@end

@interface MBDebugOscillogramWindow : UIWindow


+ (instancetype)shareInstance;

@property (nonatomic, strong) MBDebugOscillogramViewController *vc;

@property (nonatomic, assign) BOOL isShown;

//需要子类重写
- (void)addRootVc;

- (void)show;

- (void)hide;

- (void)addDelegate:(id<MBDebugOscillogramWindowDelegate>) delegate;

- (void)removeDelegate:(id<MBDebugOscillogramWindowDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
