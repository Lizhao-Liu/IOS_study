//
//  YMMRouterDebugErrorViewController.h
//  AFNetworking
//
//  Created by yc on 2019/12/3.
//

@import MBCommonUILib;

NS_ASSUME_NONNULL_BEGIN

typedef void(^YMMRouterDebugClearErrorBlock)();

@interface YMMRouterDebugErrorViewController : YMMNewBaseViewController

@property (nonatomic, strong) NSArray *errorSchemes;

- (void)clearErrorSchemes:(YMMRouterDebugClearErrorBlock)clearBlock;

@end

NS_ASSUME_NONNULL_END
