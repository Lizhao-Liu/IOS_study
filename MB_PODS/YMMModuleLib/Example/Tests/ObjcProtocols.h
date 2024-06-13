//
//  ObjcProtocols.h
//  YMMModuleLib
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

#ifndef ObjcProtocols_h
#define ObjcProtocols_h

@import YMMModuleLib;

@protocol OCServiceForSwiftImpl <MBAdapterProtocol>


@property(nonatomic, assign) BOOL methodCalled;

-(void)runTest;

@end

@protocol OCServiceForOCImpl <MBAdapterProtocol>


@property(nonatomic, assign) BOOL methodCalled;
-(void)runTest;

@end


@protocol OCServiceNotRegistered <MBAdapterProtocol>


@property(nonatomic, assign) BOOL methodCalled;
-(void)runTest;

@end

@protocol OCServiceNotFound <MBAdapterProtocol>


@property(nonatomic, assign) BOOL methodCalled;
-(void)runTest;

@end
#endif /* ObjcProtocols_h */
