//
//  MBAPMViewPageProtocol.h
//  Pods
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, MBAPMViewPageRenderType) {
    MBAPMViewPageRenderTypeNative,      /// 原生页面
    MBAPMViewPageRenderTypeRN,          /// ReactNative页面
    MBAPMViewPageRenderTypeFlutter,      /// Flutter页面
    MBAPMViewPageRenderTypeH5           /// H5页面
};

typedef NS_ENUM(NSUInteger, MBAPMViewPageRenderDetectType) {
    MBAPMViewPageRenderDetectTypeText,      /// 文本检测自动埋点
    MBAPMViewPageRenderDetectTypeLifeCycle, ///  生命周期检测自动埋点
    MBAPMViewPageRenderDetectTypeManaul          /// 使用方手动埋点
};


/// 性能监控页面协议
@protocol MBAPMViewPageProtocol <NSObject>

@required
/// 返回页面渲染方式
- (MBAPMViewPageRenderType)renderTypeForAPM;

/// 返回页面名称
- (NSString *)pageNameForAPM;

@optional
/// 返回需要检测的页面view
- (UIView *)detectViewForAPM;

/// 是否开启页面的加载时间检测，默认开启
- (BOOL)enableRenderDetectForAPM;

/// 返回页面渲染耗时检测方式, 默认自动
- (MBAPMViewPageRenderDetectType)renderDetectTypeForAPM;

@end

NS_ASSUME_NONNULL_END
