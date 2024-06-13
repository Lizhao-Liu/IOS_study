//
//  MBDebugItemModel.h
//  MBDebug
//
//  Created by Ymm on 2019/12/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBDebugHandleBlock)(UIViewController *vc);


@interface MBDebugThumbnailViewItemModel : NSObject

@property (nonatomic, copy) NSString *title; // 名称
@property (nonatomic, copy) NSString *module; // // 业务模块名，唯一标识
@property (nonatomic, copy) MBDebugHandleBlock handleBlock; // 点击事件触发（业务方逻辑处理）

@end



NS_ASSUME_NONNULL_END
