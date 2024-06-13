//
//  MBDebugDefaultTools.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
@import MBDebugService;

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugAPPComponentHandle : NSObject <MBDebugServiceProtocol>

@end

@interface MBDebugDIDIToolsHandle : NSObject <MBDebugServiceProtocol>

@end

@interface MBDebugConfigHandle : NSObject <MBDebugServiceProtocol>

@end


NS_ASSUME_NONNULL_END
