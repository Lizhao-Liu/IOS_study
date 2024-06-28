### 私有库学习记录



### [MBFoundation](https://code.amh-group.com/iOSYmm/MBFoundation/tree/develop/MBFoundation/Classes)

框架完整定义并提供了一套iOS开发常用基础API集合，包括但不限于基本数据类型、结构体、类、对象、时间日期处理、文件系统、内存安全管理、归档存储、异步协程机制等相关功能。



Safe Extension
方法中有一些 hook 数组，字典空值越界崩溃的操作

在 Debug 会抛出 OC 错误，帮助开发纠正
会通过 MBFoundationExceptionUtil 吐出结果给上层

- [ ] 没看懂



#### Algorithm 一般理解

新的加解密算法

###### Cryptor ：对称加密 / 非对称加密

```swift

CryptorAligorithm.Symmetric.algorithm

使用：
// public struct Cryptor 


public struct Cryptor {

static func symmetricEncrypt(algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data? = nil) -> Data?

static func symmetricDecrypt(algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data? = nil) -> Data?

//private static func symmetricCrypt(operation: CCOperation, algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data?) -> Data? 

static func asymmetricEncrypt(_ algorithm: CryptorAligorithm.Asymmetric? = .rsa, data: Data, publicKey: String) -> Data?

static func asymmetricDecrypt(_ algorithm: CryptorAligorithm.Asymmetric? = .rsa, data: Data, privateKey: String) -> Data?
  
//IV的作用 IV称为初始向量，不同的IV加密后的字符串是不同的，加密和解密需要相同的IV，既然IV看起来和key一样，却还要多一个IV的目的，对于每个块来说，key是不变的，但是只有第一个块的IV是用户提供的，其他块IV都是自动生成。
}



```

> Swift 用Data表示二进制数据，同样也是一个[结构体](https://so.csdn.net/so/search?q=结构体&spm=1001.2101.3001.7020)



###### DataCompressor: 数据压缩/解压 （不同形式）

###### Digest： data/string 本身扩充的获取哈希值方法

```swift
//public extension Data or public extension String
func digestData(using method: Digest.HashMethod) -> Data?
func digestString(using method: Digest.HashMethod, format: Digest.Format = .hex) -> String? 
```



#### Collection 基本理解

线程安全的数组，字典，Set

- [ ] swift 范型
- [ ] Where 

###### MBThreadSafeArray

[ios数组线程安全](https://www.jianshu.com/p/4195209e4d8e)

```swift
public class MBThreadSafeArray<Element> 
// immutable 读取：非并发队列，**同步**执行
// mutable操作： 凡涉及更改数组中元素的操作，使用 **异步** 栅栏块将数组的写（插入、修改、删除）操作放进队列中dispatch_barrier函数中，这样当进行写的操作时，会先等待前面的读的任务完成后再执行写操作;而且后面的读任务也要等待dispatch_barrier中的写操作执行完成后才会被执行。
// 添加回调 回调返回主线程异步操作 e.g.
func remove(at index: Int, completion: ((Element) -> Void)?)
// predicate判断 逃逸闭包 （因为是异步操作）e.g.
func remove(where predicate: @escaping (Element) -> Bool, completion: ((Element) -> Void)?)
```

###### MBThreadSafeDictionary

原理同上，加了一个subscript封装

#### ContactsKit  不太懂

###### MBContacts

获取用户联系人信息

`Contact`类是线程安全的,联系人的属性是不可以改变的,比如联系人的名称,图片,或者电话号码

```swift
/// The current application's access status to the system address book.
    static var authorizationStatus: CNAuthorizationStatus { get }

    /// Whether the current application allows access to the system address book.
    //  Note20220314: 在宿主使用
    static var isAuthorized: Bool { get }

    /// The application actively applies for permission to access the system address book.
    /// - Parameter completion: This block is called upon completion.
    ///   If the user grants access then granted is YES and error is nil.
    ///   Otherwise granted is NO with an error.
    static func requestAccess(_ completion: @escaping (Bool, Error?) -> Void)

    /// Fetch the system address book contact data.
    static func fetchContacts() -> [CNContact]?

    /// Fetch the system address book contact data.
    /// Only applicable to iOS10 and above.
    /// - Parameter sortOrder: Sort order for contacts.
    @available(iOS 10.0, *)
    static func fetchContacts(_ sortOrder: CNContactSortOrder) -> [CNContact]?

    /// Format an array of 'CNContact' object into an array of
    ///   ''' {"name": "xxx", "telephone": "xxx"} ''' object.
    /// - Parameter contacts: Array of 'CNContact' object.
    static func formatContacts(_ contacts: [CNContact]) -> [[String: String]]?
```



#### CoreTelephonyKit 一般理解

获取运营商信息 当前电话状态 拨打电话等

###### MBCoreTelephony

```swift
public class MBCoreTelephony: NSObject, MBCoreTelephonyable 

//初始状态不监听

private static let _sharedInstance: MBCoreTelephony

public static func shared() //调用sharedinstance
public static func startMonitoring() 
//callStatusChanged -> notificationcenter post MBCoreTelephonyCallSatusChangedNotification
//recordCallDuration -> NotificationCenter.default.post(name: NSNotification.Name(rawValue: MBCoreTelephonyCallSatusChangedNotification), object: call, userInfo: nil)MBCoreTelephonyCallEventDurationNotification), object: call, userInfo: [MBCoreTelephonyCallEventDurationKey: duration >= 0 ? duration : 0])
public static func stopMonitoring()
public static func callStatus(with call: CTCall) -> MBCoreTelephonyCallStatus
public static func call(with telephoneNumber: String, durationClosure: (() -> TimeInterval)?)
//通过生成telephone url 并UIApplication.shared.open(telephoneURL, options: [:], completionHandler: nil)实现
```

> 1. [swift中的defer用法](https://alanli7991.github.io/2017/08/01/Swift%E7%9A%84defer%E7%94%A8%E6%B3%95/)
>
> 若对象有互斥锁，则在任一时刻，只能有一个线程访问对象。类锁、对象锁都属于对象监视器，而对象监视器是基于互斥锁的。
>
> swift实现
>
> ```swift
> objc_sync_enter(self)
> defer { objc_sync_exit(self) }
> ```
>
> oc
>
> ```objc
> @synchronized(self) {
> }
> ```
>
> 2. ios版本区分
>
> swift
>
> ```swift
> if #available(iOS 10.0, *) {
>             UIApplication.shared.open(telephoneURL, options: [:], completionHandler: nil)
>         } else {
>             UIApplication.shared.openURL(telephoneURL)
>         }
> ```
>
> 



#### Extension

思路：

用MBFoundationWrapper将各个类（值类型/引用类型）封装， 各个类实现MBFoundationWrappable协议

```swift
public protocol MBFoundationWrappable {
    associatedtype WrapperType
    var mb: WrapperType { get set }
    static var mb: WrapperType.Type { get set }
}
```

```swift
public protocol MBFoundationWrappableObject: MBFoundationWrappable, AnyObject { }
public protocol MBFoundationWrappableValue: MBFoundationWrappable { }
```

将MBFoundationWrapper进行扩展

```swift
public struct MBFoundationWrapper<T> {
    let this: T
    let THIS: Self.Type
    init(_ object: T) {
        self.this = object
        self.THIS = Self.self
    }
}
```



MBFoundationWrapper

###### ArrayExtension

Nsarray:

```swift
// MARK: JSON
func mb_jsonString() -> NSString? 
func mb_jsonPrettyString() -> NSString?
func mb_jsonData() -> NSData?
// MARK: Immutable
static func mb_isNilOrEmpty(_ array: NSArray?) -> Bool
func mb_isEmpty() -> Bool
func mb_count() -> NSInteger
func mb_object(at index: NSInteger) -> Any?
func mb_string(at index: NSInteger) -> NSString?
func mb_number(at index: NSInteger) -> NSNumber?
func mb_array(at index: NSInteger) -> NSArray?
func mb_dictionary(at index: NSInteger) -> NSDictionary?
func mb_decimalNumber(at index: NSInteger) -> NSDecimalNumber?
func mb_bool(at index: Int) -> Bool
func mb_int8(at index: Int) -> Int8 //int16, 32, 64, 
func mb_unsignedInteger(at index: Int) -> UInt
func mb_unsignedInt8(at index: Int) -> UInt8  //int16, 32, 64
func mb_float(at index: Int) -> Float
func mb_double(at index: Int) -> Double
func mb_CGFloat(at index: Int) -> CGFloat
func mb_CGPoint(at index: Int) -> CGPoint //mb_CGSize mb_CGRect
//common
func mb_each(_ block: (Any) -> Void)
@discardableResult
func mb_map(_ block: (Any) -> Any?) -> NSArray
func mb_flatMap(_ block: (Any) -> Any?) -> NSArray 
func mb_filter(_ block: (Any) -> Bool) -> NSArray 
func mb_reduce(_ initial: Any, block: (Any, Any) -> Any) -> Any? 
func mb_first(_ block: (Any) -> Bool) -> Any?
```

>  @discardableResult 是 Swift 用于禁止显示 Result unused 警告的一个属性

NSMutableArray 

```swift
// MARK: Mutable
func mb_add(_ object: Any?)
func mb_insert(_ object: Any?, at index: Int) 
func mb_remove(at index: Int) 
func mb_removeAll()
func mb_replace(at index: Int, with object: Any?)
func mb_addContainNil(_ object: Any?)
func mb_insertContainNil(_ object: Any?, at index: Int)
```

###### Character: 

```swift
var isSimpleEmoji: Bool
var isCombinedIntoEmoji: Bool 
var isEmoji: Bool 
```

> character扩展时方法：
>
> **public** **extension** MBFoundationWrapper **where** T == Character { ... }

###### Collection：

```swift
var nonEmpty: Self?
subscript(safe index: Index) -> Element?
```

###### Data：

hashdata： e.g. md2Data()

Encode & Decode 

Inflate & Deflate

Encrypt & Decrypt

Byte Utils

###### Date & DateFormatter

###### Dictionary：

```swift
// json
var json: String?
var jsonPretty: String?
var jsonData: Data?
func mb_jsonString() -> NSString?
func mb_jsonPrettyString() -> NSString?
func mb_jsonData() -> NSData? 
// url
func mb_URLEncodingString() -> NSString?
func mb_URLParamsString() -> NSString?
// MARK: Plist
var plistData: Data?
var plistString: String?
static func mb_dictionaryWithPlistData(_ plist: Data?) throws -> [AnyHashable: Any]?
static func mb_dictionaryWithPlistString(_ plist: String?) throws -> [AnyHashable: Any]?
// MARK: Immutable
func mb_objectForKey(_ key: AnyObject?) -> AnyObject?
func mb_objectForKeyIgnoreNil(_ key: AnyObject?) -> AnyObject?
func mb_dictionaryForKey(_ key: AnyObject?) -> NSDictionary? 
func mb_arrayForKey(_ key: AnyObject) -> NSArray?
func mb_numberForKey(_ key: AnyObject) -> NSNumber? //decimalnumber... int8...CGFloat...
func mb_isContain(_ key: AnyObject?) -> Bool
static func mb_isNilOrEmpty(_ dict: NSDictionary?) -> Bool 
func mb_isEmpty() -> Bool
// MARK: Generic
func mb_each(_ block: (Any, Any?) -> Void) 
func mb_map(_ block: (Any, Any?) -> Any?) -> NSDictionary
func mb_filter(_ block: (Any, Any?) -> Bool) -> NSDictionary
// MARK: Mutable   
// public extension NSMutableDictionary
func mb_setObject(_ object: AnyObject?, forKey key: NSString)
func mb_setObjectContainNil(_ object: AnyObject?, forKey key: NSString)
func mb_setObjectIgnoreNil(_ object: AnyObject?, forKey key: NSString)
func mb_setString(_ string: NSString, forKey key: NSString) //其他类型都可
```

###### DispatchQueue

```swift
static func once(file: String = #file, function: String = #function, line: Int = #line, block:() -> Void)
```

###### Double / FLoat

```swift
var int: Int
var float: Float
var cgFloat: CGFloat
```

###### Int

```swift
var countableRange: CountableRange<Int>
var degreesToRadians: Double
var radiansToDegrees: Double
var uInt: UInt
var double: Double
var float: Float
var cgFloat: CGFloat
```

###### NSNull

```swift
override func forwardingTarget(for aSelector: Selector!) -> Any?
```

###### NSNumber

```swift
func mb_formatToSince1970Date() -> NSDate?
func mb_formatCentToYuan2() -> NSString 
func mb_formatCentToYuanMax2() -> NSString
func mb_numberWithString(_ string: NSString?) -> NSNumber?
func mb_formatCentToYuanWithCN() -> NSString
```

###### Object

```swift
一些有关埋点的内容
```

###### SignedNumeric

```swift
var string: String 
var asLocaleCurrency: String? 
func spelledOutString(locale: Locale = .current) -> String? 
```

###### NSSortDescriptor

```swift
看不懂
```

###### String

```swift
func nsRange(from range: Range<String.Index>?) -> NSRange?
func range(from nsRange: NSRange) -> Range<String.Index>?
/// a[1...3] 下标
subscript(of index: Int) -> String
subscript(r: ClosedRange<Int>) -> String
// MARK: Hash
func md2String() -> String? //...
// MARK: Encode & Decode
func utf8EncodeData() -> Data 
func base64EncodedString() -> String? 
func encodeString() -> String?
func decodeString() -> String? 
func urlQueryString() -> String?
func urlQueryParams() -> [String: String]?
// MARK: Regular Expression
func matchesRegx(pattern: String, options: NSRegularExpression.Options) -> Bool
func stringByReplacingRegex(_ regex: String, options: NSRegularExpression.Options, withString replacement: NSString) -> NSString
func isNumbers() -> Bool //is + other types
// MARK: Money
// MARK: Desensitization
// MARK: Emoji
// MARK: Utilities
static func stringWithUUID() -> String
func stringByTrim() -> String
func contains(string: String, caseInSensitive: Bool) -> Bool
func dataValue() -> Data 
func jsonValueDecoded() -> Any?
var uppercase: String
var lowercase: String
func OSSUrlStringWithImageSize(_ size: CGSize) -> String
func filterEmoji() -> String?
func appendURLQueryParameters(_ params: [String: String]) -> String?
func appendingQueryValue(_ value: String, forKey key: String) -> String

//public extension NSString 
// MARK: Hash
func mb_md2String() -> NSString?
// MARK: Encode & Decode
func mb_utf8EncodeData() -> NSData 
// MARK: Regular Expression
func mb_matchesRegx(pattern: NSString, options: NSRegularExpression.Options) -> Bool
//和上面相似，只是使用前加mb_前缀
```

- [ ] 问题：**TODO: fix spelling error** 102

###### Timer

```swift
// MARK: Weak timer
static func mb_scheduledTimerWith(timeInterval: TimeInterval, repeats: Bool, completion: @escaping(_ timer: Timer) -> Void) -> Timer
```



###### UserDefault

```swift
/// get object from UserDefaults by using subscript.
subscript(key: String) -> Any?
func float(forKey key: String) -> Float?
func date(forKey key: String) -> Date?
func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T?
/// Allows storing of Codable objects to UserDefaults.
func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder())

```



###### UIView

```swift
var parentViewController: UIViewController?
/// Recursively find the first responder.
func firstResponder() -> UIView? 
```



###### UITableView

```swift
var indexPathForLastRow: IndexPath?
var lastSection: Int? 
func numberOfRows() -> Int
func indexPathForLastRow(inSection section: Int) -> IndexPath?
func reloadData(_ completion: @escaping () -> Void)
func removeTableFooterView() 
func removeTableHeaderView()
func isValidIndexPath(_ indexPath: IndexPath) -> Bool 
func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool)
```



###### UIImage

###### UIColor

###### UICollectionView

```swift
func numberOfItems() -> Int 
func indexPathForLastItem(inSection section: Int) -> IndexPath?
func reloadData(_ completion: @escaping () -> Void) 
func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool)
func isValidIndexPath(_ indexPath: IndexPath) -> Bool
```



###### UIAlertController

```swift
func show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil)
func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        isEnabled: Bool = true,
        handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction 
func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        editingChangedTarget: Any?,
        editingChangedSelector: Selector?)
```

#### Global

###### AppInfo

```swift
public static var appDisplayName: String?
public static var appBundleID: String? 
public static var statusBarHeight: CGFloat 
public static var appBuild: String?/// App current build number (if applicable).
public static var safeBottomHeight: CGFloat
public static var safeTopHeight: CGFloat
public static var isStatusBarHidden: Bool
public static var appVersion: String?
public static var batteryLevel: Float
public static var currentDevice: UIDevice 
public static var screenHeight: CGFloat
 public static var screenWidth: CGFloat
public static var deviceModel: String
public static var deviceOrientation: UIDeviceOrientation
public static var isInDebuggingMode: Bool
public static var isInTestFlight: Bool
public static var isMultitaskingSupported: Bool
public static var isPhone: Bool 
public static var isRegisteredForRemoteNotifications: Bool
public static var keyWindow: UIView?
public static var mostTopViewController: UIViewController?
public static var systemVersion: String
///methods
@discardableResult static func delay(milliseconds: Double, queue: DispatchQueue = .main, completion: @escaping () -> Void) -> DispatchWorkItem
static func debounce(millisecondsDelay: Int, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void
static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void)
```

###### GlobalDefines

```swift
```

#### SafeExtensions

空值越界扩展，防止崩溃，且上报 hubble

```objc
@implementation NSArray (SafeKit)
- (instancetype)safe_mb_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt;
- (id)safe_mb_objectAtIndex:(NSUInteger)index;

```

- [ ] 不再h文件写明的话其他文件可以调用吗

#### HTMLParser

#### Protocols

NibLoadable 支持load nib Example：ServiceEvaluateViewContent.load(in: Bundle.imCenter)

Reusable 支持table重用一些语法糖

Then 语法糖



#### Tools

MBDateFormatterManager 日历控件，使用 gregorian 公历 MBNetworkInfoProvider 卡信息，手机信息，连接信息 MBPluginInfos 组件信息 MBToolsManager setupWithCompany(_ isHCB: Bool)



#### ManagerCenter

依靠 MBManagerProtocol 通知相应的类进入某些状态。

```swift
public protocol MBManagerProtocol {

// 是否退出登录后也需要常驻内存，默认是NO 

@objc optional func isManagerPersistent() -> Bool 

// Manager初始化时调用 

@objc optional func onManagerInit() 

// 重新登录时会调用 

@objc optional func onManagerReloadData() 

// 进入后台运行 

@objc optional func onManagerEnterBackground() 

// 进入前台运行 

@objc optional func onManagerEnterForeground() 

// 程序退出 

@objc optional func onManagerTerminate() 

// 内存警告 

@objc optional func onManagerMemoryWarning() 

// 退出登录时调用，用于清理和释放资源 

@objc optional func onManagerClearData() 

}
```



[oc swift 互相调用方法](https://blog.51cto.com/u_15146321/2742941)







---

补充学习了哪些

多线程 线程安全的数组

mbfoundationwrapper大致原理

几个板块的api使用



---

问老师的问题：

关于线程安全的数组，字典，Set

1. 关于线程：串行队列同步执行 并行队列同步执行 他们都是在当前队列一个一个执行有什么使用上的偏好吗

2. **@escaping** 在remove函数中的添加

3. nsnull forward那个方法



---

threadSafeSet 没有完成

CoreTelephonyKit api deprecated in ios10





文档 和使用方建议

问题：

NSString 扩展**TODO: fix spelling error** 102

safeExtension 不再h文件写明的话其他文件可以调用吗





