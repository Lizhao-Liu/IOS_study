//
//  HCBCodeScanerRegulationGroup.h
//  HCBCodeScaner
//
//  Created by tp on 21/03/2018.
//

#import <Foundation/Foundation.h>

@class HCBCodeScanerRegulation;

NS_ASSUME_NONNULL_BEGIN

@interface HCBCodeScanerRegulationGroup : NSObject

@property (nonatomic, strong, readonly) NSArray<HCBCodeScanerRegulation *> *regulations;

- (BOOL)hasRegulation:(HCBCodeScanerRegulation *)regulation;
- (void)addRegulation:(HCBCodeScanerRegulation *)regulation;
- (void)removeRegulation:(HCBCodeScanerRegulation *)regulation;

- (nullable HCBCodeScanerRegulation *)regulationMathesResult:(NSString *)result;

@end

NS_ASSUME_NONNULL_END
