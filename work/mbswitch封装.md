mbswitch封装





[样式示例&需求](https://lanhuapp.com/web/#/item/project/detailDetach?type=share_mark&pid=e9230115-5dcc-43e8-86ea-2165e9eebf75&imgId=e7408b42-40e6-41ad-9cd6-2d10a7e0c8d1&project_id=e9230115-5dcc-43e8-86ea-2165e9eebf75&image_id=e7408b42-40e6-41ad-9cd6-2d10a7e0c8d1&teamId=0a750fb7-f042-4813-8d26-664638b18206&userId=bba825f2-96d4-4e52-a924-69a8e8667e9e&param=none&tid=0a750fb7-f042-4813-8d26-664638b18206)

[不同状态的button自定义示例](https://brontoxx.medium.com/proper-way-to-set-uibutton-background-color-for-disabled-state-15d4c6482bd)

[switch自定义示例](https://juejin.cn/post/6844903750977454088)









bugs

uiview不响应

对于UIIView userInteractionEnabled属性默认是YES;
所以UIView会截获点击事件，点击事件不会向下传播。

对于UIImageView userInteractionEnabled属性默认是NO;
所以UIImageView不会截获点击事件，点击事件会继续向下传播。

你以前可能是在button上添加UIImageView，而现在添加的是UIIView。所以会出现跟以前不一样的效果。

解决办法：将UIView的userInteractionEnabled设置为NO即可。