//
//  MBAPMBacktraceLogger.h
//  MBAPMBacktraceLogger
//
//  Created by xp on 2020/11/3.
//


#import <Foundation/Foundation.h>
#include <dlfcn.h>

@class MBThreadStackModel;

#define MBAPM_BACKTRACE_LOG NSLog(@"%@",[MBAPMBacktraceLogger mbapm_backtraceOfCurrentThread]);
#define MBAPM_BACKTRACE_MAIN NSLog(@"%@",[MBAPMBacktraceLogger mbapm_backtraceOfMainThread]);
#define MBAPM_BACKTRACE_ALL NSLog(@"%@",[MBAPMBacktraceLogger mbapm_backtraceOfAllThread]);

typedef struct MBAPMBacktraceStack {
    uintptr_t * _Nonnull stack;//堆栈数组
    size_t count; //堆栈数组长度
}MBAPMBacktraceStack;

@interface MBAPMSymbolicatedBacktraceStack : NSObject

@property (nonatomic, copy, nonnull) NSString *wholeStack;
@property (nonatomic, copy, nullable) NSString *keyFunction;

@end

@interface MBAPMStackImageInfo : NSObject

@property (nonatomic, copy, nonnull) NSString *imageName;
@property (nonatomic, assign) uint64_t imageAddress;
@property (nonatomic, assign) uint64_t instructionAddr;

@end

@interface MBAPMBacktraceLogger : NSObject

+ (NSString *_Nonnull)mbapm_backtraceOfAllThread;
+ (NSString *_Nonnull)mbapm_backtraceOfCurrentThread;
+ (NSString *_Nonnull)mbapm_backtraceOfMainThread;
+ (NSString *_Nonnull)mbapm_backtraceOfNSThread:(NSThread *_Nonnull)thread;
+ (MBThreadStackModel *_Nullable)mbapm_backtraceOfThread:(thread_t)thread;


/// 获取主线程堆栈地址数组，返回的MBAPMBacktraceStack在使用结束后需要手动释放
+ (MBAPMBacktraceStack *_Nonnull)mbapm_backtraceAddressOfMainThread;


/// 解析堆栈地址数组，获取符号解析后的主线程堆栈
/// @param stack 调用堆栈地址结构体
+ (MBAPMSymbolicatedBacktraceStack *_Nonnull)mbapm_backtraceOfMainThreadWithStack:(MBAPMBacktraceStack *_Nonnull)stack;


/// 返回特定堆栈所在的image的地址
/// @param stackAddress 堆栈地址
+ (MBAPMStackImageInfo *_Nullable)mbapm_imageInfoFromStackAddress:(unsigned long)stackAddress;

@end
