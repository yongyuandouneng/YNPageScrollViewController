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
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    configration.scrollMenu = NO;
    configration.showNavigation = YES;
    configration.showGradientColor = NO;//取消渐变
    configration.showTabbar = YES;//设置显示tabbar
    
    
    YNJianShuDemoViewController *vc = [YNJianShuDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:@"QYPPMyContributeListHead"];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)]];
    
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

//半塘Demo
- (UIViewController *)getBanTangViewController{
    
    YNTestOneViewController *one = [[YNTestOneViewController alloc]init];
    
    YNTestTwoViewController *two = [[YNTestTwoViewController alloc]init];
    
    YNTestThreeViewController *three = [[YNTestThreeViewController alloc]init];
    
    YNTestFourViewController *four = [[YNTestFourViewController alloc]init];
    
    
    //配置信息
    YNPageScrollViewMenuConfigration *configration = [[YNPageScrollViewMenuConfigration alloc]init];
    configration.scrollViewBackgroundColor = [UIColor redColor];
    configration.itemLeftAndRightMargin = 30;
    configration.lineColor = [UIColor blackColor];
    configration.lineHeight = 4;
    configration.showConver = YES;
    configration.itemMaxScale = 1.2;
    configration.pageScrollViewMenuStyle = YNPageScrollViewMenuStyleSuspension;
    configration.showNavigation = NO;//设置没有导航条
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"];
    
    
    //头部headerView
    SDCycleScrollView *headerView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200) imageURLStringsGroup:imagesURLStrings];
    headerView2.delegate = self;
    YNBanTangDemoViewController *vc = [YNBanTangDemoViewController pageScrollViewControllerWithControllers:@[one,two,three,four] titles:@[@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
    vc.dataSource = self;
    
    vc.headerView = headerView2;
    
    return vc;
}




@end
