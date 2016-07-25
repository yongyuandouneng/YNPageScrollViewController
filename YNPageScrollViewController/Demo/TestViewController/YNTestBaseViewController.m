//
//  YNTestBaseViewController.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNTestBaseViewController.h"
#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshAutoFooter.h"
#import "YNPageScrollViewController.h"
#import "YNTestOneViewController.h"
#import "YNTestTwoViewController.h"
//是否带刷新
#define HasHeaderRefresh 0
//是否有loading和无数据view
#define HasLoadingAndNotDataView 1

@interface YNTestBaseViewController ()

@property (nonatomic, strong) NSMutableArray *datasArrayM;

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView ;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL isFirst;

@end


@implementation YNTestBaseViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    self.isFirst = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 20; i++) {
            [self.datasArrayM addObject:[NSString stringWithFormat:@" 原始数据 %zd",i]];
        }
        
        if (HasLoadingAndNotDataView) {
            [self.datasArrayM removeAllObjects];
            
            [self.indicatorView stopAnimating];
            self.label.hidden = NO;
        }
        
        [self.tableView reloadData];
        //调整占位图footer
        [self.ynPageScrollViewController reloadPlaceHoderViewFrame];
        
        
    });
    
    __weak typeof (YNTestBaseViewController *)weakself = self;
    


    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger count = weakself.datasArrayM.count;
            for (int i = 0; i < 2; i++) {
                [weakself.datasArrayM insertObject:[NSString stringWithFormat:@" 刷新数据 %zd",count + i] atIndex:0];
            }
            NSLog(@"上啦加载完成");
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView reloadData];
            [self.indicatorView stopAnimating];
            self.label.hidden = NO;
        });
    }];

    if (!HasHeaderRefresh) {
        self.tableView.mj_header = nil;
    }
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger count = weakself.datasArrayM.count;
            for (int i = 0; i < 20; i++) {
                [weakself.datasArrayM addObject:[NSString stringWithFormat:@" 加载数据 %zd",count + i]];
            }
            NSLog(@"下拉加载完成");
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
            
            [self.indicatorView stopAnimating];
            self.label.hidden = NO;
        });
    }];
    
}



- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    
    if (!HasLoadingAndNotDataView) return;
    
    //必须要在此上添加 站位图  最好用懒加载
    //添加菊花/无数据      在获取数据前后进行判断显示与隐藏
    if (self.isFirst) {self.isFirst = NO;return;}
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicatorView.center = self.ynPageScrollViewController.placeHoderView.center;
    indicatorView.backgroundColor = [UIColor purpleColor];
    indicatorView.hidden = NO;
    indicatorView.hidesWhenStopped = YES;
    [indicatorView startAnimating];
    [self.tableView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    label.text = @"暂时还没有数据呢·";
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.center = self.ynPageScrollViewController.placeHoderView.center;
    self.label = label;
    [self.tableView addSubview:label];
    
    
}

#pragma mark - UITableViewDelegate  UITableViewDataSource

//header-height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 10;
    
}
//header-secion
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

//footer-hegiht
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

//footer-section
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}


//sections-tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
//rows-section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datasArrayM.count;
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
    cell.textLabel.text = [NSString stringWithFormat:@"section : %zd row : %zd  %@",indexPath.section,indexPath.row,self.datasArrayM[indexPath.row]];
    return cell;
    
}
//select-tableview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    YNTestOneViewController *vc = [[YNTestOneViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - lazy

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;

};


- (NSMutableArray *)datasArrayM{
    
    if (!_datasArrayM) {
        _datasArrayM = @[].mutableCopy;
    }
    return _datasArrayM;


};


@end
