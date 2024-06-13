//
//  MBAPMWhiteScreenCounter.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/11/21.
//

#import <Foundation/Foundation.h>
#import "MBAPMWhiteScreenDetector.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWhiteScreenCounter : NSObject

+ (instancetype)shared;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSUInteger detectDuration;

@property (nonatomic, assign) NSUInteger pageFrequentCount;
@property (nonatomic, copy) void(^pageFrequentWhiteScreen)(MBAPMWhiteScreenData *data, NSDictionary *attrs);

@property (nonatomic, assign) NSUInteger stackFrequentCount;
@property (nonatomic, assign) NSUInteger stackFrequentPageMiniCount;
@property (nonatomic, copy) void(^technicalStackFrequentWhiteScreen)(MBAPMWhiteScreenData *data, NSDictionary *attrs);

- (void)whiteScreen:(MBAPMWhiteScreenData *)data;
- (void)notWhiteScreen:(NSString *)pageId techStack:(NSString *)techStack;

@end

NS_ASSUME_NONNULL_END
