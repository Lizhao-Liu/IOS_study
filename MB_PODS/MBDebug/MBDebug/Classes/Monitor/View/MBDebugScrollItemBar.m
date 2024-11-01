//
//  MBDebugScrollItemBar.m
//  MBDebug
//
//

#import "MBDebugScrollItemBar.h"
@import MBUIKit;

#define ITEM_COUNT  4 //default count of items in a screen
#define BUTTON_START_TAG    100
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface MBDebugScrollItemBar ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) UIScrollView *relevantScrollView;

@end

@implementation MBDebugScrollItemBar{
    
    UIScrollView *_scrollView;
    UIView *_sliderView;
    UIView *_bottomLine;
    CGFloat _itemWidth;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        _currentIndex = 0;
    }
    return self;
}

- (void)setupItemTitles:(NSArray *)itemTitles relevantScrollView:(UIScrollView *)relevantScrollView{
    
    self.itemTitles = itemTitles;
    self.relevantScrollView = relevantScrollView;
}

- (void)initialize{
    
    self.backgroundColor = [UIColor blackColor];
    
    _itemCountPerScreen = ITEM_COUNT;
    _itemWidth = CGRectGetWidth(self.frame) / _itemCountPerScreen;
    _textNormalColor = [UIColor whiteColor];
    _textSelectedColor = [UIColor redColor];
    _textFont = [UIFont systemFontOfSize:15.0f];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_scrollView) {        
        [_scrollView removeFromSuperview];
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    [self layoutItems];
}

- (void)changeButtonState:(UIButton *)itemBtn{
    
    for (UIView *btn in _scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)btn;
            button.selected = NO;
        }
    }
    itemBtn.selected = YES;
}

- (void)layoutItems{
    
    if (_itemTitles.count < _itemCountPerScreen) {
        self.itemCountPerScreen = _itemTitles.count;
    }
    
    for (UIView *view in _scrollView.subviews) {
        
        [view removeFromSuperview];
    }
    
    NSMutableArray *btnArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _itemTitles.count; i ++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(i * _itemWidth, 0, _itemWidth, CGRectGetHeight(_scrollView.frame) - 2);
        itemBtn.tag = BUTTON_START_TAG + i;
        itemBtn.backgroundColor = [UIColor clearColor];
        [itemBtn setTitle:_itemTitles[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:_textNormalColor forState:UIControlStateNormal];
        [itemBtn setTitleColor:_textSelectedColor forState:UIControlStateSelected];
        itemBtn.titleLabel.font = _textFont;
        [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:itemBtn];
        [btnArr addObject:itemBtn];
        if (i == 0) {
            itemBtn.selected = YES;
        }
    }
    self.titleButtons = btnArr;
    
    _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 2, _itemWidth, 2)];
    _sliderView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:186.0 / 255.0 blue:26.0 / 255.0 alpha:0.6];
    [_scrollView addSubview:_sliderView];
    
    CGFloat lineH = 0.5;
//    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) - lineH, CGRectGetWidth(_scrollView.frame), lineH)];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.frame) - lineH, _itemWidth*self.itemTitles.count, lineH)];
    _bottomLine.backgroundColor = [UIColor colorWithRed:229.0 / 255.0 green:229.0 / 255.0 blue:229.0 / 255.0 alpha:1];;
    [_scrollView addSubview:_bottomLine];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) / _itemCountPerScreen * _itemTitles.count, CGRectGetHeight(_scrollView.frame));
    
    if (_itemTitles.count > _currentIndex) {
        
        UIButton *itemBtn = [_scrollView viewWithTag:_currentIndex + BUTTON_START_TAG];
        [self itemBtnClick:itemBtn];
    }
}


#pragma mark - set methods

- (void)setScrollEnable:(BOOL)scrollEnable {
    
    _scrollEnable = scrollEnable;
    
    _scrollView.scrollEnabled = _scrollEnable;
    _relevantScrollView.scrollEnabled = _scrollEnable;
    _sliderView.backgroundColor = _scrollEnable ? _sliderColor : _textNormalColor;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            ((UIButton *)subView).enabled = self.scrollEnable;
        }
    }];
}

- (void)setItemTitles:(NSArray *)itemTitles{
    
    if (_itemTitles == itemTitles) {
        return;
    }
    _itemTitles = itemTitles;
}

- (void)setRelevantScrollView:(UIScrollView *)relevantScrollView{
    
    if (_relevantScrollView == relevantScrollView) {
        return;
    }
    _relevantScrollView = relevantScrollView;
    _relevantScrollView.delegate = self;
}

- (void)setItemCountPerScreen:(NSInteger)itemCountPerScreen{
    
    if (_itemCountPerScreen == itemCountPerScreen) {
        return;
    }
    _itemCountPerScreen = itemCountPerScreen;
    _itemWidth = CGRectGetWidth(self.frame) / _itemCountPerScreen;
}

- (void)setTextFont:(UIFont *)textFont{
    
    _textFont = textFont;
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.titleLabel.font = _textFont;
        }
    }
}

- (void)setTextNormalColor:(UIColor *)textNormalColor{
    
    if (_textNormalColor == textNormalColor) {
        return;
    }
    _textNormalColor = textNormalColor;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_textNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor{
    
    if (_textSelectedColor == textSelectedColor) {
        return;
    }
    _textSelectedColor = textSelectedColor;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_textSelectedColor forState:UIControlStateSelected];
        }
    }
}

- (void)setSliderColor:(UIColor *)sliderColor{
    
    if (_sliderColor == sliderColor) {
        return;
    }
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = sliderColor;
}

#pragma mark - button event
- (void)itemBtnClick:(UIButton *)itemBtn{
    [self changeButtonState:itemBtn];
    _currentIndex = itemBtn.tag - BUTTON_START_TAG;
    [self hideRedDotAtIndex:_currentIndex];
    [_relevantScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (itemBtn.tag - BUTTON_START_TAG), 0) animated:YES];
}

- (void)showRedDotAtIndex:(NSInteger)index {
    [self.titleButtons[index] ft_showRedDotAtCenterOffset:CGPointMake(30, -10) withImage:nil];
}

-(void)hideRedDotAtIndex:(NSInteger)index{
    [self.titleButtons[index] ft_hideRedDotView];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.x < 0 || offset.x > CGRectGetWidth(_relevantScrollView.frame) * (_itemTitles.count - 1)) {
        return;
    }
    CGFloat xOffset = offset.x / CGRectGetWidth(_relevantScrollView.frame) * _itemWidth;
    
    CGRect tempFrame = _sliderView.frame;
    tempFrame.origin.x = xOffset;
    _sliderView.frame = tempFrame;
    
    if (CGRectGetMinX(_sliderView.frame) < _scrollView.contentOffset.x) {
        
        [_scrollView scrollRectToVisible:CGRectMake(xOffset, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
    }else if (CGRectGetMaxX(_sliderView.frame) - SCREEN_WIDTH > _scrollView.contentOffset.x){
        
        [_scrollView scrollRectToVisible:CGRectMake(CGRectGetMaxX(_sliderView.frame) - SCREEN_WIDTH, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
    }
    
    if (_relevantScrollView.dragging) {
        
        NSInteger selectIndex = round(offset.x / SCREEN_WIDTH);
        UIButton *btn = [_scrollView viewWithTag:selectIndex + BUTTON_START_TAG];
        [self changeButtonState:btn];
    }
}

@end

