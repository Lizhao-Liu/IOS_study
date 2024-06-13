//
//  MBNavTransition.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import <Foundation/Foundation.h>
#import "MBNavPageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class MBNavTransition;

typedef NS_ENUM(NSInteger, MBNavParameterOptions) {
    MBNavParameterOptionsVisible                  = 0,              // 展示页面
    MBNavParameterOptionsHidden                   = 1 << 0,         // 隐藏页面
    MBNavParameterOptionsAnimated                 = 1 << 1,         // 启用动画
    MBNavParameterOptionsUnAnimated               = 1 << 2,         // 不显示动画
    MBNavParameterOptionsModal                    = 1 << 3,         // VC为模态弹窗
    MBNavParameterOptionsTransparent              = 1 << 4,         // 模态弹窗背景透明
    MBNavParameterOptionsPopNav                   = 1 << 5,         // 当pop页面为UINavigationController根页面，弹出UINavigationController
    MBNavParameterOptionsPushWithNav              = 1 << 6          // push页面时包一层UINavigationController
};

typedef NS_ENUM(NSInteger, MBNavParameterFlags) {
    MBNavParameterFlagDefault                  = 0,
    MBNavParameterFlagClearTop                  = 1
};

/// 页面切换回调block
typedef void(^MBNavTransitionCompletion)(void);

/// 页面返回回传数据
typedef void(^MBNavTransitionOnResultCallback)(NSError *error, id data,  NSString * _Nullable requestId);



@interface MBNavBaseAction : NSObject

@property (nonatomic, assign) MBNavParameterOptions options;

@property (nonatomic, assign) uint64_t delayTime;

@property (nonatomic, weak) UIViewController *currentVC;

@end

@interface MBNavPushAction : MBNavBaseAction

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, assign) MBNavParameterFlags flags;

@property (nonatomic, assign) NSUInteger deltaOfNextPop;

@end

@interface MBNavPopAction : MBNavBaseAction

@property (nonatomic, assign) NSUInteger delta;

@end

@interface MBNavPopKeepAction : MBNavBaseAction

@property (nonatomic, assign) NSUInteger keepNum;

@end

@interface MBNavPopUtilAction : MBNavBaseAction

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSDictionary *params;

@end

@interface MBNavUpdateChildPagesAction : MBNavBaseAction

@property (nonatomic, copy) NSArray<MBNavContainerInnerPageInfo *> *childPages;

@end

@interface MBNavSetResultAction : MBNavBaseAction

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong, nullable) NSString *requestId;

@end

@class MBNavBaseTransition;

@protocol MBNavTransitionDelegate <NSObject>


- (void)transitionWillStart:(MBNavBaseTransition *)transition;


//- (void)transition:(MBNavTransition *)transition performActions:(NSArray<MBNavBaseAction *> *)actions inContainerPage:(UIViewController *)container completion:(void(^)(BOOL))completion;

- (void)transitionDidComplete:(MBNavBaseTransition *)transition;

@end

@interface MBNavBaseTransition : NSObject {
    NSUInteger _nextIndex;
    BOOL _hasFinished;
}

@property (nonatomic, weak) UIViewController *currentVC;

@property (nonatomic, weak) UIViewController *popFromVC;

@property (nonatomic, weak) UIViewController *popKeepVC;

@property (nonatomic, weak) UINavigationController *rootVC;

@property (nonatomic, copy) NSMutableArray<MBNavBaseAction *> *actions;

@property (nonatomic, weak) id<MBNavTransitionDelegate> delegate;

@property (nonatomic, copy) MBNavTransitionCompletion externalCompletionCallback;

@property (nonatomic, copy) MBNavTransitionOnResultCallback onResultCallback;

@property (nonatomic, strong, nullable) NSTimer *timeoutTimer;

@property (nonatomic, strong, readonly) NSString *requestId;
 
- (void)start;

- (void)executeAction:(MBNavBaseAction *)action complete:(void(^)(BOOL result, BOOL updateCurrentVC))completion;

@end

@interface MBNavTransition : MBNavBaseTransition

@end

NS_ASSUME_NONNULL_END
