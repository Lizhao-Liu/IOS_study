#### ios动画

##### UI动画

![ui动画](/Users/admin/Documents/study/ios/images/ui动画.png)

- 使用block 和delegate传递信息的区别，使用方法 （clickbutton函数）

  ```objc
  __weak typeof(self)wself = self;
  [deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
       __strong typeof(wself) strongSelf = wself;
      NSIndexPath *delIndexPath = [strongSelf.tableView indexPathForCell:tableViewCell];
      if (strongSelf.dataArray.count > delIndexPath.row) {
          //删除数据
          NSMutableArray *dataArrayTmp = [strongSelf.dataArray mutableCopy];
          [dataArrayTmp removeObjectAtIndex:delIndexPath.row];
          strongSelf.dataArray = [dataArrayTmp copy];
          //删除cell
          [strongSelf.tableView deleteRowsAtIndexPaths:@[delIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
   }];
  ```

  使用block注意循环引用问题

- 删除数据表示列表信息一致（count）

- frame bounds 区别，转换rect的系统函数

- 添加view到window

  ```objective-c
  //添加
  //[[UIApplication sharedApplication].keyWindow addSubview:self];
   [[self window] addSubview:self];
  //移除
  [self removeFromSuperview];
  
  /// 解决 keyWindow' is deprecated: first deprecated in iOS 13.0 - Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
  - (UIWindow *) window {
      UIWindow* window = nil;
      for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
      {
          if (windowScene.activationState == UISceneActivationStateForegroundActive)
          {
              window = windowScene.windows.firstObject; //lastObject
  
              break;
          }
      }
      return window;
  }
  ```

- override父类init函数

  ```objc
  - (instancetype)initWithFrame:(CGRect)frame {
      self = [super initWithFrame:frame];
      if(self) {
        //...添加内容
      }
      return self;
  }
  ```

- 判断delegate是否实现方法并调用

  ```objc
  - (void)deleteButtonClick {
      if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDeleteButton:)]) {
          [self.delegate tableViewCell:self clickDeleteButton:self.deleteButton];
      }
  }
  ```

##### CALayer

##### CoreAnimation 

底层