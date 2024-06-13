//
//  MBDebugScrollItemBar.h
//  MBDebug
//

#import <UIKit/UIKit.h>
#import "MBDebugMonitorToolModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBDebugScrollItemBar : UIControl

/**
 *  按钮的字体
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 *  按钮的正常颜色
 */
@property (nonatomic, strong) UIColor *textNormalColor;
/**
 *  按钮的选中颜色
 */
@property (nonatomic, strong) UIColor *textSelectedColor;
/**
 *  滑块的颜色
 */
@property (nonatomic, strong) UIColor *sliderColor;
/**
 *  底部横线的颜色的颜色
 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/**
 *  屏幕内显示几个按钮
 */
@property (nonatomic, assign) NSInteger itemCountPerScreen;

/**
 *  是否能够滑动
 */
@property (nonatomic, assign, getter=isScrollEnable) BOOL scrollEnable;

/**
 *  当前index
 */
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *titleButtons;

- (void)setupItemTitles:(NSArray *)itemTitles
     relevantScrollView:(UIScrollView *)relevantScrollView;

- (void)showRedDotAtIndex:(NSInteger) index;

- (void)hideRedDotAtIndex:(NSInteger) index;

@end


NS_ASSUME_NONNULL_END
