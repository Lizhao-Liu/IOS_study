//
//  YMMPluginManager+MBBridgeDebugMonitor.m
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/9/20.
//

#import "YMMPluginManager+MBBridgeDebugMonitor.h"
#import <RSSwizzle/RSSwizzle.h>
#import "MBBridgeDebugMonitorLogModel.h"
#import "MBBridgeDebugMonitorDataSource.h"
#import "MBBridgeDebugMonitorService.h"
@import MBDebug;
@import MBDoctorService;
@import MBUIKit;

@implementation YMMPluginManager (MBBridgeDebugMonitor)

+ (void)load {
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          RSSwizzleInstanceMethod(self, @selector(performPlugin:callBack:), RSSWReturnType(void), RSSWArguments(YMMPluginRequest *request, YMMPluginResponseBlock responseBlock), RSSWReplacement({
              YMMPluginRequest *requestData = request;
              __block YMMPluginResponse *responseData;
              YMMPluginResponseBlock fetchResponseBlock = ^(YMMPluginResponse *response) {
                  responseBlock(response);
                  responseData = response;
              };
              RSSWCallOriginal(request, fetchResponseBlock);
              dispatch_async(dispatch_get_main_queue(), ^{
                  UIViewController *currentVC = [UIViewController mb_currentViewController];
                  NSString *pageName = [currentVC getJournalPageName];
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                      if([MBBridgeDebugMonitorManager defaultManager].isMonitoring){
                          MBBridgeDebugMonitorLogModel* eventModel = [MBBridgeDebugMonitorLogModel configWithRequest:requestData response:responseData time:[[NSDate date] timeIntervalSince1970] pageName:pageName];
                          MBDebugMonitorLogDataSource *dataSource = [MBBridgeDebugMonitorDataSource sharedDataSource];
                          [dataSource addObject:eventModel];
                      }
                  });
              });
          }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBBridgeDebugMonitor");
      });
}





@end
