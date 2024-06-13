//
//  HCBHostChangeCell.h
//  Runner
//
//  Created by heyAdrian on 2018/10/22.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HCBHostChangeModel;
@interface HCBHostChangeCell : UITableViewCell

@property (nonatomic, copy) void (^changeHostHandler)(NSString *hostName, NSString *hostUrl);
@property (nonatomic, copy) void (^changeDefaultHostHandler)();

- (void)setupWithHostModel:(HCBHostChangeModel *)model;

+ (NSString *)reuseID;

@end


@interface HCBHostChangeModel : NSObject

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *hostUrl;
- (instancetype)initWithHostName:(NSString *)hostName hostUrl:(NSString *)hostUrl;

@end
NS_ASSUME_NONNULL_END
