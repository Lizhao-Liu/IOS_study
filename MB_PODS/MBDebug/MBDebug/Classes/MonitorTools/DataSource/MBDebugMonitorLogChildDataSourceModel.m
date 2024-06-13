//
//  MBDebugMonitorLogChildDataSourceModel.m
//  MBDebug
//
//  Created by Lizhao on 2023/8/1.
//

#import "MBDebugMonitorLogChildDataSourceModel.h"

@implementation MBDebugMonitorLogChildDataSourceModel

+ (instancetype)modelWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource predicate:(PredicateBlock)predicate formatter:(FormatterBlock)formatter {
    MBDebugMonitorLogChildDataSourceModel *model = [[MBDebugMonitorLogChildDataSourceModel alloc] init];
    model.dataSource = dataSource;
    model.predicateBlock = predicate;
    model.formatterBlock = formatter;
    return model;
}

@end

