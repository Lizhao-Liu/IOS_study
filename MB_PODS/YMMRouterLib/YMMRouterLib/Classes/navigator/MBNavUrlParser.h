//
//  MBNavUrlParser.h
//  YMMRouterLib
//
//  Created by xp on 2023/8/1.
//

#import <Foundation/Foundation.h>
#import "MBNavTransition.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBNavUrlParser <NSObject>

- (MBNavParameterOptions)parseUrl:(NSString *)url;

@end

@interface MBCommonNavUrlParser : NSObject

@end

NS_ASSUME_NONNULL_END
