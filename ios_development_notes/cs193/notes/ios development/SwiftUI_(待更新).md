IOS开发入门，记录SwiftUI学习入门历程，参考教程[斯坦福大学cs193课程2021年春](https://www.bilibili.com/video/BV1q64y1d7x5?p=1), 笔记参考[博客](http://m.55mx.com/ios/144.html)



## 第一阶段 Task: build an app “Memorize”

### Lecture 1: Getting Started with SwiftUI

- 配置xcode项目界面：

  use core data: 面向对象数据库

  include tests: 测试框架

- xcode界面

  根目录文件夹：总体配置，包括info.plist

  preview，code，inspector三者同步

  assets: 资源通过拖拉转移， appicon用来存储不同分辨率的图片

- memorizeApp （入口文件）

```swift
import SwiftUI

@main
struct memorizeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

- ContentView

```swift
import SwiftUI

//struct in swift can have functions
struct ContentView: View {
  // “some” means some other things that behaves like a view, a combiner view
  // function {} here returns a text type, which equals to var body: Text{} with the keyword "return" hidden
  // why we use some View instead of Text?:
  //    1. declaration: View 不要求body必须是text，也可以是combiner view，所以在声明中使用some view
  //    2. 方便：code will become complicated, 让compiler自动去figure out function return的内容
    var body: some View {
        Text("Hello, world!") 
            .padding() 
      // padding is a funcion that exists in all structs that behaves like a view i.e. Text, ContentView
      // .padding()使用默认值进行填充，默认值is platform-specific
      // .padding() is a modifier, created a modified view which is not a text type
    }
}

//配置previews，使他展现contentview的code内容
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

> - swift支持functional programming， 也支持object-oriented programming
>
> - 我们使用fp去构建ui，使用oop去hook up model，logic to ui
>
> - 理解函数式编程：
>
>   functional programming不会定义数据存储，注重行为描述
>
>   函数定义了行为，需要做的事物都可以交给函数处理。即使是存储工作。函数是一等公民。

- some other views : 自定义矩形, text, color ...

```swift
struct ContentView: View {
    var body: some View {
        return RoundedRectangle(cornerRadius: 25)//使用带有标签的参数
            .stroke() 
      //for all shapes .fill() is called by default 
      //use .fill() after stroke 表示fill这个边框，比如添加渐变图案等等
      //注意stroke(边缘消失)和strokeborder区别
            .padding(.horizontal)
    }
}
```

Stack (类比乐高积木 - a bag of legos） (ZStack /HStack /VStack)

- 作为一种view combiner，实现view sum
- 两个参数 对齐方式，content（通常采用简写模式），content 参数用来表示装入袋子的legos

```swift
    var body: some View {
        //ZStack 一种view combiner（叠加）
        ZStack { //最后一个函数参数可以提取到括号外面， 如果只有一个函数参数括号可以省略
            RoundedRectangle(cornerRadius: 25)
                .stroke(lineWidth: 3) 
                .foregroundColor(.red)//子元素修改前景色后会覆盖掉父元素的值
            Text("Hello, world!")
        }
        .padding(.horizontal)    
    }
```

这些stacks内部:

a. 可以设置variables（通常用来简化ui的design code， 比如用一个shape接收RoundedRectangle(cornerRadius: 25)变量）

b. 也可以使用if 等逻辑语句



### Lecture2 Learning more about SwiftUI

- 设置previews dark mode 和 light mode

```swift
//配置previews，使他展现contentview的code内容
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //创建多种preview
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
```

- 打包视图结构体CardView 

```swift
struct ContentView: View {
    var body: some View{
        HStack{
            CardView(content:"hello") //调用者修改被调用结构体变量
            CardView()
            //下面将复制20次CardView()
            //...........
        }.padding(.horizontal)
        .foregroundColor(.red)
    }
}
//我们将上面需要重复使用的代码打包成了一个新的视图
struct CardView:View {
    var content: String //承接参数 //此处如果不赋值，那么需要调用者去覆盖赋值，以label的形式
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 25) //简化代码
            shape.fill().foregroundColor(.white)
            shape.stroke(lineWidth: 3)
            Text(content).foregroundColor(.orange)
        }
    }
}
```

- 判断与修改卡片面向

在CardView组件内设置一个布尔值参数，并在zstack内通过if语句进行判断

```swift
struct CardView: View {
    @State var isFaceUp: Bool = true 
    var content: String
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
        
    }
}
```

> 当绑定点击手势改变isfaceup变量时，出现报错 Error: Cannot assign to property: 'self' is immutable
>
> 问题： UI views are static, and immutable，视图(self)是不能修改的，因为self下的isFaceUp是我们整个CardView视图的一部分，在SwiftUI里视图是**不能被修改**的，只能**被重建**； 
>
> 原因：在就算我们定义的是var isFaceUp一但它被创建者初始化后或者指定了默认的值后（可以被调用者覆盖1次）也是无法修改其值的。这个值改变后视图将会立即重建被新的视图所替换（isFaceUp也被替换掉了，修改无意义），因为isFaceUp属于视图的一部分，同时将被系统回收掉，所以这个值是不能修改的
>
> 解决：就是把这个值放到视图的外面去保存，使用一个@State修饰后，这个变量将保存到视图的外部，这里做为引用变量: `@state var isFaceUp: Bool = true` 



- 遍历数组创建CardView

  1. 在ContentView里先定义一个数组emojis:Array用于存储表情:

  但是在实际开发中我们永远不会把CardView复制多次，我们需要计算有多少显示显示的content内容来生成相同数量的CardView，我们有多种方式，这里课程中使用最基础的Array来存储content里的内容。

  ```swift
  var emojis: [String] = ["🐶", "🐮", "🐯", "🐷", "🐭", "🐰", "🐻‍❄️", "🙈","🌵", "🌲", "🍄", "☘️", "🐚", "🌴", "🍃", "🌈"]
  ```

  2. swiftUI里返回视图的遍历需要使用ForEach，

     注意点：

       a. ForEach**只能使用在stack中**，因为他只是view maker，不是view combiner，无法独立使用作为结果返回

       b. 放入进去的数据需要符合Identifiable协议，在swift里所以的struct都可以符合这个协议，只需要增加一个id属性即可

     > 为什么Foreach需要遍历的数据符合Identifiable呢？这是因为显示的子视图需要重新排序，或者向其中添加新的内容，大概都就增删改查CRUD操作，既然有操作就需要知道对谁操作。这样我们就通过ID来识别被操作的对象。

  

  但遗憾的是String没有可识别ID，下面的代码中我们将使用.self来做为识别ID。但字串一样的时候ID将变得不再唯一，这里就会出现新的问题，如果我们在数组里放入相同的2个字符串，通过Foreach遍历后生成的视图在识别上就会出现问题：

  ```swift
  struct ContentView: View {
      var emojis: [String] = ["🐰", "🙈","🌵", "🌲", "🍄", "☘️", "🐚", "🌴", "🍃", "🌈"]
      var body: some View{
          HStack{
              ForEach(emojis,id:\.self){ emoji in //函数传参
                  CardView(isFaceUp: true, content: emoji)
              }
          }.padding(.horizontal)
          .foregroundColor(.red)
      }
  }
  ```

  3. 限制Foreach的读取范围：

  ```swift
  ForEach(emojis[0..<4],id:.self){ emoji in
      CardView(isFaceUp: true, content: emoji)
  }
  
  //让区间运算符的范围可变
  
  @State var emojiCount = 6
  ...
  ForEach(emojis[0..<emojiCount], id: \.self){ emoji in
       CardView(content: emoji)
  }
  ```

  4. 在底部增加一个点击按钮

  ```swift
  var body: some View{
      VStack{ //增加一个VStack以达到按钮排列到底部的目的
          HStack{
              ForEach(emojis[0..<emojiCount],id:.self){ emoji in
                  CardView(isFaceUp: true, content: emoji)
              }
          }.padding(.horizontal)
          .foregroundColor(.red)
          HStack{
              Button(action: {
                  emojiCount -= 1 //点击减少数组范围
              }, label: {
                  Text("删除")
              })
              Spacer() //占据所有剩余空间
              Button(action: {
                  emojiCount += 1 //点击增加数组范围
              }, label: {
                  Text("增加")
              })
          }.padding(.horizontal)        
      }
  }
  ```

  这样的代码会显示太比较臃肿，不适合排版，我们优化一下代码,将”删除“与”增加“按钮包装到一个变量里

  在swiftUI里，如果没有参数传入的情况下，我们尽量使用var来定义视图。就像var body: some View一样，我们定义 var remove:some View与 var add:some View。

  ```swift
     HStack{
        remove
        Spacer()
        add
    }
    .font(.largeTitle) //可修改SF Symbols库里的图标大小
    .padding(.horizontal)
     var remove: some View {
          //函数名字后面直接跟函数参数
          Button {
              if emojiCount>1 {
                  emojiCount-=1
              }
              
          } label: {
              Image(systemName: "minus.circle") //SF Symbols
          }
      }
      var add: some View {
          Button {
              if emojiCount<emojis.count {
                  emojiCount+=1
              }
          } label: {
              Image(systemName:"plus.circle")//SF Symbols
          }
      }
  }
  ```

  > SF Symbols是swiftUI内置的图标库，通过[官方](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/)下载查看里有数千个常用的图标，我们只需要像下面代码一样调用图片的名称就能使用了。

- 使用LazyVGrid让卡片以网络方式排列

  1. 使用网络化排列

     我只需要将卡片的上一层HStack替换成下面的代码即可：

     ```swift
     LazyVGrid(columns: [GridItem(.fixed(200)),GridItem(),GridItem()])
     ```

  2. 调整卡片大小比例

     .aspectRatio是一个强大的修饰器，可以让视图按照纵横比显示。

     我们只需要在CardView后面增加一个.aspectRatio(2/3,contentMode: .fit)就以2(宽):3(高)的方式显示卡片。

     ```swift
     CardView(isFaceUp: true, content: emoji).aspectRatio(2/3,contentMode: .fit)
     ```

  3. 利用ScrollView正常显示卡片

  4. 使用strokeBorder替换掉stroke防止边框溢出到频幕外

     **视图**，该视图是用前景色填充self的宽度大小的边框(又称内描边)的结果。这相当于用width / 2插入self，并以width作为线宽来描划结果形状。

     **新形状**，它是self的描边副本，其行宽由lineWidth定义，而StrokeStyle的所有其他属性具有默认值。

  5. 使用.adaptive让卡片适应横屏











Lecture 3

##### MVVM开发模式与Swift类型系统

body var always return a ui that represents the model

declarative vs imperative coding 





types　

class vs. struct

Similarities

stored variables 

computed variables

Constant variables

Functions (all arguments have labels inside labels vs outside labels)

Initialisers



Differences

Struct: value type; coppied when passed or assigned;copy on write;functional programmimng;no inheritance;

Class: reference type; passed around via pointers;automatically reference counted; oop(good for sharing) ;single inheritance;



##### Lecture 5: 

###### More memorize: make our game reactive and respond to touch events

###### varieties of types

Struct class

Protocol

generics

enum:

cases 

associated data for each case

Switch, 如何取到associated data

enum内部可以有functions，还可以有vars but only computed vars

functions

###### Optional



---

[A Swift Tour](https://docs.swift.org/swift-book/GuidedTour/GuidedTour.html)

- Simple Values 

  `let`常量 `var` 变量

   value type： 写出type， infer出type

   转变类型方法 在string中直接读取变量方法 三个双引号

   array/dictionary的声明方法，如何声明类型 

- Control Flow 

- Functions and Closures 

- Objects and Classes 

- Enumerations and Structures 

- Protocols and Extensions 

- Error Handling 

- Generics

[Language Guide ](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)

The Basics

- Constants and Variables 
- Comments 
- Semicolons 
- Integers 
- Floating-Point Numbers 
- Type Safety and Type Inference 
- Numeric Literals 
- Numeric Type 
- Conversion Type 
- Aliases 
- Booleans 
- Tuples 
- Optionals 
- Error Handling 
- Assertions and Preconditions