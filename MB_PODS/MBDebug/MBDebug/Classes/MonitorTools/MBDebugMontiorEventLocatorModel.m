//
//  MBDebugMontiorEventLocatorModel.m
//  MBDebug
//
//  Created by Lizhao on 2023/9/25.
//

#import "MBDebugMontiorEventLocatorModel.h"

@interface MBDebugMontiorEventLocatorModel()

@property(nonatomic, readwrite) NSString *pageName;

@end

@implementation MBDebugMontiorEventLocatorModel

+ (instancetype)locatorModelWithPageName:(NSString *)pageName{
    MBDebugMontiorEventLocatorModel *model = [[MBDebugMontiorEventLocatorModel alloc] init];
    model.pageName = pageName;
    return model;
}

+ (instancetype)locatorModelWithPageName:(NSString *)pageName bundleName:(NSString *)bundleName bundleType:(NSString *)bundleType {
    MBDebugMontiorEventLocatorModel *model = [[MBDebugMontiorEventLocatorModel alloc] init];
    model.pageName = pageName;
    model.bundleName = bundleName;
    model.bundleType = bundleType;
    return model;
}

+ (instancetype)locatorModelWithPageName:(NSString *)pageName moduleName:(NSString *)moduleName subModuleName:(NSString *)subModuleName {
    MBDebugMontiorEventLocatorModel *model = [[MBDebugMontiorEventLocatorModel alloc] init];
    model.pageName = pageName;
    model.moduleName = moduleName;
    model.submoduleName = subModuleName;
    return model;
}

@end
