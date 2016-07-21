//
//  YNPageScrollView.h
//  039_PageScrollView
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNPageScrollViewMenu.h"

#define YNNotificationUpdateTableViewRefresh @"YNNotificationUpdateTableViewRefresh"

@class YNPageScrollViewController,YNPageScrollViewController;

typedef void(^AddButtonAtion) (UIButton *button ,YNPageScrollViewController *pageScrollViewController);

//数据源
@protocol YNPageScrollViewControllerDataSource <NSObject>
@optional

- (UITableView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController tableViewForIndex:(NSInteger )index;

@end
//代理
@protocol YNPageScrollViewControllerDelegate <NSObject>
@optional
- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController tableViewScrollViewContentOffset:(CGFloat)contentOffset progress:(CGFloat)progress;

@end

@interface YNPageScrollViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) NSArray *titleArrayM;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) YNPageScrollViewMenu *scrollViewMenu;

/** 父容器UIScrollView*/
@property (nonatomic, strong) UIScrollView *parentScrollView;

@property (nonatomic, strong) YNPageScrollViewMenuConfigration *configration;

@property (nonatomic, copy) AddButtonAtion addButtonAtion;

@property (nonatomic, weak) id<YNPageScrollViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<YNPageScrollViewControllerDelegate> delegate;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(YNPageScrollViewMenuConfigration *)configration;

- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index animated:(BOOL)animated;

- (void)addAddButtonViewController:(UIViewController *)viewController;

- (void)removeAddButtonViewController:(UIViewController *)viewController;

//- (void)addPageScrollViewControllerWithTitle:(NSString *)title




@end
