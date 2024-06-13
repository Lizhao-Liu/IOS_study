//
//  MBAPMUrlUtil.h
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMUrlUtil : NSObject
+ (NSString *)convertJsonFromData:(NSData *)data;

+ (NSDictionary *)convertDicFromData:(NSData *)data;

+ (NSUInteger)getRequestLength:(NSURLRequest *)request;

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers ;

+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request ;

+ (int64_t)getResponseLength:(NSHTTPURLResponse *)response data:(NSData *)responseData;

+ (NSData *)getHttpBodyFromRequest:(NSURLRequest *)request;

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(NSUInteger)byte;
@end

NS_ASSUME_NONNULL_END
