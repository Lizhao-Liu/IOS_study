//
//  MBDebugEntryServiceProtocol.h
//  MBDebugService
//
//  Created by Lizhao on 2023/6/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import YMMModuleLib;

/// block事件处理
typedef void(^MBDebugHandleBlock)(UIViewController *vc);

@protocol MBDebugEntryServiceProtocol <YMMServiceProtocol>

@property (nonatomic, copy, readonly) NSString *entryTitle; // 入口名称

@property (nonatomic, assign) BOOL isHidden; // 是否隐藏入口

@property (nonatomic, copy, readonly) MBDebugHandleBlock handleBlock; // 点击入口事件触发

- (void)entryToolDidLoad; //已加载时机需要执行的方法

@optional

// 需要自定义frame, 建议不超过50*50
@property (nonatomic, strong) UIView *entryView; // 入口视图 (优先级高于入口icon)
// 默认以40*40展示
@property (nonatomic, strong) UIImage *entryIcon; // 入口icon

// 如果未提供入口视图或入口icon 将使用entryTitle展示

@end

