//
//  YNPageScrollViewMenu.h
//  039_PageScrollView
//
//  Created by ZYN on 16/7/13.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNPageScrollViewMenuConfigration.h"

@protocol YNPageScrollViewMenuDelegate <NSObject>
@optional
- (void)pageScrollViewMenuItemOnClick:(UILabel *)label index:(NSInteger)index;

- (void)pageScrollViewMenuAddButtonAction:(UIButton *)button;


@end

@interface YNPageScrollViewMenu : UIView

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) YNPageScrollViewMenuConfigration *configration;

@property (nonatomic, weak) id<YNPageScrollViewMenuDelegate> delegate;



+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)pageScrollViewMenuWithFrame:(CGRect)frame titles:(NSArray *)titlesArray Configration:(YNPageScrollViewMenuConfigration *)configration delegate:(id)delegate currentIndex:(NSInteger)currentIndex;

- (void)adjustItemPositionWithCurrentIndex:(NSInteger)index;

- (void)adjustItemWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex;

- (void)selectedItemIndex:(NSInteger)index animated:(BOOL)animated;

- (void)adjustItemWithAnimated:(BOOL)animated;

@end
