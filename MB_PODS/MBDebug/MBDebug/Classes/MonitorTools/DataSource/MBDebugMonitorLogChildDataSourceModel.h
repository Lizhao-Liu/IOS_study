//
//  MBDebugMonitorLogChildDataSourceModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/8/1.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^PredicateBlock)(id);
typedef id<MBDebugMonitorLogObject> (^FormatterBlock)(id);

@interface MBDebugMonitorLogChildDataSourceModel : NSObject

@property (nonatomic, strong) id<MBDebugMonitorLogDataSourceProtocol> dataSource;
@property (nonatomic, copy) PredicateBlock predicateBlock;
@property (nonatomic, copy) FormatterBlock formatterBlock;

+ (instancetype)modelWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource predicate:(PredicateBlock)predicate formatter:(FormatterBlock)formatter;

@end

NS_ASSUME_NONNULL_END
