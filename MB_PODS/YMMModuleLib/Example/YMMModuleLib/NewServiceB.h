//
//  NewServiceB.h
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YMMModuleLib/YMMModuleManager.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ServiceYProtocol <NSObject, YMMServiceProtocol>

- (void)testServiceY;

@end

@interface NewServiceB : NSObject

@end

NS_ASSUME_NONNULL_END
