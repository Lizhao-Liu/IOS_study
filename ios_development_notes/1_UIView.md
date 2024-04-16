#### UIView

- 各种视图类型的父类，提供基础的能力

- 外观、渲染和动画
  相应区域内的事件
  布局和管理理⼦子视图

- 布局

  设置大小，位置（frame）

  addSubView

- 使用栈管理全部的子view



##### UIView 生命周期：

\- (**void**)willMoveToSuperview:(**nullable** UIView *)newSuperview;

\- (**void**)didMoveToSuperview;

\- (**void**)willMoveToWindow:(**nullable** UIWindow *)newWindow;

\- (**void**)didMoveToWindow;





### 手势识别

[UIGestureRecognizer ](https://cloud.tencent.com/developer/article/1129288)

[传递与响应](https://www.codercto.com/a/49603.html)

https://juejin.cn/post/6905914367171100680

https://juejin.cn/post/6844903712985464840



### Safearea 适配

[reference](https://juejin.cn/post/6844903958205431815#heading-1)

一个控制器从创建到界面显示， 会依次调用以下方法： 

-(void)viewDidLoad； 

-(void)viewWillAppear:(BOOL)animated； 

-(void)viewSafeAreaInsetsDidChange； 

-(void)viewWillLayoutSubviews； 

-(void)viewDidLayoutSubviews； 

-(void)viewDidAppear:(BOOL)animated； 

在调用- viewSafeAreaInsetsDidChange方法时, 界面的safeAreaInsets值会被计算出来，在这个方法中可以更改控件的位置；

```objc
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)) {
        NSLog(@"3 --- viewSafeAreaInsetsDidChange");
        NSLog(@"self.view.safeAreaInsets.top = %f",self.view.safeAreaInsets.top);
        NSLog(@"self.view.safeAreaInsets.left = %f",self.view.safeAreaInsets.left);
        NSLog(@"self.view.safeAreaInsets.bottom = %f",self.view.safeAreaInsets.bottom);
        NSLog(@"self.view.safeAreaInsets.right = %f",self.view.safeAreaInsets.right);
    }
}
```

