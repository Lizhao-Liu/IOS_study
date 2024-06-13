//
//  MBAPMDebugPageRenderViewController.m
//  AliyunOSSiOS
//
//  Created by xp on 2020/7/29.
//

#import "MBAPMDebugPageRenderViewController.h"
@import MBAPMLib;
#import "MBAPMDebugListItemCell.h"
#import "MBAPMDebugPageRenderDetailViewController.h"


static NSString *MBAPMDebugPageRenderCellID = @"MBAPMPageRenderCellID";


@interface MBAPMDebugPageRenderViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<MBAPMPageRenderMetricStatistic *> *dataArray;

@end

@implementation MBAPMDebugPageRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"页面加载耗时检测";
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
        } else {
    #endif
        self.view.backgroundColor = [UIColor whiteColor];
        }
    self.dataArray = [[MBAPMDataCache sharedInstance]getPageRenderStatistic];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.collectionView.frame = self.view.frame;
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
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [_collectionView registerClass:[MBAPMDebugListItemCell class] forCellWithReuseIdentifier:MBAPMDebugPageRenderCellID];
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width - 20, 128);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MBAPMDebugPageRenderDetailViewController *detailVC = [[MBAPMDebugPageRenderDetailViewController alloc]init];
    detailVC.pageName = self.dataArray[row].pageName;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBAPMDebugListItemCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugPageRenderCellID forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    MBAPMPageRenderMetricStatistic *statistic = self.dataArray[row];
    [cell updateCell:[NSString stringWithFormat:@"页面：%@", statistic.pageName] value1:[NSString stringWithFormat:@"成功率：%f", statistic.successRate] value2:[NSString stringWithFormat:@"平均耗时：%lld", statistic.avgTime]];
    return cell;
    
}


@end
