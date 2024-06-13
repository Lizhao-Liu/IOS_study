//
//  MBDebugMonitorDefine.h
//  Pods
//
//  Created by Lizhao on 2023/8/1.
//

#ifndef MBDebugMonitorDefine_h
#define MBDebugMonitorDefine_h
@import MBDebugService;
#import "MBDebugDefine.h"
#import "MBDebugMontiorEventLocatorModel.h"
#import "MBDebugMonitorEventAlertModel.h"

@protocol MBDebugMonitorLogObject <NSObject>

- (BOOL)isErrorObject; // 是否为异常数据

- (MBDebugMontiorEventLocatorModel *)locatorModel; // 数据来源

- (NSString *)searchStr; // 用于匹配搜索关键字的字符串

@optional

- (MBDebugMonitorAlertDialog *)dialogAlert; // 异常弹窗

- (NSString *)toastAlert; // 异常toast提醒

- (MBDebugMonitorPageInfoModel *)pageInfoModel; // 页面信息数据，用于生成当前页面信息浏览页面

@end

@class MBDebugMonitorTagModel;
@class MBDebugMonitorCellStyleModel;

@protocol MBDebugMonitorLogCellObject <NSObject, MBDebugMonitorLogObject>

- (NSTimeInterval)time; // 时间戳

- (NSString *)source; // 日志来源

- (NSString *)summary; // 主要内容

- (NSString *)detail; // 展开详细内容

@optional

- (MBDebugMonitorTagModel *)tagModel; // 数据标签信息

- (MBDebugMonitorCellStyleModel *)styleModel; //样式

- (NSArray<NSString *> *)attributes; //底部属性标签

@end

@protocol MBDebugMonitorLogDataSourceProtocol

@property (nonatomic, assign) NSInteger countLimit;
@property (nonatomic, strong) NSArray<id<MBDebugMonitorLogObject>> *allObjects;
@property (nonatomic, assign) NSArray<id<MBDebugMonitorLogObject>> *allErrorObjects;

- (void)addObject:(id<MBDebugMonitorLogObject>)object;

- (void)removeObjects:(NSArray<id<MBDebugMonitorLogObject>> *)objects;

- (void)clear;


/// 注册子数据源方法
/// - Parameters:
///   - childDataSource: 一个遵循 MBDebugMonitorLogDataSourceProtocol 协议的子数据源对象
///   - predicate: 返回布尔值的block，用于判断是否应该将监听到的数据添加到子数据源中
///   - formatter: 返回遵循 MBDebugMonitorLogObject 协议的对象的block，用于将监听数据转换为MBDebugMonitorLogObject格式
- (void)registerChildDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)childDataSource
                      predicate:(BOOL (^)(id object))predicate
                      formatter:(id<MBDebugMonitorLogObject> (^)(id object))formatter;


- (void)unregisterChildDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)childDataSource;

@property (nonatomic, strong) NSArray<id<MBDebugMonitorLogDataSourceProtocol>> *childDataSources;

@property (nonatomic, assign) BOOL canRecieveData;

@end


#endif /* MBDebugMonitorDefine_h */
