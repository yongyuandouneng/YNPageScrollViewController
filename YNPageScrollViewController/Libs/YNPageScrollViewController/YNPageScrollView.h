//
//  YNPageScrollView.h
//  039_PageScrollView
//
//  Created by ZYN on 16/7/18.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNPageScrollView : UIScrollView

@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) BOOL gestureRecognizerShouldBegin;

@end
