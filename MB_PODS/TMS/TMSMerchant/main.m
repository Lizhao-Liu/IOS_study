//
//  main.m
//  TMSMerchant
//
//  Created by zht on 2021/5/8.
//

#import <UIKit/UIKit.h>
@import MBLauncherLib;
@import MBAppBasisModule;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return MBApplicationMainWithHandler(argc, argv, [[MBMainLaunchHandler alloc] init], [[MBMainModuleLaunchHandler alloc] init]);
    }
}
