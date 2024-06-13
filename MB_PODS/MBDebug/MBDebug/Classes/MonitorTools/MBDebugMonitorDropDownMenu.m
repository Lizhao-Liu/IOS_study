//
//  MBDebugMonitorDropDownMenu.m
//  MBDebug
//
//  Created by Lizhao on 2023/8/23.
//

#import "MBDebugMonitorDropDownMenu.h"

@interface MBDebugMonitorDropDownMenu()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *menuTableView;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, assign) CGRect buttonFrame;
@property (nonatomic, strong) NSString *animationDirection;//动画方向
@end


@implementation MBDebugMonitorDropDownMenu


- (instancetype)init{
    self = [super init];
    if(self){
        _isPresented = NO;
    }
    return self;
}

- (void)showDropDownMenu:(UIButton *)button withButtonFrame:(CGRect)buttonFrame arrayOfTitle:(NSArray *)titleArr animationDirection:(NSString *)direction{
    
    self.backgroundColor = [UIColor clearColor];
    self.animationDirection = direction;
    self.btnSender = button;
    self.menuTableView = [[UITableView alloc] init];
    self.buttonFrame = buttonFrame;
    if (self) {
        CGRect btnRect = buttonFrame;//按钮在视图上的位置
        CGFloat height = 0;//菜单高度
        if ( titleArr.count <= 4) {
            height = titleArr.count * 30;
        }else{
            height = 150;
        }
        
        self.titleList = [NSArray arrayWithArray:titleArr];
        
        //菜单视图的起始大小和位置
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btnRect.origin.x+btnRect.size.width/2-50, btnRect.origin.y-2, 100, 0);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btnRect.origin.x+btnRect.size.width/2-50, btnRect.origin.y+btnRect.size.height+2, 100, 0);
        }
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.layer.cornerRadius = 5;
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.menuTableView.separatorColor = [UIColor grayColor];
        self.menuTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.menuTableView.backgroundColor = [UIColor clearColor];
        self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0.001)];//最后无分割线
        [self.menuTableView flashScrollIndicators];//显示滚动条
        self.menuTableView.scrollEnabled = YES;
        
        [UIView beginAnimations:nil context:nil];//动画
        [UIView setAnimationDuration:0.5];
        //菜单视图的最终大小和位置
        if ([direction isEqualToString:@"up"]) {
            CGFloat originX = (btnRect.origin.x+btnRect.size.width/2-50)>0 ? (btnRect.origin.x+btnRect.size.width/2-50) : 0;
            self.frame = CGRectMake(originX, btnRect.origin.y-height-2, 100, height);
        } else if([direction isEqualToString:@"down"]) {
            CGFloat originX = (btnRect.origin.x+btnRect.size.width/2-50)>0 ?: 0;
            self.frame = CGRectMake(originX, btnRect.origin.y+btnRect.size.height+2, 100, height);
        }
        self.menuTableView.frame = CGRectMake(0, 0, 100, height);
        [UIView commitAnimations];
        [self addSubview:self.menuTableView];
        self.isPresented = YES;
    }
}

-(void)hideDropDownMenuWithBtnFrame:(CGRect)btnFrame {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if ([self.animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btnFrame.origin.x+btnFrame.size.width/2-50, btnFrame.origin.y-2, 100, 0);
    }else if ([self.animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btnFrame.origin.x+btnFrame.size.width/2-50, btnFrame.origin.y+btnFrame.size.height+2, 100, 0);
    }
    self.menuTableView.frame = CGRectMake(0, 0, 100, 0);
    [UIView commitAnimations];
    self.isPresented = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FilterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.frame = CGRectMake(0, 0, self.menuTableView.frame.size.width, 30);
        cell.textLabel.frame = CGRectMake(0, 0, self.menuTableView.frame.size.width, 30);
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.text =[self.titleList objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textColor = [UIColor whiteColor];
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor blackColor];
    cell.selectedBackgroundView = v;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDownMenuWithBtnFrame:self.buttonFrame];
    [self.delegate didSelectIndex:indexPath.row fromMenu:self];
    
}

@end

