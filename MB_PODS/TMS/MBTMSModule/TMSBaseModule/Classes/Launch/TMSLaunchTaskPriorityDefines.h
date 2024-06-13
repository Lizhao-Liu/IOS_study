//
//  TMSLaunchTaskPriorityDefines.h
//  MBTMSModule
//
//  Created by xp on 2023/5/12.
//


#ifndef TMSLaunchTaskPriorityDefines_h
#define TMSLaunchTaskPriorityDefines_h

typedef NS_ENUM(NSUInteger, TMSLaunchTaskPriority) { //启动场景
   TMSLaunchBasicTaskPriorityLowest = 0,
   TMSLaunchBasicTaskPriorityDefault = 1,
    
   TMSLaunchBasicTaskPriorityBridge = 887,
   TMSLaunchBasicTaskPriorityHotfix = 888,
   TMSLaunchBasicTaskPriorityConfigCenter = 889,
   TMSLaunchBasicTaskPriorityRepair = 900,
   TMSLaunchBasicTaskPriorityRepairView = 901,
   TMSLaunchBasicTaskPriorityUser = 989,
   TMSLaunchBasicTaskPriorityNetwork = 990,
   TMSLaunchBasicTaskPriorityProjectConfig = 991,
   TMSLaunchBasicTaskPriorityCrash = 993,
   TMSLaunchBasicTaskPriorityLog = 994,
   TMSLaunchBasicTaskPriorityAPM = 995,
   TMSLaunchBasicTaskPriorityFoundation = 996,
   TMSLaunchBasicTaskPriorityDoctor = 997,
   TMSLaunchBasicTaskPriorityStorage = 998,
   TMSLaunchBasicTaskPriorityConfigSetup = 999,
   TMSLaunchBasicTaskPriorityHighest = 1000
};

#endif /* TMSLaunchTaskPriorityDefines_h */
