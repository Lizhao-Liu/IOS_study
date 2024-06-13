//
//  MBDebugMonitorEventAlertModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MBDebugMonitorAlertDialogButtonAction)(void);

@interface MBDebugMonitorAlertDialogButton : NSObject

@property (nonatomic, strong) NSString *btnTitle;

@property (nonatomic, copy) MBDebugMonitorAlertDialogButtonAction btnAction;

@end

@interface MBDebugMonitorAlertDialog : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSArray<MBDebugMonitorAlertDialogButton *> *buttons;

+ (instancetype)alertDialogWithTitle:(NSString *)title content:(NSString *)content buttons:(NSArray<MBDebugMonitorAlertDialogButton *> *)buttons;

@end


NS_ASSUME_NONNULL_END
