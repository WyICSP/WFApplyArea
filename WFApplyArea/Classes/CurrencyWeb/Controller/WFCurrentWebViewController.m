//
//  WFCurrentWebViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/27.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFCurrentWebViewController.h"
#import "WFJSApiTools.h"
#import "WKHelp.h"

@interface WFCurrentWebViewController ()
@end

@implementation WFCurrentWebViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dwebview addJavascriptObject:[[WFJSApiTools alloc] init] namespace:nil];
    self.progressColor = NavColor;
}


@end
