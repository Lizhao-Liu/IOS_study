//
//  MBAPMContext.h
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBAPMConfiguration;
@protocol MBAPMDelegate;


@interface MBAPMContext : NSObject

@property (nonatomic, strong) MBAPMConfiguration *configuration;

@property (nonatomic, weak, nullable) id<MBAPMDelegate> delegate;

@property (nonatomic, assign) BOOL hasLaunchSuccess;

@property (nonatomic, strong, nullable) NSMutableArray<NSString *> *allRenderDetectBlockList;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (MBAPMContext *)createContext;

+ (MBAPMContext *)globalContext;


@end

NS_ASSUME_NONNULL_END
