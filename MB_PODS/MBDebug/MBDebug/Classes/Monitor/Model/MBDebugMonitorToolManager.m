//
//  MBDebugMonitorToolManager.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugMonitorToolManager.h"
#import "MBDebugMonitorToolModel.h"
@import MBFoundation;
@import MBDebugService;
@import MBUIKit;

@interface MBDebugMonitorToolManager ()

@property (nonatomic, strong) NSMutableArray<MBDebugMonitorToolModel *> *currentMonitorTools;

@property (nonatomic, strong) NSMutableSet<NSString *> *currentMonitorTitles;

@property (nonatomic, strong) NSDictionary *keyMonitorTools;

@end

@implementation MBDebugMonitorToolManager

DEFINE_SINGLETON_FOR_CLASS(MBDebugMonitorToolManager)


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentMonitorTools = [[NSMutableArray alloc] init];
        _currentMonitorTitles = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)installMonitorTools {
    NSArray<id<MBDebugMonitorServiceProtocol>> *monitorToolsList = (NSArray<id<MBDebugMonitorServiceProtocol>> *)[[MBService shared] servicesForProtocol:@protocol(MBDebugMonitorServiceProtocol) fromContext:nil];
    if (monitorToolsList) {
        for (id<MBDebugMonitorServiceProtocol> monitorTool in monitorToolsList) {
            if (monitorTool) {
                NSAssert(![_currentMonitorTitles containsObject:monitorTool.title], @"add monitor tool fail: title【%@】already exists", monitorTool.title);
                if([monitorTool respondsToSelector:@selector(monitorToolDidLoad)]){
                    [monitorTool monitorToolDidLoad];
                }
                MBDebugMonitorToolModel *monitorModel = [[MBDebugMonitorToolModel alloc] init];
                monitorModel.title= monitorTool.title;
                monitorModel.monitorVCBlock = monitorTool.monitorVCBlock;
                monitorModel.monitorStatusBlock = ^BOOL{
                    return [monitorTool isMonitoring];
                };
                if([monitorTool respondsToSelector:@selector(pageInfoBlock)]){
                    // 协议实现类提供了当前页面数据获取block
                    monitorModel.pageInfoBlock = monitorTool.pageInfoBlock;
                }
                if([monitorTool respondsToSelector:@selector(monitorStatusChangedBlock)]){
                    // 协议实现类提供了切换监听开关回调block
                    monitorModel.monitorStatusChangedBlock = monitorTool.monitorStatusChangedBlock;
                }
                
                if([self.keyMonitorTools containsObjectForKey:monitorTool.title]){
                    monitorModel.priority = [[self.keyMonitorTools objectForKey:monitorTool.title] integerValue];
                } else {
                    monitorModel.priority = MBDebugMonitorToolPriorityNormal;
                }
                [self.currentMonitorTools addObject:monitorModel];
                [self.currentMonitorTitles addObject:monitorModel.title];
            }
        }
    }
    [self sortMonitorTools];
}

- (void)sortMonitorTools {
    if(self.currentMonitorTools.count > 1) {
        NSArray *monitorItems = [self.currentMonitorTools sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            MBDebugMonitorToolModel *model1, *model2;
            model1 = (MBDebugMonitorToolModel *)obj1;
            model2 = (MBDebugMonitorToolModel *)obj2;
            if(model1.priority < model2.priority){
                return (NSComparisonResult)NSOrderedDescending;
            } else if(model2.priority < model1.priority){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [self.currentMonitorTools removeAllObjects];
        [self.currentMonitorTools addObjectsFromArray:monitorItems];
    }
}

- (NSDictionary *)keyMonitorTools {
    return @{
        @"APM":@(MBDebugMonitorToolPriorityCritical),
        @"Network":@(MBDebugMonitorToolPriorityImportant),
        @"Router":@(MBDebugMonitorToolPriorityImportant),
        @"Bridge":@(MBDebugMonitorToolPriorityImportant),
        @"log":@(MBDebugMonitorToolPriorityImportant)
    };
}


- (NSArray *)monitorTools {
    return self.currentMonitorTools;
}




@end
