//
//  MBBridgeAccessModel.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2021/12/29.
//

#import "MBBridgeAccessModel.h"

@implementation MBBridgeAccessModel

#pragma mark - lifeCycle method
- (instancetype)initWithAccess:(NSArray *)list level:(MBBridgeAccessLevel)level {
    self = [super init];
    if (self) {
        self.list = list;
        self.level = level;
    }
    return self;
}

#pragma mark - public method
- (BOOL)matchAccess:(NSString *)visitor {
    if (self.nolimit) {
        return YES;
    }
    
    if (self.list == nil || self.list.count <= 0) {
        // 没有配置权限，默认为不限制访问
        return YES;
    }
    
    // 业务侧设置了白名单，但是调用者visitor为空
    if ([visitor isKindOfClass:[NSNull class]] || visitor.length <= 0) {
        return NO;
    }
    
    NSString *module = nil;
    NSArray *values = [visitor componentsSeparatedByString:@"."];
    if (values.count > 1) {
        module = [values objectAtIndex:0];
    }
    
    if (module != nil) {
        // 访问者是a.x格式，判断满足 a 或 a.x 都可以访问
        if (module.length <= 0) {
            return YES;
        }
        for (NSString *access in self.list) {
            if ([access isEqualToString:module] || [access isEqualToString:visitor]) {
                return YES;
            }
        }
    } else {
        // 访问者是a格式，判断满足 a 可以访问
        for (NSString *access in self.list) {
            if ([access isEqualToString:visitor]) {
                return YES;
            }
        }
    }
    
    // 没有权限
    return NO;
}

@end
