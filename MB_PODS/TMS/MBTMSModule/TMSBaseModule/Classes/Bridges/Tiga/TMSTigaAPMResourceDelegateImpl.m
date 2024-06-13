//
//  TMSTigaAPMResourceDelegateImpl.m
//  AAChartKit
//
//  Created by Lizhao on 2023/12/19.
//

#import "TMSTigaAPMResourceDelegateImpl.h"
@import MBAPMLib;

@serviceEX(TMSTigaAPMResourceDelegateImpl, MBTigaAPMResourceDelegate)

- (CGFloat)appMemoryUsage {
    return [MBAPMMemoryUtil appMemoryUsage];
}

- (NSArray *)getLatestAppMemoryUsageForDuration:(NSInteger)duration {
    return [[MBAPMSystemDataGather sharedIntance] getLatestAppMemoryUsageForDuration:duration];
}

- (CGFloat)totalMemoryUsage {
    return [MBAPMMemoryUtil totalMemoryUsage];
}


- (NSArray *)getLatestTotalMemoryUsageForDuration:(NSInteger)duration {
    return [[MBAPMSystemDataGather sharedIntance] getLatestTotalMemoryUsageForDuration:duration];
}

- (CGFloat)availableMemory {
    return [MBAPMMemoryUtil availableMemory];
}

- (NSArray *)getLatestAvailableMemoryUsageForDuration:(NSInteger)duration {
    return [[MBAPMSystemDataGather sharedIntance] getLatestAvailableMemoryUsageForDuration:duration];
}

- (NSInteger)totalMemoryForDevice {
    return [MBAPMMemoryUtil totalMemoryForDevice];
}

// cpu
- (CGFloat)appCpuUsagePercentage {
    return [MBAPMCPUUtil appCpuUsage];
}


- (NSArray *)getLatestAppCPUUsageForDuration:(NSInteger)duration {
    return [[MBAPMSystemDataGather sharedIntance] getLatestAppCPUUsageForDuration:duration];
}

- (CGFloat)totalCpuUsagePercentage {
    return [MBAPMCPUUtil totalCpuUsage];
}


- (NSArray *)getLatestTotalCPUUsageForDuration:(NSInteger)duration {
    return [[MBAPMSystemDataGather sharedIntance] getLatestTotalCPUUsageForDuration:duration];
}


// 存储空间
- (CGFloat)availableStorage {
    return [MBAPMStorageUtil getAvailableStorage];
}

- (CGFloat)totalStorageForDevice {
    return [MBAPMStorageUtil totalStorageForDevice];
}

// 设备评分
- (NSString *)deviceScore {
    return [MBDeviceInfo deviceScore];
}

- (BOOL)highRefreshRate {
    return [MBAPMFPSUtil.sharedInstance isHighFps];
}

- (uint64_t)cpuRecordInterval {
    return [MBAPMSystemDataGather sharedIntance].dataGatherfrequency;
}

- (uint64_t)memoryRecordInterval {
    return [MBAPMSystemDataGather sharedIntance].dataGatherfrequency;
}


@end

