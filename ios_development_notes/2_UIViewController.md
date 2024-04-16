

##### UIViewController

- 管理view
- 响应用户操作
- 可以管理多个controller
- 和app整体的交互

##### UIViewController生命周期

Init

\- (**void**)viewDidLoad;

\- (**void**)viewWillAppear:(**BOOL**)animated;  // Called when the view is about to made visible. Default does nothing

\- (**void**)viewDidAppear:(**BOOL**)animated;   // Called when the view has been fully transitioned onto the screen. Default does nothing

\- (**void**)viewWillDisappear:(**BOOL**)animated; // Called when the view is dismissed, covered or otherwise hidden. Default does nothing

\- (**void**)viewDidDisappear:(**BOOL**)animated; // Called after the view was dismissed, covered or otherwise hidden. Default does nothing

选择合适的函数处理不同的业务

##### UITabBarController

多个UIViewController + UITabBar视图

设置UITabBarItem

##### UINavigationController

通过栈管理页面切换

- 需要设置root viewcontroller

  ```objc
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController]
  ```

- 可以在每个viewcontroller中添加响应事件进行push pop操作切换页面

- 可以设置navigation item样式

  ```objective-c
  vc.navigationItem.title = @"xxx";
  vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"xxx" ...]
  ```

一般情况下设置root viewcontroller为navigation controller

navigation controller的root controller设置为tabbar

[adding icons/images](https://guides.codepath.com/ios/adding-image-assets)

##### delegate

![delegate](/Users/admin/Documents/study/ios/images/delegate.png)

比如UITabBarControllerDelegate

常用方法：

```objc
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController API_AVAILABLE(ios(3.0));
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
```

##### 列表/UITableView

![UITableView](/Users/admin/Documents/study/ios/images/UITableView.png)

UITableView 作为视图，只负责展示，不管理数据， 通过dataSource delegate管理数据

datasource delegate 两个required 方法

返回行数

返回uitableviewcell

![UITableViewCell](/Users/admin/Documents/study/ios/images/UITableViewCell.png)

回收池

![reusablecell pool](/Users/admin/Documents/study/ios/images/reusablecell pool.png)

NSIndexPath

indexPath.section

indexPath.row



UITableViewDelegate

- 提供滚动过程中，uitableviewcell的出现 消失时机
- 提供cell的高度，headers footers设置 
- cell各种行为的回调（点击删除等）



列表：数据和操作都是通过delegate给开发者进行回调执行



UICollectionView （基础创建 cell生成）

![UICollectionView](/Users/admin/Documents/study/ios/images/UICollectionView.png)

UICollectionView UITableView 区别

- 声明flowlayout来创建

- 定位NSIndexPath:  Row -> item

- 不提供默认的样式

  只有contentview 和backgroundview

  继承自uicollectionresuableview

- 必须先注册cell类型用于重用

UICollectionViewFlowLayout

系统自动生成的默认流式布局样式，如果想要进行修改，可以实现UICollectionViewDelegateFlowLayout实现函数设置（e.g. 根据indexpath做更细化的自定义样式）

`CGSizeMake(<#CGFloat width#>, <#CGFloat height#>)`

如果想要customize layout样式，继承UICollectionViewLayout（抽象类），实现uicollectionviewlayout uisubclassinghooks中的方法，自定义attribute

UICollectionView使用：

1. 创建UICollectionViewLayout,系统默认流式布局，或自定义布局
2. 创建UICollectionView，设置delegate和datasource，注册cell类型
3. 选择实现UICollectionViewDataSource方法，行数 cell复用
4. 选择实现UICollectionViewDelegate中方法（点击 滚动等）

总结

UITableView算特殊flow布局的UICollectionView

简单的列表可以用UITableView

有双向的布局，特殊布局等非普通场景（瀑布流/弹幕等）；有layout的切换，在选择屏幕时有动画， 可以使用UICollectionView



UIScrollView

![scrollView](/Users/admin/Documents/study/ios/images/uiscrollview.png)

![scrollView_基础设置](/Users/admin/Documents/study/ios/images/scrollView_基础设置.png)

如何在scroll view工作中监听scrollview的状态，响应事件，处理业务逻辑 --实现delegate (UIScrollViewDelegate)

![scrollViewDelegate](/Users/admin/Documents/study/ios/images/scrollViewDelegate.png)

应用

![UIScrollView应用](/Users/admin/Documents/study/ios/images/UIScrollView应用.png)

总结

![UIScrollView总结](/Users/admin/Documents/study/ios/images/UIScrollView总结.png)

总结

##### 单页面展示 

通过列表 

通过滚动页面

##### 多页面管理

底部按钮进行页面切换