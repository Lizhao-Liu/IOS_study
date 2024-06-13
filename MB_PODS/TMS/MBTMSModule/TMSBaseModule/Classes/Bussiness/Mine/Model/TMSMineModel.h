//
//  TMSMineModel.h
//  TMSBaseModule
//
//  Created by zht on 2021/5/9.
//

#import "TMSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMSMineModel : TMSBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic) NSInteger type;//0表示文字，1表示头像图片，2表示箭头
@property (nonatomic, copy) NSString *selectorStr;
@property (nonatomic, copy) NSString *schema;

@end

NS_ASSUME_NONNULL_END
