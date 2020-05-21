//
//  WFApplyAreaPublicAPI.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaPublicAPI : NSObject

/**
 打开片区申请页面
 */
+ (void)openApplyAreaCtrlWithController:(NSArray *)params;

/**
 开发我的片区页面
 
 @param controller 上一个页面
 */
+ (void)openMyChargePileCtrlWithController:(UIViewController *)controller;

/// 打开授信充值页面
/// @param NSArray 上一个页面相关数据
+ (void)openCreditPayCtrlWithController:(NSArray *)params;

/// 打开申请片区
/// @param params 参数
+ (void)gotoAppleAreaCtrlWithController:(UIViewController *)controller;


/// 打开社区服务
/// @param controller 控制器
+ (void)gotoCommunityServicePageWithController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
