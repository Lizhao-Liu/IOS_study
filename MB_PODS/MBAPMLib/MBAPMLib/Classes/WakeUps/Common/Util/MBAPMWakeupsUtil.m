//
//  MBAPMWakeupsUtil.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import "MBAPMWakeupsUtil.h"
#include <mach/mach.h>
#include <mach/task.h>

/**
 方法耗时区间 0.000006s - 0.000023s
 */
BOOL GetSystemInterruptWakeups(NSInteger *interrupt_wakeup) {
    struct task_power_info info = {0};
    mach_msg_type_number_t count = TASK_POWER_INFO_COUNT;
    kern_return_t ret = task_info(current_task(), TASK_POWER_INFO, (task_info_t)&info, &count);
    if (ret == KERN_SUCCESS) {
        if (interrupt_wakeup) {
            *interrupt_wakeup = info.task_interrupt_wakeups;
        }
        return true;
    }
    else {
        if (interrupt_wakeup) {
            *interrupt_wakeup = 0;
        }
        return false;
    }
}


@implementation MBAPMWakeupsUtil


+ (NSInteger)getCurrentSystemWakeups {
    NSInteger interruptWakeups;
    GetSystemInterruptWakeups(&interruptWakeups);
    return interruptWakeups;
}


@end
