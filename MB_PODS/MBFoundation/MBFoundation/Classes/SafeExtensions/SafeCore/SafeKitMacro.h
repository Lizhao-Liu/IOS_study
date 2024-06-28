//
//  SafeKitMacro.h
//  SafeKitExample
//
//  Created by zhangyu on 14-3-24.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#if __has_feature(objc_arc)
#define SK_AUTORELEASE(exp) exp
#define SK_RELEASE(exp) exp
#define SK_RETAIN(exp) exp
#else
#define SK_AUTORELEASE(exp) [exp autorelease]
#define SK_RELEASE(exp) [exp release]
#define SK_RETAIN(exp) [exp retain]
#endif

#ifdef DEBUG
#define SKLog(...)  NSLog(__VA_ARGS__)
#else
#define SKLog(...)
#endif

#define SK_CATCHSTACK_TRY \
@try { \

#define SK_CATCHSTACK_CATCH \
} @catch (NSException *exception) { \
[[MBFoundationExceptionUtil shared] reportWithException:exception]; \
} @finally {}
