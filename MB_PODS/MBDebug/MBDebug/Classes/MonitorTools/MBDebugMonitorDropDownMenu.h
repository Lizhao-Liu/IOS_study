//
//  MBDebugMonitorDropDownMenu.h
//  MBDebug
//
//  Created by Lizhao on 2023/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MBDebugMonitorDropDownMenu;
@protocol MBDebugMonitorDropMenuDelegate
@required
- (void)didSelectIndex:(NSInteger)index fromMenu:(MBDebugMonitorDropDownMenu *)menu;
@end

@interface MBDebugMonitorDropDownMenu : UIView
@property (nonatomic, weak) id <MBDebugMonitorDropMenuDelegate> delegate;//代理
@property (nonatomic, assign) BOOL isPresented;
@property(nonatomic, copy) NSArray *titleList;

- (void)hideDropDownMenuWithBtnFrame:(CGRect)btnFrame;

- (void)showDropDownMenu:(UIButton *)button withButtonFrame:(CGRect)buttonFrame arrayOfTitle:(NSArray *)titleArr animationDirection:(NSString *)direction;
@end

NS_ASSUME_NONNULL_END
