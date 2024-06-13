//
//  MBAPMURLSessionDemux.m
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import "MBAPMURLSessionDemux.h"

@import MBFoundation;
@import MBLogLib;
@import MBDoctorService;

@interface MBAPMURLSessionDemuxTaskInfo : NSObject

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@property (atomic, strong, readonly ) NSURLSessionDataTask *        task;
@property (atomic, strong, readonly ) id<NSURLSessionDataDelegate>  delegate;
@property (atomic, strong, readonly ) NSThread *                    thread;
@property (atomic, copy,   readonly ) NSArray *                     modes;

- (void)performBlock:(dispatch_block_t)block;

- (void)invalidate;

@end

@interface MBAPMURLSessionDemuxTaskInfo ()

@property (atomic, strong, readwrite) id<NSURLSessionDataDelegate>  delegate;
@property (atomic, strong, readwrite) NSThread *                    thread;

@end

@implementation MBAPMURLSessionDemuxTaskInfo

- (instancetype)initWithTask:(NSURLSessionDataTask *)task delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes
{
    NSAssert(task != nil, @"task can not be nil");
    NSAssert(delegate != nil, @"delegate can bot be nil");
    NSAssert(modes != nil, @"modes can not be nil");
    
    self = [super init];
    if (self != nil) {
        self->_task = task;
        self->_delegate = delegate;
        self->_thread = [NSThread currentThread];
        self->_modes = [modes copy];
    }
    return self;
}

- (void)performBlock:(dispatch_block_t)block
{
    NSAssert(self.delegate != nil, @"delegate can not be nil");
    NSAssert(self.thread != nil, @"thread can not be nil");
    [self performSelector:@selector(performBlockOnClientThread:) onThread:self.thread withObject:[block copy] waitUntilDone:NO modes:self.modes];
}

- (void)performBlockOnClientThread:(dispatch_block_t)block
{
    NSAssert([NSThread currentThread] == self.thread, @"thread is error");
    block();
}

- (void)invalidate
{
    self.delegate = nil;
    self.thread = nil;
}

@end


@interface MBAPMURLSessionDemux() <NSURLSessionDataDelegate>

@property (atomic, strong, readonly ) NSMutableDictionary *taskInfoByTaskID;
@property (atomic, strong, readonly ) NSOperationQueue *sessionDelegateQueue;

@end

@implementation MBAPMURLSessionDemux

- (instancetype)init{
    return [self initWithConfiguration:nil];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super init];
    if (self != nil) {
        if (configuration == nil) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self->_configuration = [configuration copy];
        
        self->_taskInfoByTaskID = [[NSMutableDictionary alloc] init];
        
        self->_sessionDelegateQueue = [[NSOperationQueue alloc] init];
        [self->_sessionDelegateQueue setMaxConcurrentOperationCount:1];
        [self->_sessionDelegateQueue setName:@"MBAPMURLSessionDemux"];
        
        self->_session = [NSURLSession sessionWithConfiguration:self->_configuration delegate:self delegateQueue:self->_sessionDelegateQueue];
        self->_session.sessionDescription = @"MBAPMURLSessionDemux";
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes
{
    NSURLSessionDataTask *          task;
    MBAPMURLSessionDemuxTaskInfo *    taskInfo;
    
    NSAssert(request != nil, @"request can not be nil");
    NSAssert(delegate != nil, @"delegate can not be nil");
    
    
    if ([modes count] == 0) {
        modes = @[ NSDefaultRunLoopMode ];
    }
    
    task = [self.session dataTaskWithRequest:request];
    NSAssert(task != nil, @"task can not be nil");
    
    taskInfo = [[MBAPMURLSessionDemuxTaskInfo alloc] initWithTask:task delegate:delegate modes:modes];
    
    @synchronized (self) {
        self.taskInfoByTaskID[@(task.taskIdentifier)] = taskInfo;
    }
    
    return task;
}

- (MBAPMURLSessionDemuxTaskInfo *)taskInfoForTask:(NSURLSessionTask *)task{
    MBAPMURLSessionDemuxTaskInfo *result;
    
    NSAssert(task != nil, @"task can not be nil");
    
    @synchronized (self) {
        result = [self.taskInfoByTaskID mb_objectForKey:@(task.taskIdentifier)];
        NSAssert(result != nil, @"result can bot be nil, url: %@", task.currentRequest.URL.absoluteString);
    }
    return result;
}

#pragma mark -- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task willPerformHTTPRedirection:response newRequest:newRequest completionHandler:completionHandler];
        }];
    } else {
        completionHandler(newRequest);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    // 拦截测试环境的上传 url
    MBModuleContext *con = [[MBModuleContext alloc] initWithModuleName:@"APMModule"];
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(con, MBDoctorServiceProtocol);
    if (service && [service respondsToSelector:@selector(doctor:)]) {
        MBDoctorEventLog *logEvent = [[MBDoctorEventLog alloc] initWithPlatform:MBDoctorPlatformHubble];
        logEvent.message = [NSString stringWithFormat:@"流量上传拦截 oriUrl:%@, curUrl:%@", task.originalRequest.URL.absoluteString, task.currentRequest.URL.absoluteString];
        logEvent.level = MBDoctorEventLogLevelError;
        
        [service doctor:logEvent];
    }

    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:needNewBodyStream:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task needNewBodyStream:completionHandler];
        }];
    } else {
        completionHandler(nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:task];
    @synchronized (self) {
        [self.taskInfoByTaskID removeObjectForKey:@(taskInfo.task.taskIdentifier)];
    }
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session task:task didCompleteWithError:error];
            [taskInfo invalidate];
        }];
    } else {
        [taskInfo invalidate];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
        }];
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask didReceiveData:data];
        }];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    MBAPMURLSessionDemuxTaskInfo *taskInfo;
    
    taskInfo = [self taskInfoForTask:dataTask];
    if ([taskInfo.delegate respondsToSelector:@selector(URLSession:dataTask:willCacheResponse:completionHandler:)]) {
        [taskInfo performBlock:^{
            [taskInfo.delegate URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
        }];
    } else {
        completionHandler(proposedResponse);
    }
}


@end
