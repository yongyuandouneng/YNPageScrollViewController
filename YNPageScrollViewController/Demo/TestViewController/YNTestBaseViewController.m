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

#import "UIScrollView+EmptyDataSet.h"


NSInteger viewcontroller_type = 1;

@interface YNTestBaseViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *datasArrayM;

@end


@implementation YNTestBaseViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    if ([self isKindOfClass:[YNTestTwoViewController class]]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i = 0; i < 12; i++) {
                
                [self.datasArrayM addObject:[NSString stringWithFormat:@" 原始数据 %zd",i]];
            }
            [self.tableView reloadData];
            //重置placeHoderView frame
            [self.ynPageScrollViewController reloadPlaceHoderViewFrame]; 
        });
    }else{
        
        for (int i = 0; i < 20; i++) {
            [self.datasArrayM addObject:[NSString stringWithFormat:@" 原始数据 %zd",i]];
        }
        [self.tableView reloadData];
        //重置placeHoderView frame
        [self.ynPageScrollViewController reloadPlaceHoderViewFrame];
        
    }

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
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger count = weakself.datasArrayM.count;
            for (int i = 0; i < 20; i++) {
                [weakself.datasArrayM addObject:[NSString stringWithFormat:@" 加载数据 %zd",count + i]];
            }
            NSLog(@"下拉加载完成");
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        });
    }];
    
}


- (void)endRefreshing{
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
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
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@ 销毁",NSStringFromClass([self class])]);

}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{

    return YES;
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
    
    NSLog(@"emptyDataSetDidAppear");

}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    
    return YES;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    
    return YES;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    
    UIView *view2 =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1000)];
    view2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view2;

}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 1000;
}

@end
