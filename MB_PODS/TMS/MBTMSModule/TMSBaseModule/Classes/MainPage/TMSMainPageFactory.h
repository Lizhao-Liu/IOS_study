//
//  TMSMainPageFactory.h
//  MBTMSModule
//
//  Created by Lizhao on 2023/12/21.
//

#import <Foundation/Foundation.h>
@import YMMMainServices;

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeRootVCBlock)(UIViewController *rootVC);

@interface TMSMainPageFactory : NSObject

//-(UIViewController *) createMainPage:(MainPageType) pageType needloginBlock:(_Nullable needloginBlock) needloginBlock;

- (UIViewController *)createMainPageWithChangeRootVCBlock:(changeRootVCBlock) needloginBlock;

@end

NS_ASSUME_NONNULL_END
