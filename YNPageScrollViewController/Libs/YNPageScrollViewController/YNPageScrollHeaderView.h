//
//  YNHeaderView.h
//  YNPageScrollViewController
//
//  Created by ZYN on 16/8/24.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNPageScrollHeaderViewDelegate <NSObject>

- (void)YNPageScrollHeaderViewHitTest:(BOOL)showGestureBegin;

@end

@interface YNPageScrollHeaderView : UIView

@property (nonatomic, weak) id<YNPageScrollHeaderViewDelegate> delegate;

@end
