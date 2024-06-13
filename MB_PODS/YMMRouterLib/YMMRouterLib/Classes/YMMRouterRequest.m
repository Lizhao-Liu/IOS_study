//
//  YMMRouterRequest.m
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import "YMMRouterRequest.h"
#import "YMMRouter.h"
#import "YMMRouterConfigManager.h"
#import "MBRouterLogger.h"

@interface YMMRouterRequest () {
    NSURL *_url;
    NSString *_urlString;
    NSString *_originUrlString;
    NSString *_scheme;
    NSString *_host;
    NSString *_path;
    NSString *_requestId;
    NSDictionary *_params;
    NSString *_fragment;
    HandleBlock _handleBlock;
    MBNavHandleBlock _navHandleBlock;
}
@end

@implementation YMMRouterRequest
@synthesize startTimestamp;
@synthesize requestId;

- (id)initWithURL:(NSURL *)url {
    return [self initWithURL:url params:nil];
}

- (id)initWithURLString:(NSString *)urlString {
    return [self initWithURLString:urlString params:nil];
}

- (id)initWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params {
    return [self initWithURLString:urlString params:params handleBlock:nil];
}

- (id)initWithURL:(NSURL *)url params:(nullable NSDictionary *)params {
    return [self initWithURL:url params:params handleBlock:nil];
}

- (id)initWithURLString:(NSString *)urlString params:(NSDictionary *)params handleBlock:(HandleBlock)handleBlock {
    
    NSURL *url = [YMMRouterRequest transferToURL:urlString];
    return [self initWithURL:url params:params handleBlock:handleBlock navHandleBlock:nil];
}

- (id)initWithURL:(NSURL *)url params:(NSDictionary *)params handleBlock:(nullable HandleBlock)handleBlock {
    return [self initWithURL:url params:params handleBlock:handleBlock navHandleBlock:nil];
}

- (id)initWithURL:(NSURL *)url params:(NSDictionary *)params handleBlock:(nullable HandleBlock)handleBlock navHandleBlock:(nullable MBNavHandleBlock) navHandleBlock {
    return [self initWithURL:url params:params requestId:nil handleBlock:handleBlock navHandleBlock:navHandleBlock];
}

- (id)initWithURL:(NSURL *)url params:(NSDictionary *)params requestId:(NSString *)requestId handleBlock:(HandleBlock)handleBlock navHandleBlock:(MBNavHandleBlock)navHandleBlock {
    self = [super init];
    if (self) {
        _url = url;
        _scheme = _url.scheme;
        if (!_scheme) {
            _scheme = @"";
        }
        _host = _url.host;
        if (!_host) {
            _host = @"";
        }
        _path = _url.path;
        if (!_path) {
            _path = @"";
        }
        _fragment = _url.fragment;
        if (!_fragment) {
            _fragment = @"";
        }
        NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
        if (params && [params isKindOfClass:NSDictionary.class] && params.count > 0) {
            [newParams addEntriesFromDictionary:params];
        } else {
            _urlString = url.absoluteString;
        }
        NSDictionary *queryItems = [self parseQueryItemsForURL:url];
        if (queryItems) {
            [newParams addEntriesFromDictionary:queryItems];
        }
        _params = newParams;
        _handleBlock = handleBlock;
        _navHandleBlock = navHandleBlock;
        _requestId = requestId;
    }
    return self;
}

- (BOOL)schemeValid {
    return self.scheme && self.scheme.length > 0;
}

- (BOOL)hostValid {
    return self.host && self.host.length > 0;
}

+ (NSURL *)transferToURL:(NSString *) urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if(url == nil) {
        NSString *encodeString = urlString;
        NSString *tryDecodeString = [urlString stringByRemovingPercentEncoding];
        if ([urlString isEqualToString:tryDecodeString]) {
            NSCharacterSet *allowedCharacterSet = [YMMRouterConfigManager useNewURLEncodeFunction]?[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789;,/?:@&=+$-_.!~*'()#"]:[NSCharacterSet URLQueryAllowedCharacterSet];
            encodeString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        }
        url = [NSURL URLWithString:encodeString];
    }
    return url;
}

#pragma mark - YMMRouterRoutable
- (NSString *)urlString {
    if([YMMRouterConfigManager useOldRequestUrlstringFunction]) {
        return [self oldUrlString];
    } else {
        return [self newUrlString];
    }
}

- (NSString *)originUrlString {
    if (![self isValid]) {
        return @"";
    }
    if (_originUrlString) {
        return _originUrlString;
    }
    if (!_url) {
        return @"";
    }
    NSURLComponents *comps = [NSURLComponents componentsWithURL:_url resolvingAgainstBaseURL:NO];
    if (comps.queryItems.count > 0) {
        return [_url absoluteString];
    }
    _originUrlString = [NSString stringWithFormat:@"%@://%@%@", _scheme, _host, _path];
    if (_fragment && _fragment.length > 0) {
        _originUrlString = [NSString stringWithFormat:@"%@#%@", _originUrlString, _fragment];
    }
    NSArray *allKeys = [_params allKeys];
    NSUInteger count = allKeys.count;
    if (count > 0) {
        _originUrlString = [NSString stringWithFormat:@"%@?", _originUrlString];
        for (NSUInteger i = 0; i < count; i++) {
            NSString *key = allKeys[i];
            id valueObj = [_params objectForKey:key];
            NSString *valueString = nil;
            if ([YMMRouterConfigManager getConfig].encodeParamInOriginUrlString) {
                 valueString = [self transferParamValueObjToJsonString:valueObj];
            } else {
                 valueString = [NSString stringWithFormat:@"%@", valueObj];
            }
            NSString *encodedValue = [self encodeParamValueString:valueString];
            if (i >= count - 1) {
                _originUrlString = [NSString stringWithFormat:@"%@%@=%@", _originUrlString, key, encodedValue];
            } else {
                _originUrlString = [NSString stringWithFormat:@"%@%@=%@&", _originUrlString, key, encodedValue];
            }
        }
    }
    return _originUrlString;
}

- (BOOL)matchToRouter:(id<YMMRouterRoutable>)routable {
    if ([self.originUrlString isEqualToString:routable.originUrlString]) {
        return YES;
    }
    return NO;
}

#pragma mark - private

- (NSString *)transferParamValueObjToJsonString:(id)valueObj {
    if (!valueObj) {
        return @"";
    }
    NSString *valueString = nil;
    if (valueObj && [NSJSONSerialization isValidJSONObject:valueObj]) {
        NSError *error;
        NSData *valueData = nil;
        if (@available(iOS 11.0, *)) {
            valueData = [NSJSONSerialization dataWithJSONObject:valueObj options:NSJSONWritingSortedKeys error:&error];
        } else {
            valueData = [NSJSONSerialization dataWithJSONObject:valueObj options:kNilOptions error:&error];
        }
        if (error) {
            MBRouterFatal(@"transfer param value:%@, error:%@", valueString, error.description);
        }
        if (valueData) {
            valueString = [[NSString alloc]initWithData:valueData encoding:NSUTF8StringEncoding];
        }
    }
    if (!valueString) {
        valueString = [NSString stringWithFormat:@"%@", valueObj];
    }
    return valueString;
}

- (NSString *)encodeParamValueString:(NSString *)valueString {
    if (!valueString) {
        return @"";
    }
    NSString *encodedValue = nil;
    NSString *tryDecodeValue = [valueString stringByRemovingPercentEncoding];
    if ([valueString isEqualToString:tryDecodeValue]) {
        encodedValue = [valueString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!~*'()"]];
    } else {
        encodedValue = valueString;
    }
    return encodedValue;
}

- (NSString *)newUrlString {
    if (![self isValid]) {
        return @"";
    }
    if (_urlString) {
        return _urlString;
    }
    if (!_url) {
        return @"";
    }
    NSURLComponents *comps = [NSURLComponents componentsWithURL:_url resolvingAgainstBaseURL:NO];
    
    if (_params) {
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in _params.allKeys) {
            id valueObj = [_params objectForKey:key];
            NSString *valueString = nil;
            if ([YMMRouterConfigManager getConfig].encodeParamInUrlString) {
                 valueString = [self transferParamValueObjToJsonString:valueObj];
            } else {
                 valueString = [NSString stringWithFormat:@"%@", valueObj];
            }
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:valueString];
            [queryItems addObject:item];
        }
        comps.queryItems = queryItems;
    }
    _urlString = comps.URL.absoluteString;
    return _urlString;
}



- (NSString *)oldUrlString {
    if (![self isValid]) {
        return @"";
    }
    if (!_urlString) {
        _urlString = [NSString stringWithFormat:@"%@://%@%@", _scheme, _host, _path];
        if (_fragment && _fragment.length > 0) {
            _urlString = [NSString stringWithFormat:@"%@#%@", _urlString, _fragment];
        }
        NSArray *allKeys = [_params allKeys];
        NSUInteger count = allKeys.count;
        if (count > 0) {
            _urlString = [NSString stringWithFormat:@"%@?", _urlString];
            for (NSUInteger i = 0; i < count; i++) {
                NSString *key = allKeys[i];
                if (i >= count - 1) {
                    _urlString = [NSString stringWithFormat:@"%@%@=%@", _urlString, key, _params[key]];
                } else {
                    _urlString = [NSString stringWithFormat:@"%@%@=%@&", _urlString, key, _params[key]];
                }
            }
        }
    }
    return _urlString;
}



- (NSString *)scheme {
    return _scheme;
}

- (NSString *)host {
    return _host;
}

- (NSString *)path {
    return _path;
}

- (NSDictionary *)params {
    return _params;
}

- (NSString *)fragment {
    return _fragment;
}

- (NSString *)requestId {
    if (!_requestId) {
        _requestId = [[NSUUID UUID]UUIDString];
    }
    return _requestId;
}

- (BOOL)isValid {
    return [self schemeValid] && [self hostValid];
}

- (HandleBlock)handleBlock {
    return _handleBlock;
}

- (MBNavHandleBlock)navHandleBlock {
    return _navHandleBlock;
}

- (NSDictionary *)parseQueryItemsForURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *queryItem in urlComponents.queryItems) {
        
        if (queryItem.value&&queryItem.name) {
            [dict setObject:queryItem.value forKey:queryItem.name];
        }
    }
    return dict;
}

@end
