//
//  MBAPMDebugMonitorLogModel.h
//  MBAPMDebug
//
//  Created by Lizhao on 2023/8/10.
//

#import <Foundation/Foundation.h>
@import MBDebug;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDebugMonitorLogModelFactory : NSObject

+ (id<MBDebugMonitorLogCellObject>)apmLogModelWithLog:(NSString *)log
                                                 time: (NSTimeInterval)time
                                                 page:(NSString *)pageName;


+ (NSArray<NSString *> *)apmAlertIndicators;

@end

@interface MBAPMDebugLogUtils : NSObject

+ (NSDictionary *)metricTagsWithLogDict:(NSDictionary *)logDict;
+ (NSString *)bundleTypeWithLogDict:(NSDictionary *)logDict;
+ (NSString *)stackInfoWithLogDict:(NSDictionary *)logDict;
+ (NSDictionary *)extInfoWithLogDict:(NSDictionary *)logDict;
+ (NSString *)metricValueWithLogDict:(NSDictionary *)logDict;
+ (NSString *)bundleNameWithLogDict:(NSDictionary *)logDict;
+ (NSString *)metricNameWithLogDict:(NSDictionary *)logDict;
+ (NSDictionary *)bundleInfoWithLogDict:(NSDictionary *)logDict;
+ (NSDictionary *)attrsWithLogDict:(NSDictionary *)logDict;
+ (NSDictionary *)metricSectionsWithLogDict:(NSDictionary *)logDict;
+ (NSString *)prettyPrintedStringWithDict: (NSDictionary *)dict;

@end

@interface MBAPMDebugLogModelBase :  NSObject<MBDebugMonitorLogCellObject>

@end

@interface MBAPMDebugCrashLogModel : MBAPMDebugLogModelBase

+ (instancetype)crashLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugLagLogModel : MBAPMDebugLogModelBase

+ (instancetype)lagLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugAppLaunchLogModel : MBAPMDebugLogModelBase

+ (instancetype)appLaunchLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugCpuExceptionLogModel : MBAPMDebugLogModelBase

+ (instancetype)cpuExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugWhiteScreenLogModel : MBAPMDebugLogModelBase

+ (instancetype)whiteScreenLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugBigImageLogModel : MBAPMDebugLogModelBase

+ (instancetype)bigImageLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugJSExceptionLogModel : MBAPMDebugLogModelBase

+ (instancetype)jsExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugDartExceptionLogModel : MBAPMDebugLogModelBase
+ (instancetype)dartExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugResourceLoadLogModel : MBAPMDebugLogModelBase

+ (instancetype)resourceLoadLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugPageViewPerformanceLogModel : MBAPMDebugLogModelBase

+ (instancetype)pageViewPerformanceLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugAppErrorLogModel : MBAPMDebugLogModelBase

+ (instancetype)appErrorLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugMemoryWarningLogModel : MBAPMDebugLogModelBase

+ (instancetype)memoryWarningLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugMemoryLeakLogModel : MBAPMDebugLogModelBase

+ (instancetype)memoryLeakLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

@interface MBAPMDebugWakeupsExceptionLogModel : MBAPMDebugLogModelBase

+ (instancetype)wakeupsExceptionLogModelWithLog:(NSString *)logString time:(NSTimeInterval)time page:(nonnull NSString *)pageName;

@end

NS_ASSUME_NONNULL_END
