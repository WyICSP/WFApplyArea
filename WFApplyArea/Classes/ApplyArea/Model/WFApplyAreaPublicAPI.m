//
//  WFApplyAreaPublicAPI.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAreaPublicAPI.h"
#import "WFMyAreaViewController.h"
#import "WFMyChargePileViewController.h"
#import "WFCreditPayViewController.h"
#import "WFApplyAreaViewController.h"
#import "WFShareHelpTool.h"

@implementation WFApplyAreaPublicAPI

/**
 打开我的片区页面
 */
+ (void)openApplyAreaCtrlWithController:(NSArray *)params {
    if (params.count == 2) {
        // 获取controller
        UIViewController *controller = params.firstObject;
        // 获取来源
        NSInteger type = [params.lastObject integerValue];
        WFMyAreaViewController *area = [[WFMyAreaViewController alloc] init];
        area.partnerRole = type;
        area.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:area animated:YES];
    }
}

/// 打开申请片区
/// @param controller 当前页面
+ (void)gotoAppleAreaCtrlWithController:(UIViewController *)controller {
    WFApplyAreaViewController *apply = [[WFApplyAreaViewController alloc] init];
    apply.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:apply animated:YES];
}

/**
 打开我的充电桩
 
 */
+ (void)openMyChargePileCtrlWithController:(UIViewController *)controller {
    WFMyChargePileViewController *area = [[WFMyChargePileViewController alloc] init];
    area.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:area animated:YES];
}

/// 打开授信充值页面
+ (void)openCreditPayCtrlWithController:(NSArray *)params {
    if (params.count == 2) {
        // 获取controller
        UIViewController *controller = params.firstObject;
        // 获取来源
        NSInteger type = [params.lastObject integerValue];
        WFCreditPayViewController *cred = [[WFCreditPayViewController alloc] init];
        cred.hidesBottomBarWhenPushed = YES;
        cred.sourceType = type;
        [controller.navigationController pushViewController:cred animated:YES];
    }
    
}

@end
