//
//  YMMRouterModule.m
//  AFNetworking
//
//  Created by Xiaohui on 2019/3/6.
//

#import "YMMRouterModule.h"
#import "YMMRouterErrorViewController.h"
#import "MBWXMiniProgramRouter.h"
#import "MBDialogRouter.h"
@import YMMModuleLib;
@import MBDoctorService;
@import YMMMainServices;

@interface YMMRouterMappingModel : NSObject

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *theNewHost;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, readonly) BOOL keepOldHost;

- (instancetype)initWithDict:(NSDictionary *)dict newHost:(NSString *)newHost;

@end


@implementation YMMRouterMappingModel

- (instancetype)initWithDict:(NSDictionary *)dict newHost:(NSString *)newHost {
    self = [super init];
    if (self) {
        _scheme = dict[@"scheme"];
        _host = dict[@"host"];
        _path = dict[@"path"];
        _theNewHost = newHost;
        _keepOldHost = ((NSNumber *)dict[@"keep_old_host"]).boolValue;
    }
    return self;
}

@end

@interface YMMRouterModuleContext : MBModuleContext

@end

@interface YMMRouterModule ()<YMMRouterCenterInterceptorProtocol, YMMRouterFilterProtocol>
{
    NSArray *_routeMappingArray;
}
@end

@moduleEX(YMMRouterModule)

#pragma mark - YMMModuleProtocol
+ (NSString *)moduleName {
    return @"app";
}

+ (NSString *)subModuleName {
    return @"YMMRouterModule";
}

- (NSArray<YMMRouter *> *) routers {
    
    NSArray *defaultSchemes = @[@"ymm", @"ymm-driver", @"ymm-consignor", @"wlqq", @"wlqq.driver", @"wlqq.consignor", @"wlqq.consignor.launch"];
    YMMRouter *appRouter = [[YMMRouter alloc] initWithSchemes:defaultSchemes
                                                  hostPattern:@"app"];
    
    MBDialogRouter *dialogHandle = [[MBDialogRouter alloc] init];
    YMMRouterTable *appTable = [[YMMRouterTable alloc] init];
    [appTable registerHandler:dialogHandle forPathPattern:@"/uidialog"];
    [appRouter addRouterTable:appTable];
    
    // 打开微信小程序
    YMMRouter *wxRouter = [[YMMRouter alloc] initWithSchemes:@[@"mb-wx"]
                                               hostPattern:@"min_program"];
    
    MBWXMinProgramRouter *wxHandle = [[MBWXMinProgramRouter alloc] init];
    YMMRouterTable *wxTable = [[YMMRouterTable alloc] init];
    [wxTable registerHandler:wxHandle forPathPattern:@"/index"];
    
    [wxRouter addRouterTable:wxTable];
    
    return @[appRouter, wxRouter];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"YMMRouterModule" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSString *path = [bundle pathForResource:@"route_mapping" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *routeMappingArray = [NSMutableArray array];
    for (NSString *key in [dict allKeys]) {
        NSArray *values = dict[key];
        for (NSDictionary *value in values) {
            [routeMappingArray addObject:[[YMMRouterMappingModel alloc] initWithDict:value newHost:key]];
        }
    }
    _routeMappingArray = routeMappingArray;
    [[YMMRouterCenter shared] addFilter:self];
    [[YMMRouterCenter shared] addInterceptor:self];
    return YES;
}

#pragma mark - YMMRouterFilterProtocol

- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response
           chain:(id<YMMRouterFilterChainProtocol>)chain {
    if ([self handleLowVersionIssue:routable]) {
        response.status = YMMRouterStatusLowVersion;
        return;
    }
    for (YMMRouterMappingModel *model in _routeMappingArray) {
        if (([NSString mb_isNilOrEmpty:model.scheme] || [YMMRouter match:model.scheme content:routable.scheme])
            && [YMMRouter match:model.host content:routable.host]
            && [YMMRouter match:model.path content:routable.path]) {
            NSString *urlString = nil;
            if (model.keepOldHost) {
                urlString = [NSString stringWithFormat:@"%@://%@/%@%@", routable.scheme, model.theNewHost, routable.host, routable.path];
            } else {
                urlString = [NSString stringWithFormat:@"%@://%@%@", routable.scheme, model.theNewHost, routable.path];
            }
            response.status = YMMRouterStatusRedirect;
            response.result = [[YMMRouterRequest alloc] initWithURLString:urlString
                                                                   params:routable.params
                                                              handleBlock:routable.handleBlock];
            return;
        }
    }
    [chain doFilter:routable response:response];
}

- (BOOL)handleLowVersionIssue:(id<YMMRouterRoutable>)routable {
    NSString *version = routable.params[@"amh-min-app-ios"];
    if (![version length]) {
        version = routable.params[@"amh-min-app"];
    }
    if ([version length]) {
        long long localVersion = [self getVersionNumber];
        if (localVersion >= [version longLongValue]) {
            return NO;
        } return YES;
    } else {
        return NO;
    }
}

// 本来可以通过 MBProjectConfig 直接获取，但是因为循环依赖的问题，只能自己写
// example: 6.77.5(6.77.5.0) -> 6770500
- (long long)getVersionNumber {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSMutableArray *arr = [version componentsSeparatedByString:@"."].mutableCopy;
    while (arr.count < 4) { [arr addObject:@"00"]; }
    NSMutableString *str = @"".mutableCopy;
    for (NSString *code in arr) {
        if (code.length == 1) {
            [str appendFormat:@"0%@",code];
        } else {
            [str appendString:code];
        }
    }
    return [str longLongValue];
}

#pragma mark - YMMRouterCenterInterceptorProtocol

- (BOOL)routerShouldHandle:(id<YMMRouterRoutable>)routable {
    [self saveUTM:routable.params];
    if (routable.isValid) {
        return YES;
    }
    return NO;
}

- (void)routerDidHandle:(id<YMMRouterRoutable>)routable
               response:(YMMRouterResponse *)response {
    id<MBDoctorServiceProtocol> doctor = BIND_SERVICE([YMMRouterModule getContext], MBDoctorServiceProtocol);
    NSString *eventUrlPath = [NSString stringWithFormat:@"%@://%@%@", routable.scheme, routable.host, routable.path];
    if (response.status != YMMRouterStatusSuccess
        && response.status != YMMRouterStatusRedirect) {
        UIViewController *errorViewController;
        MBRouterErrorViewControllerConfigBlock configBlock = [YMMRouterConfigManager getConfig].errorViewControllerConfigBlock;
        if (configBlock) {
            errorViewController = configBlock(routable, response);
        }
        if (!errorViewController) {
            errorViewController = [YMMRouterErrorViewController pageWithPage:response.status urlString:routable.urlString urlPath:eventUrlPath];
        }
        response.result = errorViewController;
        //路由失败监控
        MBDoctorEventError *errorEvent = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble];
        errorEvent.feature = [NSString stringWithFormat:@"%lu, %@",(unsigned long)response.status,  eventUrlPath];
        errorEvent.errorDetail = [NSString stringWithFormat:@"Router error: full url = %@, code = %lu", routable.urlString, (unsigned long)response.status];
        errorEvent.tag = @"router";
        errorEvent.tags = @{@"code" : @(response.status), @"path" : eventUrlPath?:@""};
        [doctor doctor:errorEvent];
    }
    if (response.status == YMMRouterStatusSuccess) {
        [self saveSource:routable params:routable.params routerResult:response.result];
        [self saveReferSPM:routable params:routable.params routerResult:response.result];
    }
    MBDoctorEventCustom *routerEvent = [[MBDoctorEventCustom alloc]initWithPlatform:MBDoctorPlatformHubble];
    routerEvent.metricName = @"router";
    routerEvent.metricType = MBDoctorMetricTypeCounter;
    routerEvent.metricValue = 1;
    routerEvent.tags = @{@"code" : @(response.status), @"path" : eventUrlPath?:@""};
    routerEvent.ext = @{@"full": routable.urlString?:@""};
    [doctor doctor:routerEvent];
}

#pragma mark - private

- (void)saveUTM:(NSDictionary *)params {
    NSString *urlString = [params[@"report"] stringByRemovingPercentEncoding];
    if (urlString) {
        NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
        for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [paramsDic setObject:[elts lastObject] forKey:[elts firstObject]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:paramsDic forKey:@"kAdvert_utm_report"];
    }
}

- (void)saveSource:(id<YMMRouterRoutable>)routable params:(NSDictionary *)params routerResult:(id)result {
    NSString *amhSource = params[@"amh-src"];
    NSString *tabPageName = params[@"tabPageName"];
    NSString *bizType = params[@"bizType"];
    if(!amhSource || amhSource.length <0) {
        return;
    }
    NSString *resultVCClassName = nil;
    if (!result) {
        resultVCClassName = [self getTabBarChildVCByUrl:routable.urlString tabPageName:tabPageName?:bizType];
    } else {
        if ([result isKindOfClass:[UIViewController class]]) {
            resultVCClassName = NSStringFromClass([result class]);
        } else if ([result isKindOfClass:[NSNumber class]]) {
            NSInteger tabIndex = [result integerValue];
            resultVCClassName = [self getTabBarChildVCByIndex:tabIndex];
        }
    }
    if (resultVCClassName) {
        [[MBDoctorGlobalPV shared] saveAmhSource:resultVCClassName amhSource:amhSource];
    }
}

- (void)saveReferSPM:(id<YMMRouterRoutable>)routable params:(NSDictionary *)params routerResult:(id)result {
    NSString *amhReferSPM = params[@"amh-refer-spm"];
    if (!result) {
        return;
    }
    if ([result isKindOfClass:[UIViewController class]]) {
        [MBDoctorReferUtil setReferSPM:amhReferSPM ofVC:(UIViewController *)result];
    }
}

- (NSString *)getTabBarChildVCByUrl:(NSString *)url tabPageName: (NSString *)tabPageName {
    id<MBTabbarProtocol> tabBarService = BIND_SERVICE([YMMRouterModule getContext], MBTabbarProtocol);
    UIViewController *tabBarChildVC = [tabBarService getTabChildVC:url tabPageName:tabPageName];
    NSString *tabBarVCClassName = NSStringFromClass([tabBarChildVC class]);
    return tabBarVCClassName;
}

- (NSString *)getTabBarChildVCByIndex:(NSInteger)index {
    id<MBTabbarProtocol> tabBarService = BIND_SERVICE([YMMRouterModule getContext], MBTabbarProtocol);
    UIViewController *tabBarChildVC = [tabBarService getTabChildVCByIndex: index];
    NSString *tabBarVCClassName = NSStringFromClass([tabBarChildVC class]);
    return tabBarVCClassName;
    return nil;
}


@end
