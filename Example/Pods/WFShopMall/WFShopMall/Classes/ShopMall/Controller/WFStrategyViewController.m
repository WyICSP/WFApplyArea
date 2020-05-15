//
//  WFStrategyViewController.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFStrategyViewController.h"
#import "WKHelp.h"
@interface WFStrategyViewController ()

@end

@implementation WFStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修复bug
    self.dwebview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight);
    self.title = @"邀请攻略";
}


@end
