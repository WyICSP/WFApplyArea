//
//  WFShopMallWebViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/9/2.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFShopMallWebViewController.h"
#import "WFJSApiTools.h"
#import "WKHelp.h"

@interface WFShopMallWebViewController ()
@end

@implementation WFShopMallWebViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dwebview addJavascriptObject:[[WFJSApiTools alloc] init] namespace:nil];
    self.progressColor = NavColor;
}

@end
