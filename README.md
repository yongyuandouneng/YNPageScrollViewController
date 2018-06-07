# YNPageScrollViewController

### 先上效果图
---

![YNPageScrollViewController] (https://github.com/yongyuandouneng/YNPageScrollViewController/blob/master/GifAndImage/myProject.gif)
![YNPageScrollViewController] (https://github.com/yongyuandouneng/YNPageScrollViewController/blob/master/GifAndImage/Demo.gif)

第一张是集成在项目后的gif，喜欢就start鼓励一下，您在使用过程中有任何问题、出现任何(BUG、Crash)，请加QQ群538133294或联系我的扣扣1003580893.

### 优点
---
* 控制器缓存、控制器生命周期无破坏、性能高
* 菜单样式多样化、易拓展、易集成、易维护

### 支持Pod:
---
pod 'YNPageScrollViewController'

如果发现pod search YNPageScrollViewController 搜索出来的不是最新版本，需要在终端执行cd转换文件路径命令退回到desktop，然后执行pod setup命令更新本地spec缓存（可能需要几分钟），然后再搜索就可以了

### 版本更新:
---
1.0.2：
     修改悬浮式假数据高度、提供线条距离底部、宽度配置、修改其他BUG、修改了缓存机制、新增三个用来操作title和vc的Api。


### 怎么样使用呢？
---

一、统一使用配置信息类YNPageScrollViewMenuConfigration 创建YNPageScrollViewController控制器。控制器可以采用继承/直接使用/作为子类方式。
```objective-c

//简书Demo
- (YNJianShuDemoViewController *)getJianShuDemoViewController{

        //配置信息
        YNPageScrollViewMenuConfigration *configration = [[YNPageScrollViewMenuConfigration alloc]init];
        configration.scrollViewBackgroundColor = [UIColor redColor];
        configration.itemLeftAndRightMargin = 30;
        configration.lineColor = [UIColor orangeColor];
        configration.lineHeight = 2;
        configration.itemMaxScale = 1.2;
        configration.pageScrollViewMenuStyle = YNPageScrollViewMenuStyleSuspension;
        configration.scrollViewBackgroundColor = [UIColor whiteColor];
        configration.selectedItemColor = [UIColor redColor];
        //设置平分不滚动   默认会居中
        configration.aligmentModeCenter = NO;
        configration.scrollMenu = NO;
        configration.showGradientColor = NO;//取消渐变
        configration.showNavigation = YES;
        configration.showTabbar = YES;//设置显示tabbar

        //创建控制器
        YNJianShuDemoViewController *vc = [YNJianShuDemoViewController pageScrollViewControllerWithControllers:[self getViewController] titles:@[@"最新收录",@"最新评论",@"热门",@"更多",@"第一个界面",@"第二个界面",@"第三个界面",@"第四个界面"] Configration:configration];
        //头部视图
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        imageView.image = [UIImage imageNamed:@"QYPPMyContributeListHead"];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)]];

        //footer用来当做内容高度
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        vc.placeHoderView = footerView;

        vc.dataSource = self;
        vc.headerView = imageView;

        return vc;
}
```

(1) 悬浮样式
    
    1.配置样式为YNPageScrollViewMenuStyleSuspension.
    
    2.悬浮样式创建时候如果需要headerView则需要在外面统一提供headerView，footerView也要提供用来充当里面的内容高度。具体请看上面的OC代码。
    
    3.还需要设置数据源提供三个数据源的方法。
    
    4.目前只支持里面的内容是UITableView或UITableViewController，并且不能有FooterView.
    
    5.在[self.tableView reloadData]后,需要调用刷新footerView的方法以计算需要填充的内容高度。[self.ynPageScrollViewController reloadPlaceHoderViewFrame];
    
    6.具体请看上面的简书Demo代码.

(2) 导航条样&顶部样式
    
    1. 设置样式为YNPageScrollViewMenuStyleNavigation(导航条)、样式YNPageScrollViewMenuStyleTop(顶部).
    
    2. 实现数据源的一个方法返回ScrollView数据
    
    3. 内容支持UITableView、UITableViewController、UICollectionViewController
    
    4. 具体看Demo代码.
    

