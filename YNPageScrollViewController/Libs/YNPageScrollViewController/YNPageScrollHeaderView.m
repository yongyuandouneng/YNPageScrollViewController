//
//  YNHeaderView.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/8/24.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNPageScrollHeaderView.h"

@implementation YNPageScrollHeaderView



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(YNPageScrollHeaderViewHitTest:)]) {
            [self.delegate YNPageScrollHeaderViewHitTest:!CGRectContainsPoint(self.frame, point)];
    }
    return [super hitTest:point withEvent:event];
}


@end
