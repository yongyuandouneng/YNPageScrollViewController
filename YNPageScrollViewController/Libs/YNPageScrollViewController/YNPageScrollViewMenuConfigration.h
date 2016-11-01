//
//  YNPageScrollViewMenuStyle.h
//  039_PageScrollView
//
//  Created by ZYN on 16/7/13.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , YNPageScrollViewMenuStyle) {
    
    YNPageScrollViewMenuStyleTop        = 0,//顶部  默认
    YNPageScrollViewMenuStyleNavigation = 1,//导航条
    YNPageScrollViewMenuStyleSuspension = 2,//悬浮
    
};

@interface YNPageScrollViewMenuConfigration : NSObject

/** 是否显示导航条 YES*/
@property (nonatomic, assign) BOOL showNavigation;
/** 是否显示Tabbar NO*/
@property (nonatomic, assign) BOOL showTabbar;
/** 菜单位置风格 默认 0*/
@property (nonatomic, assign) YNPageScrollViewMenuStyle pageScrollViewMenuStyle;
/** 是否显示遮盖*/
@property (nonatomic, assign) BOOL showConver;
/** 是否显示线条 YES */
@property (nonatomic, assign) BOOL showScrollLine;
/** 颜色是否渐变 YES */
@property (nonatomic, assign) BOOL showGradientColor;
/** 是否显示按钮 NO */
@property (nonatomic, assign) BOOL showAddButton;
/** 菜单是否滚动 YES */
@property (nonatomic, assign) BOOL scrollMenu;
/** 菜单弹簧效果 NO */
@property (nonatomic, assign) BOOL bounces;
/**
 *  是否是居中 (当所有的Item+margin的宽度小于ScrollView宽度)  默认 YES
 *  scrollMenu = NO,aligmentModeCenter = NO 会变成平分
 */
@property (nonatomic, assign) BOOL aligmentModeCenter;
/** 当aligmentModeCenter 变为平分时 是否需要线条宽度等于字体宽度 默认 NO*/
@property (nonatomic, assign) BOOL lineWidthEqualFontWidth;

/** 按钮N图片*/
@property (nonatomic, copy) NSString *addButtonNormalImageName;
/** 按钮H图片*/
@property (nonatomic, copy) NSString *addButtonHightImageName;
/** 按钮背景*/
@property (nonatomic, strong) UIColor *addButtonBackgroundColor;
/** 线条color*/
@property (nonatomic, strong) UIColor *lineColor;
/** 遮盖color*/
@property (nonatomic, strong) UIColor *converColor;
/** 菜单背景color*/
@property (nonatomic, strong) UIColor *scrollViewBackgroundColor;
/** 选项正常color*/
@property (nonatomic, strong) UIColor *normalItemColor;
/** 选项选中color*/
@property (nonatomic, strong) UIColor *selectedItemColor;
/** 线height 2 */
@property (nonatomic, assign) CGFloat lineHeight;
/** 线条底部距离 0*/
@property (nonatomic, assign) CGFloat lineBottomMargin;
/** 线条左右增加 0  默认线条宽度是等于 item宽度*/
@property (nonatomic, assign) CGFloat lineLeftAndRightAddWidth;
/** 遮盖height 28 */
@property (nonatomic, assign) CGFloat converHeight;
/** 菜单height */
@property (nonatomic, assign) CGFloat menuHeight;
/** 遮盖圆角 14 */
@property (nonatomic, assign) CGFloat coverCornerRadius;
/** 选项相邻间隙 15 */
@property (nonatomic, assign) CGFloat itemMargin;
/** 选项左边或者右边间隙 15*/
@property (nonatomic, assign) CGFloat itemLeftAndRightMargin;
/** 选项字体 14*/
@property (nonatomic, strong) UIFont *itemFont;
/** 缩放系数*/
@property (nonatomic, assign) CGFloat itemMaxScale;
/** 下拉刷新头部动画（endingRefresh）时间 0.4 */
@property (nonatomic, assign) CGFloat tableViewResfreshAnimationTime;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)pageScrollViewMenuConfigration;


//##################################无需关注##########################################

@property (nonatomic, assign) CGFloat deltaScale;

@property (nonatomic, assign) CGFloat deltaNorR;

@property (nonatomic, assign) CGFloat deltaNorG;

@property (nonatomic, assign) CGFloat deltaNorB;

@property (nonatomic, assign) CGFloat deltaSelR;

@property (nonatomic, assign) CGFloat deltaSelG;

@property (nonatomic, assign) CGFloat deltaSelB;

- (void)setRGBWithProgress:(CGFloat)progress;

@end

