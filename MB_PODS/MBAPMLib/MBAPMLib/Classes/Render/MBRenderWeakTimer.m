//
//  MBRenderWeakTimer.m
//  AliyunOSSiOS
//
//  Created by seal on 2020/4/20.
//

#import "MBRenderWeakTimer.h"

@interface MBRenderWeakTimer()

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, strong) dispatch_queue_t privateSerialQueue;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation MBRenderWeakTimer

#pragma mark -- lifeCycle method
- (id)init
{
    return [self initWithTimeInterval:0
                                start:0
                               target:nil
                             selector:NULL
                             userInfo:nil
                              repeats:NO];
}

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval
                     start:(NSTimeInterval)startTimeInterval
                    target:(id)target
                  selector:(SEL)selector
                  userInfo:(id)userInfo
                   repeats:(BOOL)repeats
{
    NSParameterAssert(target);
    NSParameterAssert(selector);

    if ((self = [super init]))
    {
        self.timeInterval = timeInterval;
        self.startTimeInterval = startTimeInterval;
        self.target = target;
        self.selector = selector;
        self.userInfo = userInfo;
        self.repeats = repeats;

        NSString *privateQueueName = [NSString stringWithFormat:@"com.mb.performance.render.%p", self];
        self.privateSerialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                            0,
                                            0,
                                            self.privateSerialQueue);
    }
    return self;
}

- (void)dealloc
{
    [self invalidate];
}


#pragma mark -- public method
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                         start:(NSTimeInterval)startTimeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats {
    MBRenderWeakTimer *timer = [[self alloc] initWithTimeInterval:timeInterval
                                                      start:startTimeInterval
                                                     target:target
                                                   selector:selector
                                                   userInfo:userInfo
                                                    repeats:repeats];

    [timer schedule];

    return timer;
}

- (void)invalidate
{
    if(self.timer) {
        __block dispatch_source_t timer = self.timer;
        dispatch_async(self.privateSerialQueue, ^{
            if(timer) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
        });
    }
}

#pragma mark -- private method
- (void)resetTimerProperties
{
    int64_t intervalInNanoseconds = (int64_t)(self.timeInterval * NSEC_PER_SEC);
    int64_t startTimeInNanoseconds = (int64_t)(self.startTimeInterval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, startTimeInNanoseconds),
                              (uint64_t)intervalInNanoseconds,
                              0
                              );
}

- (void)schedule
{
    if(!self.timer) {
        return;
    }
    [self resetTimerProperties];
    __weak MBRenderWeakTimer *weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerFired];
    });
    dispatch_resume(self.timer);
}

- (void)timerFired
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.userInfo];
    #pragma clang diagnostic pop
    if (!self.repeats)
    {
        [self invalidate];
    }
}

@end
