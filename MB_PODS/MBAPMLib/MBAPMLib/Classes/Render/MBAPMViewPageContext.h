//
//  MBAPMViewPageContext.h
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMViewPageContext : NSObject

- (instancetype)initWithPageProtocol:(id<MBAPMViewPageProtocol>)viewPage;

@property (nonatomic, copy) NSString *objcetPointer;

@property (nonatomic, copy) NSString *pageName;

@property (nonatomic, copy) NSString *className;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) UIView *view;

@property (nonatomic, assign, readonly) MBAPMViewPageRenderType renderType;

@property (nonatomic, assign, readonly) MBAPMViewPageRenderDetectType detectType;

@property (nonatomic, assign, readonly) BOOL renderDetectEnabled;

@end

NS_ASSUME_NONNULL_END
