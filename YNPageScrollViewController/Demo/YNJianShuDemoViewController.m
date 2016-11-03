//
//  YNJianShuDemoViewController.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNJianShuDemoViewController.h"

@interface YNJianShuDemoViewController ()
/// 自定义线条
@property (nonatomic, strong)  UIView *lineView;

@end

@implementation YNJianShuDemoViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"简书Demo";
    
    
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    [self.scrollViewMenu addSubview:self.lineView];
    
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.scrollViewMenu.frame.size.height - 3, self.scrollViewMenu.frame.size.width - 20, 3)];
        _lineView = lineView;
        _lineView.backgroundColor = [UIColor blueColor];
    }
    return _lineView;
    
}


@end
