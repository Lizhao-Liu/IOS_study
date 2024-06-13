//
//  MBDebugMontiorEventLocatorModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugMontiorEventLocatorModel : NSObject

@property (nonatomic, copy, readonly) NSString *pageName; // 来源页面名称，必传

@property (nonatomic, copy) NSString *bundleName;

@property (nonatomic, copy) NSString *bundleType;

@property (nonatomic, copy) NSString *bundleVersion;

@property (nonatomic, copy) NSString *moduleName;

@property (nonatomic, copy) NSString *submoduleName;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)locatorModelWithPageName:(NSString *)pageName;

+ (instancetype)locatorModelWithPageName:(NSString *)pageName bundleName:(NSString *)bundleName bundleType:(NSString *)bundleType;

+ (instancetype)locatorModelWithPageName:(NSString *)pageName moduleName:(NSString *)moduleName subModuleName:(NSString *)subModuleName;

@end

NS_ASSUME_NONNULL_END
