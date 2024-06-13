//
//  MBAPMDebugModule.m
//  
//
//  Created by shixuan on 2022/5/31.
//  
//

#import "MBAPMDebugModule.h"

@interface MBAPMDebugModule ()
@end

@moduleEX(MBAPMDebugModule)

+ (NSString *)moduleName {
    return @"app";
}

+ (NSString *)subModuleName {
    return @"apm_debug";
}
@end
