//
//  MBNavTransitionBuilder_Private.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import "MBNavTransitionBuilder.h"

@protocol MBNavTransitionBuilderDelegate;

@interface MBNavTransitionBuilder()

@property (weak, nonatomic) id<MBNavTransitionBuilderDelegate> delegate;

@end

@interface MBNavTransitionBuilder(Output)

/// 返回通过transitionBuilder构造的transition对象
- (MBNavBaseTransition *)build;

@end



@protocol MBNavTransitionBuilderDelegate <NSObject>

- (void)enqueueTransitionForBuilder:(MBNavTransitionBuilder *)transitionBuilder;

@end
