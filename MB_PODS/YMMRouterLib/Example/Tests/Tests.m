//
//  YMMRouterLibTests.m
//  YMMRouterLibTests
//
//  Created by knop on 02/17/2019.
//  Copyright (c) 2019 knop. All rights reserved.
//

@import XCTest;
@import YMMRouterLib;
#import "TestHanlder.h"
#import "TestFilter.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequest {
    YMMRouterRequest *request1 = [[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test"];
    
    XCTAssert([request1.scheme isEqualToString:@"ymm"], @"scheme: %@", request1.scheme);
    XCTAssert([request1.host isEqualToString:@"view"], @"host: %@", request1.host);
    XCTAssert([request1.path isEqualToString:@"/test"], @"path: %@", request1.path);
    
    YMMRouterRequest *request2 = [[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test?k1=v1&k2=v2"];
    NSArray *allKeys2 = request2.params.allKeys;
    XCTAssert([allKeys2 containsObject:@"k1"] && [allKeys2 containsObject:@"k2"], @"params: %@", request2.params.debugDescription);
    
    YMMRouterRequest *request3 = [[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test?k1=v1&k2=v2" params:@{@"k3":@"v3", @"k4":@"v4"}];
    NSArray *allKeys3 = request3.params.allKeys;
    XCTAssert([allKeys3 containsObject:@"k1"]
              && [allKeys3 containsObject:@"k2"]
              && [allKeys3 containsObject:@"k3"]
              && [allKeys3 containsObject:@"k4"],
              @"params: %@",
              request3.params.debugDescription);
    
    YMMRouterRequest *request4 = [[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test?k1=v1&k2=v2#fragment"];
    NSArray *allKeys4 = request4.params.allKeys;
    XCTAssert([allKeys4 containsObject:@"k1"]
              && [allKeys4 containsObject:@"k2"]
              && [request4.fragment isEqualToString:@"fragment"],
              @"params: %@, fragment: %@",
              request4.params.debugDescription, request4.fragment);
}

- (void)testRegisterForTable {
    id handler = [[TestHanlder alloc] init];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    id matchedHandler = [table matches:@"/test"];
    XCTAssert(handler == matchedHandler, @"handler != matchedHandler");
}

- (void)testUnregisterForTable {
    id handler = [[TestHanlder alloc] init];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    id matchedHandler = [table matches:@"/test"];
    XCTAssert(handler == matchedHandler, @"handler != matchedHandler");
    
    [table unregisterHandlerForPathPattern:@"/test"];
    id notMatchHandler = [table matches:@"/test"];
    XCTAssert(notMatchHandler == nil, @"matchedHandler != nil");
}

- (void)testFoundForRouter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    id handler = [[TestHanlder alloc] init];
    [router registerHandler:handler forPathPattern:@"/test"];
    YMMRouterResponse *response1 = [router matches:[[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test"]];
    XCTAssert(handler == response1.handler, @"handler != response1.handler");
}

- (void)testNotFoundForRouter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    id handler = [[TestHanlder alloc] init];
    [router registerHandler:handler forPathPattern:@"/test"];
    YMMRouterResponse *response = [router matches:[[YMMRouterRequest alloc] initWithURLString:@"ymm://view/testError"]];
    XCTAssert(response.status == YMMRouterStatusNotFound, @"code: %lu", response.status);
}

- (void)testMatchFilter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    TestFilter *filter = [[TestFilter alloc] init];
    filter.invoked = NO;
    [router addFilter:filter];
    [router matches:[[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test"]];
    XCTAssert(filter.invoked, @"invoked: %d", filter.invoked);
}

- (void)testNotMatchFilter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    TestFilter *filter = [[TestFilter alloc] init];
    filter.invoked = NO;
    [router addFilter:filter];
    [router matches:[[YMMRouterRequest alloc] initWithURLString:@"ymm://view/test1"]];
    XCTAssert(!filter.invoked, @"invoked: %d", filter.invoked);
}

- (void)testHandlerForRouterCenter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    [[YMMRouterCenter shared] addRouter:router];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:nil];
    XCTAssert([@"/test" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test1" completion:nil];
    XCTAssert(![@"/test1" isEqualToString:handler.path], @"invoked: %@", handler.path);
    [[YMMRouterCenter shared] removeRouter:router];
}

- (void)testHandlerBlockForRouterCenter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    [[YMMRouterCenter shared] addRouter:router];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    TestHanlder *handler = [[TestHanlder alloc] init];
    [router registerBlock:^(id<YMMRouterRoutable> routable, HandlerCallback callback) {
        handler.path = routable.path;
        if (callback) {
            callback(@"callback");
        }
    } forPathPattern:@"/test"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse * response) {
        XCTAssert([@"/test" isEqualToString:handler.path], @"handler.path: %@", handler.path);
        XCTAssert(response.status == YMMRouterStatusSuccess, @"response.status: %lu", response.status);
        XCTAssert([response.result isEqualToString:@"callback"], @"response.result: %@", response.result);
        
    }];

    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test1" completion:nil];
    XCTAssert(![@"/test1" isEqualToString:handler.path], @"handler.path: %@", handler.path);
    [[YMMRouterCenter shared] removeRouter:router];
}

- (void)testHandlersForRouterCenter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    [[YMMRouterCenter shared] addRouter:router];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test0"];
    [table registerHandler:handler forPathPattern:@"/test1"];
    [table registerHandler:handler forPathPattern:@"/test2"];
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test0" completion:nil];
    XCTAssert([@"/test0" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test1" completion:nil];
    XCTAssert([@"/test1" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test2" completion:nil];
    XCTAssert([@"/test2" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] removeRouter:router];
}

- (void)testTablesForRouterCenter {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    [[YMMRouterCenter shared] addRouter:router];
    YMMRouterTable *table0 = [[YMMRouterTable alloc] init];
    [router addRouterTable:table0];
    YMMRouterTable *table1 = [[YMMRouterTable alloc] init];
    [router addRouterTable:table1];
    YMMRouterTable *table2 = [[YMMRouterTable alloc] init];
    [router addRouterTable:table2];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table0 registerHandler:handler forPathPattern:@"/test0"];
    [table1 registerHandler:handler forPathPattern:@"/test1"];
    [table2 registerHandler:handler forPathPattern:@"/test2"];
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test0" completion:nil];
    XCTAssert([@"/test0" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test1" completion:nil];
    XCTAssert([@"/test1" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test2" completion:nil];
    XCTAssert([@"/test2" isEqualToString:handler.path], @"invoked: %@", handler.path);
    
    [[YMMRouterCenter shared] removeRouter:router];
}

- (void)testRoutersForRouterCenter {
    YMMRouter *router0 = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view0"];
    YMMRouterTable *table0 = [[YMMRouterTable alloc] init];
    [router0 addRouterTable:table0];
    [[YMMRouterCenter shared] addRouter:router0];

    YMMRouter *router1 = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view1"];
    YMMRouterTable *table1 = [[YMMRouterTable alloc] init];
    [router1 addRouterTable:table1];
    [[YMMRouterCenter shared] addRouter:router1];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table0 registerHandler:handler forPathPattern:@"/test"];
    [table1 registerHandler:handler forPathPattern:@"/test"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view0/test" completion:nil];
    XCTAssert([@"view0" isEqualToString:handler.host] && [@"/test" isEqualToString:handler.path], @"host:%@, view:%@", handler.host, handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view1/test" completion:nil];
    XCTAssert([@"view1" isEqualToString:handler.host] && [@"/test" isEqualToString:handler.path], @"host:%@, view:%@", handler.host, handler.path);
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view2/test" completion:nil];
    XCTAssert(![@"view2" isEqualToString:handler.host], @"host:%@", handler.host);
    
    [[YMMRouterCenter shared] removeRouter:router0];
    [[YMMRouterCenter shared] removeRouter:router1];
}

- (void)testSuccessResponse {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    [[YMMRouterCenter shared] addRouter:router];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse * response) {
        XCTAssert(response.status == YMMRouterStatusSuccess, @"status:%lu", (unsigned long)response.status);
        [[YMMRouterCenter shared] removeRouter:router];
    }];
}

- (void)testForbiddenResponse {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    [[YMMRouterCenter shared] addRouter:router];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view1/test" completion:^(YMMRouterResponse * response) {
        XCTAssert(response.status == YMMRouterStatusForbidden, @"status:%lu", (unsigned long)response.status);
        [[YMMRouterCenter shared] removeRouter:router];
    }];
}

- (void)testNotFoundResponse {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    [[YMMRouterCenter shared] addRouter:router];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test1"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse * response) {
        XCTAssert(response.status == YMMRouterStatusNotFound, @"status:%lu", (unsigned long)response.status);
        [[YMMRouterCenter shared] removeRouter:router];
    }];
}

- (void)testResponseWithBlock {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"view"];
    YMMRouterTable *table = [[YMMRouterTable alloc] init];
    [router addRouterTable:table];
    [[YMMRouterCenter shared] addRouter:router];
    
    TestHanlder *handler = [[TestHanlder alloc] init];
    [table registerHandler:handler forPathPattern:@"/test"];
    
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse *response) {
        XCTAssert(response.status == YMMRouterStatusSuccess && [@"callback" isEqualToString:response.result], @"status:%lu, result:%@", (unsigned long)response.status, response.result);
    }];
    
    [[YMMRouterCenter shared] removeRouter:router];
}

- (void)testIgnoreCase {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"View"];
    TestHanlder *handler = [[TestHanlder alloc] init];
    [router registerHandler:handler forPathPattern:@"/Test"];
    [[YMMRouterCenter shared] addRouter:router];
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse *response) {
        XCTAssert(response.status == YMMRouterStatusSuccess && [@"callback" isEqualToString:response.result], @"status:%lu, result:%@", (unsigned long)response.status, response.result);
        [[YMMRouterCenter shared] removeRouter:router];
    }];
}

- (void)testInterceptor {
    YMMRouter *router = [[YMMRouter alloc] initWithScheme:@"ymm" hostPattern:@"View"];
    TestHanlder *handler = [[TestHanlder alloc] init];
    [router registerHandler:handler forPathPattern:@"/Test"];
    [[YMMRouterCenter shared] addRouter:router];
    [[YMMRouterCenter shared] performWithURLString:@"ymm://view/test" completion:^(YMMRouterResponse *response) {
        XCTAssert(response.status == YMMRouterStatusSuccess && [@"callback" isEqualToString:response.result], @"status:%lu, result:%@", (unsigned long)response.status, response.result);
        [[YMMRouterCenter shared] removeRouter:router];
    }];
}

- (void)testSickRequest {
    NSString *a = @"wlqq://ScanGas/{\"url\":\"http://dev.s.56qq.cn/publicSignAct/draw.html?qrCode=20260409\"}";
    YMMRouterRequest *request1 = [[YMMRouterRequest alloc] initWithURLString:a];
    XCTAssert(request1.isValid, @"request is invalid");
}

- (void)testEncodeRequest {
    NSString *a = @"wlqq://activity/truck_navigation_amap?_module_=amap&sName=%E5%8C%97%E4%BA%AC+%E4%B8%9C%E5%9F%8E&sLat=39.928353&sLon=116.416357&eName=%E4%B8%8A%E6%B5%B7%20%E5%BE%90%E6%B1%87&eLat=31.188523&eLon=121.436525&source=cargo_detail_page&locationType=gcj02";
    YMMRouterRequest *request1 = [[YMMRouterRequest alloc] initWithURLString:a];
    XCTAssert(request1.isValid, @"request is invalid");
}

- (void)testNilURL {
    NSString *urlString = nil;
    [[YMMRouterCenter shared] performWithURLString:urlString completion:^(YMMRouterResponse * response) {
        XCTAssert(response.status == YMMRouterStatusNotFound, @"request is invalid");
    }];
}


@end
