//
//  MBDebugEntryItemModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MBDebugHandleBlock)(UIViewController *vc);

typedef NS_ENUM(NSUInteger, MBDebugEntryItemPriority) {
    MBDebugEntryItemPriorityLow = 0,
    MBDebugEntryItemPriorityNormal = 1,
    MBDebugEntryItemPriorityImportant = 2,
    MBDebugEntryItemPriorityCritical = 3,
};

extern NSString * const kMBDebugEntryItemDefaultPerformanceDetection;
extern NSString * const kMBDebugEntryItemDefaultMonitorLog;
extern NSString * const kMBDebugEntryItemDefaultDebugTools;

@interface MBDebugEntryItemModel : NSObject

@property (nonatomic, copy) NSString *entryTitle; // 入口名称

@property (nonatomic, strong) UIButton *entryButton; // 入口按钮

@property (nonatomic, assign) MBDebugEntryItemPriority priority;

- (void)setUpBtnView:(UIView *)btnView withHandleBlock:(MBDebugHandleBlock)handleBlock;

- (void)setUpBtnIcon:(UIImage *)btnIcon withHandleBlock:(MBDebugHandleBlock)handleBlock;

- (void)setUpDefaultBtnWithHandleBlock:(MBDebugHandleBlock)handleBlock;


@end


NS_ASSUME_NONNULL_END
