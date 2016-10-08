//
//  UIHomeViewControler.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/21.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "UIHomeViewControler.h"
#import "SDCycleScrollView.h"
#import "YNTestOneViewController.h"
#import "YNTestTwoViewController.h"
#import "YNTestThreeViewController.h"
#import "YNTestFourViewController.h"
#import "YNBanTangDemoViewController.h"
#import "YNJianShuDemoViewController.h"
#import "MJRefresh.h"
#import "ViewController.h"

@interface  UIHomeViewControler ()<YNPageScrollViewControllerDataSource>


@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation UIHomeViewControler

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //        [self.navigationController.navigationBar setTranslucent:NO];
    
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self.loadingView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingView stopAnimating];
        
        YNJianShuDemoViewController *viewController = [self getJianShuDemoViewController];
        [viewController addSelfToParentViewController:self isAfterLoadData:YES];
        
        
        
        
    });
    
    
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    NSLog(@"%@",[NSValue valueWithCGRect:self.view.frame]);
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    NSLog(@"%@",[NSValue valueWithCGRect:self.view.frame]);
}

//简书Demo
- (YNJianShuDemoViewController *)getJianShuDemoViewController{
    
    //配置信息
    YNPageScrollViewMenuConfigration *configration = [[YNPageScrollViewMenuConfigration alloc]init];
    configration.scrollViewBackgroundColor = [UIColor redColor];
    configration.itemLeftAndRightMargin = 30;
    configration.lineColor = [UIColor orangeColor];
    configration.lineHeight = 2;
    configration.itemMaxScale = 1.2;
    configration.pageScrollViewMenuStyle = YNPageScrollViewMenuStyleSuspension;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.selectedItemColor = [UIColor redColor];
    //设置平分不滚动   默认会居中
    configration.aligmentModeCenter = NO;
    configration.scrollMenu = YES;
    configration.showGradientColor = NO;//取消渐变
    configration.showNavigation = YES;
    configration.showTabbar = NO;//设置显示tabbar
    
    //创建控制器
    YNJianShuDemoViewController *vc = [YNJianShuDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
    //头部视图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:@"QYPPMyContributeListHead"];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)]];
    
    //footer用来当做内容高度
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    vc.placeHoderView = footerView;
    
    vc.dataSource = self;
    vc.headerView = imageView;
    
    return vc;
}

- (void)dealloc{
    
    NSLog(@"释放 父类 UIHomeViewController");
}

- (void)imageViewTap{
    
    NSLog(@"----- imageViewTap -----");
    
}

#pragma mark - YNPageScrollViewControllerDataSource
- (UITableView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= pageScrollViewController.viewControllers[index];
    return [VC tableView];
    
};

- (BOOL)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController headerViewIsRefreshingForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= pageScrollViewController.viewControllers[index];
    return [[[VC tableView] mj_header] isRefreshing];
}

- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewHeaderAndFooterEndRefreshForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= pageScrollViewController.viewControllers[index];
    [[[VC tableView] mj_header] endRefreshing];
    [[[VC tableView] mj_footer] endRefreshing];
}


- (NSArray *)getViewController{
    
    YNTestOneViewController *one = [[YNTestOneViewController alloc]init];
    
    YNTestTwoViewController *two = [[YNTestTwoViewController alloc]init];
    
    YNTestThreeViewController *three = [[YNTestThreeViewController alloc]init];
    
    YNTestFourViewController *four = [[YNTestFourViewController alloc]init];
    
    YNTestOneViewController *one1 = [[YNTestOneViewController alloc]init];
    
    YNTestTwoViewController *two1 = [[YNTestTwoViewController alloc]init];
    
    YNTestThreeViewController *three1 = [[YNTestThreeViewController alloc]init];
    
    YNTestFourViewController *four1 = [[YNTestFourViewController alloc]init];
    return @[one,two,three,four,one1,two1,three1,four1];
}


#pragma mark - lazy

- (UIActivityIndicatorView *)loadingView{
    
    if (!_loadingView) {
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        _loadingView.center = self.view.center;
        [self.view addSubview:_loadingView];
    }
    
    return _loadingView;
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)createTabbarItems
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49 + 5)];
    [imageView setImage:[self createImageWithColor:[UIColor clearColor]]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.tabBarController.tabBar insertSubview:imageView atIndex:0];
    //覆盖原生Tabbar的上横线
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    // 背景图片为透明色
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor clearColor]]];
    self.tabBarController.tabBar.translucent = YES;
}


@end
