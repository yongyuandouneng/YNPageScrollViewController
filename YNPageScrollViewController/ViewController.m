//
//  ViewController.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "ViewController.h"
#import "YNBanTangDemoViewController.h"
#import "YNTestBaseViewController.h"
#import "YNTestOneViewController.h"
#import "YNTestFourViewController.h"
#import "YNTestTwoViewController.h"
#import "YNTestThreeViewController.h"
#import "SDCycleScrollView.h"
#import "YNJianShuDemoViewController.h"
#import "YNNavStyleViewDemoViewController.h"
#import "YNTopStyleViewController.h"
#import "MJRefresh.h"
#import "UIHomeViewControler.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,YNPageScrollViewControllerDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"YNBanTangDemoViewController",@"YNJianShuDemoViewController"
                   ,@"YNNavStyleViewDemo",@"YNTopStyleViewController",@"UIHomeViewControler"];
    
    self.title = @"Push控制器";
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

//sections-tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
//rows-section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}
//cell-height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

//cell-tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
    
}
//select-tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    if (indexPath.row == 0) {     //半塘Demo
        
        vc = [self getBanTangViewController];
        vc.hidesBottomBarWhenPushed = YES;
        
    }else if (indexPath.row == 1){//简书Demo
        
        vc = [self getJianShuDemoViewController];
        vc.hidesBottomBarWhenPushed = YES;
        
    }else if (indexPath.row == 2){//导航条样式Demo
        
        vc = [self getNavStyleViewDemoViewController];
        vc.hidesBottomBarWhenPushed = YES;
        
    }else if (indexPath.row == 3){//顶部样式Demo
        
        vc = [self YNTopStyleViewController];
        vc.hidesBottomBarWhenPushed = YES;
        
    }else{
        vc = [[UIHomeViewControler alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    vc.placeHoderView = footerView;
    vc.headerView = headerView2;
    
    return vc;
}



//简书Demo
- (UIViewController *)getJianShuDemoViewController{
    
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
    configration.aligmentModeCenter = YES;
    configration.scrollMenu = YES;
    
    configration.showGradientColor = NO;//取消渐变
    
    YNJianShuDemoViewController *vc = [YNJianShuDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:@"QYPPMyContributeListHead"];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)]];
    
    //里面有默认高度 等ScrollView的高度 //里面设置了背景颜色与tableview相同
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    
    vc.pageIndex = 3;
    
    vc.placeHoderView = footerView;
    
    vc.headerView = imageView;
    
    vc.dataSource = self;
    
    
    return vc;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"轮播图 点击 Index : %zd",index);
}

- (void)imageViewTap{
    
    NSLog(@"----- imageViewTap -----");
    
}

//导航条样式Demo
- (UIViewController *)getNavStyleViewDemoViewController{
    
    
    //配置信息s
    YNPageScrollViewMenuConfigration *configration = [[YNPageScrollViewMenuConfigration alloc]init];
    configration.scrollViewBackgroundColor = [UIColor redColor];
    configration.itemLeftAndRightMargin = 30;
    configration.lineColor = [UIColor orangeColor];
    configration.lineHeight = 2;
    configration.pageScrollViewMenuStyle = YNPageScrollViewMenuStyleNavigation;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.selectedItemColor = [UIColor redColor];
    configration.showConver = YES;
    
    YNNavStyleViewDemoViewController *vc = [YNNavStyleViewDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"新闻",@"搞笑视频",@"热门视频",@"有趣小事"] Configration:configration];
    
    vc.dataSource = self;
    return vc;
}

//顶部样式Demo
- (UIViewController *)YNTopStyleViewController{
    
    //配置信息
    YNPageScrollViewMenuConfigration *configration = [[YNPageScrollViewMenuConfigration alloc]init];
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.itemLeftAndRightMargin = 30;
    configration.lineColor = [UIColor greenColor];
    configration.lineHeight = 2;
    configration.pageScrollViewMenuStyle = YNPageScrollViewMenuStyleTop;//顶部
    configration.selectedItemColor = [UIColor blackColor];
    configration.showConver = YES;
    configration.converColor = [UIColor blueColor];
    
    YNTopStyleViewController *vc = [YNTopStyleViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"新闻",@"搞笑视频",@"热门视频",@"有趣小事"] Configration:configration];
    vc.dataSource = self;
    
    return vc;

}

#pragma mark - YNPageScrollViewControllerDataSource
- (UITableView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= (YNTestBaseViewController *)pageScrollViewController.currentViewController;
    return [VC tableView];
    
};

- (BOOL)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController headerViewIsRefreshingForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= (YNTestBaseViewController *)pageScrollViewController.currentViewController;
    return [[[VC tableView] mj_header ] isRefreshing];
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


@end
