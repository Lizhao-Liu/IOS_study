//
//  MBXXXModule.h
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import <Foundation/Foundation.h>
#import "MBXXXModuleAdapterProtocol.h"

@import YMMModuleLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBXXXModule : NSObject <YMMModuleProtocol>

- (void)targetMethodToRun;


@end

NS_ASSUME_NONNULL_END
