//
//  FlutterLogReporter.h
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseChannelModule.h"
NS_ASSUME_NONNULL_BEGIN

@interface FlutterLogReporter : BaseChannelModule

- (void)pageVisible:(NSArray *)arguments;

- (void)pageInvisible:(NSArray *)arguments;

- (void)trackTap:(NSArray *)arguments;

- (void)trackView:(NSArray *)arguments;

- (void)track2BI:(NSArray *)arguments;

- (void)track2TalkingData:(NSArray *)arguments;


@end

NS_ASSUME_NONNULL_END
