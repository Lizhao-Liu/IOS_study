//
//  MBAPMNetworkDateManager.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/5/8.
//

#import "MBAPMNetworkDateManager.h"
#import "MBAPMNetworkDateManager_Private.h"
#import "MBAPMNetworkInterceptor.h"
#import "MBAPMTimeUtil.h"

@interface MBAPMNetworkPageModel : NSObject
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, assign) BOOL isPageIn;
@property (nonatomic, assign) long long startTimestamp;
@end
@implementation MBAPMNetworkPageModel
@end

@interface MBAPMNetworkUrlModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) long long timestamp;
@property (nonatomic, assign) BOOL isStart;
@end
@implementation MBAPMNetworkUrlModel
@end

@interface MBAPMNetworkUrlReportModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) long long strartTimestamp;
@property (nonatomic, assign) long long endTimestamp;
@end
@implementation MBAPMNetworkUrlReportModel
@end


/// 取值流程
/// - 传入page name，从page url dic查询所有的url
/// - 传入page name，从page time dic 查询总的耗时
///
/// 收集流程
/// 大体流程如下，存在两个循环，循环一：15115115551515 循环二：23222333。
///
/// 1、start page 开始创建对象，存入page url dic
/// 2.1、发生 start url，如过在old dic 查询到进入2.2。未查询到，结束。
/// 2.2、start url 放入 dic value; 更新 page的开始请求时间。
/// 3.1、发生 end url，如过在old dic 查询到进入3.2。未查询到，结束。
/// 3.2、end url 放入 dic value; 更新 page的结束请求时间。
/// 4、到2，重复。
/// 5、end page 对 page url dic 的value 清理，清理没有调用end的，将数据存放old page url dic；处理和清理 old dic 的大小。
@interface MBAPMNetworkDateManager () {
    
    dispatch_queue_t _dataQueue;
    // 原始数据
    NSMutableArray<id> *_dataItems;
    // 页面信息
    NSMutableDictionary <NSString*, NSArray *> *_pageUrlInfoDic;
    NSMutableDictionary <NSString*, NSNumber *> *_pageTimeDic;
    NSMutableDictionary <NSString*, NSNumber *> *_pageBeginTimeDic;
    // 历史页面信息
    NSMutableDictionary <NSString*, NSSet<NSString *> *> *_oldPageUrlDic;
}

@end

@implementation MBAPMNetworkDateManager

+ (MBAPMNetworkDateManager *)sharedInstance {
    static MBAPMNetworkDateManager * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBAPMNetworkDateManager alloc] init];
    });
    return _manager;
}

// MARK: - interface
- (NSArray<NSDictionary *> *)urlsInfoOfThePageName:(NSString *)pageName {
    __block NSArray<NSDictionary *> *arr;
    dispatch_barrier_sync(_dataQueue, ^{
        arr = [_pageUrlInfoDic valueForKey:pageName];
        [_pageUrlInfoDic removeObjectForKey:pageName];
    });
    return arr ?: @[];
}

- (double)totalTimeOfThePageName:(NSString *)pageName {
    __block double time;
    dispatch_sync(_dataQueue, ^{
        time = [[_pageTimeDic valueForKey:pageName] doubleValue];
        [_pageTimeDic removeObjectForKey:pageName];
    });
    return time;
}

- (double)beginTimeOfThePageName:(NSString *)pageName {
    __block double time;
    dispatch_sync(_dataQueue, ^{
        time = [[_pageBeginTimeDic valueForKey:pageName] doubleValue];
        [_pageBeginTimeDic removeObjectForKey:pageName];
    });
    return time;
}

// MARK: - protocal

- (void)startUrl:(NSString *)url {
    dispatch_async(_dataQueue, ^{
        [self startUrlJob:url];
    });
}

- (void)endUrl:(NSString *)url {
    dispatch_async(_dataQueue, ^{
        [self endUrlJob:url];
    });
}

- (void)startPageLoadPageName:(NSString *)pageName {
    dispatch_async(_dataQueue, ^{
        [self startPageLoadPageNameJob:pageName];
    });
}

- (void)endPageLoadPageName:(NSString *)pageName {
    dispatch_async(_dataQueue, ^{
        [self endPageLoadPageNameJob:pageName];
    });
}

// MARK: - dic manager
- (void)startPageLoadPageNameJob:(NSString *)pageName {
    
    MBAPMNetworkPageModel *model = [[MBAPMNetworkPageModel alloc] init];
    model.pageName = pageName;
    model.isPageIn = YES;
    model.startTimestamp = [MBAPMTimeUtil currentTimestamp];
    [_dataItems addObject:model];
}

- (void)endPageLoadPageNameJob:(NSString *)pageName {
    //NSLog(@"😁end %@", pageName);
    // urls
    MBAPMNetworkPageModel *model = [[MBAPMNetworkPageModel alloc] init];
    model.pageName = pageName;
    model.isPageIn = NO;
    [_dataItems addObject:model];
    
    //处理一下url归属
    NSMutableArray *startUrls = [[NSMutableArray alloc] init];
    NSMutableSet *startUrlsSet = [[NSMutableSet alloc] init];
    NSMutableSet *endUrlsSet = [[NSMutableSet alloc] init];
    NSMutableDictionary *urlsEndTimestamp = [[NSMutableDictionary alloc] init];
    
    long long pageStartT = 0;
    NSUInteger index = 0;
    // 收集start信息，记录end时间戳
    for (id item in  [_dataItems reverseObjectEnumerator]) {
        index += 1;
        if ([item isKindOfClass: [MBAPMNetworkUrlModel class]]) {
            MBAPMNetworkUrlModel *url = (MBAPMNetworkUrlModel*)item;
            if (url.isStart) {
                [startUrls addObject:url];
                [startUrlsSet addObject:url.url];
            } else {
                [endUrlsSet addObject:url.url];
                [urlsEndTimestamp setValue:@(url.timestamp) forKey:url.url];
            }
        }
        
        if ([item isKindOfClass: [MBAPMNetworkPageModel class]]) {
            MBAPMNetworkPageModel *page = (MBAPMNetworkPageModel*)item;
            if (page.isPageIn == YES) {
                pageStartT = page.startTimestamp;
                break;
            }
        }
    }
    if (pageStartT == 0) {
        return;
    }
    //清理，保留最新50个
    NSUInteger len = _dataItems.count - 100;
    if (len > 0 && len < _dataItems.count) {
        [_dataItems removeObjectsInRange:NSMakeRange(0, len)];
    }
    
    // 和旧页面取交集，去重
    NSSet *oldUrlsSet = [_oldPageUrlDic valueForKey:pageName];
    if (oldUrlsSet && oldUrlsSet.count > 0) {
        [endUrlsSet intersectSet:oldUrlsSet];
    }
    
    long long startT = pageStartT;
    long long endT = 0;
    // 取结束时间，组合数据
    NSMutableArray *pageUrlsInfo = [[NSMutableArray alloc] init];
    for (MBAPMNetworkUrlModel *item in  [startUrls reverseObjectEnumerator]) {
        if ([endUrlsSet containsObject:item.url]) {
            if (startT == 0 && item.isStart) {
                startT = item.timestamp;
            }
            endT = [[urlsEndTimestamp valueForKey:item.url] longLongValue];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:item.url forKey:@"request_url"];
            if (endT > 0) {
                [dic setValue:@(endT - item.timestamp) forKey:@"request_duration"];
            }
            [dic setValue:@(item.timestamp - pageStartT) forKey:@"request_start"];
            [pageUrlsInfo addObject:dic];
        }
    }
    //保存
    long long duration = 0;
    if (startT > 0) {
        duration = endT - startT;
    }
    [_pageUrlInfoDic setValue:pageUrlsInfo forKey:pageName];
    [_pageTimeDic setValue:@(duration) forKey:pageName];
    [_pageBeginTimeDic setValue:@(startT) forKey:pageName];
    [startUrlsSet intersectSet:endUrlsSet];
    [_oldPageUrlDic setValue:startUrlsSet forKey:pageName];
    
}

- (void)startUrlJob:(NSString *)url {
    MBAPMNetworkUrlModel *model = [[MBAPMNetworkUrlModel alloc] init];
    model.url = url;
    model.isStart = YES;
    model.timestamp = [MBAPMTimeUtil currentTimestamp];
    [_dataItems addObject:model];
    
}

- (void)endUrlJob:(NSString *)url {
    MBAPMNetworkUrlModel *model = [[MBAPMNetworkUrlModel alloc] init];
    model.url = url;
    model.isStart = NO;
    model.timestamp = [MBAPMTimeUtil currentTimestamp];
    [_dataItems addObject:model];
    
}

// MARK: - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create("com.amh-group.mbapmlib.page_network.data", NULL);
        _dataQueue = queue;
        _dataItems = [[NSMutableArray alloc] init];
        _pageUrlInfoDic = [[NSMutableDictionary alloc] init];
        _pageTimeDic = [[NSMutableDictionary alloc] init];
        _pageBeginTimeDic = [[NSMutableDictionary alloc] init];
        _oldPageUrlDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
