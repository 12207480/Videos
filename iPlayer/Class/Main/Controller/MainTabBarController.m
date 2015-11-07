//
//  MainTabBarController.m
//  CheDealer
//  Created by Zhouwu on 14-9-18.
//  Copyright (c) 2014年 Zhouwu. All rights reserved.
//

#import "MainTabBarController.h"
#import "LocalViewController.h"
#import "NetworkViewController.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>


@end

@implementation MainTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1.0];
    /**设置UITabBar*/
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(171/255.0) green:(68/255.0) blue:(0/255.0) alpha:1.0]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    self.delegate = self;
    //添加所有子控制器
    [self addAllChildVcs];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVcs
{
    // 本地视频
    LocalViewController *localVC=[[LocalViewController alloc]init];
    [self addOneChlildVc:localVC title:@"本地" imageName:@"local" selectedImageName:@""];
    
    // 网络视频
    NetworkViewController *networkVC=[[NetworkViewController alloc]init];
    [self addOneChlildVc:networkVC title:@"网络" imageName:@"network" selectedImageName:@""];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置tabBarItem的普通文字颜色
    //    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    //    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    //    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:(171/255.0) green:(68/255.0) blue:(0/255.0) alpha:1.0];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    //    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

/**处理点击*/
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    UIViewController *vc = [viewController.viewControllers firstObject];
    //    if ([vc isKindOfClass:[AccountController class]]) {
    //        [self.accountVC getTodayCache];
    //        self.receivableVC.isCurrentPage=NO;
    //    }
}

//-(BOOL)shouldAutorotate
//{
//    
//    return NO;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
