//
//  MBAPMDebugPageRenderDetailViewController.m
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import "MBAPMDebugPageRenderDetailViewController.h"
@import MBAPMLib;
#import <YYModel/NSObject+YYModel.h>
#import "MBAPMDebugItemDetailCell.h"

static NSString *MBAPMDebugDetailCellID = @"MBAPMDebugDetailCellID";


@interface MBAPMDebugPageRenderDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<MBAPMPageRenderMetric *> *dataArray;

@end

@implementation MBAPMDebugPageRenderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"页面%@加载耗时", self.pageName];
       #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
           if (@available(iOS 13.0, *)) {
               self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
           } else {
       #endif
           self.view.backgroundColor = [UIColor whiteColor];
           }
       self.dataArray = [[MBAPMDataCache sharedInstance]getCachedPageMetics:self.pageName];
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
    [_collectionView registerClass:[MBAPMDebugItemDetailCell class] forCellWithReuseIdentifier:MBAPMDebugDetailCellID];
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width - 20, 128);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBAPMDebugItemDetailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MBAPMDebugDetailCellID forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    MBAPMPageRenderMetric *statistic = self.dataArray[row];
    
    [cell updateDes:[statistic yy_modelToJSONString]];
    return cell;
    
}


@end
