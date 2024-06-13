//
//  MBAPMDebugMonitorLogModel.m
//  MBAPMDebug
//
//  Created by Lizhao on 2023/8/10.
//

#import "MBAPMDebugMonitorLogModelFactory.h"
#import "MBAPMDebugMonitorDefine.h"
@import MBFoundation;
@import MBUIKit;
@import YMMRouterLib;
@import MBAPMLib;
@import YYModel;


#define SUBCLASS_MUST_OVERRIDE \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
                               reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] \
                             userInfo:nil]



@implementation MBAPMDebugMonitorLogModelFactory

+ (id<MBDebugMonitorLogCellObject>)apmLogModelWithLog:(NSString *)log
                                                 time: (NSTimeInterval)time
                                                 page:(NSString *)pageName {
    id<MBDebugMonitorLogCellObject> model;
    if([log containsString:@"app.crash"]){
        model = [MBAPMDebugCrashLogModel crashLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"app.error"]){
        model = [MBAPMDebugAppErrorLogModel appErrorLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.memory_warning"]){
        model = [MBAPMDebugMemoryWarningLogModel memoryWarningLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.memory_leak"]){
        model = [MBAPMDebugMemoryLeakLogModel memoryLeakLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.memory_big_image"]){
        model = [MBAPMDebugBigImageLogModel bigImageLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.applaunch"]){
        model = [MBAPMDebugAppLaunchLogModel appLaunchLogModelWithLog:log time:time page:pageName];
    }  else if ([log containsString:@"performance.pageview"]){
        model = [MBAPMDebugPageViewPerformanceLogModel pageViewPerformanceLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.cpu_exception"]){
        model = [MBAPMDebugCpuExceptionLogModel cpuExceptionLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.lag"]){
        model = [MBAPMDebugLagLogModel lagLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"performance.white_screen"]){
        model = [MBAPMDebugWhiteScreenLogModel whiteScreenLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"app.js_exception"]){
        model = [MBAPMDebugJSExceptionLogModel jsExceptionLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"app.dart_exception"]){
        model = [MBAPMDebugDartExceptionLogModel dartExceptionLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"app.resource_load"]){
        model = [MBAPMDebugResourceLoadLogModel resourceLoadLogModelWithLog:log time:time page:pageName];
    } else if ([log containsString:@"app.wakeups_exception"]){
        model = [MBAPMDebugWakeupsExceptionLogModel wakeupsExceptionLogModelWithLog:log time:time page:pageName];
    }
    return model;
}

+ (NSArray<NSString *> *)apmAlertIndicators {
    return @[@"app.crash", @"performance.lag", @"performance.applaunch", @"performance.cpu_exception", @"performance.white_screen", @"performance.memory_big_image", @"app.js_exception", @"app.error", @"performance.memory_warning", @"performance.memory_leak", @"performance.pageview", @"app.dart_exception", @"app.resource_load", @"app.wakeups_exception"];
}

@end

@interface MBAPMDebugLogModelBase ()

@property (nonatomic, assign) NSTimeInterval logTime;
@property (nonatomic, copy) NSString *pageName;  //页面名
@property (nonatomic, copy) NSString *currentVCPageName;
@property (nonatomic, copy) NSString *bundleType;
@property (nonatomic, copy) NSString *bundleName;

@end


@implementation MBAPMDebugLogModelBase


- (BOOL)isErrorObject {
    SUBCLASS_MUST_OVERRIDE;
}

- (NSString *)searchStr {
    SUBCLASS_MUST_OVERRIDE;
}

- (NSString *)detail {
    SUBCLASS_MUST_OVERRIDE;
}


- (NSString *)summary {
    SUBCLASS_MUST_OVERRIDE;
}

- (NSTimeInterval)time {
    return self.logTime;
}

- (NSString *)source {
    NSString *sourceStr = [NSString stringWithFormat:@"%@", self.pageName];
    if(self.bundleName && self.bundleName.length > 0){
        sourceStr = [sourceStr stringByAppendingFormat:@" | %@", self.bundleName];
    }
    if(self.bundleType && self.bundleType.length > 0){
        sourceStr = [sourceStr stringByAppendingFormat:@" | %@", self.bundleType];
    }
    return sourceStr;
}

- (MBDebugMontiorEventLocatorModel *)locatorModel {
    MBDebugMontiorEventLocatorModel *locatorModel = [MBDebugMontiorEventLocatorModel locatorModelWithPageName:self.currentVCPageName bundleName:self.bundleName bundleType:self.bundleType];
    return locatorModel;
}

@end


#pragma mark - app.crash

@interface MBAPMDebugCrashLogModel ()

@property (nonatomic, copy) NSString *pageClass;
@property (nonatomic, copy) NSString *crashTag;  //crash类型
@property (nonatomic, copy) NSString *crashType; //聚合信息
@property (nonatomic, strong) NSDictionary *stackDict; //堆栈信息
@property (nonatomic, copy) NSString *appForeground;
@property (nonatomic, strong) NSDictionary *metricTags;

@end


@implementation MBAPMDebugCrashLogModel

+ (instancetype)crashLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugCrashLogModel *model = [MBAPMDebugCrashLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    NSDictionary *tags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = tags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.pageClass = tags[@"page_className"] ?: @"";
    model.metricTags = tags;
    model.crashTag = [tags[@"crash_tag"] isEqualToString:@"oom"] ? @"oom" : @"crash";
    model.crashType = tags[@"crash_type"] ?: @"";
    model.appForeground = [tags mb_stringForKey:@"app_foreground"] ?: @"";
    model.stackDict = [MBJsonUtil dictionaryWithJsonString:[MBAPMDebugLogUtils stackInfoWithLogDict:contentDict]];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    return model;
}

- (NSString *)crashedStack {
    MatrixReportModel *reportModel = [MatrixReportModel yy_modelWithDictionary: self.stackDict];
    MatrixReportCrashModel *crashModel = reportModel.crash;
    NSString *crashedStack = @"";
    for (MatrixReportCrashThreadModel *thread in crashModel.threads){
        if(thread.crashed){
            crashedStack = [thread reportText];
            break;
        }
    }
    return crashedStack;
}

- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"%@", self.crashType];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSString *crashStack = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.stackDict];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】 \n%@\n\n【stack】 \n%@", metricTags, crashStack];
    return detail;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSArray<NSString *> *)attributes {
    if(self.crashTag && self.crashTag.length > 0){
        return @[self.crashTag];
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelRedTag();
    tagModel.tagName = @"app crash";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelRedColor;
    return styleModel;
}

- (MBDebugMonitorAlertDialog *)dialogAlert {
    MBDebugMonitorAlertDialogButton *btn = [MBDebugMonitorAlertDialogButton new];
    btn.btnTitle = @"上传日志";
    btn.btnAction = ^{
        NSString *urlString = @"ymm://app/logupload";
        [[YMMRouterCenter shared] performWithURLString:urlString completion:^(YMMRouterResponse *response) {
                if (response.result && [response.result isKindOfClass:[UIViewController class]]) {
                    UIViewController *vc = (UIViewController *)response.result;
                    [[UIViewController mb_currentViewController].navigationController pushViewController:vc animated:YES];
                }
        }];
    };
    NSString *crashStack = [self crashedStack];
    NSString *crashType = self.crashType;
    NSString *content = [NSString stringWithFormat:@"应用在上一次使用时触发了崩溃，崩溃原因:\n%@\n\n崩溃堆栈:\n%@", crashType, crashStack];
    MBDebugMonitorAlertDialog *alertDialog = [MBDebugMonitorAlertDialog alertDialogWithTitle:@"crash 详情" content:content buttons:@[btn]];
    return alertDialog;
}

@end

#pragma mark - app.error

@interface MBAPMDebugAppErrorLogModel ()

@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, copy) NSString *errorTag;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, copy) NSString *stack;//堆栈信息

@end

@implementation MBAPMDebugAppErrorLogModel

+ (instancetype)appErrorLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugAppErrorLogModel *model = [MBAPMDebugAppErrorLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"];
    model.errorTag = model.metricTags[@"error_tag"] ?: @"";
    model.stack = [MBAPMDebugLogUtils stackInfoWithLogDict:contentDict] ?: @"";

    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【stack】\n%@", metricTags, self.stack];
    return detail;
}

- (NSString *)summary {
    return self.metricTags[@"error_feature"] ?: @"";
}

- (NSArray<NSString *> *)attributes {
    NSMutableArray *tags = @[].mutableCopy;
    NSString *errorTag = [self.metricTags mb_stringForKey:@"error_tag"];
    NSString *errorCode = [self.metricTags mb_stringForKey:@"error_code"];
    if(self.errorTag && self.errorTag.length>0){
        [tags addObject:errorTag];
    }
    if(errorCode){
        [tags addObject:errorCode];
    }
    if(tags.count > 0){
        return tags;
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorAlertDialog *)dialogAlert {
    if([self.errorTag isEqualToString:@"lag"]){
        MBDebugMonitorAlertDialogButton *btn = [MBDebugMonitorAlertDialogButton new];
        btn.btnTitle = @"上传日志";
        btn.btnAction = ^{
            NSString *urlString = @"ymm://app/logupload";
            [[YMMRouterCenter shared] performWithURLString:urlString completion:^(YMMRouterResponse *response) {
                    if (response.result && [response.result isKindOfClass:[UIViewController class]]) {
                        UIViewController *vc = (UIViewController *)response.result;
                        [[UIViewController mb_currentViewController].navigationController pushViewController:vc animated:YES];
                    }
            }];
        };
        NSString *feature = [self.metricTags mb_stringForKey:@"error_feature"];
        NSString *stack = [self crashedStack];
        NSString *content = [NSString stringWithFormat:@"错误特征:\n%@\n\n堆栈信息:\n%@", feature, stack];
        MBDebugMonitorAlertDialog *alertDialog = [MBDebugMonitorAlertDialog alertDialogWithTitle:@"应用发生了卡死" content:content buttons:@[btn]];
        return alertDialog;
    }
    return nil;
}

- (NSString *)crashedStack {
    NSDictionary *stackDict = [MBJsonUtil dictionaryWithJsonString:self.stack];
    if(stackDict){
        MatrixReportModel *reportModel = [MatrixReportModel yy_modelWithDictionary:stackDict];
        if(reportModel){
            MatrixReportCrashModel *crashModel = reportModel.crash;
            NSString *crashedStack = @"";
            for (MatrixReportCrashThreadModel *thread in crashModel.threads){
                if(thread.crashed){
                    crashedStack = [thread reportText];
                    break;
                }
            }
            return crashedStack;
        }
    }
    return self.stack;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelRedTag();
    tagModel.tagName = @"app error";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelRedColor;
    return styleModel;
}

@end

#pragma mark - performance.memory_warning

@interface MBAPMDebugMemoryWarningLogModel ()

@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, strong) NSDictionary *attrsDict;

@end

@implementation MBAPMDebugMemoryWarningLogModel

+ (instancetype)memoryWarningLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugMemoryWarningLogModel *model = [MBAPMDebugMemoryWarningLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.attrsDict = [MBAPMDebugLogUtils attrsWithLogDict:contentDict];
    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSString *attrs = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.attrsDict];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【attrs】\n%@", metricTags, attrs];
    return detail;
}


- (NSString *)summary {
    return self.pageName;
}


- (NSArray<NSString *> *)attributes {
    NSMutableArray *tags = @[].mutableCopy;
    NSString *errorTag = [self.metricTags mb_stringForKey:@"error_tag"];
    NSString *state = [self.metricTags mb_boolForKey:@"app_foreground"] ? @"foreground" : @"background";
    if(errorTag){
        [tags addObject:errorTag];
    }
    [tags addObject:state];
    return tags;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelOrangeTag();
    tagModel.tagName = @"memory warning";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelOrangeColor;
    return styleModel;
}

@end


#pragma mark - performance.memory_leak

@interface MBAPMDebugMemoryLeakLogModel ()

@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, strong) NSDictionary *attrsDict;

@end

@implementation MBAPMDebugMemoryLeakLogModel

+ (instancetype)memoryLeakLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugMemoryLeakLogModel *model = [MBAPMDebugMemoryLeakLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.attrsDict = [MBAPMDebugLogUtils attrsWithLogDict:contentDict];
    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSString *attrs = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.attrsDict];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【attrs】\n%@", metricTags, attrs];
    return detail;
}

- (NSString *)summary {
    return self.pageName;
}

- (NSArray<NSString *> *)attributes {
    NSMutableArray *tags = @[].mutableCopy;
    NSString *errorTag = [self.metricTags mb_stringForKey:@"error_tag"];
    NSString *state = [self.metricTags mb_boolForKey:@"app_foreground"] ? @"foreground" : @"background";
    if(errorTag){
        [tags addObject:errorTag];
    }
    [tags addObject:state];
    return tags;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelOrangeTag();
    tagModel.tagName = @"memory leak";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelOrangeColor;
    return styleModel;
}

@end

#pragma mark - performance.memory_big_image

@interface MBAPMDebugBigImageLogModel ()
@property (nonatomic, copy) NSString *pageClass;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSDictionary *metricTags;

@end


@implementation MBAPMDebugBigImageLogModel

+ (instancetype)bigImageLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugBigImageLogModel *model = [MBAPMDebugBigImageLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.imageUrl = model.metricTags[@"error_feature"] ?: @"";
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    return model;
}


- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"%@", self.imageUrl];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@", metricTags];
    return detail;
}



- (NSString *)searchStr {
    return [self detail];
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelYellowTag();
    tagModel.tagName = @"big image";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelYellowColor;
    return styleModel;
}

@end

#pragma mark - performance.applaunch

@interface MBAPMDebugAppLaunchLogModel ()
@property (nonatomic, copy) NSString *pageClass;

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *timeInterval;
@property (nonatomic, copy) NSString *appForeground;

@property (nonatomic, copy) NSString *launchType;
@property (nonatomic, copy) NSString *lastShutOffType;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, strong) NSDictionary *metricSections;

@end

@implementation MBAPMDebugAppLaunchLogModel

+ (instancetype)appLaunchLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugAppLaunchLogModel *model = [MBAPMDebugAppLaunchLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    NSDictionary *tags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    
    model.pageName = tags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.appForeground = [tags mb_stringForKey:@"app_foreground"] ?: @"";
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.pageClass = tags[@"page_className"] ?: @"";
    model.value = [MBAPMDebugLogUtils metricValueWithLogDict:contentDict];
    model.timeInterval = tags[@"time_interval"] ?: @"";
    model.launchType = tags[@"launchType"] ?: @"";
    model.lastShutOffType = tags[@"lastShutOffType"] ?: @"";
    model.metricTags = tags;
    model.metricSections = [MBAPMDebugLogUtils metricSectionsWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    return model;
}

- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"time interval : %@\n耗时 : %@", self.timeInterval, self.value];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSString *metricSections = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricSections];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【耗时】\n%@\n\n【metric tags】\n%@\n\n【metric sections】\n%@", self.value, metricTags, metricSections];
    return detail;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSArray<NSString *> *)attributes {
    NSMutableArray *arr = @[].mutableCopy;
    if(self.appForeground && [self.appForeground isEqualToString:@"1"]){
        [arr addObject:@"foreground"];
    }
    if(self.launchType && self.launchType.length > 0){
        [arr addObject:self.launchType];
    }
    return arr;
}

- (BOOL)isErrorObject {
    return NO;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelGreenTag();
    tagModel.tagName = @"app launch";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.highlightColor = kMBAPMDebugMonitorLogModelGreenColor;
    return styleModel;
}

@end

#pragma mark - performance.pageview

@interface MBAPMDebugPageViewPerformanceLogModel ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, strong) NSDictionary *metricSections;
@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, copy) NSString *value;

@end

@implementation MBAPMDebugPageViewPerformanceLogModel

+ (instancetype)pageViewPerformanceLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugPageViewPerformanceLogModel *model = [MBAPMDebugPageViewPerformanceLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.value = [MBAPMDebugLogUtils metricValueWithLogDict:contentDict];
    model.path = [model.metricTags mb_stringForKey:@"page_path"];
    model.metricSections = [MBAPMDebugLogUtils metricSectionsWithLogDict:contentDict];
    model.extInfo = [MBAPMDebugLogUtils extInfoWithLogDict:contentDict];
    return model;
}

- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"path : %@\n页面开屏耗时 : %@", self.path, self.value];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSString *metricSections = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricSections];
    NSString *extra = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.extInfo];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【页面开屏耗时】\n%@\n\n【metric tags】\n%@\n\n【metric sections】\n%@\n\n【extra】\n%@", self.value, metricTags, metricSections, extra];
    return detail;
}

- (NSArray<NSString *> *)attributes {
    NSString *success = [self.metricTags mb_stringForKey:@"success"];
    if([success isEqualToString:@"true"] || [success isEqualToString:@"1"]){
        return @[@"success"];
    } else {
        return @[@"fail"];
    }
}

- (NSString *)searchStr {
    return [self detail];
}

- (BOOL)isErrorObject {
    return NO;
}

- (MBDebugMonitorPageInfoModel *)pageInfoModel {
    MBDebugMonitorPageInfoModel *pageInfoModel = [[MBDebugMonitorPageInfoModel alloc] init];
    
    NSString *valueStr = [NSString stringWithFormat:@"%@", self.value];
    NSString *metricSections = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricSections];
    
    pageInfoModel.sectionDict = @{@"总耗时": valueStr, @"分段耗时":metricSections};
    pageInfoModel.sectionTitle = @"页面开屏耗时";
    return pageInfoModel;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelGreenTag();
    tagModel.tagName = @"pageview";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.highlightColor = kMBAPMDebugMonitorLogModelGreenColor;
    return styleModel;
}

@end

#pragma mark - performance.cpu_exception

@interface MBAPMDebugCpuExceptionLogModel ()

@property (nonatomic, copy) NSString *pageClass;
@property (nonatomic, copy) NSString *stack; //堆栈信息
@property (nonatomic, copy) NSString *threadName;
@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, strong) NSDictionary *metricTags;

@property (nonatomic, copy) NSString *tagName;

@end

@implementation MBAPMDebugCpuExceptionLogModel

+ (instancetype)cpuExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugCpuExceptionLogModel *model = [MBAPMDebugCpuExceptionLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.pageClass = model.metricTags[@"page_className"] ?: @"";
    model.threadName = model.metricTags[@"thread_name"] ?: @"";
    model.errorFeature = model.metricTags[@"error_feature"] ?: @"";
    model.stack = [MBAPMDebugLogUtils stackInfoWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.tagName = @"cpu exception";
    return model;
}

- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"%@\nthread_name: %@", self.errorFeature, self.threadName];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【stack】\n%@", metricTags, self.stack];
    return detail;
}

- (NSString *)searchStr {
    return [self detail];
}

- (BOOL)isErrorObject {
    return YES;
}


- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelCyanTag();
    tagModel.tagName = self.tagName;
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelCyanColor;
    return styleModel;
}


@end



#pragma mark - performance.lag

@interface MBAPMDebugLagLogModel ()

@property (nonatomic, copy) NSString *pageClass;

@property (nonatomic, copy) NSString *stack;//堆栈信息

@property (nonatomic, copy) NSString *lagType;
@property (nonatomic, copy) NSString *lagFeature;
@property (nonatomic, copy) NSString *lagTotalTime;
@property (nonatomic, strong) NSDictionary *metricTags;


@end

@implementation MBAPMDebugLagLogModel

+ (instancetype)lagLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugLagLogModel *model = [MBAPMDebugLagLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    NSDictionary *tags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.metricTags = tags;
    model.pageName = tags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.lagType = tags[@"lagType"] ?: @"";
    model.lagFeature = tags[@"lagFeature"] ?: @"";
    NSDictionary *extInfo = [MBAPMDebugLogUtils extInfoWithLogDict:contentDict];
    model.lagTotalTime = extInfo[@"lagTotalTime"] ?: @"";
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.stack = [MBAPMDebugLogUtils stackInfoWithLogDict:contentDict];
    model.pageClass = tags[@"page_className"] ?: @"";
    return model;
}


- (NSString *)summary {
    NSString *summary = [self.lagFeature stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【lag_total_time】\n%@\n\n【metric tags】\n%@\n\n【stack】\n%@\n", self.lagTotalTime, metricTags, self.stack];
    return detail;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSArray<NSString *> *)attributes {
    if(self.lagType && self.lagType.length > 0){
        return @[self.lagType];
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelBlueTag();
    tagModel.tagName = @"lag";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelBlueColor;
    return styleModel;
}

@end

#pragma mark - performance.white_screen

@interface MBAPMDebugWhiteScreenLogModel ()

@property (nonatomic, copy) NSString *errorFeature;

@property (nonatomic, copy) NSString *exceptionType;

@property (nonatomic, strong) NSDictionary *metricTags;

@end

@implementation MBAPMDebugWhiteScreenLogModel

+ (instancetype)whiteScreenLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugWhiteScreenLogModel *model = [MBAPMDebugWhiteScreenLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"] ?: @"";
    model.exceptionType = model.metricTags[@"exception_type"];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    return model;
}

- (NSString *)summary {
    NSString *summary = [self.errorFeature stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return summary;
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@",  metricTags];
    return detail;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSArray<NSString *> *)attributes {
    if(self.exceptionType && self.exceptionType.length>0){
        return @[self.metricTags[@"exception_type"]];
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelBlueTag();
    tagModel.tagName = @"white screen";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelBlueColor;
    return styleModel;
}


@end


#pragma mark - app.js_exception

@interface MBAPMDebugJSExceptionLogModel()

@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, copy) NSString *stack;//堆栈信息


@end

@implementation MBAPMDebugJSExceptionLogModel

+ (instancetype)jsExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugJSExceptionLogModel *model = [MBAPMDebugJSExceptionLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"];
    model.stack = [MBAPMDebugLogUtils stackInfoWithLogDict:contentDict] ?: @"";

    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【stack】\n%@", metricTags, self.stack];
    return detail;
}

- (NSString *)summary {
    return self.metricTags[@"error_feature"] ?: @"";
}

- (NSArray<NSString *> *)attributes {
    NSMutableArray *tags = @[].mutableCopy;
    NSString *errorTag = [self.metricTags mb_stringForKey:@"error_tag"];
    NSString *errorSource = [self.metricTags mb_stringForKey:@"source"];
    NSString *errorCode = [self.metricTags mb_stringForKey:@"error_code"];
    if(errorTag){
        [tags addObject:errorTag];
    }
    if(errorSource){
        [tags addObject:errorSource];
    }
    if(errorCode){
        [tags addObject:errorCode];
    }
    if(tags.count > 0){
        return tags;
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelPurpleTag();
    tagModel.tagName = @"js exception";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelPurpleColor;
    return styleModel;
}

@end

#pragma mark - app.dart_exception

@interface MBAPMDebugDartExceptionLogModel()

@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, copy) NSString *stack;//堆栈信息

@end

@implementation MBAPMDebugDartExceptionLogModel

+ (instancetype)dartExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugDartExceptionLogModel *model = [MBAPMDebugDartExceptionLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"];
    model.stack = [MBAPMDebugLogUtils stackInfoWithLogDict:contentDict] ?: @"";

    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【stack】\n%@", metricTags, self.stack];
    return detail;
}

- (NSString *)summary {
    return self.metricTags[@"error_feature"] ?: @"";
}

- (NSArray<NSString *> *)attributes {
    NSMutableArray *tags = @[].mutableCopy;
    NSString *errorTag = [self.metricTags mb_stringForKey:@"error_tag"];
    NSString *errorCode = [self.metricTags mb_stringForKey:@"error_code"];
    if(errorTag){
        [tags addObject:errorTag];
    }
    if(errorCode){
        [tags addObject:errorCode];
    }
    if(tags.count > 0){
        return tags;
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelPurpleTag();
    tagModel.tagName = @"dart exception";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelPurpleColor;
    return styleModel;
}


@end

#pragma mark - app.resource_load

@interface MBAPMDebugResourceLoadLogModel()

@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, copy) NSString *elapsedTime;

@end

@implementation MBAPMDebugResourceLoadLogModel

+ (instancetype)resourceLoadLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugResourceLoadLogModel *model = [MBAPMDebugResourceLoadLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"];
    model.elapsedTime = [MBAPMDebugLogUtils metricValueWithLogDict:contentDict];
    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *metricTags = [MBAPMDebugLogUtils prettyPrintedStringWithDict:self.metricTags];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【metric tags】\n%@\n\n【资源加载耗时】\n%@", metricTags, self.elapsedTime];
    return detail;
}


- (NSString *)summary {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"resource url : %@\n资源加载耗时 : %@", self.metricTags[@"resource_url"], self.elapsedTime];
    return summary;
}

- (NSArray<NSString *> *)attributes {
    NSString *code = [self.metricTags mb_stringForKey:@"code"];
    if(code){
        return @[code];
    }
    return nil;
}

- (BOOL)isErrorObject {
    return YES;
}


- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelYellowTag();
    tagModel.tagName = @"resource load";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelYellowColor;
    return styleModel;
}

@end


#pragma mark - app.wakeups_exception

@interface MBAPMDebugWakeupsExceptionLogModel()

@property (nonatomic, copy) NSString *errorFeature;
@property (nonatomic, strong) NSDictionary *metricTags;
@property (nonatomic, strong) NSDictionary *metricSections;
@property (nonatomic, strong) NSDictionary *heavySections;
@property (nonatomic, strong) NSString *averageWakeups;
@property (nonatomic, strong) NSString *errorDesc;

@end

@implementation MBAPMDebugWakeupsExceptionLogModel

+ (instancetype)wakeupsExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName {
    MBAPMDebugWakeupsExceptionLogModel *model = [MBAPMDebugWakeupsExceptionLogModel new];
    model.logTime = time;
    NSDictionary *contentDict = [MBJsonUtil dictionaryWithJsonString:logString];
    model.metricTags = [MBAPMDebugLogUtils metricTagsWithLogDict:contentDict];
    model.pageName = model.metricTags[@"page_id"] ?: pageName;
    model.currentVCPageName = pageName;
    model.bundleType = [MBAPMDebugLogUtils bundleTypeWithLogDict:contentDict];
    model.bundleName = [MBAPMDebugLogUtils bundleNameWithLogDict:contentDict];
    model.errorFeature = model.metricTags[@"error_feature"];
    model.averageWakeups = [MBAPMDebugLogUtils metricValueWithLogDict:contentDict];
    model.metricSections = [MBAPMDebugLogUtils metricSectionsWithLogDict:contentDict];
    NSDictionary *attrs = [MBAPMDebugLogUtils attrsWithLogDict:contentDict];
    model.heavySections = attrs[@"heavy_sections"] ?: @{};
    NSDictionary *extInfo = [MBAPMDebugLogUtils extInfoWithLogDict:contentDict];
    model.errorDesc = extInfo[@"error_description"];
    return model;
}

- (NSString *)searchStr {
    return [self detail];
}

- (NSString *)detail {
    NSString *wakeupsCaused = [self.metricSections mb_stringForKey:@"wakeups_caused"];
    NSString *wakeupsDruation = [self.metricSections mb_stringForKey:@"wakeups_duration"];
    NSString *heavySectionsCount = [self.metricSections mb_stringForKey:@"heavy_sections_count"];
    NSMutableString *detail = [NSMutableString stringWithFormat:@"【error description】\n%@\n\n【average wakeups】\n%@\n\n【wakeups caused】\n%@\n\n【wakeups duration】\n%@\n\n【heavy sections count】\n%@\n\n【heavy sections】\n%@", self.errorDesc, self.averageWakeups, wakeupsCaused, wakeupsDruation, heavySectionsCount, self.heavySections];
    return detail;
}


- (NSString *)summary {
    return self.errorDesc ?: @"";
}


- (BOOL)isErrorObject {
    return YES;
}

- (MBDebugMonitorTagModel *)tagModel {
    MBDebugMonitorTagModel *tagModel = kMBAPMDebugMonitorLogModelCyanTag();
    tagModel.tagName = @"wakeups exception";
    return tagModel;
}

- (MBDebugMonitorCellStyleModel *)styleModel {
    MBDebugMonitorCellStyleModel *styleModel = [[MBDebugMonitorCellStyleModel alloc] init];
    styleModel.errorHighlightColor = kMBAPMDebugMonitorLogModelCyanColor;
    return styleModel;
}

@end

@implementation MBAPMDebugLogUtils

+ (NSString *)prettyPrintedStringWithDict: (NSDictionary *)dict {
    if(!dict){
        return nil;
    }
    __block NSMutableString *text = @"".mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *value;
        if(obj && [obj isKindOfClass:[NSString class]]){
            value = (NSString *)obj;
            value = [value stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        } else if ([obj isKindOfClass:[NSNumber class]]){
            value = [NSString stringWithFormat:@"%@", obj];
        } else if ([obj isKindOfClass:[NSDictionary class]]){
            value = [MBJsonUtil dictionaryToJson:obj];
        } else if ([obj isKindOfClass:[NSArray class]]){
            value = [MBJsonUtil arrayToJson:obj];
        }
        [text appendFormat:@"%@ : %@\n", key, value];
    }];
    return text;
}

+ (NSString *)metricNameWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"metric"] && [logDict[@"metric"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *metricDict = logDict[@"metric"];
        if(metricDict[@"name"] && [metricDict[@"name"] isKindOfClass:[NSString class]]){
            return (NSString *)metricDict[@"name"];
        }
    }
    return nil;
}

+ (NSDictionary *)metricTagsWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"metric"] && [logDict[@"metric"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *metricDict = logDict[@"metric"];
        if(metricDict[@"tags"] && [metricDict[@"tags"] isKindOfClass:[NSDictionary class]]){
            return (NSDictionary *)metricDict[@"tags"];
        }
    }
    return nil;
}

+ (NSDictionary *)metricSectionsWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"metric"] && [logDict[@"metric"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *metricDict = logDict[@"metric"];
        if(metricDict[@"sections"] && [metricDict[@"sections"] isKindOfClass:[NSDictionary class]]){
            return (NSDictionary *)metricDict[@"sections"];
        }
    }
    return nil;
}

+ (NSDictionary *)bundleInfoWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"bundle"] && [logDict[@"bundle"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *bundleDict = logDict[@"bundle"];
        return (NSDictionary *)bundleDict;
    }
    return nil;
}

+ (NSString *)metricValueWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"metric"] && [logDict[@"metric"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *metricDict = logDict[@"metric"];
        if(metricDict[@"value"]){
            return [metricDict mb_stringForKey:@"value"];
        }
    }
    return nil;
}


+ (NSDictionary *)extInfoWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"ext"] && [logDict[@"ext"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *extDict = logDict[@"ext"];
        return (NSDictionary *)extDict;
    }
    return nil;
}

+ (NSDictionary *)attrsWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"attrs"] && [logDict[@"attrs"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *attrsDict = logDict[@"attrs"];
        return (NSDictionary *)attrsDict;
    }
    return nil;
}


+ (NSString *)bundleTypeWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"bundle"] && [logDict[@"bundle"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *bundleDict = logDict[@"bundle"];
        if(bundleDict[@"type"]){
            return [bundleDict mb_stringForKey:@"type"];
        }
    }
    return nil;
}

+ (NSString *)bundleNameWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"bundle"] && [logDict[@"bundle"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *bundleDict = logDict[@"bundle"];
        if(bundleDict[@"name"]){
            return [bundleDict mb_stringForKey:@"name"];
        }
    }
    return nil;
}

+ (NSString *)stackInfoWithLogDict:(NSDictionary *)logDict {
    if(logDict[@"attrs"] && [logDict[@"attrs"] isKindOfClass:[NSDictionary class]]){
        NSDictionary *attrDict = logDict[@"attrs"];
        if(attrDict[@"stack"] && [attrDict[@"stack"] isKindOfClass:[NSString class]]){
            return (NSString *)attrDict[@"stack"];
        }
    }
    return nil;
}



@end
