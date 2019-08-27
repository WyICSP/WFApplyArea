//
//  WFAppDelegate.m
//  WFApplyArea
//
//  Created by wyxlh on 08/05/2019.
//  Copyright (c) 2019 wyxlh. All rights reserved.
//
 #define  key  @"CFBundleShortVersionString"

#import "WFAppDelegate.h"
#import "WFMyAreaViewController.h"
#import "YFMainPublicModelAPI.h"
#import "WFViewController.h"
#import "WFLoginViewController.h"
#import <WFKitLogin/WFLoginPublicAPI.h>
#import "NSString+Regular.h"
#import "WKNavigationController.h"
#import "WFUserCenterViewController.h"
#import "WFHomeViewController.h"
#import "UserData.h"
#import "IQKeyboardManager.h"
#import "WKHelp.h"

@implementation WFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self createTabbar];
    [self configureKeyboardManager];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 创建tabbar
-(void)createTabbar{
    
    //去掉导航栏的黑线
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //创建window
    UIWindow *window                         = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window                              = window;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults                 = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion                    = [defaults stringForKey:key];
    // 获得当前软件的版本号
    NSString *currentVersion                 = [NSString getAppVersion];
    if ([lastVersion isEqualToString:currentVersion]){
        //如果没有登录
        if ([UserData isUserLogin]) {
            UITabBarController *rootVC        = [YFMainPublicModelAPI rootTabBarCcontroller];
            [YFMainPublicModelAPI addChildVC:[WFHomeViewController new] normalImageName:@"" selectedImageName:@"" title:@"登录"];
            [YFMainPublicModelAPI addChildVC:[WFMyAreaViewController new] normalImageName:@"" selectedImageName:@"" title:@"我的片区"];
            [YFMainPublicModelAPI addChildVC:[WFUserCenterViewController new] normalImageName:@"" selectedImageName:@"" title:@"我的"];
            [YFMainPublicModelAPI setGlobalBackGroundColor:[UIColor whiteColor]];
            [YFMainPublicModelAPI setNarBarGlobalTextColor:[UIColor blackColor] andFontSize:18];
            
            [self.window setRootViewController:rootVC];
        }else{
            WFLoginViewController *login      = [WFLoginPublicAPI rootLoginViewController];
            self.window.rootViewController    = [[WKNavigationController alloc] initWithRootViewController:login];
        }
    }else{
        WFLoginViewController *login         = [WFLoginPublicAPI rootLoginViewController];
        self.window.rootViewController       = [[WKNavigationController alloc] initWithRootViewController:login];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
    
    [self.window makeKeyAndVisible];
    
}

#pragma mark - 键盘管理对象
- (void)configureKeyboardManager{
    // 获取类库的单例变量
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    keyboardManager.enable = YES;
    // 控制点击背景是否收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.shouldToolbarUsesTextFieldTintColor = NO;
    // 设置工具条颜色
    keyboardManager.toolbarTintColor = NavColor;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 控制是否显示键盘上的工具条
    keyboardManager.enableAutoToolbar = NO;
    // 是否显示占位文字
    keyboardManager.shouldShowToolbarPlaceholder = NO;
}

@end
