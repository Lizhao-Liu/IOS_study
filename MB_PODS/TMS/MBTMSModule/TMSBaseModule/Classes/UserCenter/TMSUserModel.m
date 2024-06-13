//
//  TMSUserModel.m
//  TMSBaseModule
//
//  Created by zht on 2021/4/27.
//

#import "TMSUserModel.h"
#import <UIKit/UIKit.h>
#import "TMSCommonMacros.h"
@import MBStorageLib;
@implementation TMSRoleModel


@end


@implementation TMSUserModel
@synthesize nakedMobile = _nakedMobile;

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
        @"roles" : @"TMSRoleModel",
        @"dataList" : @"TMSMineModel",
    };
}


- (NSString *)nakedMobile{
    
    if (!_nakedMobile) {
        _nakedMobile = [[NSUserDefaults standardUserDefaults] objectForKey:TMSKEY_STORAGE_USERINFO];
    }
    
    return _nakedMobile;
}

- (void)setNakedMobile:(NSString *)nakedMobile{

    _nakedMobile = nakedMobile;

    [[NSUserDefaults standardUserDefaults] setObject:nakedMobile forKey:TMSKEY_STORAGE_USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation TMSDeviceModel
@synthesize appversion = _appversion;
@synthesize appuuid = _appuuid;

- (NSString *)appversion{
    
    if (!_appversion) {
        
        NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
        _appversion = bundleDic[@"CFBundleShortVersionString"];
        _appversion = [NSString stringWithFormat:@"%@.0",_appversion];
    }
    
    return _appversion;
}

- (NSString *)appuuid{
    
    return @"";
}

@end
