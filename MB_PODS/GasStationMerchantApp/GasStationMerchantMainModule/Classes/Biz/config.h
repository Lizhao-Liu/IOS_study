//
//  config.h
//  GasStationBiz
//
//  Created by ty on 2017/9/21.
//  Copyright © 2017年 56qq. All rights reserved.
//

@import MBUIKit;

#ifndef config_h
#define config_h


#define appClientID 261

#define gasStationBugly_Id @"900029891"
#define gasStationBugly_Id_Dev @"43b3296a98"

#define kReloginNotificationKey @"kReloginNotificationKey"

#pragma mark - 颜色配置
#define color_gray_MC3 [UIColor colorWithHexString:@"f3f6fa"] //MC3高级灰
#define color_yellow [UIColor colorWithHexString:@"ffce26"]//统一黄色


#define SCREENWIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT   [[UIScreen mainScreen] bounds].size.height

#define KBUNDLE [[NSBundle mainBundle] pathForResource:@"GasStationMerchantMainModule" ofType:@"bundle"]
#define KBUNDLE_PT [NSBundle bundleWithPath:KBUNDLE]

#define gasStationFlutterHomePageUrl @"ymm://flutter.gs/merchant/homepage"


#endif /* config_h */
