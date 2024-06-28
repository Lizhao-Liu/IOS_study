//
//  MBManagerCenterExport.h
//  MBFoundation
//
//  Created by weigen on 2021/9/22.
//

#ifndef MBManagerCenterExport_h
#define MBManagerCenterExport_h


#ifndef GET_MANAGER
#define GET_MANAGER(obj) ((obj*)[[MBManagerCenter defaultCenter] getManager:[obj class]])
#endif

#ifndef REMOVE_MANAGER
#define REMOVE_MANAGER(obj) [[MBManagerCenter defaultCenter] removeManager:[obj class]]
#endif

#ifndef IS_MANAGER_CREATED
#define IS_MANAGER_CREATED(obj) [[MBManagerCenter defaultCenter] isManagerCreated:[obj class]]
#endif

#endif /* MBManagerCenterExport_h */
