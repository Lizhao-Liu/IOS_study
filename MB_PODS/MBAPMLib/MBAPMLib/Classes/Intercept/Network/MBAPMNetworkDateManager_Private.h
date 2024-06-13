//
//  MBAPMNetworkDateManager_Private.h
//  Pods
//
//  Created by 别施轩 on 2023/5/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMNetworkDateManager.h"

#ifndef MBAPMNetworkDateManager_Private_h
#define MBAPMNetworkDateManager_Private_h

@interface MBAPMNetworkDateManager (Private)

- (void)startUrl:(NSString *)url;
- (void)endUrl:(NSString *)url;

- (void)startPageLoadPageName:(NSString *)pageName;
- (void)endPageLoadPageName:(NSString *)pageName;

@end

#endif /* MBAPMNetworkDateManager_Private_h */
