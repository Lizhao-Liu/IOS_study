//
//  MBAPMDebugMemoryStateViewController.m
//  MBAPMDebug
//
//  Created by xp on 2021/10/9.
//

#import "MBAPMDebugMemoryStateViewController.h"
#import "MBAPMDebugEntryCell.h"
#import "MBAPMDebugSwitchCell.h"
#import "MBAPMDebugModule.h"
@import Matrix;
@import DoraemonKit;
@import MBAPMServiceLib;

@interface TestContact : NSObject

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *signature;

@end

@implementation TestContact

- (id)init
{
    self = [super init];
    if (self) {
        self.nickName = @"Don Shirley";
        self.sex = @"Man";
        self.country = @"U.S.A";
        self.state = @"New York";
        self.city = @"New York City";
        self.signature = @"You never win with violence. You only win when you maintain your dignity.- Don Shirley (Green Book) \
        It takes courage to change people’s hearts. - Oleg (Green Book) \
        The world's full of lonely people afraid to make the first move. - Tony Lip (Green Book)";
    }
    return self;
}

@end


static NSString *MBAPMDebugEntryCellID = @"MBAPMEntryCellID";
static NSString *MBAPMDebugEntrySwitchCellID = @"MBAPMEntrySwitchCellID";

@interface MBAPMDebugMemoryStateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MBAPMDebugSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *vcArr;

@end

@implementation MBAPMDebugMemoryStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"内存监控";
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
        } else {
    #endif
            self.view.backgroundColor = [UIColor whiteColor];
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
    #endif
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@"MemoryDump"];
    [_dataArray addObject:@"模拟OOM"];
    [_dataArray addObject:@"模拟RetainCycle的内存泄漏"];
    [self.view addSubview:self.collectionView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.frame;
}

#pragma mark - private method

- (id<MBAPMServiceProtocol>)apmService {
    id<MBAPMServiceProtocol> service = BIND_SERVICE([MBAPMDebugModule getContext], MBAPMServiceProtocol);
    return service;
}

- (void)memoryDump {
    WCMemoryStatPlugin *memoryStatPlugin = (WCMemoryStatPlugin *)[[Matrix sharedInstance] getPluginWithTag:@"MemoryStat"];
    [memoryStatPlugin uploadReport:[memoryStatPlugin recordOfLastRun] withCustomInfo:nil];
}

- (void)mockFOOM {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        while (1) {
            TestContact *contact = [[TestContact alloc] init];
            [array addObject:contact];
        }
    });
}

- (void)mockRetainCycle {
    self.vcArr = [NSMutableArray arrayWithArray:@[self]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - property method

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        
    }
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            if (@available(iOS 13.0, *)) {
                _collectionView.backgroundColor = [UIColor systemBackgroundColor];
            } else {
    #endif
                _collectionView.backgroundColor = [UIColor whiteColor];
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            }
    #endif
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MBAPMDebugEntryCell class] forCellWithReuseIdentifier:MBAPMDebugEntryCellID];
    [_collectionView registerClass:[MBAPMDebugSwitchCell class] forCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID];
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 128);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger row = indexPath.row;
        
        if (row == 0) {
            [self memoryDump];
        } else if (row == 1) {
            [self mockFOOM];
        } else if (row == 2) {
            [self mockRetainCycle];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return _dataArray.count;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.section == 1) {
        MBAPMDebugEntryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntryCellID forIndexPath:indexPath];
        NSString *name = _dataArray[row ];
        [cell updateCell:name];
        return cell;
    }
    
    if(row == 0) {
        MBAPMDebugSwitchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID forIndexPath:indexPath];
        [cell setLabelText:@"MBAPM 内存泄漏 功能开关"];
        [cell setSwitchState:[[self apmService] isEnableLeaksFinder]];
        cell.delegate = self;
        cell.tag = 10001;
        return cell;
    } else if(row == 1) {
        MBAPMDebugSwitchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID forIndexPath:indexPath];
        [cell setLabelText:@"MBAPM 内存泄漏弹窗功能开关"];
        [cell setSwitchState:[[self apmService] isEnableLeaksAlert]];
        cell.delegate = self;
        cell.tag = 10002;
        return cell;
    } else {
        MBAPMDebugSwitchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID forIndexPath:indexPath];
        [cell setLabelText:@"MBAPM 内存泄漏循环引用功能开关"];
        [cell setSwitchState:[[self apmService] isEnableCheckRetainCycle]];
        cell.tag = 10003;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - MBAPMDebugSwitchCellDelegate

- (void)switchChanged:(BOOL)isON cellTag:(NSInteger)tag {
    if (tag == 10001) {
        [[self apmService] setEnableLeaksFinder:isON];
//
//        [[DoraemonCacheManager sharedInstance] saveMemoryLeak:isON];
    }

    if (tag == 10002) {
        [[self apmService] setEnableLeaksAlert:isON];
//        [[DoraemonCacheManager sharedInstance] saveMemoryLeakAlert:isON];
    }

    if (tag == 10003) {
        [[self apmService] setEnableCheckRetainCycle:isON];
//        [[DoraemonCacheManager sharedInstance] saveMemoryLeakAlert:isON];
    }
}

/*
 
 
 // 打开leaks finder
 + (void)setEnableLeaksFinder:(BOOL)enable;
 + (BOOL)isEnableLeaksFinder;

 // 是否弹窗
 + (void)setEnableLeaksAlert:(BOOL)enable;
 + (BOOL)isEnableLeaksAlert;

 // 注意，当导入FBRetainCycle才会生效。用于设置是否启用FBRetainCycle
 + (void)setEnableCheckRetainCycle:(BOOL)enable;
 + (BOOL)isEnableCheckRetainCycle;*/

@end
