//
//  ObjcImplClasses.h
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

#import <Foundation/Foundation.h>
@import YMMModuleLib;
#import "ObjcProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjcImplClassA : NSObject

@property(nonatomic, assign) BOOL methodCalled;

@end

@interface ObjcImplClassB : NSObject <OCServiceForOCImpl>

@property(nonatomic, assign) BOOL methodCalled;

@end

@interface ObjcImplClassC : NSObject

@end

@interface ObjcImplClassD : NSObject

@end


NS_ASSUME_NONNULL_END
