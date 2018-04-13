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
#import "YNPageScrollView.h"
#import "UIView+YNCategory.h"

typedef NS_ENUM(NSInteger , YNHeaderViewScaleMode){
    YNHeaderViewScaleModeTop = 0,
    YNHeaderViewScaleModeCenter = 1
};

@class YNPageScrollViewController,YNPageScrollViewController;

typedef void(^AddButtonAtion) (UIButton *button ,YNPageScrollViewController *pageScrollViewController);
/// 数据源
@protocol YNPageScrollViewControllerDataSource <NSObject>

/// 设置UIScrollView
- (UIScrollView *)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewForIndex:(NSInteger )index;

- (BOOL)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController headerViewIsRefreshingForIndex:(NSInteger)index;

- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController scrollViewHeaderAndFooterEndRefreshForIndex:(NSInteger)index;

@end

/// 代理
@protocol YNPageScrollViewControllerDelegate <NSObject>
@optional
/** 监听进度*/
- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController 
tableViewScrollViewContentOffset:(CGFloat)contentOffset
                        progress:(CGFloat)progress;

//==================================头部伸缩代理======================================
@optional
/** 伸缩开始结束监听*/
- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController
      scrollViewHeaderScaleState:(BOOL)isStart;
@optional
/** 伸缩位置contentOffset*/
- (void)pageScrollViewController:(YNPageScrollViewController *)pageScrollViewController
scrollViewHeaderScaleContentOffset:(CGFloat)contentOffset;

/// 自定义 menu
- (void)pageScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)pageScrollViewDidScroll:(UIScrollView *)scrollView;

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

/** 头部是否能伸缩效果   要伸缩效果就不能有下拉刷新控件 NO*/
@property (nonatomic, assign) BOOL HeaderViewCouldScale;
/** 头部伸缩背景View*/
@property (nonatomic, strong) UIView *scaleBackgroundView;
/** 默认顶部*/
@property (nonatomic, assign) YNHeaderViewScaleMode headerViewScaleMode;
/** 菜单Menu*/
@property (nonatomic, strong) YNPageScrollViewMenu *scrollViewMenu;
/** 父容器UIScrollView*/
@property (nonatomic, strong) YNPageScrollView *parentScrollView;
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
+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers
                                                 titles:(NSArray *)titleArrayM
                                           Configration:(YNPageScrollViewMenuConfigration *)configration;

/**
 *  选中第几页
 *
 *  @param index    第几页 从0开始
 *  @param animated 是否动画
 */
- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index
                                    animated:(BOOL)animated;

/**
 *  为YNPageScrollViewControoler添加title 控制器
 *
 *  @param titles          菜单title
 *  @param viewControllers 目标控制器
 *  @param index           插入到的index
 */
- (void)addPageScrollViewControllerWithTitle:(NSArray *)titles
                              viewController:(NSArray *)viewControllers
                                  inserIndex:(NSInteger)index;

/**
 *  为YNPageScrollViewControoler移除一个title 控制器
 *
 *  @param title          菜单title
 */
- (void)removePageScrollControllerWithTtitle:(NSString *)title;

- (void)removePageScrollControllerWithIndex:(NSInteger)index;


/**
 *  整个标题替换,相应的控制器也会作出调整。可用作排序功能。
 *
 *  @param titleArray 标题数组
 */
- (void)replaceTitleArray:(NSMutableArray *)titleArray;

/**
 *  重新加载YNPageScrollViewController，缓存控制器仍然在。
 *  @param index  定位到第几index，默认会加载第0页。如果为nil，原来有的话 就是加载原来的否则会定位为0.
 */
- (void)reloadYNPageScrollViewControllerLoadPage:(NSNumber *)index;

/**
 *  重新加载YNPageScrollViewController，清空缓存控制器。
 */
- (void)reloadYNPageScrollViewControllerRemoveCacheLoadPage:(NSNumber *)index;

/**
 *  当前PageScrollViewVC作为子控制器
 *
 *  @param parentViewControler 父类控制器
 *  @param isAfterLoadData     是否是在加载数据之后
 */
- (void)addSelfToParentViewController:(UIViewController *)parentViewControler
                      isAfterLoadData:(BOOL)isAfterLoadData;

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
