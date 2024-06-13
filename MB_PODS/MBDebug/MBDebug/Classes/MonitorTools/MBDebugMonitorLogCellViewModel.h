//
//  MBDebugMonitorCellViewModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/8/2.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorDefine.h"

NS_ASSUME_NONNULL_BEGIN


@interface MBDebugMonitorTagModel : NSObject

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) UIColor *textColor;//文字颜色
@property (nonatomic, copy) UIColor *borderColor;//文字描边颜色
@property (nonatomic, copy) UIColor *bgColor;//文字背景颜色

@end

@interface MBDebugMonitorCellStyleModel : NSObject

@property (nonatomic, copy) UIColor *errorHighlightColor;//异常数据背景颜色
@property (nonatomic, copy) UIColor *highlightColor;//背景颜色

@end

@interface MBDebugMonitorCellViewModel : NSObject


@property (nonatomic, strong) id<MBDebugMonitorLogObject> originalObject;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, strong) MBDebugMontiorEventLocatorModel *locatorModel;

@end


@interface MBDebugMonitorLogCellViewModel : MBDebugMonitorCellViewModel

@property (nonatomic, strong) MBDebugMonitorTagModel *tagModel;

@property (nonatomic, strong) MBDebugMonitorCellStyleModel *styleModel;

@property (nonatomic, copy) NSString * sourceStr;

@property (nonatomic, copy) NSString * timeStr;

@property (nonatomic, copy) NSString * summaryStr;

@property (nonatomic, copy) NSString * detailStr;

@property (nonatomic, strong) NSArray<NSString *> *attributes;

@property (nonatomic, assign) BOOL isError;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)cellModelWithObject:(id<MBDebugMonitorLogCellObject>)object;

@end

NS_ASSUME_NONNULL_END
