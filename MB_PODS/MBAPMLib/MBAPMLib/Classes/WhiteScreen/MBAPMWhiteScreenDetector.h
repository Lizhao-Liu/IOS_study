//
//  MBAPMWhiteScreenDetector.h
//  Pods
//
//  Created by 别施轩 on 2023/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBAPMConfiguration;
@class MBModuleInfo;

@interface MBAPMWhiteScreenData : NSObject
@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSString *pagePath;
@property (nonatomic, strong) NSString *pageClassName;

@property (nonatomic, strong) NSString* errorFeature;
@property (nonatomic, strong) NSString* exceptionType;
@property (nonatomic, strong) NSString* lastStep;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSString* detectSenario;
@property (nonatomic, strong) MBModuleInfo *moduleInfo;
@property (nonatomic, assign) BOOL hasBitMap;
//page_full_url
//string    否    页面完整url
//bitmap
//string    否    屏幕截图oss key
//duration
//int    否    页面使用时长
//steps
//array    否    白屏前的步骤记录
//
//name    string    在steps中必传    步骤名
//
//st    int    在steps中必传    步骤开始时间戳，相对时间
//
//duration    int    在steps中必传    步骤耗时
//
//success    int    在steps中必传    步骤是否成功
@property (nonatomic, strong) NSDictionary* attrs;

// 以上是结果指标 -- 以下是白屏性能指标

@property (nonatomic, assign) NSInteger bitmapDtectResult;
@property (nonatomic, assign) BOOL isCaptured;
///是否检测完成，只有最后分析截屏图片得出是否白屏的结果才能判定为检测完成，1：完成，0：未完成
@property (nonatomic, assign) BOOL isFinished;
/// 当is_finished为0时必传
/// 枚举值：page_exit(页面退出)，first_layout（页面完成第一次渲染），dialog_exist(存在弹窗页面)，capture_fail(截图失败)
@property (nonatomic, strong) NSString* interruptType;
@property (nonatomic, assign) BOOL isWhiteScreen;
@property (nonatomic, assign) CGFloat captureCostTime;
@property (nonatomic, assign) CGFloat analysisCostTime;
@property (nonatomic, assign) NSInteger timeoutDuration;
@property (nonatomic, assign) CGFloat captureRatio;
@property (nonatomic, assign) CGFloat whitepixelRatio;


@end

@protocol MBAPMWhiteScreenDetectorDelegate <NSObject>

// 发生白屏
- (void)whiteScreen:(NSString*)pageName data:(MBAPMWhiteScreenData *)data;

// 白屏分析工具
- (void)whiteScreenDetect:(NSString*)pageName data:(MBAPMWhiteScreenData *)data;

@end

@interface MBAPMWhiteScreenDetector : NSObject

@property (nonatomic, strong) MBAPMConfiguration *apmConfiguration;

- (void)startDetectWithDelegate:(id<MBAPMWhiteScreenDetectorDelegate>)delegate;
- (void)stopDetect;
@end

NS_ASSUME_NONNULL_END
