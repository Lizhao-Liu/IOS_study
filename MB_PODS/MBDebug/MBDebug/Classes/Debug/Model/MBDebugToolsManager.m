//
//  MBDebugToolsManager.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugToolsManager.h"
#import "MBDebugToolModel.h"
@import YMMModuleLib;
@import MBDebugService;


@protocol mb_DoraemonKitTempProtocol <NSObject>
+ (id)sharedInstance;
- (void)install;
- (void)hiddenDoraemon;
- (void)saveMemoryLeak:(BOOL)newV;
- (void)saveMemoryLeakAlert:(BOOL)newV;
@end

@interface MBDebugToolsManager ()

@property (nonatomic, strong) NSMutableArray *currentDebugTools;

@end

@implementation MBDebugToolsManager

DEFINE_SINGLETON_FOR_CLASS(MBDebugToolsManager)

- (instancetype)init{
    self = [super init];
    if (self) {
        _currentDebugTools = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)debugTools {
    return self.currentDebugTools;
}

- (void)installDebugTools {
    NSArray<id<MBDebugServiceProtocol>> *serviceList = (NSArray<id<MBDebugServiceProtocol>> *)[[MBService shared] servicesForProtocol:@protocol(MBDebugServiceProtocol) fromContext:nil];
    if (serviceList) {
        for (id<MBDebugServiceProtocol> service in serviceList) {
            if (service) {
                MBDebugToolModel *model = [[MBDebugToolModel alloc] init];
                model.itemTitle = service.itemTitle;
                model.summary = service.summary;
                model.handleBlock = service.handleBlock;
                [self.currentDebugTools addObject:model];
            }
        }
    }
    [self sortDebugTools];
    [self setUpDefaultTools];
}

- (void)sortDebugTools {
    if (self.currentDebugTools.count > 1) {
        NSArray *debugItems = [self.currentDebugTools sortedArrayUsingFunction:titleSort context:NULL];
        [self.currentDebugTools removeAllObjects];
        [self.currentDebugTools addObjectsFromArray:debugItems];
    }
}
    
NSInteger titleSort(id obj1, id obj2, void *context) {
    MBDebugToolModel *model1, *model2;
    model1 = (MBDebugToolModel *)obj1;
    model2 = (MBDebugToolModel *)obj2;
    return [model1.itemTitle localizedCompare:model2.itemTitle];
}

- (void)setUpDefaultTools {
    Class DoraemonManagerClass = NSClassFromString(@"DoraemonManager");
    if (DoraemonManagerClass) {
        // 初始化DoraemonKit
        [[DoraemonManagerClass shareInstance] install];
        [[DoraemonManagerClass shareInstance] hiddenDoraemon];
    }
#if TARGET_OS_SIMULATOR
#else
    Class DoraemonCacheManagerClass = NSClassFromString(@"DoraemonCacheManager");
    if (DoraemonCacheManagerClass) {
        // 内存监控切换到 Doraemon，默认跟之前配置一样，打开了内存监控的弹窗
        [[DoraemonCacheManagerClass sharedInstance] saveMemoryLeak: YES];
        [[DoraemonCacheManagerClass sharedInstance] saveMemoryLeakAlert: YES];
    }
#endif
}

@end
