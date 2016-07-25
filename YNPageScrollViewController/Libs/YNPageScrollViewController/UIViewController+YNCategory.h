//
//  UIViewController+YNCategory.h
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/24.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNPageScrollViewController;

@interface UIViewController (YNCategory)

/** YNPageScrollViewController子类可以直接获取*/
- (YNPageScrollViewController *)ynPageScrollViewController;

@end
