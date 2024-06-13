//
//  MBAPMPageViewTrackTask.m
//  MBAPMLib
//
//  Created by xp on 2024/1/26.
//

#import "MBAPMPageViewTrackTask.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMWhiteScreenCounter.h"
#import "MBAPMPageLaunchDivideCenter.h"
#import "MBAPMContext+RenderMonitor.h"
#import "MBAPMCurrentPageInfo_Private.h"

@implementation MBAPMPageViewTrackTask


#pragma mark override methods
- (BOOL)section:(NSString *)sectionTag withExtra:(NSDictionary *)extData {
    BOOL result = [super section:sectionTag withExtra:extData];
    if (result) {
        [self sectonCheckReceivePageLoadEvent:sectionTag withExtra:extData];
    }
    return result;
}

- (BOOL)section:(NSString *)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary *)extData {
    BOOL result = [super section:sectionTag cost:elapsedTime withExtra:extData];
    if (result) {
        [self sectonCheckReceivePageLoadEvent:sectionTag withExtra:extData];
    }
    return result;
}

- (BOOL)section:(NSString *)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary *)extData {
    BOOL result = [super section:sectionTag beginAt:beginTimestamp endAt:endTimeStamp sectionType:type withExtra:extData];
    if (result) {
        [self sectonCheckReceivePageLoadEvent:sectionTag withExtra:extData];
    }
    return result;
}

- (BOOL)end:(NSString *)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary *)extData {
    if (self.container && [self.container respondsToSelector:@selector(mbapm_isFirstHomePage)]) {
        BOOL isFirstHomePage = [self.container mbapm_isFirstHomePage];
        if (isFirstHomePage) {
            if ([MBAPMContext globalContext].getLaunchTimeBlock) {
                NSDictionary *launchTimeDic = [MBAPMContext globalContext].getLaunchTimeBlock();
                [self setAssociatedData:launchTimeDic];
            }
        }
    }
    return [super end:lastSectionTag endAt:endTimeStamp withExtra:extData];
}

#pragma mark private methods

// 兼容：从rn等栈内page load阶段触发，需要记录并且启用first second渲染检测
- (void)sectonCheckReceivePageLoadEvent:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData {
    if ([sectionTag isEqualToString:kMBAPMEventTimeTrack_Page_Load]
        && self.moduleInfo.bundleType
        && [self.moduleInfo.bundleType isEqualToString:@"rn"]) {
        if ([[extData valueForKey:@"tags"] isKindOfClass:[NSDictionary class]]
            && [[extData[@"tags"] valueForKey:@"page_id"] isKindOfClass:[NSString class]]
            && [extData[@"tags"][@"page_id"] length] > 0) {
            NSString *pageId = extData[@"tags"][@"page_id"];
            [[MBAPMCurrentPageInfo sharedInstance] viewLoadUpdatePageID:pageId];
            [self sectionReceivePageLoadEvent];
        }
    }
    if ([[extData valueForKey:@"tags"] isKindOfClass:[NSDictionary class]]
        && [[extData[@"tags"] valueForKey:@"page_path"] isKindOfClass:[NSString class]]
        && [extData[@"tags"][@"page_path"] length] > 0) {
        NSString *pagePath = extData[@"tags"][@"page_path"];
        [[MBAPMCurrentPageInfo sharedInstance] viewLoadUpdatePagePath:pagePath];
    }
    if ([sectionTag isEqualToString:kMBAPMEventTimeTrack_Page_Second_Layout]) {
        if ([[extData valueForKey:@"tags"] isKindOfClass:[NSDictionary class]]
            && [[extData[@"tags"] valueForKey:@"page_id"] isKindOfClass:[NSString class]]
            && [extData[@"tags"][@"page_id"] length] > 0) {
            NSString *pageId = extData[@"tags"][@"page_id"];
            [[MBAPMWhiteScreenCounter shared] notWhiteScreen:pageId techStack:self.moduleInfo.bundleType];
        }
    }
}

- (void)sectionReceivePageLoadEvent {
    [[MBAPMPageLaunchDivideCenter sharedInstance] startFirstLayoutCheck:self];
}

@end
