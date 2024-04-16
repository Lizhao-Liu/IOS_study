##### WebView 

广泛使用 （跨端）

WKWebView 优势: 

- 独立进程，内存

- crash不影响主app

- 对html和css更好的支持

- 更多更有好的系统函数

- 采用jit技术

![使用wkwebview](/Users/admin/Documents/study/ios/images/使用wkwebview.png)

![wkwebview delegates](/Users/admin/Documents/study/ios/images/wkwebview delegates.png)

![创建一个wkwebview](/Users/admin/Documents/study/ios/images/创建一个wkwebview.png)

![使用wkwebview流程](/Users/admin/Documents/study/ios/images/使用wkwebview流程.png)

##### KVO

![kvo](/Users/admin/Documents/study/ios/images/kvo.png)

对比delegate只能实现一对一， 然后借助一个controller来做中转，才能实现一对多

![kvo实现](/Users/admin/Documents/study/ios/images/kvo实现.png)

实现一个进度条

![进度条](./images/进度条.png)

开源kvo： KVOController (Facebook)

![进度条](./images/ios重的web应用.png)



