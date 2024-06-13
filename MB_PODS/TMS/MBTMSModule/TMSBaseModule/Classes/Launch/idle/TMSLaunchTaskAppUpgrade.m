//
//  TMSLaunchTaskAppUpgrade.m
//  MBTMSModule
//
//  Created by xp on 2023/5/11.
//

// 注意：检察版本启动项，在 MBVersionModule 1.5.x 版本之后，会被迁移到MBVersionModule中，此处可考虑移除
// 参考：https://wiki.amh-group.com/pages/viewpage.action?pageId=814402759

#import "TMSLaunchTaskAppUpgrade.h"
@import MBLauncherLib;
@import MBVersionModule;

@interface TMSLaunchTaskAppUpgrade() <MBLaunchTask>

@property (nonatomic, strong) MBVersionManager *versionManager;

@end

@MBLaunchTaskEX(TMSLaunchTaskAppUpgrade)
@implementation TMSLaunchTaskAppUpgrade



- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneIdle;
}

- (nonnull NSString *)taskName {
    return @"upgrade";
}

- (BOOL)runTask:(MBLaunchParams *)params {
    [self.versionManager autoCheckAppVersion];
    return YES;
}


#pragma mark - lazyInit

-(MBVersionManager *) versionManager {
    if (!_versionManager) {
        _versionManager = [[MBVersionManager alloc] init];
    }
    return _versionManager;
}

@end
