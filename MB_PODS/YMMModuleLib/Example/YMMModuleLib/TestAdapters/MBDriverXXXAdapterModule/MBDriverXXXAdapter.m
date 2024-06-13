//
//  MBDriverXXXAdapter.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBDriverXXXAdapter.h"
#import "MBXXXModuleAdapterProtocol.h"

@interface MBDriverXXXAdapter() <MBXXXModuleAdapterProtocol>

@end

@implementation MBDriverXXXAdapter

- (BOOL)run {
    // adapter 方法实现
    NSLog(@"run method for driver");
    
    return NO;
}

@end
