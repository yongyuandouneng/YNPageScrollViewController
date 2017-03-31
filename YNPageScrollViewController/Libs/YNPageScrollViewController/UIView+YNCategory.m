//
//  UIView+Category.m
//  iOS_CommonProject
//
//  Created by ZYN on 16/5/9.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "UIView+YNCategory.h"

@implementation UIView (YNCategory)

//重写setter
- (void)setYn_x:(CGFloat)yn_x{
    
    CGRect frame = self.frame;
    frame.origin.x = yn_x;
    self.frame = frame;
    
}


//getter
- (CGFloat)yn_x
{
    return self.frame.origin.x;
}

- (void)setYn_y:(CGFloat)yn_y
{
    CGRect frame = self.frame;
    frame.origin.y = yn_y;
    self.frame = frame;
}

- (CGFloat)yn_y
{
    return self.frame.origin.y;
}


- (CGFloat)yn_width{
    return self.frame.size.width;
}

- (void)setYn_width:(CGFloat)yn_width{
    CGRect frame = self.frame;
    frame.size.width = yn_width;
    self.frame = frame;
}

- (CGFloat)yn_height{
    return self.frame.size.height;
}

- (void)setYn_height:(CGFloat)yn_height
{
    CGRect frame = self.frame;
    frame.size.height = yn_height;
    self.frame = frame;
}

-(void)removeAllSubviews{
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}





@end
