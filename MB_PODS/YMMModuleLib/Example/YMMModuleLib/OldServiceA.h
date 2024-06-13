//
//  OldServiceA.h
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YMMModuleLib/YMMModuleManager.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ServiceXProtocol <NSObject, YMMServiceProtocol>

- (void)testServiceX;

@end

@interface OldServiceA : NSObject

@end

NS_ASSUME_NONNULL_END
