//
//  MBAPMCallStackUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/8/16.
//

#import <Foundation/Foundation.h>
@import Matrix;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMThreadStack : NSObject

@property (nonatomic, copy) NSArray* returnAddresses;

- (size_t)occupyMemorySize;

@end

@interface MBAPMCallStackUtil : NSObject

+ (NSString *)callStackOfMainThread;

+ (void)selfThreadStackByMatrix:(KSStackCursor *)stackCursor;

+ (void)selfThreadStackReturnAddresses:(MBAPMThreadStack *)threadStack;

+ (void)selfThreadStackByMatrix:(KSStackCursor *)stackCursor withReturnAddresses:(NSArray *)addresses;


@end

NS_ASSUME_NONNULL_END
