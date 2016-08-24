//
//  YNPageScrollView.m
//  039_PageScrollView
//
//  Created by ZYN on 16/7/18.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNPageScrollView.h"

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
    // iOS横向滚动的scrollView和系统pop手势返回冲突的解决办法:     http://blog.csdn.net/hjaycee/article/details/49279951
    
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //MARK: UITableViewCell 自定义手势可能要在此处自行定义
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    
    return self.gestureRecognizerShouldBegin;
}

@end
