/*
 * Tencent is pleased to support the open source community by making wechat-MB available.
 * Copyright (C) 2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the BSD 3-Clause License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBDeviceInfo.h"
#import "MBAPMMemoryUtil.h"

#include <sys/sysctl.h>
#include <sys/mount.h>

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#endif

@import MBBuildPreLib;
@import MBProjectConfig;

static bool isSimulatorBuild() {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@implementation MBDeviceInfo

+ (BOOL)isBeingDebugged {
    // Returns true if the current process is being debugged (either
    // running under the debugger or has a debugger attached post facto).
    int junk;
    int mib[4];
    struct kinfo_proc info;
    size_t size;

    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.

    info.kp_proc.p_flag = 0;

    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();

    // Call sysctl.

    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);

    // We're being debugged if the P_TRACED flag is set.
    return ((info.kp_proc.p_flag & P_TRACED) != 0);
}

+ (BOOL)canEnableMonitor {
   if (isSimulatorBuild()) {
       return NO;
   }
   if (![MBFMacro ymm_buildDebug] && ![MBFMacro ymm_buildAdhoc]) {
       return YES;
   }
   if ([MBDeviceInfo isBeingDebugged]) {
       return NO;
   }
    return YES;
}

+ (NSString *)deviceScore {
    NSInteger deviceTotalMemory = [MBAPMMemoryUtil totalMemoryForDevice];
    
    if (deviceTotalMemory >= 6000) {
        return @"high";
    } else if (deviceTotalMemory >= 4000) {
        return @"middle";
    } else {
        return @"low";
    }
}

@end
