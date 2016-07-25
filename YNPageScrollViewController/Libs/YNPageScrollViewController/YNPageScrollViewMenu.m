//
//  YNPageScrollViewMenu.m
//  039_PageScrollView
//
//  Created by ZYN on 16/7/13.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "YNPageScrollViewMenu.h"
#import "UIView+YNCategory.h"

#define converMarginX 5
#define converMarginW 10

@interface YNPageScrollViewMenu ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *converView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *itemsArrayM;

@property (nonatomic, strong) NSMutableArray *itemsWidthArraM;

@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, assign) NSInteger currentIndex;

@end


@implementation YNPageScrollViewMenu

+ (instancetype)pageScrollViewMenuWithFrame:(CGRect)frame titles:(NSArray *)titlesArray Configration:(YNPageScrollViewMenuConfigration *)configration delegate:(id)delegate currentIndex:(NSInteger)currentIndex{

   return [[YNPageScrollViewMenu alloc] initPageScrollViewMenuWithFrame:frame titles:titlesArray Configration:configration delegate:delegate currentIndex:currentIndex];

}

- (instancetype)initPageScrollViewMenuWithFrame:(CGRect)frame titles:(NSArray *)titlesArray Configration:(YNPageScrollViewMenuConfigration *)configration delegate:(id)delegate currentIndex:(NSInteger)currentIndex{
    self.currentIndex = currentIndex;
    self.titlesArray = titlesArray;
    self.configration = configration ? configration : [YNPageScrollViewMenuConfigration pageScrollViewMenuConfigration];
    self.delegate = delegate;
    if (self.configration.menuHeight > 0) {
        frame.size.height = self.configration.menuHeight;
    }
    self = [super initWithFrame:frame];

    if (self) {
       
        [self initMenuItems];
        [self configUI];
        
    }
    return self;
    
}


- (void)initMenuItems{
    
    [self.titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UILabel *itemLabel = [[UILabel alloc]init];
        itemLabel.font = self.configration.itemFont;
        itemLabel.textColor = self.configration.normalItemColor;
        itemLabel.text = title;
        itemLabel.tag = idx;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.userInteractionEnabled = YES;
        
        [itemLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemLabelTapOnClick:)]];
        
        CGFloat width = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : itemLabel.font} context:nil].size.width;
        
        [self.itemsWidthArraM addObject:@(width)];
        [self.itemsArrayM addObject:itemLabel];
        [self.scrollView addSubview:itemLabel];
    }];
    
}

- (void)configUI{
    
    //scrollView
    self.scrollView.frame = CGRectMake(0, 0, self.configration.showAddButton ? self.yn_width - self.yn_height : self.yn_width, self.yn_height);
    
    [self addSubview:self.scrollView];
    
    //addButton
    if (self.configration.showAddButton) {
        self.addButton.frame = CGRectMake(self.yn_width - self.yn_height, 0, self.yn_height, self.yn_height);
        [self addSubview:self.addButton];
    }
    
    //item
    __block CGFloat itemX = 0;
    __block CGFloat itemY = 0;
    __block CGFloat itemW = 0;
    __block CGFloat itemH = self.yn_height - self.configration.lineHeight;
    
    [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                itemX += self.configration.itemLeftAndRightMargin;
            }else{
                itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
            }
            label.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);

    }];
    
        CGFloat scrollSizeWidht = self.configration.itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]);
        if (scrollSizeWidht < self.scrollView.yn_width) {//不超出宽度
            itemX = 0;
            itemY = 0;
            itemW = 0;
            
            CGFloat left = 0;
            
            for (NSNumber *width in self.itemsWidthArraM) {
                left += [width floatValue];
            }
            
            left = (self.scrollView.yn_width - left - self.configration.itemMargin * (self.itemsWidthArraM.count-1)) * 0.5;
            if (self.configration.aligmentModeCenter && left >= 0) {//居中且有剩余间距
   
                self.configration.itemLeftAndRightMargin = left;
                
                [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (idx == 0) {
                            itemX += self.configration.itemLeftAndRightMargin;
                    }else{
                        itemX += self.configration.itemMargin + [self.itemsWidthArraM[idx - 1] floatValue];
                    }
                        label.frame = CGRectMake(itemX, itemY, [self.itemsWidthArraM[idx] floatValue], itemH);
                }];
                
                self.scrollView.contentSize = CGSizeMake(self.configration.itemLeftAndRightMargin + CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
                
            }else{//否则按原来样子
                if (!self.configration.scrollMenu) {//不能滚动则平分
                    [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * label, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        itemW = self.scrollView.yn_width / self.itemsArrayM.count;
                        itemX = itemW *idx;
                        label.frame = CGRectMake(itemX, itemY, itemW, itemH);
                    }];
                    
                    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([[self.itemsArrayM lastObject] frame]), self.scrollView.yn_height);
                    
                }else{
                    self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
                }
            }
        }else{//大于scrollView的width·
            self.scrollView.contentSize = CGSizeMake(scrollSizeWidht, self.scrollView.yn_height);
        }
    
    CGFloat lineX = [(UILabel *)[self.itemsArrayM firstObject] yn_x];
    CGFloat lineY = self.scrollView.yn_height - self.configration.lineHeight;
    CGFloat lineW = [[self.itemsArrayM firstObject] yn_width];
    CGFloat lineH = self.configration.lineHeight;
    
    //conver
    if (self.configration.showConver) {
        
        self.converView.frame = CGRectMake(lineX - converMarginX, (self.scrollView.yn_height - self.configration.converHeight - self.configration.lineHeight) * 0.5, lineW + converMarginW, self.configration.converHeight);
        [self.scrollView insertSubview:self.converView atIndex:0];
    }
    
    if (self.configration.showScrollLine) {
        self.lineView.frame = CGRectMake(lineX, lineY, lineW, lineH);
        [self.scrollView addSubview:self.lineView];
    }
    
    if (self.configration.itemMaxScale > 1) {
        ((UILabel *)self.itemsArrayM[0]).transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
    }
    
    [self selectedItemIndex:self.currentIndex animated:NO];
    
}


#pragma mark - Action

- (void)itemLabelTapOnClick:(UITapGestureRecognizer *)tapGresture{
    
    UILabel *label = (UILabel *)tapGresture.view;
    
    self.currentIndex= label.tag;
    
    [self adjustItemWithAnimated:YES];
}

#pragma mark - Publick Method

- (void)selectedItemIndex:(NSInteger)index animated:(BOOL)animated{
    
    self.currentIndex = index;
    
    [self adjustItemAnimate:animated];
}

- (void)adjustItemWithAnimated:(BOOL)animated{
    
    if (self.lastIndex == self.currentIndex) return;
  
    [self adjustItemAnimate:animated];
}

- (void)adjustItemAnimate:(BOOL)animated{
    
    UILabel *lastLabel = self.itemsArrayM[self.lastIndex];
    UILabel *currentLabel = self.itemsArrayM[self.currentIndex];
    
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        //缩放
        if (self.configration.itemMaxScale > 1) {
            lastLabel.transform = CGAffineTransformMakeScale(1, 1);
            currentLabel.transform = CGAffineTransformMakeScale(self.configration.itemMaxScale, self.configration.itemMaxScale);
        }
        //颜色
        [self.itemsArrayM enumerateObjectsUsingBlock:^(UILabel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.textColor = self.configration.normalItemColor;
            if (idx == self.itemsArrayM.count - 1) {
                currentLabel.textColor = self.configration.selectedItemColor;
            }
        }];
        
        //线条
        if (self.configration.showScrollLine) {
            self.lineView.yn_x = currentLabel.yn_x;
            self.lineView.yn_width = currentLabel.yn_width;
        }
        //遮盖
        if (self.configration.showConver) {
            self.converView.yn_x = currentLabel.yn_x - converMarginX;
            self.converView.yn_width = currentLabel.yn_width +converMarginW;
        }
        
        self.lastIndex = self.currentIndex;
        
        
    }completion:^(BOOL finished) {
        [self adjustItemPositionWithCurrentIndex:self.currentIndex];
    }];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pageScrollViewMenuItemOnClick:index:)]) {
        [self.delegate pageScrollViewMenuItemOnClick:currentLabel index:self.lastIndex];
    }
    
}

- (void)adjustItemWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex{
    self.lastIndex = lastIndex;
    self.currentIndex = currentIndex;
    
    if (lastIndex == currentIndex) return;
    UILabel *lastLabel = self.itemsArrayM[self.lastIndex];
    UILabel *currentLabel = self.itemsArrayM[self.currentIndex];
    
    //缩放系数
    if (self.configration.itemMaxScale > 1) {
        CGFloat scaleB = self.configration.itemMaxScale - self.configration.deltaScale * progress;
        CGFloat scaleS = 1 + self.configration.deltaScale * progress;
        lastLabel.transform = CGAffineTransformMakeScale(scaleB, scaleB);
        currentLabel.transform = CGAffineTransformMakeScale(scaleS, scaleS);
    }
    
    if (self.configration.showGradientColor) {
      
        //颜色渐变
        [self.configration setRGBWithProgress:progress];
        
        lastLabel.textColor = [UIColor colorWithRed:self.configration.deltaNorR green:self.configration.deltaNorG blue:self.configration.deltaNorB alpha:1];
        
        currentLabel.textColor = [UIColor colorWithRed:self.configration.deltaSelR green:self.configration.deltaSelG blue:self.configration.deltaSelB alpha:1];
    }else{
        if (progress > 0.5) {
            lastLabel.textColor = self.configration.normalItemColor;
            currentLabel.textColor = self.configration.selectedItemColor;
        }else if (progress < 0.5 && progress > 0){
            lastLabel.textColor = self.configration.selectedItemColor;
            currentLabel.textColor = self.configration.normalItemColor;
        }
    }
    
    CGFloat xD = currentLabel.yn_x - lastLabel.yn_x;
    CGFloat wD = currentLabel.yn_width - lastLabel.yn_width;
            
    //线条
    if (self.configration.showScrollLine) {
        self.lineView.yn_x = lastLabel.yn_x + xD *progress;
        self.lineView.yn_width = lastLabel.yn_width + wD *progress;
    }
    //遮盖
    if (self.configration.showConver) {
        self.converView.yn_x = lastLabel.yn_x + xD *progress - converMarginX;
        self.converView.yn_width = lastLabel.yn_width  + wD *progress + converMarginW;
    }
}


- (void)adjustItemPositionWithCurrentIndex:(NSInteger)index{
    
    
    
    
    if (self.scrollView.contentSize.width != self.scrollView.yn_width + 20) {
        
        UILabel *label = self.itemsArrayM[index];
        
        CGFloat offSex = label.center.x - self.scrollView.yn_width * 0.5;
        
        offSex = offSex > 0 ? offSex : 0;
        
        CGFloat maxOffSetX = self.scrollView.contentSize.width - self.scrollView.yn_width;
        
        maxOffSetX = maxOffSetX > 0 ? maxOffSetX : 0;
        
        offSex = offSex > maxOffSetX ? maxOffSetX : offSex;
        
        [self.scrollView setContentOffset:CGPointMake(offSex, 0) animated:YES];
        
    }
}

#pragma mark - lazy
//线条
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = self.configration.lineColor;
    }
    return _lineView;
}

//遮盖
- (UIView *)converView{
    
    if (!_converView) {
        _converView = [[UIView alloc] init];
        _converView.layer.backgroundColor = self.configration.converColor.CGColor;
        _converView.layer.cornerRadius = self.configration.coverCornerRadius;
        _converView.layer.masksToBounds = YES;
        _converView.userInteractionEnabled = NO;
    }
    return _converView;
    
}
//滚动
- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = self.configration.bounces;
        _scrollView.backgroundColor = self.configration.scrollViewBackgroundColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = self.configration.scrollMenu;
    }
    return _scrollView;
}
//按钮
- (UIButton *)addButton{
    
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configration.addButtonNormalImageName] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage imageNamed:self.configration.addButtonHightImageName] forState:UIControlStateHighlighted];
        _addButton.layer.shadowColor = [UIColor grayColor].CGColor;
        _addButton.layer.shadowOffset = CGSizeMake(-1, 0);
        _addButton.layer.shadowOpacity = 0.5;
        _addButton.backgroundColor = self.configration.addButtonBackgroundColor;
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
    
}

#pragma mark -  addButtonAction
- (void)addButtonAction:(UIButton *)button{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(pageScrollViewMenuAddButtonAction:)]){
        
        [self.delegate pageScrollViewMenuAddButtonAction:button];
        
    }
}
- (NSMutableArray *)itemsArrayM{
    
    if (!_itemsArrayM) {
        _itemsArrayM = [[NSMutableArray alloc]initWithCapacity:self.titlesArray.count];
    }
    return _itemsArrayM;
    
}

- (NSMutableArray *)itemsWidthArraM{
    
    if (!_itemsWidthArraM) {
        _itemsWidthArraM = [[NSMutableArray alloc]initWithCapacity:self.titlesArray.count];
    }
    return _itemsWidthArraM;
    
}

@end
