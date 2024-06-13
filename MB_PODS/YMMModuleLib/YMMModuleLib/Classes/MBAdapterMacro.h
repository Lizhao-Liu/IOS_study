//
//  MBAdapterMacro.h
//  YMMModuleLib
//
//  Created by Lizhao on 2023/3/15.
//

#ifndef MBAdapterMacro_h
#define MBAdapterMacro_h
#import <Foundation/Foundation.h>

#define GET_ADAPTER($context, $service_protocol, $adapter_name)\
- (id<$service_protocol>)$adapter_name {\
return (id<$service_protocol>)[[MBAdapter shared] adapterOfProtocol:@protocol($service_protocol) fromContext:$context withTarget: self];\
}


#define GET_TARGET\
- (id)getWeakTarget {\
return [[MBAdapter shared] getWeakTargetWithAdapter:self];\
}


#endif /* MBAdapterMacro_h */
