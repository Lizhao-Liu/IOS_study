//
//  YMMRouterCenter.m
//  Pods-YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/3.
//

#import "YMMRouterCenter.h"
#import "YMMRouter.h"
#import "YMMRouterTable.h"
#import "YMMRouterResponse.h"
#import "YMMRouterRequest.h"
#import "YMMRouterFilterChain.h"
#import "YMMRouterConfigManager.h"
#import "MBRouterLogger.h"

@interface YMMRouterCenter () <YMMRouterHandlerProtocol> {
    NSMutableArray *_routers;
    NSMutableArray *_interceptors;
    YMMRouter *_router;
}
@end

@implementation YMMRouterCenter

+ (instancetype)shared {
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YMMRouterCenter alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routers = [NSMutableArray array];
        _interceptors = [NSMutableArray array];
        _router = [[YMMRouter alloc] initWithSchemePattern:@"^\\S+$" hostPattern:@"^\\S+$"];
        [_router registerHandler:self forPathPattern:@"^/\\S+$"];
    }
    return self;
}

#pragma mark - public
+ (void)setupConfig:(YMMRouterConfig *)config {
    [YMMRouterConfigManager setConfig:config];
}

+ (void)setRouterErrorViewController:(MBRouterErrorViewControllerConfigBlock)block {
    [YMMRouterConfigManager getConfig].errorViewControllerConfigBlock = block;
}

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter {
    [_router addFilter:filter];
}

- (void)addInterceptor:(id<YMMRouterCenterInterceptorProtocol>)interceptor {
    [_interceptors addObject:interceptor];
}

- (void)addRouter:(YMMRouter *)router {
//    NSAssert(![self checkDuplicateRouter:router], @"Duplicate router: %@", router.hostPattern);
    [_routers addObject:router];
}

- (void)addRouters:(NSArray<YMMRouter *> *)routers {
//    NSAssert(![self checkDuplicateInRouters:routers], @"Duplicate router exists");
    [_routers addObjectsFromArray:routers];
}

- (void)removeRouter:(YMMRouter *)router {
    [_routers removeObject:router];
}

- (YMMRouterResponse *)match:(id<YMMRouterRoutable>)routable {
    YMMRouterResponse *response = [_router matches:routable];
    if (response.status == YMMRouterStatusRedirect) {
        if ([response.result conformsToProtocol:@protocol(YMMRouterRoutable)]) {
            id<YMMRouterRoutable> redirectRouter = (id<YMMRouterRoutable>)response.result;
            MBRouterInfo(@"[MBRouter] [matches] router redirect, url = %@, redirect url = %@", routable.urlString, redirectRouter.urlString);
            if ([redirectRouter respondsToSelector:@selector(setStartTimestamp:)]) {
                [redirectRouter setStartTimestamp:[[NSDate date] timeIntervalSince1970] * 1000];
            }
            return [self match:redirectRouter];
        }
    }
    if(response.status == YMMRouterStatusSuccess) {
        NSAssert([response.handler conformsToProtocol:@protocol(YMMRouterHandlerProtocol)], @"The 'response.handler' must implement YMMRouterHandlerProtocol");
        return [((id<YMMRouterHandlerProtocol>)response.handler) handle:response.request];
    } else {
        MBRouterWarning(@"[MBRouter][matches] router fail, url = %@, response status = %lu", routable.urlString, (unsigned long)response.status);
    }
    return response;
}

- (id<YMMRouterRoutable>)redirect:(id<YMMRouterRoutable>)routable {
    YMMRouterResponse *response = [_router redirect:routable];
    if (response.status == YMMRouterStatusRedirect) {
        if ([response.result conformsToProtocol:@protocol(YMMRouterRoutable)]) {
            id<YMMRouterRoutable> redirectRouter = (id<YMMRouterRoutable>)response.result;
            return [self redirect:redirectRouter];
        }
    }
    if (response && [response.result conformsToProtocol:@protocol(YMMRouterRoutable)]) {
        return (id<YMMRouterRoutable>)response.result;
    }
    return routable;
}

- (void)perform:(id<YMMRouterRoutable>)routable
     completion:(nonnull Completion)completion {
    if (!routable) {
        MBRouterError(@"[MBRouter][perform] routable is nil");
    }
    [self invoke:routable completion:completion];
}

- (void)performWithURLString:(NSString *)urlString
                  completion:(nullable Completion)completion {
    return [self performWithURLString:urlString
                               params:nil
                           completion:completion];
}

- (void)performWithURLString:(NSString *)urlString
                      params:(NSDictionary *)params
                  completion:(nullable Completion)completion {
    return [self perform:[[YMMRouterRequest alloc] initWithURLString:urlString params:params]
              completion:completion];
}

- (void)performWithURL:(NSURL *)url
            completion:(nullable Completion)completion {
    return [self performWithURL:url
                         params:nil
                     completion:completion];
}

- (void)performWithURL:(NSURL *)url
                params:(nullable NSDictionary *)params
            completion:(nullable Completion)completion {
    if (!url) {
        MBRouterError(@"[MBRouter][perform] url is nil");
        return;
    }
    [self perform:[[YMMRouterRequest alloc] initWithURL:url params:params]
       completion:completion];
}

- (id)syncPerformWithURL:(NSURL *)URL params:(NSDictionary *)params {
    YMMRouterRequest *request = [[YMMRouterRequest alloc] initWithURL:URL params:params];
    if ([self routerShouldHandle:request]) {
        YMMRouterResponse *response = [self match:request];
        if (response.status == YMMRouterStatusSuccess) {
            if ([response.handler conformsToProtocol:@protocol(YMMRouterHandlerProtocol)]) {
                id result = [((id<YMMRouterHandlerProtocol>)response.handler) handle:response.request];
                response.result = result;
                [self routerDidHandle:response.request response:response];
                return result;
            } else if ([response.handler conformsToProtocol:@protocol(YMMRouterAsyncHandlerProtocol)]) {
                [((id<YMMRouterAsyncHandlerProtocol>)response.handler) handle:response.request callback:^(id result) {
                    response.result = result;
                    [self routerDidHandle:response.request response:response];
                }];
            }
        }
    }
    return nil;
}

- (id<YMMRouterRoutable>)getRedictedUrl:(id<YMMRouterRoutable>)routable {
    if (!routable) {
        return nil;
    }
    if ([self routerShouldHandle:routable]) {
        id<YMMRouterRoutable> result = [self redirect:routable];
        if (result) {
            return result;
        }
    }
    return routable;
}

#pragma mark - YMMRouterHandlerProtocol

- (id)handle:(id<YMMRouterRoutable>)routable {
    YMMRouterResponse *response = nil;
    for (YMMRouter *router in _routers) {
        response = [router matches:routable];
        if (response.status == YMMRouterStatusSuccess) {
            MBRouterInfo(@"[MBRouter][matches] router matched, url = %@, router = %@, reponse handler = %@,", routable.urlString, router.hostPattern, response.handler.class);
            return response;
        } else if (response.status == YMMRouterStatusRedirect) {
            if ([response.result conformsToProtocol:@protocol(YMMRouterRoutable)]) {
                id<YMMRouterRoutable> redirectRouter = (id<YMMRouterRoutable>)response.result;
                MBRouterInfo(@"[MBRouter][matches] router redirect, url = %@, router = %@, redirect url = %@", routable.urlString, router.hostPattern, redirectRouter.urlString);
                if ([redirectRouter respondsToSelector:@selector(setStartTimestamp:)]) {
                    [redirectRouter setStartTimestamp:[[NSDate date] timeIntervalSince1970] * 1000];
                }
                return [self handle:redirectRouter];
            }
        }
    }
    if (!response) {
        MBRouterInfo(@"[MBRouter][matches] handler not found, url = %@, response status = %lu,", routable.urlString, response.status);
        response = [[YMMRouterResponse alloc] initWithStatus:YMMRouterStatusNotFound request:routable];
    }
    return response;
}

#pragma mark - YMMRouterCenterInterceptorProtocol

- (BOOL)routerShouldHandle:(id<YMMRouterRoutable>)routable {
    for (id<YMMRouterCenterInterceptorProtocol> interceptor in _interceptors) {
        if (![interceptor routerShouldHandle:routable]) {
            MBRouterInfo(@"[MBRouter][interceptor] routerShouldHandle forbidden url = %@, handler = %@", routable.urlString, interceptor.class);
            return NO;
        }
    }
    return YES;
}

- (void)routerDidHandle:(id<YMMRouterRoutable>)routable
               response:(YMMRouterResponse *)response {
    YMMRouterResponse *tempResponse = response;
    if (!tempResponse) {
        tempResponse = [[YMMRouterResponse alloc] initWithStatus:YMMRouterStatusNotFound request:routable];
    }
    for (id<YMMRouterCenterInterceptorProtocol> interceptor in _interceptors) {
        [interceptor routerDidHandle:routable
                            response:tempResponse];
    }
}

#pragma mark - private

- (void)routeComplete:(id<YMMRouterRoutable>)routable
           completion:(nullable Completion)completion
             response:(nullable YMMRouterResponse *)response {
    [self routerDidHandle:routable
                 response:response];
    MBRouterInfo(@"[MBRouter][matches] router complete, url = %@, reponse handler = %@, status = %lu, result = %@", routable.urlString, response.handler.class, response.status, response.result);
    if (completion) {
        completion(response);
    }
}

- (BOOL)checkDuplicateRouter:(YMMRouter *)router {
    for (YMMRouter *r in _routers) {
        if ([r.hostPattern isEqualToString:router.hostPattern]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkDuplicateInRouters:(NSArray<YMMRouter *> *)newRouters {
    for (YMMRouter *newRouter in newRouters) {
        for (YMMRouter *r in _routers) {
            if ([r.hostPattern isEqualToString:newRouter.hostPattern]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)invoke:(id<YMMRouterRoutable>)routable
    completion:(nullable Completion)completion {
    MBRouterInfo(@"[MBRouter][receive] url = %@", routable.urlString);
    if ([self routerShouldHandle:routable]) {
        if ([routable respondsToSelector:@selector(setStartTimestamp:)]) {
            [routable setStartTimestamp: [[NSDate date] timeIntervalSince1970] * 1000];
        }
        YMMRouterResponse *response = [self match:routable];
        if (response.status == YMMRouterStatusSuccess) {
            if ([response.handler conformsToProtocol:@protocol(YMMRouterHandlerProtocol)]) {
                id result = [((id<YMMRouterHandlerProtocol>)response.handler) handle:response.request];
                response.result = result;
                [self routeComplete:response.request
                         completion:completion
                           response:response];
            } else if ([response.handler conformsToProtocol:@protocol(YMMRouterAsyncHandlerProtocol)]) {
                __weak __typeof(self) weakSelf = self;
                [((id<YMMRouterAsyncHandlerProtocol>)response.handler) handle:response.request callback:^(id result) {
                    response.result = result;
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf routeComplete:response.request
                                   completion:completion
                                     response:response];
                }];
            }
            return;
        }
        [self routeComplete:routable
                 completion:completion
                   response:response];
        return;
    }
    YMMRouterResponse *notFoundResponse = [[YMMRouterResponse alloc] initWithStatus:YMMRouterStatusNotFound request:routable];
    [self routeComplete:routable
             completion:completion
               response:notFoundResponse];
}

@end

@implementation YMMRouterCenter (UIViewController)

+ (void)pushWithUrl:(NSURL *)url
             params:(nullable NSDictionary *)params
 fromViewController:(UIViewController *)viewController {
    [[YMMRouterCenter shared] performWithURL:url params:params completion:^(YMMRouterResponse * response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            [viewController.navigationController pushViewController:response.result animated:YES];
        }
    }];
}

+ (void)pushWithUrlString:(NSString *)urlString params:(NSDictionary *)params fromViewController:(UIViewController *)viewController {
    [[YMMRouterCenter shared] performWithURLString:urlString params:params completion:^(YMMRouterResponse *response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            [viewController.navigationController pushViewController:response.result animated:YES];
        }
    }];
}

+ (void)presentWithUrl:(NSURL *)url
                params:(nullable NSDictionary *)params
    fromViewController:(UIViewController *)viewController {
    [[YMMRouterCenter shared] performWithURL:url params:params completion:^(YMMRouterResponse * response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            [viewController presentViewController:response.result animated:YES completion:nil];
        }
    }];
}

+ (void)presentWithUrlString:(NSString *)urlString params:(NSDictionary *)params fromViewController:(UIViewController *)viewController {
    [[YMMRouterCenter shared] performWithURLString:urlString params:params completion:^(YMMRouterResponse *response) {
        if (response.result && [response.result isKindOfClass:UIViewController.class]) {
            [viewController presentViewController:response.result animated:YES completion:nil];
        }
    }];
}

@end
