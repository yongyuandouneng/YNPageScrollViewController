//
//  AppDelegate.m
//  YNPageScrollViewController
//
//  Created by ZYN on 16/7/19.
//  Copyright © 2016年 Yongneng Zheng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    UITableView.appearance.estimatedRowHeight = 0;
    UITableView.appearance.estimatedSectionHeaderHeight = 0;
    UITableView.appearance.estimatedSectionFooterHeight = 0;
    
    return YES;
}

@end
