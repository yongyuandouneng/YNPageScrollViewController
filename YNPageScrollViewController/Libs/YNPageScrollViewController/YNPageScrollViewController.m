//
//  YNPageScrollView.m
//  039_PageScrollView
//
//  Created by ZYN on 16/7/5.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#define kYNPageNavHeight 64
#define kYNPageTabbarHeight 49
#import "YNPageScrollViewController.h"
#import "UIView+YNCategory.h"
#import "YNPageScrollHeaderView.h"

@interface YNPageScrollViewController ()<UIScrollViewDelegate, YNPageScrollViewMenuDelegate, UITableViewDelegate,YNPageScrollViewControllerDelegate,YNPageScrollHeaderViewDelegate>
{
    BOOL _isAsChildViewController ;
    
    BOOL _isAfterLoadData;
}
/** 控制器缓存*/
@property (nonatomic, strong) NSMutableDictionary *cacheDictionaryM;
/** 已经展示的控制器*/
@property (nonatomic, strong) NSMutableDictionary *displayDictionaryM;
/** 偏移量缓存*/
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionaryM;
/** UIScrollView缓存*/
@property (nonatomic, strong) NSMutableDictionary *scrollViewCacheDictionryM;
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
@property (nonatomic, strong) YNPageScrollHeaderView *bigHeaderView;

@property (nonatomic, assign) BOOL DidLayoutSubviews;

@property (nonatomic, assign) BOOL isHeaderViewInTempHeaderView;

@property (nonatomic, assign) BOOL islockObserveParam;

//标识是否是第一次初始化控制器(暂时用于伸缩控制)
@property (nonatomic, assign) BOOL isFirstInitViewControler;


@end

@implementation YNPageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //检查参数
    [self checkParams];
    
    if (_isAsChildViewController && !_isAfterLoadData) {
        self.parentViewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.lockDidScrollView = YES;
    
    self.isFirstInitViewControler = NO;
    
    [self.view addSubview:self.parentScrollView];
    
    if ([self isSuspensionStyle]) {
        
        if (self.HeaderViewCouldScale) {
            [self.view addSubview:self.scaleBackgroundView];
        }
        [self.view addSubview:self.tempHeaderView];
        
    }
    
}

- (void)configUI{
    if (!self.scrollViewMenu) {
        
        if (_isAsChildViewController && _isAfterLoadData) {
            if (self.navigationController.navigationBar.isTranslucent) {
                CGFloat deltaHeight =  self.configration.showNavigation ? kYNPageNavHeight : 0;
                CGFloat dHeight  =  (self.configration.showTabbar ? kYNPageTabbarHeight : 0);
                self.view.yn_y =self.parentViewController.edgesForExtendedLayout != UIRectEdgeNone ?  deltaHeight : 0;
                self.view.yn_height =self.view.yn_height -  deltaHeight - dHeight;
            }else{
                CGFloat deltaHeight =  self.configration.showNavigation ? kYNPageNavHeight : 0;
                CGFloat dHeight  =  (self.configration.showTabbar ? kYNPageTabbarHeight : 0);
                self.view.yn_height =self.view.yn_height -  deltaHeight - dHeight;
            }
        }
        self.parentScrollView.frame = CGRectMake(0, [self isTopStyle] ? self.configration.menuHeight : 0, self.view.yn_width, ([self isTopStyle] ? self.view.yn_height - self.configration.menuHeight: self.view.yn_height));
        
        self.parentScrollView.contentSize = CGSizeMake(self.view.yn_width * self.viewControllers.count, self.view.yn_height   - ([self isTopStyle] ? self.configration.menuHeight : 0));
        
        
        if ([self isSuspensionStyle]) {
            //初始化headerView
            self.bigHeaderView.frame = self.headerView.frame;
            self.bigHeaderView.yn_height += self.configration.menuHeight;
            [self.bigHeaderView addSubview:self.headerView];
            //伸缩
            if (self.HeaderViewCouldScale) {
                self.scaleBackgroundView.hidden = YES;
                self.scaleBackgroundView.frame = CGRectMake(0, 0, self.headerView.yn_width, self.headerView.yn_height);
            }
            
            
            
            
            //初始化菜单
            [self initPageScrollViewMenuWithFrame:CGRectMake(0,self.headerView.yn_height,self.view.yn_width,self.configration.menuHeight)];
            
            self.originHeaderOffSetY = self.scrollViewMenu.yn_y;
            
            UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
            tableView.tableHeaderView = self.bigHeaderView;
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.bigHeaderView.yn_height, 0, 0, 0);
            
            ((YNPageScrollView *)self.parentScrollView).headerViewHeight = self.bigHeaderView.yn_height;
            
            
            
            
        }else if ([self isTopStyle]){
            
            [self initPageScrollViewMenuWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.configration.menuHeight)];
        }
    }
    
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self configUI];
    
}


- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.DidLayoutSubviews &&[self isNavigationStyle]) {
        
        self.DidLayoutSubviews = YES;
        
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
    }
}


- (void)initPageScrollViewMenuWithFrame:(CGRect)frame{
    
    YNPageScrollViewMenu *scrollViewMenu = [YNPageScrollViewMenu pageScrollViewMenuWithFrame:frame titles:self.titleArrayM Configration:self.configration delegate:self currentIndex:self.pageIndex];
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
    NSString *title = [self titleWithIndex:index];
    if ([self.displayDictionaryM objectForKey:title]) return;
    
    UIViewController * cacheViewController = [self.cacheDictionaryM objectForKey:title];
    if (cacheViewController) {
        self.isFirstInitViewControler = NO;
        [self addViewControllerToParentScrollView:cacheViewController index:index];
    }else{
        self.isFirstInitViewControler = YES;
        [self addViewControllerToParentScrollView:self.viewControllers[index] index:index];
    }
    
}


- (void)addViewControllerToParentScrollView:(UIViewController *)viewController index:(NSInteger)index{
    
    [self addChildViewController:self.viewControllers[index]];
    
    viewController.view.frame = CGRectMake(self.view.yn_width *index, 0, self.parentScrollView.yn_width, self.parentScrollView.yn_height);
    
    [self.parentScrollView addSubview:viewController.view];
    
    [self didMoveToParentViewController:viewController];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictionaryM setObject:viewController forKey:title];
    
    UIScrollView *scrollView = [self getScrollViewForDataSource];
    
    if (![viewController isKindOfClass:[UITableViewController class]]) {
        
        scrollView.frame = CGRectMake(0, 0, self.parentScrollView.yn_width, self.parentScrollView.yn_height);
        
    }
    if ([self isSuspensionStyle]) {
        
        UITableView *tableView = (UITableView *)scrollView;
        if (tableView.tableHeaderView == nil) {
            tableView.tableHeaderView = self.bigHeaderView;
        }
        
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.bigHeaderView.yn_height, 0, 0, 0);
        
    }
    
    if (![self.cacheDictionaryM objectForKey:title]) {//缓存
        
        [self.cacheDictionaryM setObject:viewController forKey:title];
        
        if ([self isSuspensionStyle]) {
            
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(scrollView)];
            
            if (self.placeHoderView) {
                self.placeHoderView.yn_height = self.view.yn_height;
                self.placeHoderView.backgroundColor = scrollView.backgroundColor;
                ((UITableView *)scrollView).tableFooterView = self.placeHoderView;
                [self reloadPlaceHoderViewFrame];
            }
        }
    }
}

- (void)removeViewControllerToParentScrollView:(UIViewController *)viewController index:(NSInteger)index{
    
    [self removeVCWithFromVC:viewController];
    
    NSString *title = [self titleWithIndex:index];
    
    [self.displayDictionaryM removeObjectForKey:title];
    
    if (![self.cacheDictionaryM objectForKey:title]) {
        [self.cacheDictionaryM setObject:viewController forKey:title];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIScrollView *scrollView = (__bridge id)context;
    if ([self getScrollViewForDataSource] != scrollView)return;
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue].y;
    
    if (self.islockObserveParam) {self.islockObserveParam = NO;return;}
    if (newValue != oldValue){
        
        if (self.HeaderViewCouldScale) {//是否是伸缩效果
            
            CGFloat yOffset  = scrollView.contentOffset.y;
            CGFloat xOffset = (yOffset)/ 2;
            
            if(yOffset < 0) {
                
                CGRect f =self.scaleBackgroundView.frame;
                
                if (self.headerViewScaleMode == YNHeaderViewScaleModeTop) {
                    
                    
                    f.origin.y = 0;
                    f.size.height =  -yOffset + self.headerView.yn_height;
                    f.origin.x = xOffset;
                    f.size.width = self.view.yn_width + fabs(xOffset)*2;
                    
                    self.tempHeaderView.yn_y = -yOffset;
                    
                    
                }else {
                    f.origin.y = yOffset;
                    f.size.height =  -yOffset*2 + self.headerView.yn_height;
                    f.origin.x = xOffset;
                    f.size.width = self.view.yn_width + fabs(xOffset)*2;
                    
                }
                
                self.scaleBackgroundView.frame = f;
            }
            
            
            if (newValue < 0) {
                
                if (self.bigHeaderView.subviews.count != 0) {
                    
                    self.isHeaderViewInTempHeaderView = YES;
                    
                    self.tempHeaderView.yn_y = 0;
                    
                    [self.headerView removeFromSuperview];
                    
                    [self.tempHeaderView addSubview: self.headerView];
                    
                    self.scaleBackgroundView.hidden = NO;
                    
                    [self inVokePageScrollViewDelegateWithScaleState:YES];
                    
                }
            }else{
                if (self.isFirstInitViewControler) {
                    self.isFirstInitViewControler = NO;
                    
                }else{
                    
                    if (self.bigHeaderView.subviews.count == 0) {
                        
                        UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
                        
                        self.islockObserveParam = YES;
                        
                        self.isHeaderViewInTempHeaderView = NO;
                        [self.tempHeaderView removeAllSubviews];
                        [self.headerView removeFromSuperview];
                        [self.bigHeaderView addSubview:self.headerView];
                        
                        tableView.tableHeaderView = nil;
                        tableView.tableHeaderView = self.bigHeaderView;
                        
                        self.islockObserveParam = NO;
                        
                        
                        
                        self.scaleBackgroundView.hidden = YES;
                        
                        [self inVokePageScrollViewDelegateWithScaleState:NO];
                    }
                }
            }
            [self inVokePageScrollViewDelegateWithScaleContentOffset:yOffset];
        }
        
        
        CGFloat y = self.originHeaderOffSetY - newValue;
        CGFloat progress = 0;
        CGFloat deltaHeight =  self.configration.showNavigation ? 0 : kYNPageNavHeight;
        
        if (y <= deltaHeight) {
            
            NSString *title = [self titleWithIndex:self.pageIndex];
            progress = 1;
            self.scrollViewMenu.yn_y = deltaHeight;
            [self.contentOffsetDictionaryM setObject:@(newValue) forKey:title];
            
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([self isSuspensionStyle]) {
        [self replaceTableViewHeaderView];
        
        [self reloadPlaceHoderViewFrame];
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
    
    [self replaceTempHeaderView];
    
    [self initViewControllerWithIndex:offX];
    
    CGFloat progress = offsetX - (NSInteger)offsetX;
    
    self.lastPositionX = currentPostion;
    
    [self.scrollViewMenu adjustItemWithProgress:progress lastIndex:floor(offsetX) currentIndex:ceilf(offsetX)];
    
    [self updateSubViewScrollViewContentInset];
    
    
}

- (void)removeViewController{
    
    for (int i = 0; i < self.viewControllers.count; i ++) {
        if (i != self.pageIndex) {
            NSString *title = [self titleWithIndex:i];
            if(self.displayDictionaryM[title]){
                [self removeViewControllerToParentScrollView:self.displayDictionaryM[title] index:i];
            }
        }
    }
}

#pragma mark - YNPageScrollViewMenuDelegate

- (void)pageScrollViewMenuItemOnClick:(UILabel *)label index:(NSInteger)index{
    
    self.islockObserveParam = YES;
    
    BOOL isRefresing = [self getTableViewIsRefresing];
    
    [self initViewControllerWithIndex:index];
    CGRect frame = [[self.viewControllers[index] view] frame];
    frame.origin.y = 0;
    [self.parentScrollView scrollRectToVisible:frame animated:NO];
    
    if ([self isSuspensionStyle]) {
        if (isRefresing) {
            [self getScrollViewForDataSource].contentOffset = CGPointMake(0, 0);
        }
        [self replaceTableViewHeaderView];
        
    }
    
    [self removeViewController];
    [self updateSubViewScrollViewContentInset];
}

- (void)replaceTempHeaderView{
    
    if (!self.isHeaderViewInTempHeaderView && [self isSuspensionStyle]) {
        
        self.isHeaderViewInTempHeaderView = YES;
        self.tempHeaderView.yn_y = [self.headerView convertRect:self.headerView.frame toView:self.view].origin.y;
        
        [self.headerView removeFromSuperview];
        
        [self.tempHeaderView addSubview: self.headerView];
        
        if ([self getTableViewIsRefresing]) {
            [self getTableViewEndRefresh];
            CGFloat deltaHeight = 0;
            if (self.tempHeaderView.yn_y > deltaHeight) {
                [UIView animateWithDuration:self.configration.tableViewResfreshAnimationTime animations:^{
                    self.tempHeaderView.yn_y = deltaHeight;
                    [self getScrollViewForDataSource].contentOffset = CGPointMake(0, 0);
                }];
            }
        }
    }
}

- (void)replaceTableViewHeaderView{
    
    if (self.bigHeaderView.subviews.count == 0) {
        
        UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
        
        self.islockObserveParam = YES;
        
        self.isHeaderViewInTempHeaderView = NO;
        [self.tempHeaderView removeAllSubviews];
        [self.headerView removeFromSuperview];
        [self.bigHeaderView addSubview:self.headerView];
        
        tableView.tableHeaderView = nil;
        tableView.tableHeaderView = self.bigHeaderView;
        
        self.islockObserveParam = NO;
        
        NSString *title = [self titleWithIndex:self.pageIndex];
        
        if ([self.contentOffsetDictionaryM objectForKey:title]) {
            tableView.contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:title] floatValue]);
        }else{
            tableView.contentOffset = CGPointMake(0, self.contentoffSetY);
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
    CGFloat deltaHeight =  self.configration.showNavigation ? 0 : kYNPageNavHeight;
    if (self.scrollViewMenu.yn_y  == deltaHeight) {//临界点
        
        NSString *title = [self titleWithIndex:self.pageIndex];
        
        if ([self.contentOffsetDictionaryM objectForKey:title]) {
            [self getScrollViewForDataSource].contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:title] floatValue]);
        }else{
            
            [self getScrollViewForDataSource].contentOffset = CGPointMake(0,self.originHeaderOffSetY - deltaHeight);
            self.contentoffSetY = self.originHeaderOffSetY - deltaHeight;
        }
    }else{
        
        [self getScrollViewForDataSource].contentOffset = CGPointMake(0, self.contentoffSetY);
    }
}


#pragma mark - YNPageScrollHeaderViewDelegate

- (void)YNPageScrollHeaderViewHitTest:(BOOL)showGestureBegin{
    
    self.parentScrollView.gestureRecognizerShouldBegin = showGestureBegin;
}

#pragma mark - Public Mehtod

+ (instancetype)pageScrollViewControllerWithControllers:(NSArray *)viewControllers titles:(NSArray *)titleArrayM Configration:(YNPageScrollViewMenuConfigration *)configration{
    
    YNPageScrollViewController *viewController =  [[self alloc]init];
    viewController.viewControllers = viewControllers.mutableCopy;
    viewController.titleArrayM = titleArrayM.mutableCopy;
    viewController.configration = configration ? configration : [YNPageScrollViewMenuConfigration pageScrollViewMenuConfigration];
    
    return viewController;
}

- (void)setPageScrollViewMenuSelectPageIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self.scrollViewMenu selectedItemIndex:index animated:animated];
    
    [self pageScrollViewMenuItemOnClick:nil index:index];
    
}

- (void)addPageScrollViewControllerWithTitle:(NSArray *)titles viewController:(NSArray *)viewControllers inserIndex:(NSInteger)index{
    
    index = index < 0 ? 0 : index > self.titleArrayM.count - 1 ? self.titleArrayM.count - 1 : index;
    
    for (int i = 0; i < titles.count; i++) {
        [self.titleArrayM insertObject:titles[i] atIndex:index + i];
        [self.viewControllers insertObject:viewControllers[i] atIndex:index + i];
    }
    
    
}

- (void)removePageScrollControllerWithTtitle:(NSString *)title viewController:(UIViewController *)viewController{
    
    [self.titleArrayM removeObject:title];
    [self.viewControllers removeObject:viewController];
    
    
}

- (void)replaceTitleArray:(NSMutableArray *)titleArray {
    
    NSMutableArray *resultViewControllerArray = @[].mutableCopy;
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSString * titleI = titleArray[i];
        
        for (NSInteger j = 0; j < self.titleArrayM.count; j++) {
            NSString *titleJ = self.titleArrayM[j];
            
            if ([titleI isEqualToString:titleJ]) {
                
                [resultViewControllerArray addObject:self.viewControllers[j]];
                break;
            }
        }
    }
    
    //赋值
    self.titleArrayM = titleArray;
    self.viewControllers = resultViewControllerArray;
    
    
}


- (void)reloadYNPageScrollViewControllerLoadPage:(NSNumber *)index {
    
    [self.scrollViewMenu removeFromSuperview];
    self.scrollViewMenu = nil;
    self.DidLayoutSubviews = NO;
    [self configUI];
    
    /// 防止拖动过程中 刷新
    self.isHeaderViewInTempHeaderView = NO;
    
    
    NSInteger currentPage = index == nil ? self.pageIndex : [index integerValue];
    //TODO 暂时
    [self setPageScrollViewMenuSelectPageIndex:0 animated:NO];
    
    [self setPageScrollViewMenuSelectPageIndex:currentPage animated:NO];
    
    
}


- (void)reloadYNPageScrollViewControllerRemoveCacheLoadPage:(NSNumber *)index {
    
    [self.cacheDictionaryM removeAllObjects];
    
    [self reloadYNPageScrollViewControllerLoadPage:index];
    
}


- (void)removePageScrollControllerWithTtitle:(NSString *)title{
    
    NSInteger index = -1;
    for (NSInteger i = 0; i < self.titleArrayM.count; i++) {
        if ([self.titleArrayM[i] isEqualToString:title]) {
            index = i;
            break;
        }
    }
    
    [self removePageScrollControllerWithIndex:index];
    
}


- (void)removePageScrollControllerWithIndex:(NSInteger)index{
    
    if (index < 0 || index >= self.titleArrayM.count || self.titleArrayM.count == 1) return;
    
    if (self.pageIndex >= index) {
        
        self.pageIndex--;
        if (self.pageIndex < 0) {
            self.pageIndex = 0 ;
        }
    }
    [self removePageScrollControllerWithTtitle:self.titleArrayM[index] viewController:self.viewControllers[index]];
    
    
}

- (void)removeSelfViewController{
    
    [self removeVCWithFromVC:self];
    
}

- (void)addSelfToParentViewController:(UIViewController *)parentViewControler isAfterLoadData:(BOOL)isAfterLoadData{
    _isAfterLoadData = isAfterLoadData;
    _isAsChildViewController = YES;
    [self addChildVCWithFromVC:self toVC:parentViewControler];
}

- (void)reloadPlaceHoderViewFrame{
    
    if (self.placeHoderView && [self isSuspensionStyle]) {
        UITableView *tableView = (UITableView *)[self getScrollViewForDataSource];
        CGFloat deltaHeight =  self.configration.showNavigation ? 0 : kYNPageNavHeight;
        if (tableView.contentSize.height > self.parentScrollView.yn_height) {
            
            CGFloat footerHeight = (tableView.tableFooterView == nil ? 0 : self.placeHoderView.yn_height) ;
            
            CGFloat height = tableView.contentSize.height - footerHeight - self.headerView.yn_height;
            if (height > self.parentScrollView.yn_height) {
                
                tableView.tableFooterView = nil;
            }else{
                
                self.placeHoderView.yn_height = self.parentScrollView.yn_height - height  -deltaHeight;
                tableView.tableFooterView = self.placeHoderView;
            }
        }else{
            
            self.placeHoderView.yn_height = self.parentScrollView.yn_height - tableView.contentSize.height + self.headerView.yn_height -deltaHeight;
            tableView.tableFooterView = self.placeHoderView;
        }
    }
}

- (void)reloadHeaderViewFrame{
    
    if (self.headerView && [self isSuspensionStyle]) {
        [self.scrollViewMenu removeFromSuperview];
        self.scrollViewMenu = nil;
        [self.contentOffsetDictionaryM removeAllObjects];
        [self configUI];
        
        for (UITableView *tableView in self.scrollViewCacheDictionryM.allValues) {
            [tableView setContentOffset:CGPointMake(0, 0)];
            tableView.tableHeaderView = self.bigHeaderView;
        }
        
        /// 防止拖动过程中 刷新
        self.isHeaderViewInTempHeaderView = NO;
        
    }
    
}

#pragma mark - Private Method

- (void)checkParams{
    
    NSAssert(self.viewControllers.count != 0 || self.viewControllers, @"ViewControllers`count is 0 or nil");
    
    NSAssert(self.titleArrayM.count != 0 || self.titleArrayM, @"titleArray`count is 0 or nil,");
    
    NSAssert(self.viewControllers.count == self.titleArrayM.count, @"ViewControllers`count is  not equal titleArray!");
    
    BOOL isHasNotEqualTitle = YES;
    for (int i = 0; i < self.titleArrayM.count; i++) {
        for (int j = 1; j < self.titleArrayM.count; j++) {
            
            if (i != j && [self.titleArrayM[i] isEqualToString:self.titleArrayM[j]]) {
                isHasNotEqualTitle = NO;
                break;
            }
        }
    }
    NSAssert(isHasNotEqualTitle, @"titleArray Not allow equal title.");
}

- (NSString *)titleWithIndex:(NSInteger)index{
    
    return  self.titleArrayM[index];
    
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


- (void)addChildVCWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC{
    
    [toVC addChildViewController:fromVC];
    [toVC didMoveToParentViewController:fromVC];
    [toVC.view addSubview:fromVC.view];
    
}

- (void)removeVCWithFromVC:(UIViewController *)fromVC{
    
    [fromVC.view removeFromSuperview];
    [fromVC willMoveToParentViewController:nil];
    [fromVC removeFromParentViewController];
    
}


#pragma mark - lazy

- (UIScrollView *)parentScrollView{
    
    if (!_parentScrollView) {
        _parentScrollView = [[YNPageScrollView alloc]init];
        _parentScrollView.showsVerticalScrollIndicator = NO;
        _parentScrollView.showsHorizontalScrollIndicator = NO;
        _parentScrollView.pagingEnabled = YES;
        _parentScrollView.backgroundColor = [UIColor whiteColor];
        _parentScrollView.bounces = NO;
        _parentScrollView.delegate = self;
        
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
        _bigHeaderView = [[YNPageScrollHeaderView alloc]init];
        _bigHeaderView.delegate = self;
    }
    return _bigHeaderView;
    
}


- (UIView *)scaleBackgroundView{
    
    
    if (!_scaleBackgroundView) {
        _scaleBackgroundView = [[UIView alloc]init];
    }
    return _scaleBackgroundView;
}


- (NSMutableDictionary *)scrollViewCacheDictionryM{
    
    if (!_scrollViewCacheDictionryM) {
        _scrollViewCacheDictionryM = [NSMutableDictionary dictionaryWithCapacity:self.viewControllers.count];
    }
    return _scrollViewCacheDictionryM;
    
}

#pragma mark - dealloc
- (void)dealloc{
    if ([self isSuspensionStyle]) {
        
        [self.scrollViewCacheDictionryM.allValues enumerateObjectsUsingBlock:^(UITableView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj removeObserver:self forKeyPath:@"contentOffset"];
        }];
    }
    
    NSLog(@"---- YNPageScrollViewController dealloc ----");
    
    
}

#pragma mark - 获取滚动视图
- (UIScrollView *)getScrollViewForDataSource{
    NSString *title = [self titleWithIndex:self.pageIndex];
    if (![self.scrollViewCacheDictionryM objectForKey:title]) {
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollViewController:scrollViewForIndex:)]) {
            UIScrollView *scrollView = [self.dataSource pageScrollViewController:self scrollViewForIndex:self.pageIndex];
            if (scrollView && [scrollView isKindOfClass:[UIScrollView class]]) {
                if (self.configration.pageScrollViewMenuStyle == YNPageScrollViewMenuStyleSuspension) {
                    NSAssert([scrollView isKindOfClass:[UITableView class]], @"暂时只支持设置UITableView");
                }
                [self.scrollViewCacheDictionryM setObject:scrollView forKey:title];
                return scrollView;
            }
        }
    }else{
        return [self.scrollViewCacheDictionryM objectForKey:title];
    }
    
    NSAssert(0 != 0,@"请设置数据源");
    return nil;
}

#pragma mark - 获取TableView是否正在刷新
- (BOOL)getTableViewIsRefresing{
    
    if (self.currentViewController&&self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollViewController:headerViewIsRefreshingForIndex:)]) {
        return [self.dataSource pageScrollViewController:self headerViewIsRefreshingForIndex:self.pageIndex];
    }
    return NO;
}
#pragma mark - 获取Table结束刷新的方法
- (void)getTableViewEndRefresh{
    
    if (self.currentViewController&&self.dataSource && [self.dataSource respondsToSelector:@selector(pageScrollViewController:scrollViewHeaderAndFooterEndRefreshForIndex:)]) {
        [self.dataSource pageScrollViewController:self scrollViewHeaderAndFooterEndRefreshForIndex:self.pageIndex];
    }
    
}
#pragma mark - 伸缩协议回调
- (void)inVokePageScrollViewDelegateWithScaleState:(BOOL)isStart{
    
    if ([self.delegate respondsToSelector:@selector(pageScrollViewController:scrollViewHeaderScaleState:)]) {
        [self.delegate pageScrollViewController:self scrollViewHeaderScaleState:isStart];
    }
    
}
- (void)inVokePageScrollViewDelegateWithScaleContentOffset:(CGFloat)contentOffset{
    
    if ([self.delegate respondsToSelector:@selector(pageScrollViewController:scrollViewHeaderScaleContentOffset:)]) {
        [self.delegate pageScrollViewController:self scrollViewHeaderScaleContentOffset:contentOffset];
    }
    
}



@end
