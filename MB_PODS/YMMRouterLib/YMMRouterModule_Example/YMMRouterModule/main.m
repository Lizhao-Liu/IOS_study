//
//  main.m
//  YMMRouterModule
//
//  Created by knop on 03/06/2019.
//  Copyright (c) 2019 knop. All rights reserved.
//

@import UIKit;
#import "YMMAppDelegate.h"
#import "YMMRouterMainModule.h"
#import "YMMRouterMainViewModule.h"
@import YMMModuleLib;
@import MBLauncherLib;


int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        return MBApplicationMain(argc, argv, [YMMRouterMainModule new]);
    }
}
