//
//  YNPageScrollView.m
//  039_PageScrollView
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#define kYNPageNavHeight 64

#import "YNPageScrollViewController.h"
#import "UIView+YNCategory.h"
#import "YNPageScrollView.h"


@interface YNPageScrollViewController ()<UIScrollViewDelegate, YNPageScrollViewMenuDelegate, UITableViewDelegate,YNPageScrollViewControllerDelegate>

/** 控制器缓存*/
@property (nonatomic, strong) NSMutableDictionary *cacheDictionaryM;
/** 已经展示的控制器*/
@property (nonatomic, strong) NSMutableDictionary *displayDictionaryM;
/** 偏移量缓存*/
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionaryM;
/** 滑动锁*/
@property (nonatomic, assign) BOOL lockDidScrollView;
/** 上次点位置*/
@property (nonatomic, assign) CGFloat lastPositionX;
/** 上次偏移量*/
@property (nonatomic, assign) CGFloat contentoffSetY;
/** 头部原来的偏移y*/
@property (nonatomic, assign) CGFloat originHeaderOffSetY;
/** 临时headerView*/
@property (nonatomic, strong) UIView *tempHeaderView;
/** headerView*/
@property (nonatomic, strong) UIView *bigHeaderView;

@property (nonatomic, assign) BOOL isViewDidLoad;

@end

@implementation YNPageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //检查参数
    [self checkParams];
    
    self.lockDidScrollView = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.parentScrollView];
    
    [self configUI];
    [self setPageScrollViewMenuSelectPageIndex:self.pageIndex animated:NO];
    [self configTableViewHeader];

}


- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if ([self isNavigationStyle]) {
        if (self.isViewDidLoad) return;
        CGFloat menuHeight = self.configration.menuHeight;
        __block CGFloat menuX = self.view.yn_x;
        __block CGFloat rightWidth = 0;
        
        [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            
            if (![obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] && obj.alpha != 0 && obj.hidden == NO) {
                CGFloat maxX = CGRectGetMaxX(obj.frame);
                if (maxX < self.view.yn_width / 2) {
                    CGFloat leftWidth = maxX + 6;
                    menuX = menuX > leftWidth ? menuX : leftWidth;
                }
                CGFloat minX = CGRectGetMinX(obj.frame);
                if (minX > self.view.yn_width / 2) {
                    CGFloat width = (self.view.yn_width - minX) + 6;
                    rightWidth = rightWidth > width ? rightWidth : width;
                }
            }
        }];
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
        menuHeight = self.configration.menuHeight > navHeight ? navHeight : self.configration.menuHeight;
        CGFloat menuWidth = self.view.yn_width - menuX - rightWidth;
        [self initPageScrollViewMenuWithFrame:CGRectMake(menuX, self.view.yn_y, menuWidth, menuHeight)];
        self.isViewDidLoad = YES;
        
    }
    
}

- (void)configUI{
    if ([self isSuspensionStyle]) {
        
        CGFloat dealtaHeight = self.navigationController.navigationBar.isTranslucent ? 0 : 64;
        [self initPageScrollViewMenuWithFrame:CGRectMake(0,self.headerView.yn_height + self.configration.menuHeight + 20 - (self.configration.showNavigation ? dealtaHeight : kYNPageNavHeight),self.view.yn_width,self.configration.menuHeight)];
        
        self.originHeaderOffSetY = self.scrollViewMenu.yn_y;
        
        [self.view addSubview:self.tempHeaderView];
    }else if ([self isTopStyle]){
        
        CGFloat dealtaHeight = self.navigationController.navigationBar.isTranslucent ? 64 : 0;
        [self initPageScrollViewMenuWithFrame:CGRectMake(0,dealtaHeight,self.view.frame.size.width,self.configration.menuHeight)];
    }
    
    
}
- (void)configTableViewHeader{
    
    if ([self isSuspensionStyle]) {
        UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
        self.bigHeaderView.frame = self.headerView.frame;
        self.bigHeaderView.yn_height += self.configration.menuHeight;
        
        [self.bigHeaderView addSubview:self.headerView];
        tableView.tableHeaderView = self.bigHeaderView;
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.bigHeaderView.yn_height, 0, 0, 0);
        
    }
}
- (void)initPageScrollViewMenuWithFrame:(CGRect)frame{
    
    YNPageScrollViewMenu *scrollViewMenu = [YNPageScrollViewMenu pageScrollViewMenuWithFrame:frame titles:self.titleArrayM Configration:self.configration delegate:self];
    self.scrollViewMenu = scrollViewMenu;
    
    if ([self isNavigationStyle]) {
        self.navigationItem.titleView = self.scrollViewMenu;
        return;
    }
    [self.view addSubview:self.scrollViewMenu];
    
}


#pragma mark - life Cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.lockDidScrollView = NO;
}

- (void)initViewControllerWithIndex:(NSInteger)index{
    
    self.currentViewController = self.viewControllers[index];
    
    self.pageIndex = index;
    
    if ([self.displayDictionaryM objectForKey:@(index)]) return;
    
    UIViewController * cacheViewController = [self.cacheDictionaryM objectForKey:@(index)];
    if (cacheViewController) {
        [self addViewControllerToParentScrollView:cacheViewController index:index];
    }
    [self addViewControllerToParentScrollView:self.viewControllers[index] index:index];
    
}


- (void)addViewControllerToParentScrollView:(UIViewController *)viewController index:(NSInteger)index{
    
    [self addChildViewController:self.viewControllers[index]];
    
    viewController.view.frame = CGRectMake(self.view.yn_width *index, (self.configration.showNavigation ?  0: -20), self.view.yn_width, self.view.yn_height - (self.configration.showNavigation ? kYNPageNavHeight : 0) - ([self isTopStyle] ? self.configration.menuHeight : 0));
    
    [self.parentScrollView addSubview:viewController.view];
    
    [self didMoveToParentViewController:viewController];
    
    [self.displayDictionaryM setObject:viewController forKey:@(index)];
    
    UIScrollView *scrollView = [self getScrollViewForDataSource];
    
    if ([self isSuspensionStyle]) {
        
        UITableView *tableView = (UITableView *)scrollView;
        
        if (tableView.tableHeaderView == nil) {
            tableView.tableHeaderView = self.bigHeaderView;
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.bigHeaderView.yn_height, 0, 0, 0);
        }
    }
    
    if (![self.cacheDictionaryM objectForKey:@(index)]) {//缓存
        
        [self.cacheDictionaryM setObject:viewController forKey:@(index)];
        
        if ([self isSuspensionStyle]) {
            [(UITableView *)scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)((UITableView *)scrollView)];
        }
        CGFloat navHeight = self.configration.showNavigation ? 64 : 0;
        CGFloat tabbarHeight = self.hidesBottomBarWhenPushed ? 0 : 49;
        scrollView.yn_height =scrollView.yn_height - navHeight - tabbarHeight - ([self isTopStyle] ? self.configration.menuHeight : 0);
    }
    
}

- (void)removeViewControllerToParentScrollView:(UIViewController *)viewController index:(NSInteger)index{
    
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayDictionaryM removeObjectForKey:@(index)];
    
    if (![self.cacheDictionaryM objectForKey:@(index)]) {
        [self.cacheDictionaryM setObject:viewController forKey:@(index)];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue].y;
    
    if (newValue != oldValue){
        CGFloat y = self.originHeaderOffSetY - newValue;
        CGFloat progress = 0;
        CGFloat deltaHeight = (self.navigationController.navigationBar.isTranslucent||!self.configration.showNavigation) ? 64 : 0;

        if (y <= deltaHeight) {
            
            progress = 1;
            self.scrollViewMenu.yn_y = deltaHeight;
            [self.contentOffsetDictionaryM setObject:@(newValue) forKey:@(self.pageIndex)];
        }else{
            progress = 1-((y-deltaHeight)/(self.headerView.yn_height - deltaHeight));
            self.scrollViewMenu.yn_y = y;
            self.contentoffSetY = newValue;
            [self.contentOffsetDictionaryM removeAllObjects];
        }
        
        if ([self.delegate respondsToSelector:@selector(pageScrollViewController:tableViewScrollViewContentOffset:progress:)]) {
            [self.delegate pageScrollViewController:self tableViewScrollViewContentOffset:y progress:progress];
        }
    
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self isSuspensionStyle]) {
        self.tempHeaderView.yn_y = [self.headerView convertRect:self.headerView.frame toView:self.view].origin.y;
        [self.tempHeaderView addSubview: self.headerView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:YNNotificationUpdateTableViewRefresh object:nil];
        CGFloat deltaHeight = self.navigationController.navigationBar.isTranslucent&&self.configration.showNavigation ? 64 : 0;
        if (self.tempHeaderView.yn_y > deltaHeight) {
            [UIView animateWithDuration:self.configration.tableViewResfreshAnimationTime animations:^{
                self.tempHeaderView.yn_y = deltaHeight;
            }];
        }
    }
    
};

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([self isSuspensionStyle]) {
        [self replaceTableViewHeaderView];
    }else{
        [self removeViewController];
        [self.scrollViewMenu adjustItemPositionWithCurrentIndex:self.pageIndex];
    }
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (self.lockDidScrollView) return;
    
    CGFloat currentPostion = scrollView.contentOffset.x;
    
    CGFloat offsetX = currentPostion / self.view.yn_width;
    CGFloat offX = currentPostion > self.lastPositionX ? ceilf(offsetX) : offsetX;
    
    
    [self initViewControllerWithIndex:offX];
    
    CGFloat progress = offsetX - (NSInteger)offsetX;
    
    self.lastPositionX = currentPostion;
    
    
    [self.scrollViewMenu adjustItemWithProgress:progress lastIndex:floor(offsetX) currentIndex:ceilf(offsetX)];
    
    [self updateSubViewScrollViewContentInset];
    
    
}

- (void)removeViewController{
    
    for (int i = 0; i < self.viewControllers.count; i ++) {
        if (i != self.pageIndex) {
            if(self.displayDictionaryM[@(i)]){
                [self removeViewControllerToParentScrollView:self.displayDictionaryM[@(i)] index:i];
            }
        }
    }
}

#pragma mark - YNPageScrollViewMenuDelegate

- (void)pageScrollViewMenuItemOnClick:(UILabel *)label index:(NSInteger)index{
    
    
    [self initViewControllerWithIndex:index];
    
    CGRect frame = [[self.viewControllers[index] view] frame];
    frame.origin.y = 0;
    [self.parentScrollView scrollRectToVisible:frame animated:NO];
    
    if ([self isSuspensionStyle]) {
        [self.tempHeaderView addSubview: self.headerView];
        
        if (self.bigHeaderView.yn_height - self.configration.menuHeight > 0) {
            
            CGFloat deltaHeight = (self.navigationController.navigationBar.isTranslucent||!self.configration.showNavigation) ? 64 : 0;
            
            if (self.scrollViewMenu.yn_y > deltaHeight) {
                self.scrollViewMenu.yn_y = 150;
                
                NSLog(@"%f",self.scrollViewMenu.yn_y);
                [[NSNotificationCenter defaultCenter] postNotificationName:YNNotificationUpdateTableViewRefresh object:nil];
            }
        }
        
        [self replaceTableViewHeaderView];
        
    }
    
    [self removeViewController];
    [self updateSubViewScrollViewContentInset];
}

- (void)replaceTableViewHeaderView{
    
    if (self.bigHeaderView.subviews.count == 0) {
        
        UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
        
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
        
        [self.bigHeaderView addSubview:self.headerView];
        tableView.tableHeaderView = nil;
        tableView.tableHeaderView = self.bigHeaderView;
        [self.tempHeaderView removeAllSubviews];
        
        [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(tableView)];
        
        if ([self.contentOffsetDictionaryM objectForKey:@(self.pageIndex)]) {
            tableView.contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:@(self.pageIndex)] floatValue]);
        }
        
        [self removeViewController];
        [self.scrollViewMenu adjustItemPositionWithCurrentIndex:self.pageIndex];
        
    }
    
}


- (void)pageScrollViewMenuAddButtonAction:(UIButton *)button{
    
    if (self.addButtonAtion) {
        self.addButtonAtion(button, self);
    }
}


- (void)updateSubViewScrollViewContentInset{
    
    if (![self isSuspensionStyle]) return;
    CGFloat deltaHeight = (self.navigationController.navigationBar.isTranslucent||!self.configration.showNavigation) ? 64 : 0;
    if (self.scrollViewMenu.yn_y  == deltaHeight) {//临界点
        if ([self.contentOffsetDictionaryM objectForKey:@(self.pageIndex)]) {
            [self getScrollViewForDataSource].contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:@(self.pageIndex)] floatValue]);
        }else{
            
            [self getScrollViewForDataSource].contentOffset = CGPointMake(0,self.originHeaderOffSetY - deltaHeight);
        }
    }else{
        
        [self getScrollViewForDataSource].contentOffset = CGPointMake(0, self.contentoffSetY);
    }
}


#pragma mark - Public Mehtod

+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(YNPageScrollViewMenuConfigration *)configration{
    
    YNPageScrollViewController *viewController =  [[self alloc]init];
    viewController.viewControllers = viewControllers;
    viewController.titleArrayM = titleArrayM;
    viewController.configration = configration ? configration : [YNPageScrollViewMenuConfigration pageScrollViewMenuConfigration];
    return viewController;
}

- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self.scrollViewMenu selectedItemIndex:index animated:animated];
    
    [self pageScrollViewMenuItemOnClick:nil index:index];
    
}

- (void)addAddButtonViewController:(UIViewController *)viewController{
    
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [self didMoveToParentViewController:viewController];
    
}

- (void)removeAddButtonViewController:(UIViewController *)viewController{

    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    
}

#pragma mark - Private Method

- (void)checkParams{
    
    NSAssert(self.viewControllers.count != 0 || self.viewControllers, @"ViewControllers`count is 0 or nil");
    
    NSAssert(self.titleArrayM.count != 0 || self.titleArrayM, @"titleArray`count is 0 or nil,");
    
    NSAssert(self.viewControllers.count == self.titleArrayM.count, @"ViewControllers`count is  not equal titleArray!");
    
}

- (BOOL)isTopStyle{
    return self.configration.pageScrollViewMenuStyle == YNPageScrollViewMenuStyleTop;
}

- (BOOL)isNavigationStyle{
    return self.configration.pageScrollViewMenuStyle == YNPageScrollViewMenuStyleNavigation;
}

- (BOOL)isSuspensionStyle{
    return self.configration.pageScrollViewMenuStyle == YNPageScrollViewMenuStyleSuspension;
}


#pragma mark - lazy

- (UIScrollView *)parentScrollView{
    
    if (!_parentScrollView) {
        _parentScrollView = [[YNPageScrollView alloc]initWithFrame:CGRectMake(0, [self isTopStyle] ? self.configration.menuHeight : 0, self.view.yn_width, ([self isTopStyle] ? self.view.yn_height - self.configration.menuHeight: self.view.yn_height + kYNPageNavHeight))];
        _parentScrollView.showsVerticalScrollIndicator = NO;
        _parentScrollView.showsHorizontalScrollIndicator = NO;
        _parentScrollView.pagingEnabled = YES;
        _parentScrollView.backgroundColor = [UIColor whiteColor];
        _parentScrollView.bounces = NO;
        _parentScrollView.delegate = self;
        _parentScrollView.contentSize = CGSizeMake(self.view.yn_width * self.viewControllers.count, self.view.yn_height - (self.hidesBottomBarWhenPushed ? 0 : 49) - kYNPageNavHeight - ([self isTopStyle] ? self.configration.menuHeight : 0));
        
        
    }
    return _parentScrollView;
}

- (NSMutableDictionary *)cacheDictionaryM{
    
    if (!_cacheDictionaryM) {
        _cacheDictionaryM = [NSMutableDictionary dictionaryWithCapacity:self.viewControllers.count];
    }
    
    return _cacheDictionaryM;
}

- (NSMutableDictionary *)displayDictionaryM{
    
    if (!_displayDictionaryM) {
        _displayDictionaryM = [NSMutableDictionary dictionaryWithCapacity:self.viewControllers.count];
    }
    return _displayDictionaryM;
}

- (NSMutableDictionary *)contentOffsetDictionaryM{
    
    if (!_contentOffsetDictionaryM) {
        _contentOffsetDictionaryM = [NSMutableDictionary dictionaryWithCapacity:self.viewControllers.count];
    }
    return _contentOffsetDictionaryM;
}

- (UIView *)tempHeaderView{
    
    if (!_tempHeaderView) {
        _tempHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, kYNPageNavHeight, self.view.yn_width, 50)];
        _tempHeaderView.userInteractionEnabled = NO;
        
    }
    return _tempHeaderView;
    
}

- (UIView *)bigHeaderView{
    
    if (!_bigHeaderView) {
        _bigHeaderView = [[UIView alloc]init];
    }
    return _bigHeaderView;
    
}

#pragma mark - dealloc
- (void)dealloc{
    if ([self isSuspensionStyle]) {
        [self.cacheDictionaryM.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.pageIndex = [obj integerValue];
            
            [[self getScrollViewForDataSource] removeObserver:self forKeyPath:@"contentOffset"];
        }];
    }
    
    NSLog(@"---- YNPageScrollViewController dealloc ----");
    
    
}

#pragma mark - 获取滚动视图
- (UIScrollView *)getScrollViewForDataSource{
    
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollViewController:tableViewForIndex:)]) {
        UIScrollView *scrollView = [self.dataSource pageScrollViewController:self tableViewForIndex:self.pageIndex];
        if (scrollView && [scrollView isKindOfClass:[UIScrollView class]]) {
            if (self.configration.pageScrollViewMenuStyle == YNPageScrollViewMenuStyleSuspension) {
                NSAssert([scrollView isKindOfClass:[UITableView class]], @"暂时只支持设置UITableView");
            }
            return scrollView;
        }
    }
    NSAssert(0 != 0,@"请设置数据源");
    return nil;
}


@end
