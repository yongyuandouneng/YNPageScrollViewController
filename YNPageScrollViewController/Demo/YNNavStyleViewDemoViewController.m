//
//  YNNavigationTitleViewDemo.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNNavStyleViewDemoViewController.h"

@implementation YNNavStyleViewDemoViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    v.backgroundColor = [UIColor blueColor];
    UIView * v2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    v2.backgroundColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:v]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
}


@end
