//
//  MBAPMDebugViewController.m
//  MBAPMLib
//
//  Created by xp on 2020/7/29.
//

#import "MBAPMDebugViewController.h"
#import "MBAPMDebugEntryCell.h"
#import "MBAPMDebugSwitchCell.h"
#import "MBAPMDebugAppLaunchViewController.h"
#import "MBAPMDebugPageRenderViewController.h"
#import "MBAPMDebugLagMonitorViewController.h"
#import "MBAPMDebugMemoryStateViewController.h"
#import "MBAPMDebug-Swift.h"
@import MBAPMLib;
@import MMKV;

static NSString *MBAPMDebugEntryCellID = @"MBAPMEntryCellID";
static NSString *MBAPMDebugEntrySwitchCellID = @"MBAPMEntrySwitchCellID";

@interface MBAPMDebugViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MBAPMDebugSwitchCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MBAPMDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MBAPM";
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
    [_dataArray addObject:@{@"name":@"启动耗时",@"vc":NSStringFromClass([MBAPMDebugAppLaunchViewController class])}];
    [_dataArray addObject:@{@"name":@"页面渲染", @"vc":NSStringFromClass([MBAPMDebugPageRenderViewController class])}];
    [_dataArray addObject:@{@"name":@"卡顿监控", @"vc":NSStringFromClass([MBAPMDebugLagMonitorViewController class])}];
    [_dataArray addObject:@{@"name":@"内存监控", @"vc":NSStringFromClass([MBAPMDebugMemoryStateViewController class])}];
    [_dataArray addObject:@{@"name":@"崩溃监控", @"vc":NSStringFromClass([MBAPMDebugCrashViewController class])}];
    [_dataArray addObject:@{@"name":@"CPU监控", @"vc":NSStringFromClass([CPUMonitorDebugViewController class])}];
    [self.view addSubview:self.collectionView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.frame;
}

#pragma mark - private method

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
    return CGSizeMake(self.view.frame.size.width, 60);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    NSInteger row = indexPath.row;
    if(row != 0) {
        NSDictionary *dict = _dataArray[row];
        NSString *vcClassName = dict[@"vc"];
        Class vcClass = NSClassFromString(vcClassName);
        if([vcClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *vc = [[vcClass alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if(row == 0) {
            MBAPMDebugSwitchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID forIndexPath:indexPath];
            [cell setLabelText:@"总开关，使用配置下发/关闭，重启后生效"];
            [cell setSwitchState:[MBAPMDataCache sharedInstance].cacheEnable];
            cell.delegate = self;
            return cell;
        } else {
            MBAPMDebugSwitchCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntrySwitchCellID forIndexPath:indexPath];
            [cell setLabelText:@"MBAPM白屏debugView开关，默认关"];
            cell.tag = 1;
            [cell setSwitchState:[MBAPMDebugViewController enableWhiteScreenDebugView]];
            cell.delegate = self;
            return cell;
        }
    }
    
    MBAPMDebugEntryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugEntryCellID forIndexPath:indexPath];
    NSDictionary *dict = _dataArray[row];
    NSString *name = dict[@"name"];
    [cell updateCell:name];
    return cell;
}


#pragma mark - MBAPMDebugSwitchCellDelegate

- (void)switchChanged:(BOOL)isON cellTag:(NSInteger)tag {
    if (tag == 1) {
        [self changeMBAPMWhiteScreenDetector:isON];
        return;
    }
    
    [MBAPMDataCache sharedInstance].cacheEnable = isON;
}

#pragma mark - white screen
- (void)temp_debugHandleImage:(UIImage *)image isWhite:(BOOL)isWhite vc:(UIViewController *)controller desc:(NSString *)desc {
    if (![MBAPMDebugViewController enableWhiteScreenDebugView]) {
        return;
    }
    
    // temp
    dispatch_async(dispatch_get_main_queue(), ^{
        __block UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, image.size.width * 0.8, image.size.height * 0.8)];
        imageV.image = image;
        imageV.layer.borderColor = [[UIColor blackColor] CGColor];
        imageV.layer.borderWidth = 2;
        [[[UIApplication sharedApplication] keyWindow] addSubview:imageV];
    
        __block UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 500)];
        [[[UIApplication sharedApplication] keyWindow] addSubview:label];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%@\n%@\n%@", isWhite ? @"isWhite" : @"noWhite", controller, desc];
        label.backgroundColor = UIColor.whiteColor;
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (isWhite ? 15 : 5) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [imageV removeFromSuperview];
            [label removeFromSuperview];
        });
    });
    
}

- (void)changeMBAPMWhiteScreenDetector:(BOOL)isON {
    [MBAPMDebugViewController setEnableWhiteScreenDebugView:isON];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Method originMethod = class_getInstanceMethod(NSClassFromString(@"MBAPMWhiteScreenDetector"), @selector(temp_debugHandleImage:isWhite:vc:desc:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(temp_debugHandleImage:isWhite:vc:desc:));
        
        if (originMethod && swizzledMethod) {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

+ (BOOL)enableWhiteScreenDebugView {
    return [[[MMKV defaultMMKV] valueForKey:@"enableWhiteScreenDebugView"] boolValue];
}

+ (void)setEnableWhiteScreenDebugView:(BOOL)isOn {
    [[MMKV defaultMMKV] setValue:@(isOn) forKey:@"enableWhiteScreenDebugView"];
}

@end
