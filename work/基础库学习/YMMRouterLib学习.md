## YMMRouterLib

这是基于一套 URI 来实现移动端页面定位和页面跳转的技术。

借助于 URI 的跨平台通用性，同一套 URI 在 Android / iOS / Web 端均可被正确识别。URI 可由服务端生成并下发，达到服务端动态控制移动端页面跳转行为的目的。

依靠 Android / iOS 系统能力，还可达到截获 Web 端按钮链接从外部自动打开App内相应页面的功能（Deep Link）。

[接入文档](https://techface.amh-group.com/doc/1404)

### URI规则

### 接入

##### 注册路由, 路由跳转, 过滤器, 拦截器

实例：

```objc
// 1. 注册scheme 和 host
YMMRouter *fRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm"]                                     hostPattern:@"dynamicflutter"];
// 2. 注册path
/* 
path及其回调的对应关系由YMMRouterTable进行维护，并且不同的path可以注册不同的回调，同时YMMRouterTable也提供了三种不同的回调方式：
    delegate模式
    block模式
    target-action模式
*/
//delegate模式实现
YMMRouterTable *table = [[YMMRouterTable alloc] init];
ThreshRouterHandler *handler = [[ThreshRouterHandler alloc] init];
[table registerHandler:handler forPathPattern:@"^/\\S+$"];//path注册支持正则表达式，注意正则表达式需要包含^和$
[fRouter addRouterTable:table];

// YMMRouter内置了默认routerTable，也可以直接通过ymmrouter注册path
/*
路由请求匹配到之后会分发到对应handler、block或者action，注册方可以在回调中获取到路由参数，并返回对应的处理结果，大部分场景下返回ViewController。handler支持同步和异步返回结果，block和action均只支持异步。

YMMRouterHandlerProtocol：同步返回结果；

YMMRouterAsyncHandlerProtocol：通过callback异步返回结果。
*/


// router 注册
@moduleEX(YMMUserModule)

- (NSArray<YMMRouter *> *)routers {
    YMMRouter *userRouter = [[YMMRouter alloc] initWithSchemes:@[@"ymm", @"ymm-driver", @"ymm-yy", @"ymm-consignor",@"wlqq"]
                                                   hostPattern:@"user"];
    YMMRouterTable *userTable = [[YMMRouterTable alloc] init];
    YMMUserSyncRouterHandler *syncHandler = [[YMMUserSyncRouterHandler alloc] init];
    
    [userTable registerHandler:syncHandler forPathPattern:@"/login"];
    [userTable registerHandler:syncHandler forPathPattern:@"/secure"];
    [userTable registerHandler:syncHandler forPathPattern:@"/financialLogin"];
    [userTable registerHandler:syncHandler forPathPattern:@"/about"];
    [userTable registerHandler:syncHandler forPathPattern:@"/settingmore"];
    [userTable registerHandler:syncHandler forPathPattern:@"/changeAccount"];
 
    [userRouter addRouterTable:userTable];
    
    return @[userRouter];
};



@end

  
//handler 处理
@implementation YMMUserSyncRouterHandler

- (id)handle:(id<YMMRouterRoutable>)routable {
    
    NSString *path = routable.path;
    NSDictionary *params = routable.params;
   if ([path isEqualToString:@"/about"]) {//关于我们
        if (NSClassFromString(@"MBNewAboutUsVC") != nil) {
            return [[NSClassFromString(@"MBNewAboutUsVC") alloc] init];
        }
    return nil;
}
  
- (id)handle:(id<YMMRouterRoutable>)routable {
    if (!routable.isValid) {
        return nil;
    }
  NSString *path = [routable.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
  if ([path isEqualToString:@"pathA"]) {
    ...
  } else if ([path isEqualToString:@"pathB"]) {
    ...
  } else {
    ...
  }
}

 // 过滤器
ThreshRouterRedirectFilter *redirectFilter = [ThreshRouterRedirectFilter new];
[[YMMRouterCenter shared] addFilter:redirectFilter];
  
  //拦截器 拦截器主要用于在路由请求处理前（filter和match流程前）和处理后（filter和match流程后）两个时机添加切面代码，比如埋点。
  #pragma mark - YMMRouterCenterInterceptorProtocol

- (BOOL)routerShouldHandle:(id<YMMRouterRoutable>)routable {
    [self saveUTM:routable.params];
    if (routable.isValid) {
        NSString *urlString = [NSString stringWithFormat:@"%@://%@%@", routable.scheme, routable.host, routable.path];
        if (![self.cacheURLForLogArray containsObject:urlString]) {
            [self.cacheURLForLogArray addObject:urlString];
            [MBDoctorUtil techWithModel:@"route_doing"
                                 scenario:urlString
                                 extraDic:nil];
        }
        return YES;
    }
    return NO;
}

- (void)routerDidHandle:(id<YMMRouterRoutable>)routable
               response:(YMMRouterResponse *)response {
    if (response.status != YMMRouterStatusSuccess
        && response.status != YMMRouterStatusRedirect) {
        if (response.status == YMMRouterStatusLowVersion || response.status == YMMRouterStatusLowVersionRN) {
            response.result = [YMMRouterErrorViewController pageWithPage:YMMRouterErrorPageTypeLowVersion urlString:routable.urlString];
        } else {
            response.result = [YMMRouterErrorViewController pageWithPage:YMMRouterErrorPageTypeNotFound urlString:routable.urlString];
        }
        //路由失败监控
        MBDoctorEventError *errorEvent = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble];
        errorEvent.feature = [NSString stringWithFormat:@"Router error: url = %@, status = %lu", routable.urlString, (unsigned long)response.status];
        errorEvent.tag = @"RouterError";
        errorEvent.ext = @{@"url": routable.urlString?:@"", @"status": @(response.status)};
        id<MBDoctorServiceProtocol> doctor = BIND_SERVICE([YMMRouterModule getContext], MBDoctorServiceProtocol);
        [doctor doctor:errorEvent];
    }
    if (response.status == YMMRouterStatusSuccess) {
        [self saveSource:routable params:routable.params routerResult:response.result];
        [self saveReferSPM:routable params:routable.params routerResult:response.result];
    }
}
```





