//
//  MBAPMLogDef.h
//  MBAPMLib
//
//  Created by xp on 2020/11/5.
//

#ifndef MBAPMLogDef_h
#define MBAPMLogDef_h

@import MBLogLib;

#define MBAPMDebug(...) MBSubModuleDebug("app", "apm", __VA_ARGS__)
#define MBAPMLogInfo(...) MBSubModuleInfo("app", "apm", __VA_ARGS__)
#define MBAPMWarning(...) MBSubModuleWarning("app", "apm", __VA_ARGS__)
#define MBAPMError(...) MBSubModuleError("app", "apm", __VA_ARGS__)


#endif /* MBAPMLogDef_h */
