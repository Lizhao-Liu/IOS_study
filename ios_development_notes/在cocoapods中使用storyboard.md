





### 在cocoapods中使用storyboard

1. 放在资源中 bundle

   ```objc
   s.resource_bundles = {
      'GasStationMerchantMainModule' => ['GasStationMerchantMainModule/Assets/**/*']
    }
   ```

   

2. 获取bundle

   ```objc
   #define KBUNDLE [[NSBundle mainBundle] pathForResource:@"GasStationMerchantMainModule" ofType:@"bundle"]
   #define KBUNDLE_PT [NSBundle bundleWithPath:KBUNDLE]
   ```



3. 两种方式

```objc


// vc init重写
- (instancetype)init {
    return [super initWithNibName:@"HCBAboutUsVC" bundle:KBUNDLE_PT];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HCBMyCouponListNewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCBMyCouponListNewCell class]) forIndexPath:indexPath];
}



// table cell
- (UITableView *)couponListTableView {
    if (!_couponListTableView) {
        _couponListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentControlHeight, SCREENWIDTH_PT, _couponTableViewHeight) style:UITableViewStyleGrouped];
        _couponListTableView.dataSource = self;
        _couponListTableView.delegate = self;
        _couponListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _couponListTableView.backgroundColor = COLOR_BG_PT;
        [_couponListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCBMyCouponListNewCell class]) bundle:KBUNDLE_PT] forCellReuseIdentifier:NSStringFromClass([HCBMyCouponListNewCell class])];
        [_couponListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HCBNoCouponTipCell class]) bundle:KBUNDLE_PT] forCellReuseIdentifier:NSStringFromClass([HCBNoCouponTipCell class])];
    }
    return _couponListTableView;
}

@implementation HCBMyCouponListNewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _btnGotoUse.layer.borderColor = COLOR_AC1_PT_CG;
    _btnGotoUse.layer.borderWidth = 0.5f;
    [_btnGotoUse setTitleColor:COLOR_AC1_PT forState:UIControlStateNormal];
    self.goCouponDesButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.goCouponDesButton setTitleColor:[UIColor colorWithHexString:@"#92979E"] forState:UIControlStateNormal];
    [self.goCouponDesButton setTitle:@"使用规则" forState:UIControlStateNormal];
    [self.goCouponDesButton setImage:[[UIImage petrol_imageNamed:@"icon_gas_coupon_next_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.goCouponDesButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3);
    self.goCouponDesButton.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
}

@end
  
```

