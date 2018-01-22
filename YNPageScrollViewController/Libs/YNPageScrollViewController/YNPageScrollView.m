//
//  YNPageScrollView.m
//  039_PageScrollView
//
//  Created by ZYN on 16/7/18.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNPageScrollView.h"


#define IPHONE_H [UIScreen mainScreen].bounds.size.height //屏幕的高度

#define IPHONE_W [UIScreen mainScreen].bounds.size.width // 屏幕的宽度


@implementation YNPageScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gestureRecognizerShouldBegin = YES;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
    
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    //是滑动返回距左边的有效长度
    int location_X = 0.15 * IPHONE_W;
    
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            
            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return self.gestureRecognizerShouldBegin;
    
}

@end
