//
//  MBFileUtil+md5.h
//  MBFoundation
//
//  Created by 别施轩 on 2024/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBFileUtil_md5: NSObject

+ (NSString *_Nullable)md5StringAtPath:(NSString *_Nullable)path;

@end

NS_ASSUME_NONNULL_END
