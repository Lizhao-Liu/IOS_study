//
//  MBAPMMemoryUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import "MBAPMMemoryUtil.h"
#import <mach/mach_types.h>
#import <mach/mach.h>
#import <mach/task_info.h>
#import <sys/sysctl.h>

@implementation MBAPMMemoryUtil

+ (CGFloat)appMemoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(result != KERN_SUCCESS) {
        return 0.f;
    }
    float memoryUsage =  vmInfo.phys_footprint/(float)(1024*1024);
    return memoryUsage;
}

+ (CGFloat)totalMemoryUsage {
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
    {
        return 0;
    }
    
    UInt64 wireMem = vmstat.wire_count * pagesize;
    UInt64 activeMem = vmstat.active_count * pagesize;
    // inactive_count 虽然是后续可以被释放，但是当前仍然在被占用
    UInt64 inactive_count = vmstat.inactive_count * pagesize;
    return (wireMem + activeMem + inactive_count)/(float)(1024*1024);
}

+ (CGFloat)availableMemory {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return (CGFloat)(vm_page_size * (vmStats.free_count + vmStats.inactive_count)  / 1024.0 / 1024.0);
}

+ (NSInteger)totalMemoryForDevice{
    return (NSInteger)([NSProcessInfo processInfo].physicalMemory/1024/1024);
}

@end
