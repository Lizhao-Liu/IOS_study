//
//  MBAPMDataExportManager.m
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import "MBAPMDataExportManager.h"
#import "MBAPMDataLog.h"
#import "MBAPMDataReport.h"
#import "MBAPMDataPrintHtml.h"
#import "MBAPMDataCache.h"
#import "MBAPMDataReportByJournal.h"
#import "MBAPMDataCache+DataExportChannel.h"

@interface MBAPMDataExportManager()

@property (nonatomic, strong) NSMutableArray<id<MBAPMDataExportProtocol>> *dataExportTools;

@end

@implementation MBAPMDataExportManager

#pragma mark - public method
- (instancetype)initWithContext:(MBAPMContext *)context {
    self = [super init];
    if(self) {
        [self buildTools:context];
    }
    return self;
}

- (void)exportMetricData:(MBAPMMetric *)metric {
    for(id<MBAPMDataExportProtocol> tool in _dataExportTools) {
        if([tool respondsToSelector:@selector(exportMetricData:)]) {
            [tool exportMetricData:metric];
        }
    }
}

#pragma mark - private method
- (void)buildTools:(MBAPMContext *)context {
    switch (context.configuration.env) {
        case MBAPMEnvDebug:
            _dataExportTools = [self createDebugTools:context];
            break;
        case MBAPMEnvTest:
            _dataExportTools = [self createTestTools:context];
            break;
        case MBAPMEnvRelease:
            _dataExportTools = [self createReleaseTools:context];
            break;
        default:
            break;
    }
}

- (NSMutableArray *)createDebugTools:(MBAPMContext *)context {
    NSMutableArray *toolArray = [[NSMutableArray alloc]init];
    MBAPMDataReport *dateReport = [[MBAPMDataReport alloc]initWithContext:context];
    MBAPMDataLog *log = [[MBAPMDataLog alloc]init];
    MBAPMDataCache *cache = [MBAPMDataCache sharedInstance];
    MBAPMDataReportByJournal *dataReportByJournal = [[MBAPMDataReportByJournal alloc]init];
    [toolArray addObject:dateReport];
    [toolArray addObject:dataReportByJournal];
    [toolArray addObject:log];
    [toolArray addObject:cache];
    return toolArray;
}

- (NSMutableArray *)createTestTools:(MBAPMContext *)context {
    NSMutableArray *toolArray = [[NSMutableArray alloc]init];
    MBAPMDataReport *dateReport = [[MBAPMDataReport alloc]initWithContext:context];
    MBAPMDataLog *log = [[MBAPMDataLog alloc]init];
    MBAPMDataPrintHtml *htmlTool = [[MBAPMDataPrintHtml alloc]init];
    MBAPMDataReportByJournal *dataReportByJournal = [[MBAPMDataReportByJournal alloc]init];
    [toolArray addObject:dateReport];
    [toolArray addObject:dataReportByJournal];
    [toolArray addObject:log];
    [toolArray addObject:htmlTool];
    return toolArray;
}

- (NSMutableArray *)createReleaseTools:(MBAPMContext *)context {
    NSMutableArray *toolArray = [[NSMutableArray alloc]init];
    MBAPMDataReport *dateReport = [[MBAPMDataReport alloc]initWithContext:context];
    MBAPMDataReportByJournal *dataReportByJournal = [[MBAPMDataReportByJournal alloc]init];
    [toolArray addObject:dateReport];
    [toolArray addObject:dataReportByJournal];
    return toolArray;
}


@end
