//
//  MBDebugMonitorViewController.h
//  MBDebug
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MBDebugMonitorToolModel;
typedef void (^EventHandleBlock)(void);

@interface MBDebugMonitorViewController : UIViewController

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) EventHandleBlock switchViewBlock;
@property (nonatomic, copy) EventHandleBlock closeViewBlock;

@property (nonatomic, strong) NSString *currentPageName;
@property (nonatomic, weak) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
