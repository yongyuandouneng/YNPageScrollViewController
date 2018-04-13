//
//  UIView+YNCategory.h
//  iOS_CommonProject
//
//  Created by ZYN on 16/5/9.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kYNPAGE_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kYNPAGE_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kYNPAGE_IS_IPHONE_X  ((kYNPAGE_SCREEN_HEIGHT == 812.0f && kYNPAGE_SCREEN_WIDTH == 375.0f) ? YES : NO)
#define kYNPageNavHeight (kYNPAGE_IS_IPHONE_X ? 88 : 64)
#define kYNPageTabbarHeight (kYNPAGE_IS_IPHONE_X ? 83 : 49)

@interface UIView (YNCategory)

@property (nonatomic, assign) CGFloat yn_x;

@property (nonatomic, assign) CGFloat yn_y;

@property (nonatomic, assign) CGFloat yn_width;

@property (nonatomic, assign) CGFloat yn_height;

- (void)removeAllSubviews;

@end
