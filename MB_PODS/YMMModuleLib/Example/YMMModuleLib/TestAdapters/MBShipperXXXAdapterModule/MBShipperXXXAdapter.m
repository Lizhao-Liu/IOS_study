//
//  MBShipperXXXAdapter.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBShipperXXXAdapter.h"
#import "MBXXXModuleAdapterProtocol.h"
#import "MBXXXModule.h"


@interface MBShipperXXXAdapter() <MBXXXModuleAdapterProtocol>

@end

@implementation MBShipperXXXAdapter

GET_TARGET

- (BOOL)run {
    NSLog(@"run method for shipper");
    [[self getWeakTarget] targetMethodToRun];
    return YES;
}

@end
