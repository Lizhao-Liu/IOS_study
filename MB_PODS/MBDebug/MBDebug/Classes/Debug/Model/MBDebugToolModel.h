//
//  MBDebugToolModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBDebugHandleBlock)(UIViewController *vc);

@interface MBDebugToolModel : NSObject

@property (nonatomic, copy) NSString *itemTitle; // 名称
@property (nonatomic, copy) NSString *summary; // 描述信息
@property (nonatomic, copy) MBDebugHandleBlock handleBlock; // 点击事件触发（业务方逻辑处理）

@end

NS_ASSUME_NONNULL_END
