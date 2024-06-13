//
//  MBAPMPlugin.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMPlugin.h"
#import "MBAPMDataExportManager.h"
#import "MBAPMMetric.h"

@interface MBAPMPlugin()

@property (nonatomic, weak)id<MBAPMPluginListenerDelegate> pluginListener;
@property (nonatomic, strong) MBAPMDataExportManager *dataExport;

@end

@implementation MBAPMPlugin

+ (BOOL)isSingleton {
    return NO;
}

- (BOOL)isSelfStart {
    return NO;
}

- (void)setListenerDelegate:(id<MBAPMPluginListenerDelegate>)delegate {
    _pluginListener = delegate;
}

- (void)start {
    if([_pluginListener respondsToSelector:@selector(onStart:)]) {
        [_pluginListener onStart:self];
    }
}

- (void)stop {
    if([_pluginListener respondsToSelector:@selector(onStop:)]) {
        [_pluginListener onStop:self];
    }
}

- (void)destroy {
    if([_pluginListener respondsToSelector:@selector(onDestroy:)]) {
        [_pluginListener onDestroy:self];
    }
}

- (void)reportMetrics:(MBAPMMetric *)metric {
    [self.dataExport exportMetricData:metric];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagNone;
}

- (void)abort {
    return;
}


+ (nonnull id)shareInstance {
    return nil;
}


#pragma mark - property method

- (MBAPMDataExportManager *)dataExport {
    if(!_dataExport) {
        _dataExport = [[MBAPMDataExportManager alloc]initWithContext:self.context];
    }
    return _dataExport;
}

@end
