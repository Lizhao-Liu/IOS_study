//
//  NSURLSessionConfiguration.m
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import "NSURLSessionConfiguration+MBAPM.h"
#import "MBAPMNSURLProtocol.h"
#import "NSObject+APMSwizzle.h"

@implementation NSURLSessionConfiguration (MBAPM)

+ (void)load {
    [[self class] apm_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(apm_defaultSessionConfiguration)];
    [[self class] apm_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(apm_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)apm_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self apm_defaultSessionConfiguration];
    [configuration addNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)apm_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self apm_ephemeralSessionConfiguration];
    [configuration addNSURLProtocol];
    return configuration;
}

- (void)addNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = MBAPMNSURLProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
