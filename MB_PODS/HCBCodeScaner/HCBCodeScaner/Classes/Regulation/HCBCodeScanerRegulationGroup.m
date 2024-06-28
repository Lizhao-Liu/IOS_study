//
//  HCBCodeScanerRegulationGroup.m
//  HCBCodeScaner
//
//  Created by tp on 21/03/2018.
//

#import "HCBCodeScanerRegulationGroup.h"
#import "HCBCodeScanerRegulation.h"
#import "HCBCodeScanerRegulation_Private.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"

static const void *const kHCBCodeScanerRegulationGroupSyncQueueSpecificKey = &kHCBCodeScanerRegulationGroupSyncQueueSpecificKey;

#define HCBCODESCANER_REGULATION_GROUP_DISPATCH_SYNC(block)                                                                                                                   \
    do {                                                                                                                                                                      \
        id obj = (__bridge id)dispatch_get_specific(kHCBCodeScanerRegulationGroupSyncQueueSpecificKey);                                                                       \
        NSAssert(obj != self, @"%@: '%@' method was called recursively on the same dispatch queue, this could lead to dead lock!", [self class], NSStringFromSelector(_cmd)); \
        dispatch_sync(_syncQueue, block);                                                                                                                                     \
    } while (0)

@interface HCBCodeScanerRegulationGroup ()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray<HCBCodeScanerRegulation *> *internalRegulations;

@end

@implementation HCBCodeScanerRegulationGroup

#pragma mark - Overriding

- (instancetype)init {
    self = [super init];
    if (self) {
        _syncQueue = dispatch_queue_create("com.wlqq.HCBCodeScaner.RegulationGroup.SyncQueue", DISPATCH_QUEUE_SERIAL);
        _internalRegulations = [NSMutableArray array];
    }
    return self;
}

- (HCBCodeScanerRegulation *)regulationMathesResult:(NSString *)result {
    if (result.length == 0) {
        return nil;
    }
    __block HCBCodeScanerRegulation *regulation;
    HCBCODESCANER_REGULATION_GROUP_DISPATCH_SYNC(^{
        for (HCBCodeScanerRegulation *r in self->_internalRegulations) {
            if (![r matches:result]) {
                continue;
            }
            regulation = r;
            break;
        }
    });
    return regulation;
}

#pragma mark - Public

- (BOOL)hasRegulation:(HCBCodeScanerRegulation *)regulation {
    __block BOOL result = NO;
    HCBCODESCANER_REGULATION_GROUP_DISPATCH_SYNC(^{
        result = [self->_internalRegulations containsObject:regulation];
    });
    return result;
}

- (void)addRegulation:(HCBCodeScanerRegulation *)regulation {
    HCBCODESCANER_REGULATION_GROUP_DISPATCH_SYNC(^{
        if (![self->_internalRegulations containsObject:regulation]) {
            [self->_internalRegulations addObject:regulation];
            [self->_internalRegulations sortUsingComparator:^NSComparisonResult(HCBCodeScanerRegulation *r1, HCBCodeScanerRegulation *r2) {
                if (r1.priority > r2.priority) {
                    return NSOrderedAscending;
                } else if (r1.priority == r2.priority) {
                    return NSOrderedSame;
                }
                return NSOrderedDescending;
            }];
        }
    });
}

- (void)removeRegulation:(HCBCodeScanerRegulation *)regulation {
    HCBCODESCANER_REGULATION_GROUP_DISPATCH_SYNC(^{
        if ([self->_internalRegulations containsObject:regulation]) {
            [self->_internalRegulations removeObject:regulation];
        }
    });
}

@end

#pragma GCC diagnostic pop
