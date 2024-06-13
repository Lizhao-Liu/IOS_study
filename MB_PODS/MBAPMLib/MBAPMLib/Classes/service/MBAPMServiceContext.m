//
//  MBAPMServiceContext.m
//  MBAPMLib
//
//  Created by xp on 2020/7/27.
//

#import "MBAPMServiceContext.h"

@implementation MBAPMServiceContext

- (MBModuleInfo *)getModuleInfo {
    MBModuleInfo *moduleInfo = [MBModuleInfo new];
    moduleInfo.moduleName = @"app";
    moduleInfo.subModuleName = @"apm";
    return moduleInfo;
}


@end
