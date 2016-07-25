//
//  YNPageScrollView.h
//  039_PageScrollView
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNPageScrollViewMenu.h"
#import "UIViewController+YNCategory.h"

@class YNPageScrollViewController,YNPageScrollViewController;

typedef void(^AddButtonAtion) (UIButton *button ,YNPageScrollViewController *pageScrollViewController);

//数据源
@protocol YNPageScrollViewControllerDataSource <NSObject>
@optional
//设置UIScrollView
- (UIScrollView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewForIndex:(NSInteger )index;

- (BOOL)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController headerViewIsRefreshingForIndex:(NSInteger)index;

- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewHeaderAndFooterEndRefreshForIndex:(NSInteger)index;


@end
//代理
@protocol YNPageScrollViewControllerDelegate <NSObject>
@optional
/** 监听进度*/
- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController tableViewScrollViewContentOffset:(CGFloat)contentOffset progress:(CGFloat)progress;

@end

@interface YNPageScrollViewController : UIViewController
/** 控制器*/
@property (nonatomic, strong) NSArray *viewControllers;
/** 菜单Menu标题*/
@property (nonatomic, strong) NSArray *titleArrayM;
/** 当前控制器*/
@property (nonatomic, strong) UIViewController *currentViewController;
/** 当前index*/
@property (nonatomic, assign) NSInteger pageIndex;
/** 悬浮样式 作为UITableHeaderView*/
@property (nonatomic, strong) UIView *headerView;
/** 悬浮样式 作为UITableFooterView*/
@property (nonatomic, strong) UIView *placeHoderView;
/** 菜单Menu*/
@property (nonatomic, strong) YNPageScrollViewMenu *scrollViewMenu;
/** 父容器UIScrollView*/
@property (nonatomic, strong) UIScrollView *parentScrollView;
/** 配置信息*/
@property (nonatomic, strong) YNPageScrollViewMenuConfigration *configration;
/** 添加按钮*/
@property (nonatomic, copy) AddButtonAtion addButtonAtion;
/** 数据源*/
@property (nonatomic, weak) id<YNPageScrollViewControllerDataSource> dataSource;
/** 数据代理*/
@property (nonatomic, weak) id<YNPageScrollViewControllerDelegate> delegate;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/** 初始化*/
+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(YNPageScrollViewMenuConfigration *)configration;

/** 选中第几页*/
- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index animated:(BOOL)animated;

/** 添加控制器子控制器 暂未实现*/
- (void)addAddButtonViewController:(UIViewController *)viewController;

/** 移除控制器子控制器 暂未实现 */
- (void)removeAddButtonViewController:(UIViewController *)viewController;

/** 添加title 暂未实现*/
- (void)addPageScrollViewControllerWithTitle:(NSString *)title;

/** 当前PageScrollViewVC作为子控制器*/
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler isAfterLoadData:(BOOL)isAfterLoadData;

/** 移除PageScrollViewVC*/
- (void)removeSelfViewController;


- (void)reloadPlaceHoderViewFrame;


@end
