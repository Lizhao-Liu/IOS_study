### MBNetworkLib

[文档](http://static.ymm56.com/tech-face-new/doc/19)



request

agent

response

MBBaseNetworkConfig： 默认配置sharedInstance

MBBaseNetworkModel: 继承了这个类的类 支持按照说明的方式进行编码和解码。数据流可以持久化到硬盘。

MBBaseNetworkDefine: 一些宏定义







使用：

1. 生成`MBBaseNetworkRequest`

   ```objc
   MBGNetworkRequest *request = [[MBGNetworkRequest alloc] init];
   HCBGNetworkRequest *request = [[HCBGNetworkRequest alloc] init];
   //MBGNetworkRequest and HCBGNetworkRequest inherits MBBaseNetworkRequest
   request.path = @"";
   request.baseUrl = @"";
   request.params = @{};
   request.method = MBBaseNetworkRequestMethodPOST;
   /**
    请求发起的业务线/基础域的组件名称，适用于数据报表统计区分
    必填
    */
   request.moduleName = @"xxx";
   /**
    请求发起的业务线/基础域的组件版本，适用于数据报表统计区分
    必填
    */
   request.moduleVersion = @"0.1.0";
     
   typedef NS_ENUM(NSUInteger, MBBaseNetworkRequestMethod) {
       MBBaseNetworkRequestMethodPOST = 0,
       MBBaseNetworkRequestMethodGET,
       MBBaseNetworkRequestMethodHEAD,
       MBBaseNetworkRequestMethodPUT,
       MBBaseNetworkRequestMethodDELETE,
       MBBaseNetworkRequestMethodPATCH,
   };
   ```

2. 执行请求

   ```objc
   [request startWithSuccess:^(__kindof MBNetworkResponse * _Nonnull response) {} failure:^(__kindof MBNetworkResponse * _Nonnull response) {}]
   
   
   
   
   [request stop]; //暂停
   
   
   @interface MBBaseNetworkResponse : NSObject
   /// 原始 resposne
   @property (nonatomic, strong) NSHTTPURLResponse *response;
   /// 原始数据
   @property (nonatomic, strong, nullable) id responseOriginalObject;
   /// 原始的 error
   @property (nonatomic, strong) NSError *error;
   /// 请求成功的错误信息
   @property (nonatomic,  copy) NSString *errorMsg;
   /// 状态码
   @property (nonatomic, readonly) NSInteger responseStatusCode;
   /// response header
   @property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;
   /// response data
   @property (nonatomic, strong, nullable) NSData *responseData;
   /// json
   @property (nonatomic, strong, nullable) id responseJSONObject;
   /// 模型解码结果 为responseModelClass的实例
   @property (nonatomic, strong, nullable) id decoderObj;
   /// 自定义 error 对象
   @property (nonatomic, strong, nullable) id errorObj;
   
   @end
   ```





- agent类：

  里面有对session manager的配置，避免重复初始化单例，所有请求添加给sharedInstance，处理回调或者相应的delegate

  自动开启任务

- Request类：
  作为网络请求，自定义请求的参数，
- Response类：
  作为对于网络请求后，响应的数据，包括对Error的处理（AF的，接口返回的）等等





request：

入口：

```objc
- (void)startWithSuccess:(nullable MBBaseNetworkRequestSuccessBlock)success
                 failure:(nullable MBBaseNetworkRequestFailureBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)start {
    [[MBBaseNetworkAgent sharedInstance] addRequest:self];
}
```

##### request

1. init： 通过MBBaseNetworkConfig sharedInstance执行默认配置， 配置在request上
2. 给request增加success block 和 failure block
3. 执行`[[MBBaseNetworkAgent sharedInstance] addRequest:**self**];`



##### MBBaseNetworkAgent: 

##### 代理. addRequest 方法内部：

1. 分发 plugin prepare ？？？

2. 构造url request

   获取 requestSerializer `AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithSerializationType:request.requestSerializationType];`

   获取http method `NSString *httpMehtod = [self requestMethodType:request.method];`

   分别处理上传，下载，其他的http方式，根据所获 requestSerializer创建`NSMutableURLRequest *urlRequest`

   根据所自定义配置的request.httpHeaderFields 添加到urlrequest上

   配置urlrequest.HTTPBody

3. 构造session manager

   默认configuration生成manager，

   私有属性 configuration 自定义配置completionQueue，responseSerializer，requestSerializer，securityPolicy.allowInvalidCertificates，securityPolicy.validatesDomainName

4. 构造data task， uploadProgress， downloadprogress, completionhandler

5. 分发 plugin willSend？？？

6. 发起请求 [request.dataTask resume];

```objc
@interface MBBaseNetworkAgent : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

/// 添加 request 到执行队列
- (void)addRequest:(MBBaseNetworkRequest *)request;

///  取消 request
- (void)cancelRequest:(MBBaseNetworkRequest *)request;

///  取消所有的 request
- (void)cancelAllRequests;

@end
```



封装`AFHTTPSessionManager` session

通过requestSerializer 获取url request

```objc
AFHTTPRequestSerializer *requestSerializer = [self requestSerializerWithSerializationType:request.requestSerializationType]; //自定义serializer


urlRequest = [requestSerializer multipartFormRequestWithMethod:httpMehtod URLString:urlString parameters:request.params constructingBodyWithBlock:request.constructingBodyBlock error:&e];
```





### 拦截器 Interceptor

只需要实现 *MBNetworkInterceptDelegate* 协议即可实现自定义拦截功能，

- 支持请求阶段时机拦截
- 支持响应阶段时机拦截
- 支持拦截器链执行优先级
- 支持拦截器自定义修改请求相关实例所有属性
- 无需显式代码注册拦截器



#### Todo:

- [ ] 解析部分逻辑和使用 学完yymodel补充
- [ ] 工具类内容 比如reachability， dns优化，cache， 安全， 日志等
- [ ] 进阶类内容 调度器 拦截器