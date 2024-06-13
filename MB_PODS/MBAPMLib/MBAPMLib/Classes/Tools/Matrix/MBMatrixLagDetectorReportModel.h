//
//  MBMatrixReportModel.h
//  MBAPMLib
//
//  Created by 别施轩 on 2021/8/6.
//

#import <Foundation/Foundation.h>
@import YYModel;
// 用于将matrix-wechat的数据模型转换为苹果标准的数据模型

@interface MatrixReportCrashThreadTraceModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *objectName;
@property (nonatomic, assign) unsigned long long objectAddr;
@property (nonatomic, copy) NSString *symbolName;
@property (nonatomic, assign) unsigned long long symbolAddr;
@property (nonatomic, assign) unsigned long long instructionAddr;
@property (nonatomic, assign) NSUInteger repeatCount;

- (NSString *)reportText;

- (NSString *)featureText;

@end


@interface MatrixReportCrashThreadBacktraceModel : NSObject <YYModel>

@property (nonatomic, strong) NSArray<MatrixReportCrashThreadTraceModel *> *contents;

// 返回两个String。第一个是栈信息，第二个是关键栈。
- (NSArray<NSString *> *)reportTexts;

// 返回栈信息
- (NSString *)reportText;

// 返回关键栈
- (NSString *)featureStackFrame;

@end


@interface MatrixReportCrashThreadModel : NSObject <YYModel>

@property (nonatomic, strong) MatrixReportCrashThreadBacktraceModel *backtrace;
@property (nonatomic, assign) BOOL crashed;
@property (nonatomic, assign) BOOL currentThread;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, copy)   NSString *name;

// 返回两个String。第一个是栈信息，第二个是关键栈。
- (NSArray<NSString *> *)reportTexts;

// 返回栈信息
- (NSString *)reportText;

@end

@interface MatrixReportSignalErrorModel : NSObject <YYModel>
@property (nonatomic, assign) NSUInteger signal;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code_name;

@end

@interface MatrixReportNSExceptionErrorModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *referenced_object;

@end

@interface MatrixReportCPPExceptionErrorModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *name;

@end

@interface MatrixReportErrorModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, strong) MatrixReportSignalErrorModel *signal;
@property (nonatomic, strong) MatrixReportNSExceptionErrorModel *nsexception;
@property (nonatomic, strong) MatrixReportCPPExceptionErrorModel *cpp_exception;

- (NSString *)errorType;

@end


@interface MatrixReportCrashModel : NSObject <YYModel>

@property (nonatomic, strong) NSArray<MatrixReportCrashThreadModel *> *threads;
@property (nonatomic, strong) MatrixReportCrashThreadModel *crashed_thread;

@property (nonatomic, strong) MatrixReportErrorModel *error;

// 返回两个String。第一个是栈信息，第二个是关键栈。
- (NSArray<NSString *> *)reportTexts;

- (NSArray<NSDictionary<NSString *, NSString *> *> *)crashThreadStacks;

- (NSString *)crashFeatureStackFrame;

- (NSString *)lagFeatureStackFrame;
@end


@interface MatrixReportInfoModel : NSObject <YYModel>

@property (nonatomic, assign) NSUInteger timestamp;

@end

@interface MatrixReportZombieExceptionModel : NSObject <YYModel>

@property (nonatomic, assign) unsigned long long address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, strong) MatrixReportCrashThreadBacktraceModel *backtrace;

@end

@interface MatrixReportProcessInfoModel: NSObject <YYModel>

@property (nonatomic, strong) MatrixReportZombieExceptionModel *last_dealloced_nsexception;

@end


@interface MatrixReportModel : NSObject <YYModel>

@property (nonatomic, strong) MatrixReportInfoModel *report;
@property (nonatomic, strong) MatrixReportModel *recrash_report;
@property (nonatomic, strong) MatrixReportCrashModel *crash;
@property (nonatomic, strong) NSDictionary *system;
@property (nonatomic, strong) MatrixReportProcessInfoModel *process;
@property (nonatomic, copy) NSDictionary *user;

@property (nonatomic, assign) NSInteger dumpType;

// 返回两个String。第一个是栈信息，第二个是关键栈。
- (NSArray<NSString *> *)reportTexts;

- (unsigned long)timestamp;

@end
