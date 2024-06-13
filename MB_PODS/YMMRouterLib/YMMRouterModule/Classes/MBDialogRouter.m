//
//  MBDialogRouter.m
//  YMMRouterModule
//
//  Created by Lizhao on 2023/5/9.
//

#import "MBDialogRouter.h"
@import MBFoundation;
@import MBCommonUILib;

@implementation MBDialogRouter

- (id)handle:(id<YMMRouterRoutable>)routable {
    if (!routable.isValid) {
        return nil;
    }
    NSString *path = [routable.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if([path isEqualToString:@"uidialog"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [routable.params mb_stringForKey:@"title"];
            NSString *message = [routable.params mb_stringForKey:@"message"];
            MBGAlertView *alert = [MBGAlertView tipsViewWithTitle:title message:message];
            [alert show];
        });
    }
    return nil;
}

@end
