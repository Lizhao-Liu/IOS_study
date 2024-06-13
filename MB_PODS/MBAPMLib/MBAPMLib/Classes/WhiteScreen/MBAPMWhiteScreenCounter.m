//
//  MBAPMWhiteScreenCounter.m
//  MBAPMLib
//
//  Created by 别施轩 on 2023/11/21.
//

#import "MBAPMWhiteScreenCounter.h"
#import "MBAPMTimeUtil.h"

@import YMMModuleLib;

@interface MBAPMWhiteScreenCounter ()

// {stack+pageId: 1}
@property (atomic, strong) NSMutableDictionary<NSString *, NSNumber *>* pageDic;

// {stack:{pageId: 1}}
@property (atomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *>*>* techStackDic;

@property (atomic, assign) long long timestamp;
@property (atomic, assign) NSInteger stackMaxPageCount;
@property (atomic, strong) MBAPMWhiteScreenData *stackMaxWhiteScreenData;

@end

@implementation MBAPMWhiteScreenCounter

+ (instancetype)shared {
    static MBAPMWhiteScreenCounter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMWhiteScreenCounter alloc]init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageDic = [NSMutableDictionary new];
        self.techStackDic = [NSMutableDictionary new];
        
        self.detectDuration = 60 * 10;
        
        self.pageFrequentCount = 5;
        
        self.stackFrequentCount = 5;
        self.stackFrequentPageMiniCount = 2;
    }
    return self;
}

- (void)whiteScreen:(MBAPMWhiteScreenData *)data {
    if (!self.enabled) {
        return;
    }
//    self.detectDuration = 60 * 10;
//
//    self.pageFrequentCount = 3;
//
//    self.stackFrequentCount = 3;
//    self.stackFrequentPageMiniCount = 2;
//
    NSString *bundleType = data.moduleInfo.bundleType ?: @"native";
    NSString *pageId = data.pageId;
    if (bundleType.length > 0 && pageId.length > 0) {
        //go on
    } else {
        return;
    }
    NSString *pageKey = [NSString stringWithFormat:@"%@%@", bundleType, pageId];

    // 10分钟清除
    long long newTimestamp = [MBAPMTimeUtil currentTimestamp];
    long long lastTimestamp = self.timestamp;
    self.timestamp = newTimestamp;
    if (lastTimestamp > 0 && (newTimestamp - lastTimestamp > self.detectDuration * 1000)) {
        [self cleanPageDicKey:pageId techStack:bundleType];
        [self cleanStack:bundleType];
        return;
    }
    
    // 数据加1操作
    BOOL isNetworkError = [data.exceptionType isEqualToString:@"networkException"];
    
    NSNumber *pageValue = self.pageDic[pageKey];
    NSInteger pageCount = [self valuePageVFrom:pageValue] + 1;
    self.pageDic[pageKey] = [self number:pageValue pageAdd:YES netErrorAdd:isNetworkError];
    
    NSMutableDictionary *oneStackPageDic = [[NSMutableDictionary alloc] initWithDictionary: [self.techStackDic objectForKey:bundleType]];
    NSNumber *stackPageValue = oneStackPageDic[pageId];
    NSInteger stackPageCount = [self valuePageVFrom:stackPageValue] + 1;
    oneStackPageDic[pageId] = [self number:stackPageValue pageAdd:YES netErrorAdd:isNetworkError];;
    self.techStackDic[bundleType] = oneStackPageDic;
    
    // 保存最大页面
    if (stackPageCount >= self.stackMaxPageCount) {
        self.stackMaxPageCount = stackPageCount;
        self.stackMaxWhiteScreenData = data;
    }
    
    // 判定连续白屏
    if (pageCount == self.pageFrequentCount) {
        if (self.pageFrequentWhiteScreen) {
            NSNumber *pageValue = self.pageDic[pageKey];
            NSInteger errorCount = [self valueErrorVFrom:pageValue];
            if (errorCount > self.pageFrequentCount / 2) {
                data.exceptionType = @"networkException";
            }
            self.pageFrequentWhiteScreen(data, @{});
        }
        [self cleanPageDicKey:pageId techStack:bundleType];
    }
    
    __block NSInteger stackTotalCount = 0;
    __block NSInteger stackErrorCount = 0;
    [[self.techStackDic objectForKey:bundleType] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger page = [self valuePageVFrom:obj];
        NSUInteger error = [self valueErrorVFrom:obj];
        stackTotalCount += page;
        stackErrorCount += error;
    }];
    
    if (stackTotalCount >= self.stackFrequentCount && oneStackPageDic.count >= self.stackFrequentPageMiniCount) {
        if (self.technicalStackFrequentWhiteScreen) {
            if (stackErrorCount > self.stackFrequentCount / 2) {
                data.exceptionType = @"networkException";
            }
            self.technicalStackFrequentWhiteScreen(self.stackMaxWhiteScreenData, @{});
        }
        [self cleanStack:bundleType];
    }
}

- (void)notWhiteScreen:(nonnull NSString *)pageId techStack:(nonnull NSString *)techStack {
    if (!self.enabled) {
        return;
    }
    
    NSString *bundleType = techStack ?: @"native";
    if (bundleType.length > 0 && pageId.length > 0) {
        //go on
    } else {
        return;
    }
    [self cleanPageDicKey:pageId techStack:bundleType];
    [self cleanStackPageDicKey:pageId techStack:bundleType];
}

// MARK: - private

- (NSNumber *)number:(NSNumber *)number pageAdd:(BOOL)pageAdd netErrorAdd:(BOOL)errorAdd {
    NSUInteger oldV = [number unsignedLongLongValue];
    NSUInteger page = oldV & 1111111111;
    page += (pageAdd ? 1 : 0);
    NSUInteger error = (oldV >> 10) & 1111111111;
    error += (errorAdd ? 1 : 0);
    NSUInteger newV = (error << 10) + page;
    return @(newV);
}

- (NSUInteger)valuePageVFrom:(NSNumber *)vaule {
    NSUInteger oldV = [vaule unsignedLongLongValue];
    NSUInteger page = oldV & 1111111111;
    return page;
}

- (NSUInteger)valueErrorVFrom:(NSNumber *)vaule {
    NSUInteger oldV = [vaule unsignedLongLongValue];
    NSUInteger error = (oldV >> 10) & 1111111111;
    return error;
}

- (void)cleanPageDicKey:(nonnull NSString *)pageId techStack:(nonnull NSString *)techStack  {
    NSString *pageKey = [NSString stringWithFormat:@"%@%@", techStack, pageId];
    [self.pageDic removeObjectForKey:pageKey];
}

- (void)cleanStack:(nonnull NSString *)techStack {
    self.techStackDic[techStack] = nil;
    self.stackMaxWhiteScreenData = nil;
    self.stackMaxPageCount = 0;
}

- (void)cleanStackPageDicKey:(nonnull NSString *)pageId techStack:(nonnull NSString *)techStack {
    NSMutableDictionary *oneStackPageDic = [self.techStackDic objectForKey:techStack];
    [oneStackPageDic removeObjectForKey:pageId];
    self.stackMaxWhiteScreenData = nil;
    self.stackMaxPageCount = 0;
}

@end
