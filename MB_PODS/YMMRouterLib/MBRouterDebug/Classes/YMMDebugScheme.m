//
//  YMMDebugScheme.m
//  AFNetworking
//
//  Created by yc on 2019/11/21.
//

#import "YMMDebugScheme.h"

@implementation YMMDebugScheme

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = (NSString *)[dict objectForKey:@"name"];
        self.url = (NSString *)[dict objectForKey:@"url"];
        self.isPresent = (NSNumber *)[dict objectForKey:@"isPresent"];
        self.isMainTab = (NSNumber *)[dict objectForKey:@"isMainTab"];
    }
    return self;
}

@end
