//
//  MBMatrixReportModel.m
//  MBAPMLib
//
//  Created by 别施轩 on 2021/8/6.
//

#import "MBMatrixLagDetectorReportModel.h"
#import "MBAPMUUIDUtil.h"

@import Matrix;
@import MBBuildPreLib;

@implementation MatrixReportCrashThreadTraceModel

- (NSString *)reportText {
    if ([MBFMacro ymm_buildAdhoc] || [MBFMacro ymm_buildDebug]) {
        NSString *symbolName = self.fixedSymbolName;
        if (symbolName.length > 0) {
            return [NSString stringWithFormat:@"%@                0x%llx %@", _objectName?:@"dyld", _instructionAddr, symbolName];
        }
    }
    
    if (_repeatCount <= 0) {
        return [NSString stringWithFormat:@"%@                0x%llx 0x%llx + %llu", _objectName?:@"dyld", _instructionAddr, _objectAddr, _instructionAddr - _objectAddr];
    } else {
        return [NSString stringWithFormat:@"%lu-%@                0x%llx 0x%llx + %llu", (unsigned long)_repeatCount, _objectName?:@"dyld", _instructionAddr, _objectAddr, _instructionAddr - _objectAddr];
    }
 
}

- (NSString *)fixedSymbolName {
    if (_symbolName.length > 0) {
        return _symbolName;
    }

    if (([MBFMacro ymm_buildAdhoc] || [MBFMacro ymm_buildDebug]) && ([_objectName hasPrefix:@"MB"] || [_objectName hasPrefix:@"YMM"])) {
        
        WCAddressFrame * frame = [[WCAddressFrame alloc] init];
        frame.symbolAddress = _symbolAddr;
        frame.imageAddress = _objectAddr;
        frame.instructionAddress = _instructionAddr;
        [frame symbolicateLastCrash];
        
        NSDictionary *dic = [frame getInfoDict];
        if ([[dic allKeys] containsObject:@"object_name"]) {
            return dic[@"object_name"];
        }
    }
    
    return @"";
}

- (NSString *)featureText {
    return [NSString stringWithFormat:@"%@ + %llu", _objectName?:@"dyld", _instructionAddr - _objectAddr];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"objectName" : @"object_name",
             @"objectAddr" : @"object_addr",
             @"symbolName" : @"symbol_name",
             @"symbolAddr" : @"symbol_addr",
             @"instructionAddr" : @"instruction_addr",
             @"repeatCount" : @"repeat_count"
    };
}

@end


@implementation MatrixReportCrashThreadBacktraceModel


- (NSArray<NSString *> *)reportTexts {
    if (!_contents ||_contents.count < 1) {
        return @[@"(null)", @"(null)"];
    }
    NSString *mainImageName = [MBAPMUUIDUtil getMainImageName];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *keyStack = nil;
    for (MatrixReportCrashThreadTraceModel* stack in _contents) {
        [result appendFormat:@"\n%@", stack.reportText];
        if(keyStack && keyStack.length > 0) {
            continue;
        }
        if (keyStack.length == 0 &&
            ([stack.objectName containsString:mainImageName] || [stack.objectName containsString:@"Flutter"])) {
            keyStack = [stack featureText];
        }
    }
    if (!keyStack) {
        keyStack = [_contents.firstObject featureText];
    }
    return @[result, keyStack?:@"(null)"];
}

- (NSString *)reportText {
    NSMutableString *result = [[NSMutableString alloc] init];
    for (MatrixReportCrashThreadTraceModel* stack in _contents) {
        [result appendFormat:@"\n%@", stack.reportText];
    }
    return result;
}

- (NSString *)featureStackFrame {
    NSString *mainImageName = [MBAPMUUIDUtil getMainImageName];
    NSString *keyStack = nil;
    for (MatrixReportCrashThreadTraceModel* stack in _contents) {
        if ([stack.objectName containsString:mainImageName] || [stack.objectName containsString:@"Flutter"]) {
            keyStack = [stack featureText];
            break;
        }
    }
    if (!keyStack) {
        keyStack = [_contents.firstObject featureText];
    }
    return keyStack?:@"(null)";
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contents" : [MatrixReportCrashThreadTraceModel class]};
}

@end


@implementation MatrixReportCrashThreadModel

// 返回两个String。第一个是栈信息，第二个是关键栈。
- (NSArray<NSString *> *)reportTexts {
    return _backtrace.reportTexts;
}

- (NSString *)reportText {
    return _backtrace.reportText;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"backtrace" : @"backtrace",
             @"crashed" : @"crashed",
             @"currentThread" : @"current_thread"};
}

@end


@implementation MatrixReportCrashModel

- (NSArray<NSString *> *)reportTexts {
    NSMutableString *stacks = [[NSMutableString alloc] init];
    __block NSString *errorStack;
    [_threads enumerateObjectsUsingBlock:^(MatrixReportCrashThreadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *threadStackInfos = [obj reportTexts];
        if (!errorStack && threadStackInfos.lastObject) {
            errorStack = threadStackInfos.lastObject;
        }
        NSString *threadName = [NSString stringWithFormat:@"Thread %lu", (unsigned long)idx];
        [stacks appendFormat:@"\n%@", obj.name ?: threadName];
        [stacks appendFormat:@"%@\n", threadStackInfos.firstObject];
    }];
    
    return @[stacks, errorStack];
}

- (NSArray<NSString *> *)crashThreadStacks {
    NSMutableArray<NSString *> *threadStacks = [NSMutableArray new];
    for (MatrixReportCrashThreadModel *threadModel in self.threads) {
        [threadStacks addObject:threadModel.reportText];
    }
    return threadStacks;
}

- (NSString *)crashFeatureStackFrame {
    for (MatrixReportCrashThreadModel *threadModel in self.threads) {
        if (threadModel.crashed) {
            return threadModel.backtrace.featureStackFrame;
        }
    }
    return @"(null)";
}

- (NSString *)lagFeatureStackFrame {
    return self.threads.firstObject.backtrace.featureStackFrame ?: @"(null)";
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"threads" : [MatrixReportCrashThreadModel class]};
}


@end


@implementation MatrixReportInfoModel
@end


@implementation MatrixReportModel

- (NSArray<NSString *> *)reportTexts {
    NSArray<NSString *> *reportTexts = _crash.reportTexts;
    if (reportTexts.firstObject.length > 0 && reportTexts.lastObject.length == 0) {
        return @[reportTexts.firstObject, @"(null)"];;
    }
    
    return @[reportTexts.firstObject, reportTexts.lastObject];
}

- (unsigned long)timestamp {
    return _report.timestamp;
}

@end

@implementation MatrixReportZombieExceptionModel


@end

@implementation MatrixReportProcessInfoModel

@end

@implementation MatrixReportSignalErrorModel

@end

@implementation MatrixReportNSExceptionErrorModel

@end

@implementation MatrixReportCPPExceptionErrorModel


@end

@implementation MatrixReportErrorModel

- (NSString *)errorType {
    if (!_type || _type.length == 0) {
        return @"";
    }
    if ([_type isEqualToString:@"signal"]) {
        return [NSString stringWithFormat:@"%@,%@", _signal.name, _signal.code_name];
    } else if ([_type isEqualToString:@"nsexception"]) {
        return [NSString stringWithFormat:@"%@,%@", _nsexception.name, [self preprocessNSExceptionReason:_reason]];
    } else if ([_type isEqualToString:@"cpp_exception"]) {
        return [NSString stringWithFormat:@"%@", _cpp_exception.name];
    }
    return @"";
}

- (NSString *)preprocessNSExceptionReason:(NSString *)reason {
    NSString *preprocessedReason = reason;
    NSDictionary<NSString *, NSString *> *regExpAndReplaceStrDic = @{@"(((0x)[a-f0-9]+)|([a-f0-9]+h))":@"0xxxxxxx", @"\\(\\d+ \\d+; \\d+ \\d+\\)":@"(x x; x x)", @"\\{\\d+(.\\d+)?, \\d+(.\\d+)?\\}":@"{x, x}", @"\\(\\d+\\)":@"(x)", @"\\{\\d+, \\d+, \\d+, \\d+\\}":@"{x, x, x, x}"};
    for(NSString *regExpStr in regExpAndReplaceStrDic.allKeys) {
        NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        if (!regExp) {
            continue;
        }
        NSString *replaceStr = [regExpAndReplaceStrDic objectForKey:regExpStr];
        preprocessedReason = [regExp stringByReplacingMatchesInString:preprocessedReason
                                                          options:NSMatchingReportProgress
                                                            range:NSMakeRange(0, preprocessedReason.length)
                                                     withTemplate:replaceStr];
        
        
    }
    return preprocessedReason;
}

@end
