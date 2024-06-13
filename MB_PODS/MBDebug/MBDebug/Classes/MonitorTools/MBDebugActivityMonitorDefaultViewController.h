//
//  MBDebugActivityMonitorDefaultViewController.h
//  MBDebug
//
//  Created by Lizhao on 2022/11/21.
//

#import <UIKit/UIKit.h>
@import MBDebugService;

NS_ASSUME_NONNULL_BEGIN
typedef void (^unfoldCellBlock)(void);
typedef void (^UpdateTableBlock)(NSArray *filteredArr);

/// 可折叠展开cell需要实现的protocol
@protocol MBDebugActivityMonitorExpandableCellProtocol <NSObject>

@property (nonatomic, copy) unfoldCellBlock unfoldBlock;

@end


/// 自定义search view需要实现的protocol
@protocol MBDebugActivityMonitorCustomSearchViewProtocol <NSObject>

@property (nonatomic, copy) UpdateTableBlock updateBlock;

@end


/// 监听面板展示界面delegate
@protocol MonitorPanelViewDelegate <NSObject>

@optional

/// 配置需要展示的cell
/// @param tableView 返回当前tableview
/// @param indexPath 返回当前cell的indexPath
/// @param model 返回当前cell需要展示的数据，数据类型为datasource中管理的数据类型
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(id)model;
/// 配置cell的行高
- (CGFloat)heightForMonitorCellAtIndexPath:(NSIndexPath *)indexPath withModel:(id)model;

// 点击了cell的响应事件
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(id)model;

// 返回自定义底部搜索/筛选框，取代默认自定义底部搜索/筛选框
- (UIView *)customSearchViewWithSourceArr:(NSArray *)sourceArr updateTableBlock:(UpdateTableBlock)block;

@end

typedef NS_ENUM(NSUInteger, MBDebugMonitorSourceFilterType) {
    MBDebugMonitorPanelSourceFilterWithPageName = 0,
    MBDebugMonitorPanelSourceFilterWithbundleName = 1,
    MBDebugMonitorPanelSourceFilterWithbundleType = 2,
    MBDebugMonitorPanelSourceFilterWithModuleName = 3,
    MBDebugMonitorPanelSourceFilterWithSubmoduleName = 4
};


@protocol MBDebugMonitorLogDataSourceProtocol;

@interface MBDebugMonitorPanelConfigModel : NSObject

@property (nonatomic, assign) BOOL needShowTagFilter;

@property (nonatomic, strong) NSString *tagFilterTitle;

@property (nonatomic, assign) BOOL needShowSourceFilter;

@property (nonatomic, strong) NSString *sourceFilterTitle;

@property (nonatomic, assign) MBDebugMonitorSourceFilterType sourceFilterType;

@end


/// 监听面板通用vc模板
@interface MBDebugActivityMonitorDefaultViewController : UIViewController <MBDebugActivityMonitorVCProtocol>

/// 监听面板展示delegate，详见@see MonitorPanelViewDelegate
@property (nonatomic, weak) id<MonitorPanelViewDelegate> viewDelegate;

/// 监听面板初始化
/// @param dataSource 传入监听面板展示数据源
- (instancetype)initWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource;

- (instancetype)initWithDataSource:(id<MBDebugMonitorLogDataSourceProtocol>)dataSource configuration:(MBDebugMonitorPanelConfigModel *)config;

@end

NS_ASSUME_NONNULL_END
