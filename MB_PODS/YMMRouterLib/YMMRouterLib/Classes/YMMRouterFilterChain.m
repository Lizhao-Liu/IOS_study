//
//  YMMRouterFilterChain.m
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import "YMMRouterFilterChain.h"
#import "YMMRouterResponse.h"
#import "YMMRouterRequest.h"
#import "MBRouterLogger.h"

@interface YMMRouterFilterWrapper : NSObject

@property (nonatomic, strong) id<YMMRouterFilterProtocol> filter;

@end

@implementation YMMRouterFilterWrapper

@end

@interface YMMRouterInternalFilterChain : NSObject<YMMRouterFilterChainProtocol> {
    NSUInteger _nextIndex;
    NSArray<YMMRouterFilterWrapper *> *_filters;
    YMMRouterStatus _responseResultOfLastFilter;
}

- (instancetype)initWithFilters:(NSArray *)filters;

@end

@implementation YMMRouterInternalFilterChain

- (instancetype)initWithFilters:(NSArray *)filters {
    self = [super init];
    if (self) {
        _nextIndex = 0;
        _filters = [filters copy];
        _responseResultOfLastFilter = YMMRouterStatusNotFound;
    }
    return self;
}

- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response {
    if (_nextIndex >= _filters.count) {
        return;
    }
    void(^filterLog)(void) = ^ {
        if ([response.result isKindOfClass:YMMRouterRequest.class]) {
            NSString *redirectUrl = ((YMMRouterRequest *)response.result).urlString;
            NSString *originUrl = [routable respondsToSelector:@selector(urlString)]?routable.urlString:@"";
            MBRouterInfo(@"[MBRouter][filterChain] filter = %@, url = %@, reponse status = %lu, result = %@, redirectUrl = %@", [self->_filters objectAtIndex:self->_nextIndex - 1].filter, originUrl , (unsigned long)response.status, response.result, redirectUrl);
            self->_responseResultOfLastFilter = response.status;
        }
    };
    YMMRouterFilterWrapper *filterWrapper = [_filters objectAtIndex: _nextIndex++];
    [filterWrapper.filter doFilter:routable response:response chain:self];
    if (response.status != _responseResultOfLastFilter) {
        filterLog();
    }
}

@end

@interface YMMRouterFilterChain () {
    NSMutableArray *_filters;
    YMMRouterInternalFilterChain * _internalFilterChain;
}

@end

@implementation YMMRouterFilterChain

- (instancetype)init {
    self = [super init];
    if (self) {
        _filters = [NSMutableArray array];
    }
    return self;
}

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter {
    YMMRouterFilterWrapper *filterWrapper = [[YMMRouterFilterWrapper alloc] init];
    filterWrapper.filter = filter;
    [_filters insertObject:filterWrapper atIndex:0];
}

- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response {
    [[[YMMRouterInternalFilterChain alloc] initWithFilters:_filters] doFilter:routable response:response];
}

@end
