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
#import "YNPageScrollViewMenuConfigration.h"
#import "YNBanTangDemoViewController.h"
#import "YNJianShuDemoViewController.h"

@interface  UIHomeViewControler ()<YNPageScrollViewControllerDataSource>


@end

@implementation UIHomeViewControler

- (void)viewDidLoad{
    
    [super viewDidLoad];
    UIViewController *viewController = [self getJianShuDemoViewController];
    [self addChildViewController:viewController];
    [self didMoveToParentViewController:viewController];
    [self.view addSubview:viewController.view];
    
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
    configration.aligmentModeCenter = NO;
    configration.scrollMenu = NO;
    
    configration.showGradientColor = NO;//取消渐变
    
    YNJianShuDemoViewController *vc = [YNJianShuDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:@"QYPPMyContributeListHead"];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)]];
    vc.dataSource = self;
    vc.headerView = imageView;
    
    return vc;
}


- (void)imageViewTap{
    
    NSLog(@"----- imageViewTap -----");
    
}

#pragma mark - YNPageScrollViewControllerDataSource //悬浮专用
- (UITableView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController tableViewForIndex:(NSInteger)index{
    
    YNTestBaseViewController *VC= pageScrollViewController.viewControllers[index];
    return [VC tableView];
    
};


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
