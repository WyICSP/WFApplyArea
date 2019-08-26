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

@implementation WFApplyAreaPublicAPI

/**
 打开片区申请页面
 */
+ (void)openApplyAreaCtrlWithController:(UIViewController *)controller {
    WFMyAreaViewController *area = [[WFMyAreaViewController alloc] init];
    area.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:area animated:YES];
}

/**
 打开我的充电桩
 
 */
+ (void)openMyChargePileCtrlWithController:(UIViewController *)controller {
    WFMyChargePileViewController *area = [[WFMyChargePileViewController alloc] init];
    area.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:area animated:YES];
}

@end