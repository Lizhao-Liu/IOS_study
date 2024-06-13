//
//  MBThreadStackModel.h
//  MBAPMLib
//
//  Created by FDW on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBThreadStackPerModel;
@interface MBThreadStackModel : NSObject

@property (nonatomic, assign) CGFloat cpu_usage;
@property (nonatomic, assign) CGFloat cpu_rate;
@property (nonatomic, assign) float weight;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) NSMutableArray <MBThreadStackPerModel *> *stackPerModelArray;

@property (nonatomic, strong) MBThreadStackPerModel *stackModel;

- (NSString *)stackDescription;
@end

// 每行的线程信息
@interface MBThreadStackPerModel : NSObject

@property (nonatomic, copy) NSString *stack;

@property (nonatomic, strong, nullable) MBThreadStackPerModel *superNode;

@property (nonatomic, strong) NSArray <MBThreadStackPerModel *> *child;

//层级,代表着缩进
@property (nonatomic, assign) NSInteger level;
// 出现次数
@property (nonatomic, assign) CGFloat weight;

- (uintptr_t )getCurAddress;
- (NSString *)getCurFname;
- (long )getOffset;
@end

NS_ASSUME_NONNULL_END
