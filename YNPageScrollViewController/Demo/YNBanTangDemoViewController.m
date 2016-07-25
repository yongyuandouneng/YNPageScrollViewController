//
//  YNBanTangDemoViewController.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNBanTangDemoViewController.h"

@interface YNBanTangDemoViewController ()<YNPageScrollViewControllerDelegate>

@property (nonatomic, strong) UIView *navView;

@end

@implementation YNBanTangDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 44, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)btnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - YNPageScrollViewControllerDelegate

- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController tableViewScrollViewContentOffset:(CGFloat)contentOffset progress:(CGFloat)progress{
    
    self.navView.alpha = progress;
    
}
- (UIView *)navView{
    
    if (!_navView) {
        _navView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _navView.backgroundColor = [UIColor purpleColor];
        _navView.alpha = 0;
    }
    
    return _navView;
}

@end
