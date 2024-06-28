

addImageListView: 提供图片新增列表控件

agreementView: 协议视图









UIViewController + MBExtension

```objc
@interface UIViewController (MBExtesion)

/**
兼容YMM HCB 司机货主
1、历史原因HCB的VC架构存在自定义等情况，传统的获取当前栈顶VC无法拿到正确的对象。
2、HCB司机和货主获取栈顶VC内部实现不同，详见.m文件注释部分。
*/
+ (nullable UIViewController *)mb_currentViewController;

/**
    当mb_currentVC为UIViewController时，直接获取navigationController
    为非UIViewController时，需要特殊处理
 */
+ (UINavigationController *)mb_topNavigationController;

- (void)addBackBtn;
```



#### Base:

```objc
//macros 

//定义各个元素之间的间距，注意单位都是pt
typedef NS_ENUM(NSInteger, MBMarginValue) {
    MBMarginValue2 = 2,
    MBMarginValue4 = 4,
    MBMarginValue6 = 6,
    MBMarginValue8 = 8,
    MBMarginValue12 = 12,
    MBMarginValue16 = 16,
    MBMarginValue20 = 20,
    MBMarginValue24 = 24,
    MBMarginValue28 = 28,
};

//定义圆角值范围，注意单位是pt
typedef NS_ENUM(NSInteger, MBCornerRadius) {
    MBSmallCornerRadius = 2,
    MBNormalCornerRadius = 4,
};
#define kScreenHeight       CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth        CGRectGetWidth([UIScreen mainScreen].bounds)
#define kNavigationHeight   (kStatusBarHeight + 44)
#define kSafeAreaBottomHeight (kScreenHeight >= 812. ? 34.f : 0.f)
```

```objc
// color
YMMColor_YMM_Orange
YMMColor_YMM_Background
  
YMMColor_HCB_Yellow
YMMColor_HCB_Background  
YMMColor_HCB_Blue
详细颜色...
```

```objc
//font
MBRomanFont(CGFloat size)
MBNormalSystemFont(CGFloat size)
...
```

```objc
//mbfit
public func MBFitScale(_ a :CGFloat) -> CGFloat
public func MBFit(_ a :CGFloat) -> CGFloat
```

#### BaseUI:

###### UIKitUtility 

```objc
+ (void)defaultNavigationBar:(UINavigationBar *)bar;

#pragma mark - Attributed String 相关

+ (nullable NSMutableAttributedString *)htmlString:(nullable NSString *)string
                                          withFont:(nullable UIFont *)font
                                             color:(nullable UIColor *)color;

/**
 创建attribute字典的便捷方法。

 @param font 字体
 @param color 字色
 @param config 段落样式配置。
 @return attribute字典。
 */
+ (NSMutableDictionary *)attributeWithFont:(UIFont *)font
                                     color:(UIColor *)color
                               styleConfig:(nullable void (^)(NSMutableParagraphStyle *style))config;
```

```objc
[MBUIKitUtility htmlString:item[@"subTitle"] withFont:self.bottomLable.font color:self.bottomLable.textColor]
```

###### ViewCategory

UIView (ConvenientConstructor)

UIButton (ConvenientConstructor)

UILabel (ConvenientConstructor)

UITableView (ConvenientConstructor)

UIView (MBExtension)

```objc
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

- (void)drawBorder;

- (UIViewController *)topViewController;
```

UIView (MBFinancialTools)

UIView (MBMasonryConstraint)

```objc
/**
 *  将若干view等高布局于容器containerView中
 *
 *  @param views         views array
 *  @param leftPadding   左边距
 *  @param rightPadding  右边距
 *  @param topPadding    上边距
 *  @param bottomPadding 下边距
 *  @param viewPadding   view之间的边距
 */
-(void)makeEqualHeightViews:(NSArray *)views
                LeftPadding:(CGFloat)leftPadding
               RightPadding:(CGFloat)rightPadding
                 TopPadding:(CGFloat)topPadding
              BottomPadding:(CGFloat)bottomPadding
               viewPadding :(CGFloat)viewPadding;
```

UIView (MBResponder)

```objc
- (id)findFirstResponder;
```

UIView+MBUtils

```objc
@interface UIView (MBUtils)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationHeight;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView *)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView *)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 Attaches the given block for a single tap action to the receiver.
 @param block The block to execute.
 */
- (void)setTapActionWithBlock:(void (^)(void))block;

/**
 Attaches the given block for a long press action to the receiver.
 @param block The block to execute.
 */
- (void)setLongPressActionWithBlock:(void (^)(void))block;

@end
```



###### borderView

```objc
@interface UIView (MBBorder)
//添加边框线
- (void)addBorderInPosition:(MBBorderPosition)position;
//添加边框线，指定粗线还是实线
- (void)addBorderInPosition:(MBBorderPosition)position style:(MBBorderStyle)style;
...
- (void)clearBorder;
@property (nonatomic, strong) UIColor *mb_borderColor; //边框颜色
@property (nonatomic, assign) CGFloat mb_borderWidth; //边框宽度
```

###### button

```objc
MBButton
MBBarButtonItem
@interface UIButton (MBExtends)

/*
 * 设置四边统一的触摸边界
 */
- (void)setTouchEdgeWithUnifyValue:(CGFloat)unifyValue;

/*
 * 设置四边的触摸边界
 */
- (void)setTouchEnlargeEdge:(UIEdgeInsets)edgeInsets;

/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 
 */
-(void)setYMMButtonImageTitleStyle:(YMMButtonImageTitleStyle)style
                           padding:(CGFloat)padding;



@end
  
@interface UIButton (MBStyle)

/**
 设置圆角值
 @param cornerRadius 圆角值
 */
- (void)setCornerRadius:(MBCornerRadius)cornerRadius;

/**
 设置按钮样式
 @param buttonStyle 按钮样式
 */
- (void)setMBButtonStyle:(MBButtonStyle)buttonStyle;

/**
 设置Border，必须先设置buttonStyle
 */
- (void)setupBorder;

@end
```

###### CellCatalog

###### CountdownButton

###### MBCustomNavItemButton

###### NSDictionary+MBTextAttributes

```objc
@interface NSDictionary (MBTextAttributes)
  /**
 *  创建TextAttributes用NSDictionary实例 AVAILABLE_IOS(6_0)
 *
 *  @param fontAttribute               字体属性
 *  @param colorAttribute              颜色属性
 *  @param backgroundColorAttribute    背景色属性
 *  @param shadowAttribute             阴影属性
 *  @param paragraphStyleAttribute     段落属性
 *  @param strikethroughStyleAttribute 删除线属性
 *  @param underlineStyleAttribute     下划线属性
 *  @param kernAttribute               字间距
 *
 *  @return TextAttributes用NSDictionary实例
 */
+ (instancetype)mb_textAttributesWithFont:(nullable UIFont *)fontAttribute
                                     color:(nullable UIColor *)colorAttribute
                           backgroundColor:(nullable UIColor *)backgroundColorAttribute
                                    shadow:(nullable NSShadow *)shadowAttribute
                            paragraphStyle:(nullable NSParagraphStyle *)paragraphStyleAttribute
                        strikethroughStyle:(nullable NSNumber *)strikethroughStyleAttribute
                            underlineStyle:(nullable NSNumber *)underlineStyleAttribute
                                      kern:(nullable NSNumber *)kernAttribute;

```

###### MBDivider

###### MBFiveStarView

###### UIView+MBGradient

###### MBGraph

###### UIImage+MBExtension

```objc
/**
 获取图片
 
 @param bundleName bundle名称
 @param imgeName 图片名称
 @return 图片对象 UIImage
 */
+ (UIImage *)imgFromBundle:(NSString*)bundleName WithNamed:(NSString*)imgeName;
// YMMCommonFiles Resource
+ (UIImage *)imgFromCommonFilesBundleNamed:(NSString*)imgeName;
#pragma mark - TintColor
- (UIImage *)imageWithCustomTintColor:(UIColor *)tintColor;
#pragma mark - 图片方向
- (UIImage *)normalOrientationImage;
#pragma mark - Resize
- (UIImage *)ft_resizedImageToSize:(CGSize)size scale:(CGFloat)scale;
#pragma mark - Image Action
/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image 需要处理的图片
 *  @param asize 新图片的大小
 *
 *  @return 返回新生成的图片
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
/**
 *  自动缩放到指定大小
 *
 *  @param image 需要处理的图片
 *  @param asize 制定尺寸
 *
 *  @return 返回新生成的图片
 */
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
//压缩图片
- (UIImage *)compressImage;
/**
 * 压缩图片
 * length 压缩大小，KB
 * @return return value description
 */
- (UIImage *)compressImageToLength:(CGFloat)length;
/**
 *  压缩图片Data
 *
 *  @return return value description
 */
- (NSData *)compressImageData;

/**
 * 压缩图片Data  小于指定大小
 * length 压缩大小，KB
 * @return return value description
 */
- (NSData *)compressImageDataToLength:(CGFloat)length;

/**
 旋转图片

 @param orient 指定旋转方向
 @return 旋转之后的图片
 */
- (UIImage *)ymm_rotateWithImageOrient:(UIImageOrientation)orient;
```

###### UIImageView+Cache (sdwebimage)

```objc
/**
 *  计算缓存的网络图片 (Asynchronously)
 *
 *  @param completionBlock 完成回调block
 */
+ (void)mb_calculateDiskCachesSizeWithCompletionBlock:(void(^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;

/**
 *  清除所有缓存的网络图片 (Asynchronously)
 *
 *  @param completionBlock 完成回调Block
 */
+ (void)mb_clearDiskCachesWithCompletionBlock:(void(^)(void))completionBlock;
```

###### MBInfiniteScrollView (masonry)

@description 无限轮播广告图专用

###### Label

```objc
@interface UILabel (MBExtension)

#pragma mark - AttributedString
- (void)setLabelAttributedText:(NSMutableDictionary *)dict;

- (void)setLabelMutilAttributed:(NSString *)allText optionArray:(NSMutableArray *)array;
- (void)setLabelAttributedBySameText:(NSMutableDictionary *)dict withExeceptString:(NSString *)exceptString;

// 设置UILabel行间距
- (void)setLabelLineSpacing:(CGFloat)lineSpace;

- (void)setLabelLineSpacingWithOption:(NSDictionary *)optionDict;

#pragma mark - size

- (CGSize)mb_size;
- (CGSize)mb_size:(CGSize)size;
- (CGSize)mb_attrSize;
- (CGSize)mb_attrSizeWithSize:(CGSize)size;
- (CGSize)mb_sizefont:(CGFloat)font;

#pragma mark - zoom

- (void)mb_zoom;
- (float)mb_textOriginX;
- (void)mb_zoomVertically;
- (void)mb_zoomHorizontally;

@end
```

###### MBTabBubbleView ：MB自定义气泡控件

依赖 MBTabBubbleViewOption

方法包含 init show dismiss

init需提前设置好option

###### MultiButtonView

###### NoticeBar

###### PlaceholderView

```objc
@interface UIViewController (MBPlaceholderExtension)

@property (nonatomic, strong) void (^MB_badNetworkCustomizationBlock)(MBPlaceholderView *badNetworkPlaceholderView);
@property (nonatomic, strong) void (^MB_noContentsCustomizationBlock)(MBPlaceholderView *noContentsPlaceholderView);
@property (nonatomic, strong) void (^MB_animatedloadingCustomizationBlock)(MBPlaceholderView *animatedLoadingView);

- (void)MB_showBadNetworkPlaceholderView;
- (void)MB_showNoContentsPlaceholderView;
- (void)MB_hidePlaceholderView;



- (void)MB_showAnimatedLoadingView;
- (void)MB_hideAnimatedLoadingView;

@end
```



###### PopupMaskView

###### ProgressHUD

###### ProgressView

###### QRCode

###### RedPoint

###### ScrollMenu

###### StepIndicator

###### Stepper

###### StringCategory

###### TextView

###### Timer

```objc
/*
 * 定时器方法
 * 参数：interval：定时器时间
 * aTarget:执行方法对象
 * aSelector:执行方法
 * userInfo:传递参数
 * repeats:是否循环
 */
+ (NSTimer *)mb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;
```

###### UIApplication+MBExtends

```objc
@interface UIApplication (MBExtends)
/**
 检查是否打开了远程推送

 @return 是否打开
 */
+ (BOOL)isAllowedGlobalRemoteNotification;

/**
 检查是否允许声音通知

 @return 是否声音通知
 */
+ (BOOL)isAllowedSoundNotification;

/**
 检测是否开启推送配置
 */
+ (void)registerNotification;

/// 通过scheme进行跳转
/// @param scheme scheme description
+ (void)goToScheme:(NSString *)scheme;
@end
```

###### UIBarButtonItem

###### UIDevice

###### UINavigationBar











` [**self**.dataArray addObject:@{@"title":@"(BaseUI)标签和分割线",@"class":@"MBDebugLabelViewController"}];`

`IViewController *vc = [[NSClassFromString(classStr) alloc] init];`







` **if** ([UIViewController instancesRespondToSelector:**@selector**(topLayoutGuide)])`



从bundle设置图片

```objc
[_checkButton setImage:[UIImage imageWithBundle:@"AgreementView" imageName:normalString]
                      forState:UIControlStateNormal];
```

