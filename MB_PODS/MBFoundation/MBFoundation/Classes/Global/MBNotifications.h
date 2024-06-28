//
//  MBNotifications.h
//  YMMTestProj
//
//  Created by heng wu on 2020/4/7.
//  Copyright © 2020 heng wu. All rights reserved.
//

#ifndef MBNotifications_h
#define MBNotifications_h

// 通知相关标示名称
static NSString * const GTUserDidLogoutNotification = @"com.xiwei.notification.user_did_logout";

static NSString *const GTVisitorPopToLoginNotification = @"com.xiwei.notification.visitorPopToLogin";

static NSString *const GTNewGoodsArrivedNotification = @"com.xiwei.notification.new_goods_arrived";

static NSString *const GTAlipayDidSucceedNotification = @"com.xiwei.notification.alipay_did_succeed";

static NSString *const GTAlipayDidFailedNotification = @"com.xiwei.notification.alipay_did_failed";

static NSString *const FoundNewVersionPushNotification = @"FoundNewVersionNotification";

static NSString *const UserCheckedVersionNotification = @"UserCheckedVersionNotification";

static NSString * const GTUpdateMessageReadStatusNotification = @"GTUpdateMessageReadStatusNotification";

static NSString *const YMMUserDidLogoutNotification = @"YMMUserDidLogoutNotification";

static NSString *const YMMUserWillLogoutNotification = @"YMMUserWillLogoutNotification";

static NSString *const YMMUserForceLogoutNotification = @"YMMUserForceLogoutNotification";

static NSString *const YMMMainNoticeAddQueueNotification = @"YMMNotificationMainNoticeAddQueue";

//用户需要刷新token（用于货车帮app内）
static NSString *const YMMUserRefreshTokenNotification = @"YMMUserRefreshTokenNotification";

// 配置下发了长连接配置项发送通知
static NSString *const YMMConfigLongConnecNotification = @"YMMConfigLongConnecNotification";

// App进入到首页消息通知
static NSString *const YMMAppDidLoadMainPageNotification = @"YMMAppDidLoadMainPageNotification";

//HCB 通过scheme向YMM发送讯息
static NSString *const HCBSendMsgToYMMNotification = @"HCBSendMsgToYMMNotification";

static NSString *const YMMBargainHistoryDidTapBackButtonSuccessNotification = @"YMMBargainHistoryDidTapBackButtonSuccessNotification";

//native 向flutter 发送消息
static NSString *const YMMNativeSendMsgToFlutterNotification = @"YMMNativeSendMsgToFlutterNotification";

#endif /* MBNotifications_h */
