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
@property (nonatomic, strong) NSMutableArray *viewControllers;
/** 菜单Menu标题*/
@property (nonatomic, strong) NSMutableArray *titleArrayM;
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

/**
 *  初始化控制器
 *
 *  @param viewControllers 控制器数组
 *  @param titleArrayM     菜单title数组
 *  @param configration    配置信息
 *
 */
+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(YNPageScrollViewMenuConfigration *)configration;

/**
 *  选中第几页
 *
 *  @param index    第几页 从0开始
 *  @param animated 是否动画
 */
- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  为YNPageScrollViewControoler添加一个title 控制器
 *
 *  @param title          菜单title
 *  @param viewController 目标控制器
 */
- (void)addPageScrollViewControllerWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

/**
 *  为YNPageScrollViewControoler移除一个title 控制器
 *
 *  @param title          菜单title
 */
- (void)removePageScrollControllerWithTtitle:(NSString *)title;

- (void)removePageScrollControllerWithIndex:(NSInteger)index;


/**
 *  当前PageScrollViewVC作为子控制器
 *
 *  @param parentViewControler 父类控制器
 *  @param isAfterLoadData     是否是在加载数据之后
 */
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler isAfterLoadData:(BOOL)isAfterLoadData;

/**
 *  从父类控制器里面移除自己（PageScrollViewVC）
 */
- (void)removeSelfViewController;

/**
 *  悬浮式：刷新TableFooter的补位Frame
 */
- (void)reloadPlaceHoderViewFrame;

/**
 *  悬浮式：刷新TableViewHeader的高度
 */
- (void)reloadHeaderViewFrame;

@end
