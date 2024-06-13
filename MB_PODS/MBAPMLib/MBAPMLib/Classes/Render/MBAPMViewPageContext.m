//
//  MBAPMViewPageContext.m
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import "MBAPMViewPageContext.h"

@interface MBAPMViewPageContext()

@property (nonatomic, weak) id<MBAPMViewPageProtocol> viewPage;

@end

@implementation MBAPMViewPageContext

- (instancetype)initWithPageProtocol:(id<MBAPMViewPageProtocol>)viewPage {
    self = [super init];
    if(self) {
        _viewPage = viewPage;
    }
    return self;
}

- (MBAPMViewPageRenderDetectType)detectType {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(renderDetectTypeForAPM)]) {
           return [self.viewPage renderDetectTypeForAPM];
       }
       return MBAPMViewPageRenderDetectTypeText;
}

- (MBAPMViewPageRenderType)renderType {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(renderTypeForAPM)]) {
        return [self.viewPage renderTypeForAPM];
    }
    return MBAPMViewPageRenderTypeNative;
}

- (MBAPMViewPageRenderType)getRenderType {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(renderTypeForAPM)]) {
        return [self.viewPage renderTypeForAPM];
    }
    return MBAPMViewPageRenderTypeNative;
}

- (UIView *)view {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(detectViewForAPM)]) {
        return [self.viewPage detectViewForAPM];
    }
    return _view;
}

- (NSString *)pageName {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(pageNameForAPM)]) {
        return [self.viewPage pageNameForAPM];
    }
    return _pageName;
}

- (NSString *)className {
    if(self.viewPage) {
        return NSStringFromClass([self.viewPage class]);
    }
    return _className;
}

- (BOOL)renderDetectEnabled {
    if(self.viewPage && [self.viewPage respondsToSelector:@selector(enableRenderDetectForAPM)]) {
           return [self.viewPage enableRenderDetectForAPM];
    }
    return YES;
}



@end
