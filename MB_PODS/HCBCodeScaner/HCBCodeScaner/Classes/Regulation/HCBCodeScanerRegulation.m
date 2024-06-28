//
//  HCBCodeScanerMatchRegulation.m
//  HCBCodeScaner
//
//  Created by tp on 21/03/2018.
//

#import "HCBCodeScanerRegulation.h"
#import "HCBCodeScanerRegulation_Private.h"

@interface HCBCodeScanerRegulation ()

- (instancetype)initWithRule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler;

@end

@implementation HCBCodeScanerRegulation

#pragma mark - Public

+ (instancetype)regulationWithPriority:(HCBCodeScanerRegulationPriority)priority rule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler {
    return [[self alloc] initWithWithPriority:priority rule:rule handler:handler];
}

+ (instancetype)regulationWithRule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler {
    return [self regulationWithPriority:HCBCodeScanerRegulationPriorityPlatform rule:rule handler:handler];
}

#pragma mark - Private

- (instancetype)initWithRule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler {
    return [self initWithWithPriority:HCBCodeScanerRegulationPriorityPlatform rule:rule handler:handler];
}

- (instancetype)initWithWithPriority:(HCBCodeScanerRegulationPriority)priority rule:(HCBCodeScanerRegulationRule)rule handler:(HCBCodeScanerRegulationResultHandler)handler {
    self = [super init];
    if (self) {
        _rule = rule;
        _handler = handler;
        _priority = priority;
    }
    return self;
}

- (BOOL)matches:(NSString *)str {
    return _rule(str);
}

- (void)handle:(NSString *)str sender:(id)sender {
    __kindof UIViewController *viewController;
    if (sender && [sender isKindOfClass:[UIViewController class]]) {
        viewController = sender;
    }
    _handler((HCBCodeScanerViewController *)viewController, str);
}

@end
