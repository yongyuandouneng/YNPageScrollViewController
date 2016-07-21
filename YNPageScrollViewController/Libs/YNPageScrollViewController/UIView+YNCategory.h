//
//  UIView+YNCategory.h
//  iOS_CommonProject
//
//  Created by ZYN on 16/5/9.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YNCategory)

@property (nonatomic, assign) CGFloat yn_x;

@property (nonatomic, assign) CGFloat yn_y;

@property (nonatomic, assign) CGFloat yn_width;

@property (nonatomic, assign) CGFloat yn_height;

- (void)removeAllSubviews;

@end
