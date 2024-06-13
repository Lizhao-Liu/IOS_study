//
//  YMMRouter.m
//  YMMModuleLib
//
//  Created by Xiaohui on 2018/6/11.
//

#import "YMMRouter.h"
#import "YMMRouterFilterChain.h"
#import "YMMRouterRequest.h"
#import "YMMRouterResponse.h"
#import "YMMRouterTable.h"
#import "YMMRouterHandlerFilter.h"
#import "MBRouterLogger.h"
#import <objc/runtime.h>

@interface YMMRouter () {
    YMMRouterFilterChain *_chain;
    NSMutableArray<YMMRouterTable *> *_tables;
    YMMRouterTable *_defaultTable;
    NSArray *_schemes;
    YMMRouterHandlerFilter *handlerFilter;
}

@end

@implementation YMMRouter

- (instancetype)initWithSchemePattern:(NSString *)schemePattern
                          hostPattern:(NSString *)hostPattern {
    NSMutableArray *array = [NSMutableArray array];
    if (schemePattern) {
        [array addObject:schemePattern];
    }
    return [self initWithSchemes:array hostPattern:hostPattern];
}

- (instancetype)initWithScheme:(NSString *)scheme
                   hostPattern:(NSString *)hostPattern {
    return [self initWithSchemePattern:scheme hostPattern:hostPattern];
}

- (instancetype)initWithSchemes:(NSArray *)schemes
                    hostPattern:(NSString *)hostPattern {
    self = [super init];
    if (self) {
        NSArray *defaultSchemes = [self defaultSchemes];
        if (defaultSchemes) {
            NSMutableSet *schemeSet = [NSMutableSet setWithArray:defaultSchemes];
            if (schemes) {
                [schemeSet addObjectsFromArray:schemes];
            }
            _schemes = [schemeSet allObjects];
        } else {
            _schemes = schemes;
        }
        _hostPattern = hostPattern;
        [self setup];
    }
    return self;
}

- (instancetype)initWithHostPattern:(NSString *)hostPattern {
    return [self initWithSchemePattern:nil hostPattern:hostPattern];
}

#pragma mark - public

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter {
    [_chain addFilter:filter];
}

- (void)addRouterTable:(YMMRouterTable *)table {
    [_tables addObject:table];
}

- (void)removeRouterTable:(YMMRouterTable *)table {
    [_tables removeObject:table];
}

- (void)registerHandler:(id<YMMRouterBaseHandlerProtocol>)handler
         forPathPattern:(NSString *)pathPattern {
    [_defaultTable registerHandler:handler forPathPattern:pathPattern];
}

- (void)registerBlock:(HandlerBlock)handlerBlock
       forPathPattern:(NSString *)pathPattern {
    [_defaultTable registerBlock:handlerBlock
                  forPathPattern:pathPattern];
}

- (void)registerAction:(SEL)action
                target:(id)target
        forPathPattern:(NSString *)pathPattern {
    [_defaultTable registerAction:action
                           target:target
                   forPathPattern:pathPattern];
}

- (void)unregisterHandlerForPathPattern:(NSString *)pathPattern {
    [_defaultTable unregisterHandlerForPathPattern:pathPattern];
}

- (BOOL)isSupport:(id<YMMRouterRoutable>)routable {
    if ((routable.scheme && routable.scheme.length > 0)
        && (routable.host && routable.host.length > 0)) {
        BOOL schemeIsSupport = NO;
        for (NSString *scheme in _schemes) {
            if ([YMMRouter match:scheme content:routable.scheme]) {
                schemeIsSupport = YES;
                break;
            }
        }
        BOOL hostIsSupport = [YMMRouter match:_hostPattern content:routable.host];
        return schemeIsSupport && hostIsSupport;
    }
    return NO;
}

- (YMMRouterResponse *)matches:(id<YMMRouterRoutable>)routable {
    YMMRouterResponse *response = [[YMMRouterResponse alloc] initWithStatus:YMMRouterStatusNotFound request:routable];
    if (![self isSupport:routable]) {
        response.status = YMMRouterStatusForbidden;
        return response;
    }
    [_chain doFilter:routable response:response];
    if (response.status != YMMRouterStatusRedirect && response.status != YMMRouterStatusLowVersion && response.status != YMMRouterStatusLowVersionRN) {
        if (handlerFilter) {
            [handlerFilter doFilter:routable response:response chain:nil];
        }
    }

    return response;
}

- (YMMRouterResponse *)redirect:(id<YMMRouterRoutable>)routable {
    YMMRouterResponse *response = [[YMMRouterResponse alloc] initWithStatus:YMMRouterStatusNotFound request:routable];
    if (![self isSupport:routable]) {
        response.status = YMMRouterStatusForbidden;
        return response;
    }
    [_chain doFilter:routable response:response];
    return response;
}

+ (BOOL)match:(NSString *)pattern content:(NSString *)content {
    if (!content || content.length <= 0
        || !pattern || pattern.length <= 0) {
        return NO;
    }
    if ([pattern hasPrefix:@"^"] && [pattern hasSuffix:@"$"]) {
        NSError *error;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSUInteger number = [regularExpression numberOfMatchesInString:content options:0 range:NSMakeRange(0, content.length)];
        return number != 0;
    }
    return [content.lowercaseString isEqualToString:pattern.lowercaseString];
}

#pragma mark - private

- (void)setup {
    _chain = [[YMMRouterFilterChain alloc] init];
    _tables = [NSMutableArray array];
    _defaultTable = [[YMMRouterTable alloc] init];
    [self addRouterTable:_defaultTable];
    handlerFilter = [[YMMRouterHandlerFilter alloc] initWithRouterTables:_tables];
}

- (NSArray *)defaultSchemes {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"YMMRouterModule" withExtension:@"bundle"];
    if (!bundleURL) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    NSString *path = [bundle pathForResource:@"default_schemes" ofType:@"plist"];
    if (!path) {
        return nil;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dict objectForKey:@"schemes"];
}

@end
