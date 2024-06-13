//
//  MBAPMDataMonitor.m
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import "MBAPMDataMonitor.h"
#import "MBAPMDataModel.h"
#import "MBAPMDataMonitor.h"
#import "MBAPMNetworkInterceptorManager.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMUrlUtil.h"
#import "MBAPMModel.h"
#import "MBAPMDataManager.h"
#import "MBAPMTrafficMetric.h"

@import YMMNetwork;
@import MBConfigCenterService;

@interface MBAPMDataMonitor () <MBAPMNetworkInterceptorManagerDelegate>
// 分钟间隔定时器
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic , strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger calculateInterval;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation MBAPMDataMonitor

+ (instancetype)sharedInstance {
    static MBAPMDataMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMDataMonitor alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.network.traffic", DISPATCH_QUEUE_SERIAL);
        _timerCount = 0;
        _calculateInterval = 600;
        id <MBConfigCenterProtocol> service = BIND_SERVICE(nil, MBConfigCenterProtocol);
        if ([service respondsToSelector:@selector(getIntegerConfig:key:defaultValue:)]) {
            _calculateInterval = [service getIntegerConfig:@"other" key:@"net_trffic_collect_interval" defaultValue:600];
        }
    }
    return self;
}

- (void)initData {
    [[MBAPMNetworkInterceptorManager shareInstance] addDelegate:self];
    // 上报前一天的数据
    [MBAPMDataManager sharedInstance].uploadTraffic = ^(MBAPMDataModel * _Nonnull model) {
        [self uploadTrafficWithModel:model];
    };
    
    // 上报上次流量数据 - 延迟操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self uploadLastCacheData];
    });
}

#pragma mark - MBAPMPluginProtocol

- (void)start {
    [super start];
    
    if (self.trafficConfig.isEnable) {
        [self initData];
        [self startTimer];
    }
}

- (void)startTimer {
    [self invalidate];
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC );
    dispatch_source_set_event_handler(_timer, ^{
        self->_timerCount++;
//        MBModuleDebug("MBAPMLib", @"流量 - %ld",(long)self->_timerCount);
        if (self->_timerCount % self->_calculateInterval == 0) {
            [self dealwithTrafficData];
        }
    });
    dispatch_resume(_timer);
}

- (void)invalidate {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - 流量处理

- (void)dealwithTrafficData {
    dispatch_async(_queue, ^{
        // 单次进程 - 磁盘储存当前流量
        // 天流量 - 磁盘储存当前流量
        [[MBAPMDataManager sharedInstance] cacheTraffic];
    });
    // 10 分钟流量 - 进行上报
    [self uploadTrafficWithModel:[[MBAPMDataManager sharedInstance] lastMinData]];
}

#pragma mark - 数据上报

- (void)uploadLastCacheData {
    // 进程
    MBAPMDataModel *model = [[MBAPMDataManager sharedInstance] lastProcessData];
    if (model && model.sumTraffic) {
        [self uploadTrafficWithModel:model];
    }
    // 天
    [[MBAPMDataManager sharedInstance] readCacheDayData];
}

- (void)uploadTrafficWithModel:(MBAPMDataModel *)model {
    MBAPMTrafficMetric *metric = [[MBAPMTrafficMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeTrffic;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = model.sumTraffic;
    metric.metricName = @"app.traffic";
    
    NSString *type = @"";
    NSUInteger TPM = 0;
    if (model.type == MBAPMDataModelTypeProcess) {
        type = @"process";
        TPM = model.sumTraffic / model.calculationPeriod;
    } else if (model.type == MBAPMDataModelTypeDay) {
        type = @"daily";
        TPM = model.sumTraffic / model.calculationPeriod;
    } else if (model.type == MBAPMDataModelTypeMin) {
        type = @"periodic";
        TPM = model.sumTraffic;
    }
    metric.tags = @{
        @"type": type,
        @"sdk_ver": @(1) // 功能版本号
    };
    NSDictionary *metricSections = @{
        @"TPM": @(TPM),
        @"FG": @(model.foregroundSumTraffic),
        @"BG": @(model.backgroundSumTraffic),
        @"TX": @(model.upSumTraffic),
        @"RX": @(model.downSumTraffic),
        @"wifi": @(model.wifiSumTraffic),
        @"mobile": @(model.mobileSumTraffic)
    };
    metric.metricSections = metricSections;
    metric.atts = @{
        @"formatted_traffic": [MBAPMUrlUtil formatByte:model.sumTraffic]
    };
    [self reportMetrics:metric];
    MBModuleDebug("MBAPMLib", @"流量 - 上报数据 type:%@ sections: %@", type,  metricSections);
}

#pragma mark - MBAPMNetworkInterceptorManagerDelegate

- (BOOL)shouldIntercept {
    return self.trafficConfig.isEnable;
}

- (void)networkInterceptorDidReceiveData:(NSData *)data
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError *)error
                               startTime:(NSTimeInterval)startTime {
    YMMNetworkStatus status = [YMMNetworkStatusObserver sharedYMMNetworkStatusObserver].currentNetworkStatus;
    // 无网络,不收集
    if (status == YMMNetworkStatus_None) {
        return;
    }
    dispatch_async(_queue, ^{
        
        NSInteger upTraffic = [MBAPMUrlUtil getRequestLength:request];
        NSInteger downTraffic = [MBAPMUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:data];
        
        NetworkStatus networkStatus = NetworkStatusMobile;
        if (status == YMMNetworkStatus_Unknown) {
            networkStatus = NetworkStatusNone;
        } else if (status == YMMNetworkStatus_WiFi) {
            networkStatus = NetworkStatusWifi;
        }
        
        // 区分模型和技术栈后续再做处理
        
        // 组装模型
        MBAPMModel *model = [[MBAPMModel alloc] init];
        model.traffic = upTraffic + downTraffic;
        model.isForeground = [self isForeground];
        model.upTraffic = upTraffic;
        model.downTraffic = downTraffic;
        model.networkStatus = networkStatus;
        model.businessModule = BusinessModuleNone;
        model.stack = TechStackNone;
        // 收集流量
        [[MBAPMDataManager sharedInstance] updateTrafficModel:model];
    });
}

- (BOOL)isForeground {
    return [[MBAPMAppStateUtil shared] applicationState] == UIApplicationStateActive;
}

@end
