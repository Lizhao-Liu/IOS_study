
//  MBDebugMonitorEventAlertModel.m
//  MBDebug
//
//  Created by Lizhao on 2023/11/2.
//

#import "MBDebugMonitorEventAlertModel.h"

@implementation MBDebugMonitorAlertDialogButton

@end

@implementation MBDebugMonitorAlertDialog

+ (instancetype)alertDialogWithTitle:(NSString *)title content:(NSString *)content buttons:(NSArray<MBDebugMonitorAlertDialogButton *> *)buttons {
    MBDebugMonitorAlertDialog *dialog= [MBDebugMonitorAlertDialog new];
    dialog.title = title;
    dialog.content = content;
    dialog.buttons = buttons;
    return dialog;
}

@end
