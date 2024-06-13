//
//  MBChaosCrashIssueOC.m
//  MBPatchDebug
//
//  Created by xp on 2022/5/9.
//

#import "MBChaosCrashIssueOC.h"
#import "MBAPMDebug-Swift.h"
@import MBStorageLib;

@interface MBChaosCrashIssueOC()

@property (nonatomic, assign) NSMutableDictionary<NSString *, NSString *> *testDic;


@end

@implementation MBChaosCrashIssueOC

- (instancetype)init {
    if (self = [super init]) {
        _testDic = [NSMutableDictionary new];
    }
    return self;
}

- (void)triggerIssue {
    NSLog(@"oc trigger issuue");
    NSArray *crashArray = [[MBStorageManager mbkv] get:@"chaos_crash_key"];
    if (crashArray) {
        NSLog(@"%@", crashArray[0]);
    }
    BOOL hasSaved = [[MBStorageManager mbkv]getBool:@"chaos_crash_key_hasSaved"];
    if (!hasSaved){
        [[MBStorageManager mbkv]set:@(YES) forKey:@"chaos_crash_key_hasSaved"];
        [[MBStorageManager mbkv]set:@{} forKey:@"chaos_crash_key"];
    }
    
//    [_testDic setObject:@"test_value" forKey:@"test_key"];
//    dispatch_queue_t cocurrentQueue = dispatch_queue_create("mbapmdebug_crash_test_queue", DISPATCH_QUEUE_CONCURRENT);
//    for(int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic objectForKey:@"test"];
//            NSLog(@"oc trigger issuue read dic");
//        });
//    }
//
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic objectForKey:@"test"];
//            NSLog(@"oc trigger issuue read dic");
//        });
//    }
//
//
//    for(int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic objectForKey:@"test"];
//            NSLog(@"oc trigger issuue read dic");
//        });
//    }
//
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic objectForKey:@"test"];
//            NSLog(@"oc trigger issuue read dic");
//        });
//    }
//
//    for(int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic setObject:@"value" forKey:@"test"];
//            NSLog(@"oc trigger issuue write dic");
//
//        });
//    }
//
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(cocurrentQueue, ^{
//            [self.testDic setObject:@"value" forKey:@"test"];
//            NSLog(@"oc trigger issuue write dic");
//        });
//    }
}


//- (NSMutableDictionary<NSString *,NSString *> *)testDic {
//    if (!_testDic) {
//        _testDic = [NSMutableDictionary new];
//    }
//    return _testDic;
//}
    

@end
