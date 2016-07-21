//
//  YNTestBaseViewController.h
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger viewcontroller_type;

@interface YNTestBaseViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end
