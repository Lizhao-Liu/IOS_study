//
//  HCBCodeScanerRegulation.h
//  HCBCodeScaner
//
//  Created by tp on 21/03/2018.
//

#import <Foundation/Foundation.h>

@class HCBCodeScanerViewController;

typedef NS_ENUM(NSUInteger, HCBCodeScanerRegulationPriority) {
    HCBCodeScanerRegulationPriorityPlatform = 0, //low by default
    HCBCodeScanerRegulationPriorityBusiness = 1, //mid
    HCBCodeScanerRegulationPriorityBase = 2      //high
};

NS_ASSUME_NONNULL_BEGIN

/// 识别规则 block，若扫描结果 result 能够识别则返回 YES，否则返回 NO
typedef BOOL (^HCBCodeScanerRegulationRule)(NSString *result);

/// 识别规则命中后回调 block，根据 result 进行后续操作或页面跳转
typedef void (^HCBCodeScanerRegulationResultHandler)(HCBCodeScanerViewController *_Nullable viewController, NSString *result);

/// 二维码识别规则模块，各客户端或业务线组件应分别创建并注册自己的识别规则
@interface HCBCodeScanerRegulation : NSObject

/// 识别规则 block
@property (nonatomic, copy, readonly) HCBCodeScanerRegulationRule rule;

/// 规则优先级，默认为低优先级 HCBCodeScanerRegulationPriorityPlatform
@property (nonatomic, assign, readonly) HCBCodeScanerRegulationPriority priority;

/// 识别规则命中后回调 block
@property (nonatomic, copy, readonly) HCBCodeScanerRegulationResultHandler handler;

/**
 二维码识别规则实例化方法

 @param rule 识别规则 block
 @param handler 识别规则命中后回调 block
 @return 实例
 */
+ (instancetype)regulationWithRule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler __deprecated_msg("use '+regulationWithPriority:rule:handler:'");
;

+ (instancetype)regulationWithPriority:(HCBCodeScanerRegulationPriority)priority rule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler;

@end

NS_ASSUME_NONNULL_END
