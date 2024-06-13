//
//  main.m
//  GasStationBiz
//
//  Created by xp on 2023/5/10.
//

#import <UIKit/UIKit.h>
@import MBLauncherLib;
@import MBAppBasisModule;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return MBApplicationMain(argc, argv, [[MBMainLaunchHandler alloc]init]);
    }
}
