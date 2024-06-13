//
//  MBAPMNSURLProtocol.m
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import "MBAPMNSURLProtocol.h"
#import "MBAPMURLSessionDemux.h"
#import "MBAPMNetworkInterceptorManager.h"
#import "MBAPMUrlUtil.h"

@import YMMNetwork;

static NSString * const kAPMProtocolKey = @"apm_protocol_key";

@interface MBAPMNSURLProtocol() <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@property (atomic, strong, readwrite) NSThread *clientThread;
@property (atomic, copy,   readwrite) NSArray *modes;
@property (atomic, strong, readwrite) NSURLSessionDataTask *task;

@end

@implementation MBAPMNSURLProtocol
+ (MBAPMURLSessionDemux *)sharedDemux{
    static dispatch_once_t      sOnceToken;
    static MBAPMURLSessionDemux *sDemux;
    dispatch_once(&sOnceToken, ^{
        NSURLSessionConfiguration *config;
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
        sDemux = [[MBAPMURLSessionDemux alloc] initWithConfiguration:config];
    });
    return sDemux;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([NSURLProtocol propertyForKey:kAPMProtocolKey inRequest:request]) {
        return NO;
    }
    if (![MBAPMNetworkInterceptorManager shareInstance].shouldIntercept) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    //文件类型不作处理
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    if (contentType && [contentType containsString:@"multipart/form-data"]) {
        return NO;
    }
    
//    if ([self ignoreRequest:request]) {
//        return NO;
//    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kAPMProtocolKey inRequest:mutableReqeust];
    return mutableReqeust;
}

- (void)handleFromSelect{
    if(MBAPMWeakNetwork_Delay == [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate weakNetSelecte]){
        //此处有dispatch_get_main_queue，无法使用switch
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([[MBAPMNetworkInterceptorManager shareInstance].weakDelegate delayTime] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.task resume];
        });
    }else if(MBAPMWeakNetwork_WeakSpeed == [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate weakNetSelecte]){
        [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate handleWeak:[MBAPMUrlUtil getHttpBodyFromRequest:self.request] isDown:NO];
        [self.task resume];
    }else{
        [self.task resume];
    }
}

- (BOOL)needLoading{
    BOOL result = YES;
    if ([MBAPMNetworkInterceptorManager shareInstance].weakDelegate){
        if(MBAPMWeakNetwork_OutTime == [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate weakNetSelecte]){
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorTimedOut userInfo:nil]];
            result = NO;
        }else if(MBAPMWeakNetwork_Break == [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate weakNetSelecte]){
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil]];
            result = NO;
        }
    }
    return result;
}

- (void)startLoading{
    NSMutableURLRequest *   recursiveRequest;
    NSMutableArray *        calculatedModes;
    NSString *              currentMode;
    
    NSAssert(self.clientThread == nil, @"clientThread can not be nil");
    NSAssert(self.task == nil, @"task can not be nil");
    NSAssert(self.modes == nil, @"modes can not be nil");
    
    calculatedModes = [NSMutableArray array];
    [calculatedModes addObject:NSDefaultRunLoopMode];
    currentMode = [[NSRunLoop currentRunLoop] currentMode];
    if ( (currentMode != nil) && ! [currentMode isEqual:NSDefaultRunLoopMode] ) {
        [calculatedModes addObject:currentMode];
    }
    self.modes = calculatedModes;
    NSAssert([self.modes count] > 0, @"modes count errror");
    
    recursiveRequest = [[self request] mutableCopy];
    NSAssert(recursiveRequest != nil, @"recursiveRequest can not be nil");
    
    self.clientThread = [NSThread currentThread];
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.task = [[[self class] sharedDemux] dataTaskWithRequest:recursiveRequest delegate:self modes:self.modes];
    NSAssert(self.task != nil, @"task can not be nil");
    if([MBAPMNetworkInterceptorManager shareInstance].weakDelegate){
        [self handleFromSelect];
    }else{
        [self.task resume];
    }
}

- (void)stopLoading{
    NSAssert(self.clientThread != nil, @"clientThread can not be nil");
    NSAssert([NSThread currentThread] == self.clientThread, @"clientThread not match");
    [[MBAPMNetworkInterceptorManager shareInstance] handleResultWithData: self.data
                                                            response: self.response
                                                             request:self.request
                                                               error:self.error
                                                           startTime:self.startTime];
    
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSAssert([NSThread currentThread] == self.clientThread, @"clientThread not match");
    self.response = response;
    if([self needLoading]){
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSAssert([NSThread currentThread] == self.clientThread, @"clientThread not match");
    if ([MBAPMNetworkInterceptorManager shareInstance].weakDelegate) {
        if(MBAPMWeakNetwork_WeakSpeed == [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate weakNetSelecte]){
            
            [[MBAPMNetworkInterceptorManager shareInstance].weakDelegate handleWeak:data isDown:YES];
        }
    }
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSAssert([NSThread currentThread] == self.clientThread, @"clientThread not match");
    if (error) {
        self.error = error;
        [self.client URLProtocol:self didFailWithError:error];
    }else if([self needLoading]){
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSAssert([NSThread currentThread] == self.clientThread, @"clientThread not match");
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

// 去掉一些我们不关心的链接, 与UIWebView的兼容还是要好好考略一下
+ (BOOL)ignoreRequest:(NSURLRequest *)request{
    NSString *pathExtension = [request.URL.absoluteString pathExtension];
    //NSArray *blackList = @[@"",@"",@""];
    if (pathExtension.length > 0) {
        return YES;
    }
    return NO;
}


@end
