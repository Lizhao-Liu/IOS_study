//
//  MBRouterModuleLog.h
//  YMMRouterModule
//
//  Created by Lizhao on 2023/5/9.
//

#ifndef MBRouterModuleLog_h
#define MBRouterModuleLog_h

@import MBLogLib;

#define MBRouterModuleLogDebug(...) MBSubModuleDebug("app", "main", __VA_ARGS__)
#define MBRouterModuleLogInfo(...) MBSubModuleInfo("app", "main", __VA_ARGS__)
#define MBRouterModuleLogWarning(...) MBSubModuleWarning("app", "main", __VA_ARGS__)
#define MBRouterModuleLogError(...) MBSubModuleError("app", "main", __VA_ARGS__)


#endif /* MBRouterModuleLog_h */
