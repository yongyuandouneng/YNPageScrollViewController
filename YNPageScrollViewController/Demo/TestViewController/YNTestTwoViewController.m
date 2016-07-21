//
//  YNTestTwoViewController.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNTestTwoViewController.h"

@implementation YNTestTwoViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor blackColor];
    
    
    NSLog(@"two - viewDidLoad");
    
}



#pragma mark - life cycle
#pragma mark - life cycle


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    NSLog(@"two - viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    NSLog(@"two - viewDidDisappear");
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"two - viewWillAppear");
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    NSLog(@"two - viewDidAppear ");
}



@end
