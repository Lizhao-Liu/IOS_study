//
//  MBNativeBridge.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import "MBNativeBridge.h"
#import "MBBridgeContainer.h"
#import "MBBridgeAdapter.h"

@interface MBNativeBridge()<MBBridgeContainer>

@property (nonatomic, weak) id<MBBridgeNativeContainerHandle> containerhandle;
@property (nonatomic, strong) NSMutableArray<MBBridgeContainerListener *> *containerListener; // YMMBridge反向注册的生命周期事件监听

@end

@implementation MBNativeBridge

#pragma mark - lifeCycle method
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithHandle:(nullable id<MBBridgeNativeContainerHandle>)handle {
    self = [super init];
    if (self) {
        _containerhandle = handle;
    }
    
    return self;
}

#pragma mark - public method
// 调用bridge
- (void)performBridge:(NSString *)bridgeName
               params:(nullable NSDictionary *)params
              visitor:(nullable NSString *)visitor
             callBack:(nullable MBBridgeNativeBlock)callBack {
    MBBridgeReuest *request = [MBBridgeReuest requestWithName:bridgeName
                                                      visitor:visitor
                                                       params:params];
    [self performBridge:request
               callBack:callBack];
}

//
- (void)performBridge:(MBBridgeReuest *)request
             callBack:(MBBridgeNativeBlock)callBack {
    [[MBBridgeAdapter modelWithBridgeRequest:request container:self callback:callBack] invoke];
}

#pragma mark - protocol MBBridgeContainer Method
- (void)addContainerListener:(MBBridgeContainerListener *)listener unique:(nullable NSString *)key {
    if (listener) {
        [self.containerListener addObject:listener];
    }
}

- (UIView *)containerView {
    return nil;
}

- (UIViewController *)containerViewController {
    return nil;
}

- (void)call:(NSString *)methodId params:(NSDictionary *)params {
    // 用于bridge向容器回传事件
    // 目前暂无具体实现需求
//    NSLog(@"call:%@----params:%@", methodId, params);
}

- (void)dealloc {
//    NSLog(@"MBBridge---+++++++++++++");
    for (MBBridgeContainerListener *listener in _containerListener) {
        if (listener.deallocBlock) {
            listener.deallocBlock();
        }
    }
}

#pragma mark - property method
- (NSMutableArray<MBBridgeContainerListener *> *)containerListener {
    if (!_containerListener) {
        _containerListener = [NSMutableArray array];
    }
    return _containerListener;
}

@end
