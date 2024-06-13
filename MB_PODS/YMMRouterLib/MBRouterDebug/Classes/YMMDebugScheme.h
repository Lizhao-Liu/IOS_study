//
//  YMMDebugScheme.h
//  AFNetworking
//
//  Created by yc on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YMMRouterDebugStatus) {
    YMMRouterDebugStatus_Default = 0,
    YMMRouterDebugStatus_Success = 1,
    YMMRouterDebugStatus_404 = 2,
};

@interface YMMDebugScheme : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *isPresent;
@property (strong, nonatomic) NSNumber *isMainTab;

/// 非404
@property (assign, nonatomic) YMMRouterDebugStatus status;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
