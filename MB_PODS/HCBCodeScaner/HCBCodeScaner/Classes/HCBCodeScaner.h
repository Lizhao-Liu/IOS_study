//
//  HCBCodeScaner.h
//  HCBCodeScaner
//
//  Created by tp on 20/03/2018.
//

#import "HCBCodeScanerRegulation.h"
#import "HCBCodeScanerViewController.h"
#import "HCBCodeScanerView.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const HCBCodeScanerDidScanedSuccessNotification;
FOUNDATION_EXPORT NSString *const HCBCodeScanerDidClickAlbumNotification;

/// 未识别的二维码处理 block
typedef void (^HCBCodeScanerUnrecognizedScanResultHandler)(HCBCodeScanerViewController *_Nullable viewController, NSString *_Nullable result);

/// 未能获取到选择图片中的二维码 block
typedef void (^HCBCodeScanerNoResultFoundInTargetImageHandler)(HCBCodeScanerViewController *_Nullable viewController);

@interface HCBCodeScaner : NSObject

/**
 是否允许从相册中选取照片扫码

 @param allowedChooseFromAlbum 默认为NO
 */
// cxm: 暂时先移除该配置功能，内部默认可以从相册选择，后续有需求再开发
// 后续如果开发该功能，则字段配置需要放到HCBCodeScanerViewController.h中。
//+ (void)setAllowedChooseFromAlbum:(BOOL)allowedChooseFromAlbum;

/**
 是否开启二维码放大功能

 @param scale 默认为 YES
 */
+ (void)setScalingEnabled:(BOOL)scale;

/**
 配置未识别的二维码处理 block

 @param handler 默认为 nil
 */
+ (void)setUnrecognizedScanResultHandler:(HCBCodeScanerUnrecognizedScanResultHandler)handler;

/**
 配置未识别的图片二维码处理 block

 @param handler 默认为 nil
 */
+ (void)setNoResultFoundInTargetImageHandler:(HCBCodeScanerNoResultFoundInTargetImageHandler)handler;

/**
 添加二维码识别规则，各客户端或业务线组件应分别创建并注册自己的识别规则

 @param regulation 二维码识别规则
 */
+ (void)addRegulation:(HCBCodeScanerRegulation *)regulation;

/**
 获取当前的扫码 view controller 实例

 @return 当前的扫码 view controller 实例
 */
+ (nullable HCBCodeScanerViewController *)getCurrentViewController;

/**
 识别图片中二维码或条形码
 
 @return 初始化成功/失败
 */
+ (NSString *)scanImage:(UIImage *)image format:(MBCodeScanFormatType)type;

/**
 识别图片中的二维码，并校验已注册的二维码识别规则执行回调，未命中则会执行默认行为

 @param image 待识别的二维码图片
 @return 识别结果
 */
+ (nullable NSString *)scanImage:(UIImage *)image;

/**
 识别图片中的二维码，不做规则校验和执行回调，直接返回结果
 
 @param image 待识别的二维码图片
 @return 识别结果
 */
+ (nullable NSString *)scanImageWithoutCallback:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
