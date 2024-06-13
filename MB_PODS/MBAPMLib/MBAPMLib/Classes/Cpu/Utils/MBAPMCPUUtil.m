//
//  MBAPMCPUUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import "MBAPMCPUUtil.h"
#import <mach/mach_types.h>
#import <mach/mach.h>
#import <mach/task_info.h>
#include <pthread.h>

#import "MBAPMBacktraceLogger.h"
#import "MBCpuDataGatherManager.h"
#import "MBAPMCpuMonitor.h"
#import "MBThreadStackModel.h"

@import MBLogLib;
@import Matrix;
@implementation MBAPMCPUUtil

+ (CGFloat)appCpuUsage {
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    
    if(kr != KERN_SUCCESS) {
        return 0;
    }
    integer_t cpuUsage = 0;
    for(int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        
        if(thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if(!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                cpuUsage += threadBaseInfo->cpu_usage;
            }
        }
    }
    kern_return_t vm_deallocate_kr = vm_deallocate(mach_task_self(), (vm_address_t)threads, threadCount * sizeof(thread_t));
    assert(vm_deallocate_kr == KERN_SUCCESS);
    return cpuUsage/(CGFloat)TH_USAGE_SCALE;
}

+ (CGFloat)appCpuUsageWithMonitorWithNormal:(BOOL )isNormal monitor:(MBAPMCpuMonitor *)monitor {
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    
    if(kr != KERN_SUCCESS) {
        return 0;
    }
    CGFloat cpuUsage = 0.0;
    CGFloat cpuTime = 0.0;
    
    NSInteger beginTime = 0;
    if (!isNormal) {
        beginTime = [[NSDate date] timeIntervalSince1970] * 1000;
    }
    
    NSMutableArray *threadArray = @[].mutableCopy;
    for(mach_msg_type_number_t i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;

        if(thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if(!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                CGFloat curCpuUsage = threadBaseInfo->cpu_usage / 10.0;
                CGFloat curCpuTime = threadBaseInfo->user_time.microseconds / 1000000.0;
                if (!isNormal) {
                    if (curCpuUsage > [[monitor cpuConfig] gather_threshold]) {
                        MBThreadStackModel *exceptionModel = [MBAPMBacktraceLogger mbapm_backtraceOfThread:threads[i]];
                        exceptionModel.cpu_usage = curCpuUsage;
                        exceptionModel.cpu_rate = curCpuTime;
                        char queueName[256];

                        ksthread_getQueueName((KSThread)threads[i], queueName, sizeof(queueName));
                        exceptionModel.name = [[NSString alloc] initWithCString:queueName encoding:NSUTF8StringEncoding];
                        
                        thread_t thread = threads[i];
                        pthread_t pthread = pthread_from_mach_thread_np(thread);
                        mach_port_t machTID = pthread_mach_thread_np(pthread);
                        
                        exceptionModel.number = [NSString stringWithFormat:@"%u", machTID];

//                        NSLog(@"收集的线程名: %@ num:%d mid: %u", exceptionModel.name, i, machTID);
                        if ([exceptionModel.name containsString:monitor.getCpuExceptionOperationQueueName]) {
//                            NSLog(@"收集的线程名: %@ 丢掉", exceptionModel.name);
                            continue;
                        }
                        [threadArray addObject:exceptionModel];
                    }
                }
                
                cpuUsage += curCpuUsage;
                cpuTime += curCpuTime;
            }
        }
    }
//    if (!isNormal) {
//       NSInteger endTime = [[NSDate date] timeIntervalSince1970] * 1000;
//       NSLog(@"cpu采样-异常-采集一次时间:%ld", endTime - beginTime);
//    }
    // 正常收集
    if (isNormal) {
        [[MBCpuDataGatherManager sharedInstance] addCpuUsageRecord:cpuUsage];
        [[MBCpuDataGatherManager sharedInstance] addCpuRateRecord:cpuTime];
        // 开启定时器,在一分钟内收集 60 次
        if (cpuUsage > [[monitor cpuConfig] total_gather_threshold]) {
            // 异常收集定时器为开启
            [monitor startExceptionMonitor];
        }
    } else { // 异常收集
        // 满足总 cpu 使用率时,可以收集异常堆栈
        if (cpuUsage > [[[MBAPMCpuMonitor shareInstance] cpuConfig] total_gather_threshold]) {
            NSString *msg = [NSString stringWithFormat:@"每次收集的个数:%ld", threadArray.count];
            MBModuleDebug("MBAPMLib", msg);
            if (threadArray.count) {
                for (MBThreadStackModel *m in threadArray) {
                    MBThreadStackPerModel *first = m.stackPerModelArray.firstObject;
                    if ([first.stack containsString:@"_pthread"] || m.number.intValue == 0) {
                        [[MBCpuDataGatherManager sharedInstance] addExceptionModel:m];
                    } else {
                        NSString *msg = [NSString stringWithFormat:@"丢弃线程,起始堆栈:%@", first.stack];
                        MBModuleDebug("MBAPMLib", msg);
                    }
                }
                
            }
        }
    }

    kern_return_t vm_deallocate_kr = vm_deallocate(mach_task_self(), (vm_address_t)threads, threadCount * sizeof(thread_t));
    assert(vm_deallocate_kr == KERN_SUCCESS);
    return cpuUsage;
}

+ (CGFloat)totalCpuUsage {
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    return (user + nice + system)/(float)total;
}

@end
