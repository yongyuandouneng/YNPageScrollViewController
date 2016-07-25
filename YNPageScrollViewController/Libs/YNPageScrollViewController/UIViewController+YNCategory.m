//
//  UIViewController+YNCategory.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/24.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "UIViewController+YNCategory.h"
#import "YNPageScrollViewController.h"

@implementation UIViewController (YNCategory)


- (YNPageScrollViewController *)ynPageScrollViewController{
    
    if (self.parentViewController && [self.parentViewController isKindOfClass:[YNPageScrollViewController class]]) {
        return (YNPageScrollViewController *)self.parentViewController;
    }
    return nil;

}


@end
