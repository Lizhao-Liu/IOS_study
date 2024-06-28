//
//  MBCommonDefine.h
//  YMMTestProj
//
//  Created by heng wu on 2020/4/7.
//  Copyright © 2020 heng wu. All rights reserved.
//


#import <Foundation/Foundation.h>

#ifndef MBCommonDefine_h
#define MBCommonDefine_h

static inline NSString *kMBAppType(void) {
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"App-type"] ?: @"";
}

static inline BOOL kMBAppTypeIsYMM(void) {
  return [kMBAppType() isEqualToString:@"YMM"];
}

static inline BOOL kMBAppTypeIsHCB(void) {
  return [kMBAppType() isEqualToString:@"HCB"];
}

static inline BOOL kMBAppTypeIsCCL(void) {
  return [kMBAppType() isEqualToString:@"CCL"];
}

static inline BOOL kMBAppTypeIsSD(void) {
  return [kMBAppType() isEqualToString:@"SD"];
}

static inline BOOL kMBAppTypeIs(NSString* appType) {
  return [kMBAppType() isEqualToString:appType];
}


typedef void(^MBVoidBlockFunction)(void);

// MARK: - dispatch 语法糖

/// 提高效率，若已经在队列任务中，会直接执行，不再另开async
static void fMBRunOnQueueASync(dispatch_queue_t queue, MBVoidBlockFunction block) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
        
    } else {
        dispatch_async(queue, block);
    }
}

/// 提高效率，若已经在队列任务中，会直接执行，不再另开async
static void fMBRunOnMainASync(MBVoidBlockFunction block) {
    fMBRunOnQueueASync(dispatch_get_main_queue(), block);
}

/// 避免死锁，在相应队列或者主线程会直接执行任务
static void fMBRunOnQueueSync(dispatch_queue_t queue, MBVoidBlockFunction block) {
    if ([NSThread isMainThread]) {
        block();
        
    } else if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
        
    } else {
        dispatch_sync(queue, block);
    }
}

/// 避免死锁，在相应队列或者主线程会直接执行任务
static void fMBRunOnMainSync(MBVoidBlockFunction block) {
    fMBRunOnQueueSync(dispatch_get_main_queue(), block);
}

#endif /* MBCommonDefine_h */

// 不建议使用如下宏部分
/**
 * 定义全局系统性的东西
 */

#ifndef kAppComanyIsYMM
#define kAppComanyIsYMM [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"App-type"] isEqualToString:@"YMM"]
#endif

#pragma mark -
#pragma mark Memory Manager

#ifndef YMM_Weakify
#define YMM_Weakify(oriInstance, weakInstance) __weak typeof(oriInstance) weakInstance = oriInstance;
#endif
#ifndef YMM_Strongify
#define YMM_Strongify(weakInstance, strongInstance) __strong typeof(weakInstance) strongInstance = weakInstance;
#endif

#pragma mark -
#pragma mark System

#ifndef YMM_IsIOS11rLater
#define YMM_IsIOS11rLater ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#endif

#ifndef YMM_IsIOS11_2rLater
#define YMM_IsIOS11_2rLater ([UIDevice currentDevice].systemVersion.floatValue >= 11.2f)
#endif

#pragma mark -
#pragma mark Device

#ifndef IS_IPHONE_5S
#define IS_IPHONE_5S (kScreenHeight == 568.0)
#endif
#ifndef IS_IPHONE_4S
#define IS_IPHONE_4S (kScreenHeight == 480.0)
#endif
#ifndef IS_IPHONE_6S
#define IS_IPHONE_6S (kScreenHeight == 667.0)
#endif
#ifndef IS_IPHONE_5S_OR_4S
#define IS_IPHONE_5S_OR_4S (IS_IPHONE_5S || IS_IPHONE_4S)
#endif
#ifndef IS_IPHONE_5S_OR_4S_OR_6S
#define IS_IPHONE_5S_OR_4S_OR_6S (IS_IPHONE_5S || IS_IPHONE_4S || IS_IPHONE_6S)
#endif

#pragma mark -

#ifndef YMM_EMPTYSTRING
#define YMM_EMPTYSTRING(A) ({__typeof(A) __a = (A);__a == nil ? @"" : [NSString stringWithFormat:@"%@",__a];})
#endif

// 客户端ID
#ifndef kAppClinetTypeID
#define kAppClinetTypeID 9
#endif

#ifndef kBundleAppVersion
#define kBundleAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#endif
//mod by kevin 20171207_v5.8.10.0 [4位版本号] end

// (默认客服电话)客服电话在配置中获取
#ifndef kCustomerServiceTelephone
#define kCustomerServiceTelephone @"95006"
#endif

#ifndef Define_Captcha_WaitingSeconds
#define Define_Captcha_WaitingSeconds 120
#endif

#ifndef OtherTruckLength
#define  OtherTruckLength @"-99"
#endif

// 获取验证码统一提示文字
#ifndef kGetVerifyCodeText
#define kGetVerifyCodeText @"获取验证码"
#endif

//新版本下载链接
#ifndef kAppDownloadUrl
#define kAppDownloadUrl @"https://itunes.apple.com/us/app/yun-man-man-si-ji-huo-che/id735866915?mt=8"
#endif

#ifndef kTitle_YMM_To_HCB
#define kTitle_YMM_To_HCB(string) kAppComanyIsYMM?string:[string stringByReplacingOccurrencesOfString:@"运满满" withString:@"货车帮"]
#endif

#ifndef mb_dispatch_queue_async_safe
#define mb_dispatch_queue_async_safe(queue, block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
        block();\
    } else {\
        dispatch_async(queue, block);\
    }
#endif

#ifndef mb_dispatch_main_async_safe
#define mb_dispatch_main_async_safe(block) mb_dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#ifndef mb_dispatch_queue_sync_safe
#define mb_dispatch_queue_sync_safe(queue, block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
        block();\
    } else {\
        dispatch_sync(queue, block);\
    }
#endif

#ifndef mb_dispatch_main_sync_safe
#define mb_dispatch_main_sync_safe(block) mb_dispatch_queue_sync_safe(dispatch_get_main_queue(), block)
#endif

#ifndef HCBTOOLKIT_TO_STRING
#define HCBTOOLKIT_TO_STRING(s) @ #s
#endif
