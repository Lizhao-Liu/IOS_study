//
//  MBDebugMonitorLogDataSource.m
//  MBDebug
//
//  Created by Lizhao on 2023/7/10.
//

#import "MBDebugMonitorLogDataSource.h"
#import "MBDebugMonitorDefine.h"
#import "MBDebugMonitorLogQueue.h"
#import "MBDebugMonitorLogChildDataSourceModel.h"
#import "MBDebugDefine.h"
#import "MBDebugAlertStateManager.h"
#import "MBDebugMonitorEventAlertModel.h"
#import "UIViewController+MBDebug.h"
@import MBCommonUILib;
@import MBDoctorService;

NSInteger const DefaultMaxLogLimit = 1000;

@interface MBDebugMonitorLogDataSource ()

@property(nonatomic, strong) MBDebugMonitorLogQueue *logDataQueue;

@property(nonatomic, strong) NSMutableArray<MBDebugMonitorLogChildDataSourceModel *> *childDataSourceArr;

@property (nonatomic, copy) NSString *monitorTitle;

@property (nonatomic,strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, MBDebugMonitorPageInfoModel *>*> *pageInfoDict;

@end

@implementation MBDebugMonitorLogDataSource {
    dispatch_semaphore_t _semaphore;
}

@synthesize allErrorObjects;
@synthesize allObjects;
@synthesize countLimit;
@synthesize childDataSources;
@synthesize canRecieveData;

- (instancetype)initWithMonitorTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
        _childDataSourceArr = [NSMutableArray array];
        _pageInfoDict = @{}.mutableCopy;
        countLimit = DefaultMaxLogLimit;
        _monitorTitle = title;
        canRecieveData = YES;
    }
    return self;
}

- (void)registerChildDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)childDataSource
                      predicate:(BOOL (^)(id object))predicate
                      formatter:(id<MBDebugMonitorLogObject> (^)(id object))formatter {
    MBDebugMonitorLogChildDataSourceModel *model = [MBDebugMonitorLogChildDataSourceModel modelWithDataSource:childDataSource predicate:predicate formatter:formatter];
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [self updateChildDataSource:model];
    [_childDataSourceArr addObject:model];
    dispatch_semaphore_signal(_semaphore);
}

- (void)updateChildDataSource:(MBDebugMonitorLogChildDataSourceModel *)dataSourceModel {
    NSArray *logObjects = [self.logDataQueue allLogObjects];
    [logObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(dataSourceModel.predicateBlock && dataSourceModel.predicateBlock(obj)){
            [dataSourceModel.dataSource addObject:dataSourceModel.formatterBlock(obj)];
        }
    }];
}

- (void)unregisterChildDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)childDataSource {
    NSMutableArray *dataSourceToRemove = [NSMutableArray array];

    for (MBDebugMonitorLogChildDataSourceModel *dataSourceModel in _childDataSourceArr) {
        if (dataSourceModel.dataSource == childDataSource) {
            [dataSourceToRemove addObject:dataSourceModel];
        }
    }

    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_childDataSourceArr removeObjectsInArray:dataSourceToRemove];
    dispatch_semaphore_signal(_semaphore);
}


- (NSArray<id<MBDebugMonitorLogDataSourceProtocol>> *)childDataSources {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSArray *childDataSources = _childDataSourceArr.copy;
    dispatch_semaphore_signal(_semaphore);
    return childDataSources;
}

- (id<MBDebugMonitorLogObject>)addLogObject:(id<MBDebugMonitorLogObject>)object {
    
    __block id<MBDebugMonitorLogObject> handledObject = object;
    
    // 1. 检查是否在子datasource中处理
    BOOL handledByChildDataSource = NO;
    for(MBDebugMonitorLogChildDataSourceModel *dataSourceModel in [_childDataSourceArr copy]){
        if (dataSourceModel.predicateBlock && dataSourceModel.predicateBlock(object)){
            //如果满足条件，则将对象通过formatterBlock进行数据格式化，并将格式化后的对象添加到子数据源的数据源数组中
            handledObject = dataSourceModel.formatterBlock(object);
            [dataSourceModel.dataSource addObject:handledObject];
            handledByChildDataSource = YES;
            break;
        }
    }
    
    // 2. 子datasource中未处理，在本身的datasource处理
    if(!handledByChildDataSource && canRecieveData){
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [self.logDataQueue enqueue:object];
        [self updateAlertStateWithObject:object];
        [self updatePageInfosWithObject:object];
        dispatch_semaphore_signal(_semaphore);
    }
    
    return handledObject;
}


- (void)addObject:(id<MBDebugMonitorLogObject>)object {
    dispatch_async(dispatch_queue_create("com.MBDebugMonitorDataSource.serialQueue", DISPATCH_QUEUE_SERIAL), ^{
        [self addLogObject:object];
    });
}

- (void)removeObjects:(NSArray<id<MBDebugMonitorLogObject>> *)objects{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [self.logDataQueue removeObjects:objects];
    if(![self hasErrorObject]){
        [self hideRedDotAlert];
    }
    dispatch_semaphore_signal(_semaphore);
}

- (void)clear {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [self.logDataQueue clear];
    [self hideRedDotAlert];
    dispatch_semaphore_signal(_semaphore);
}


- (NSArray<id<MBDebugMonitorLogObject>> *)allObjects {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSArray *allObjects = [self.logDataQueue allLogObjects];
    // 倒序返回数据
    NSArray *sequencedLogObjects = [[allObjects reverseObjectEnumerator] allObjects];
    dispatch_semaphore_signal(_semaphore);
    return sequencedLogObjects;
}

- (NSArray<id<MBDebugMonitorLogObject>> *)allErrorObjects {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    // 倒序返回数据
    NSArray *allErrorObjects = [[[self.logDataQueue allErrorObjects] reverseObjectEnumerator] allObjects];
    dispatch_semaphore_signal(_semaphore);
    return allErrorObjects;
}

- (MBDebugMonitorLogQueue *)logDataQueue {
    if(!_logDataQueue){
        _logDataQueue = [MBDebugMonitorLogQueue loopQueueWithCapacity:countLimit];
    }
    return _logDataQueue;
}

- (void)updatePageInfosWithObject:(id<MBDebugMonitorLogObject>)object {
    // datasource内部监听到页面信息数据，通过字典 - key为pageName - 缓存
    if([object respondsToSelector:@selector(pageInfoModel)] && [object pageInfoModel]){
        NSString *pageName = [object locatorModel].pageName;
        if(pageName){
            MBDebugMonitorPageInfoModel *pageInfo = [object pageInfoModel];
            if([_pageInfoDict containsObjectForKey:pageName]){
                NSMutableDictionary *dict = [_pageInfoDict objectForKey:pageName];
                [dict setObject:pageInfo forKey:pageInfo.sectionTitle];
                [_pageInfoDict setObject:dict forKey:pageName];
            } else {
                NSMutableDictionary *dict = @{pageInfo.sectionTitle : pageInfo}.mutableCopy;
                [_pageInfoDict setObject:dict forKey:pageName];
            }
        }
    }
}

- (void)updateAlertStateWithObject:(id<MBDebugMonitorLogObject>)object {
    if([object isErrorObject]){
        [self showRedDotAlert];
    } else {
        if(![self hasErrorObject]){
            [self hideRedDotAlert];
        }
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        if([object respondsToSelector:@selector(toastAlert)]){
            [self showToastAlertWithMsg:[object toastAlert]];
        }
        if([object respondsToSelector:@selector(dialogAlert)]){
            [self showAlert: [object dialogAlert]];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([object respondsToSelector:@selector(toastAlert)]){
                [self showToastAlertWithMsg:[object toastAlert]];
            }
            if([object respondsToSelector:@selector(dialogAlert)]){
                [self showAlert: [object dialogAlert]];
            }
        });
    }
}

- (void)showRedDotAlert {
    [[MBDebugAlertStateManager sharedMBDebugAlertStateManager] showRedDot:self];
}

- (void)hideRedDotAlert {
    [[MBDebugAlertStateManager sharedMBDebugAlertStateManager] hideRedDot:self];
}


- (BOOL)hasErrorObject {
    return self.logDataQueue.errorObjectCount != 0;
}

- (void)showToastAlertWithMsg:(NSString *)msg {
    if([MBDebugAlertStateManager sharedMBDebugAlertStateManager].isToastAlertDisabled){
        return;
    }
    if(!msg){
        return;
    }
    [MBProgressHUD showToastAddedTo:[[UIApplication sharedApplication].delegate window] imageName:nil labelText:msg];
}

- (void)showAlert:(MBDebugMonitorAlertDialog *)dialogAlert {
    if(!dialogAlert){
        return;
    }
    
    NSString *title = dialogAlert.title ?: @"debug 异常监听";
    NSString *content = dialogAlert.content;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    // 默认按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    if(dialogAlert.buttons && dialogAlert.buttons.count > 0){
        for(MBDebugMonitorAlertDialogButton *btn in dialogAlert.buttons){
            UIAlertAction *action = [UIAlertAction actionWithTitle:btn.btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                btn.btnAction();
            }];
            [alertController addAction:action];
        }
    }
    [alertController addAction:cancelAction];
    [[UIViewController mb_currentViewController] presentViewController:alertController animated:NO completion:nil];
}

- (NSArray<MBDebugMonitorPageInfoModel *> *)pageInfosWithPageVC:(UIViewController *)pageVC {
    NSString *pageName = [pageVC getJournalPageName];
    NSMutableDictionary *dict = [self.pageInfoDict objectForKey:pageName];
    return dict.allValues;
}

@end


