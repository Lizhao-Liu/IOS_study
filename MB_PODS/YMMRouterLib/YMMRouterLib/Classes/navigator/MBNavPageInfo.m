//
//  MBNavPageInfo.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import "MBNavPageInfo.h"

@implementation MBNavPageInfo

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

- (NSString *)topPageUrl {
    if (self.innerPages && self.innerPages.count > 0) {
        return self.innerPages[self.innerPages.count - 1].pageUrl;
    } else {
        return self.routable.originUrlString;
    }
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"className = %@, url = %@", NSStringFromClass(self.viewController.class), self.routable.originUrlString];
}

@end


@implementation MBNavContainerInnerPageInfo





@end
