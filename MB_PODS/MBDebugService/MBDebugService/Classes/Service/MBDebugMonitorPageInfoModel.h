//
//  MBDebugMonitorPageInfoModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface MBDebugMonitorPageInfoModel: NSObject

@property (nonatomic, copy) NSString *sectionTitle; // 页面信息页模块名称

@property (nonatomic, strong ) NSDictionary<NSString *, NSString *> *sectionDict; // 模块内容dict

@end

NS_ASSUME_NONNULL_END
