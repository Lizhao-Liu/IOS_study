//
//  MBBridgeAdapter.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import "MBBridgeAdapter.h"
#import "MBBridgeContainer.h"
#import "YMMCommonBridge.h"

@interface MBBridgeAdapter()

@property (nonatomic, strong, nonnull) NSString *module;
@property (nonatomic, strong, nullable) NSString *business;
@property (nonatomic, strong, nonnull) NSString *method;
@property (nonatomic, strong, nullable) NSDictionary *params;

@property (nonatomic, copy, nullable) NSString *visitor; ///< 所属业务模块
@property (nonatomic, weak) id container;

@property (nonatomic, copy, nullable) MBBridgeNativeBlock block;

@end

@implementation MBBridgeAdapter

- (void)dealloc {
//    NSLog(@"MBBridgeAdapter+++++++++++++");
}

+ (instancetype)modelWithBridgeRequest:(MBBridgeReuest *)request container:(nullable id)container callback:(MBBridgeNativeBlock)block {
    MBBridgeAdapter *model = [[MBBridgeAdapter alloc] init];
    if (![request.bridgeName isKindOfClass:NSString.class] || ![request.bridgeName length]) {
        return model;
    }
    
    NSString *bridge = request.bridgeName;
    if ([bridge isKindOfClass:NSString.class] && bridge.length) {
        NSArray *arr = [bridge componentsSeparatedByString:@"."];
        if (arr.count == 2) {
            model.module = arr.firstObject;
            model.method = arr.lastObject;
        } else if (arr.count == 3) {
            model.module = arr.firstObject;
            model.method = arr.lastObject;
            model.business = arr[1];
        }
    }
    model.params = request.params;
    model.container = container;
    model.visitor = request.visitor;
    model.block = block;
    
    return model;
}

- (void)invoke {
    if (![self verify]) {
        return;
    }
    
    id<MBBridgeContainer> container;
    if (self.container && [self.container conformsToProtocol:@protocol(MBBridgeContainer)]) {
        container = (id<MBBridgeContainer>)self.container;
    }
    NSMutableDictionary *bridgeInfo = @{@"module": self.module,
                                 @"method": self.method,
                                 @"source": @"native"}.mutableCopy;
    if (self.business && [self.business isKindOfClass:NSString.class]) {
        bridgeInfo[@"business"] = self.business;
    }
    if (self.params && [self.params isKindOfClass:NSDictionary.class]) {
        bridgeInfo[@"params"] = self.params;
    }
    if (self.visitor && [self.visitor isKindOfClass:NSString.class] && self.visitor.length) {
        bridgeInfo[@"visitor"] = self.visitor;
    }
    
    [[YMMCommonBridge new] performBridge:bridgeInfo.copy
                               container:container
                                callBack:^(NSDictionary * _Nonnull response) {
        [self callbackWithResult:response];
    }];
}

- (BOOL)verify {
    if (!self.module.length || !self.method.length ||
        (self.business && ![self.business isKindOfClass:NSString.class]) ||
        (self.params && ![self.params isKindOfClass:NSDictionary.class])) {
        
        [self callbackWithResult:@{@"reason": @"native bridge调用参数错误",@"code": @1}];
        return NO;
    }
    return YES;
}

- (void)callbackWithResult:(NSDictionary *)result {
    if (self.block == nil) {
        return;
    }
    // 脱壳
    NSDictionary *dataDic = result;
    if ([result[@"data"] isKindOfClass:NSDictionary.class]) {
        dataDic = result[@"data"];
    }
    
    MBBridgeResponse *response = [[MBBridgeResponse alloc] init];
    if (dataDic[@"code"]) {
        response.code = [dataDic[@"code"] integerValue];
    }
    if (dataDic[@"reason"]) {
        response.reason = [NSString stringWithFormat:@"%@", dataDic[@"reason"]];
    }
    if (dataDic[@"data"]) {
        response.data = dataDic[@"data"];
    }
    
    self.block(response);
}

@end
