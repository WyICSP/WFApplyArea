//
//  WFViewController.m
//  WFApplyArea
//
//  Created by wyxlh on 08/05/2019.
//  Copyright (c) 2019 wyxlh. All rights reserved.
//

#import "WFViewController.h"
#import "WFMyAreaViewController.h"
#import "WFShareHelpTool.h"
#import "NSString+Regular.h"
#import "WFGatewayListView.h"
#import "WKHelp.h"

//#import "WFNeedReplaceGatewayView.h"
#import "WFShareWechatView.h"
#import "WFNRReplaceGatewayListView.h"

@interface WFViewController ()
@property (nonatomic,strong) NSArray *array1;
@property (nonatomic,strong) NSMutableArray *array2;
/// 替换网关 view
@property (nonatomic, strong, nullable) WFNRReplaceGatewayListView *gatewayView;
@property (nonatomic, strong, nullable) WFShareWechatView *shareview;
@end

@implementation WFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.redColor;
	// Do any additional setup after loading the view, typically from a nib.
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
//    textField.backgroundColor = UIColor.yellowColor;
//    textField.text = @"30";
//    [self.view addSubview:textField];
//
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    [textField.rightView addSubview:rightView];
//    rightView.backgroundColor = UIColor.blueColor;
//
//
//    self.array1 = @[@"1",@"2",@"3",@"4"];
//    self.array2 = self.array1.mutableCopy;
//
//    NSString *num = self.array1.firstObject;
//    num = @"33";
//    NSLog(@"%@",self.array2);
    
    [self addRightTitleBtn:@"ceshi"];
    
    WFGatewayListView *list = [[WFGatewayListView alloc] init];
    list.tag = 10;
    list.frame = CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - TabbarHeight - NavHeight);
    
    [self.view addSubview:list];
    
    
}

- (void)rightTitleButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    WFGatewayListView *list = [self.view viewWithTag:10];
    list.index = sender.selected ? 1 : 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    WFMyAreaViewController *area = [[WFMyAreaViewController alloc] init];
//    area.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:area animated:YES];
//    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
//    NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:@"shareIcon" bundlerName:@"WFApplyArea.bundle"];
//    [WFShareHelpTool shareTextBySystemWithText:@"领取充点券" shareUrl:@"hss" shareImage:[UIImage imageWithContentsOfFile:showImgPath]];
//    [self showGatewayView];
//    [self showShareView];
}

- (void)showGatewayView {
    self.gatewayView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.gatewayView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.299];
        self.gatewayView.y = -400;
    }];
}

- (void)showShareView {
    self.shareview.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.shareview.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.299];
        self.shareview.y = -400;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 替换网关
- (WFNRReplaceGatewayListView *)gatewayView {
    if (!_gatewayView) {
        _gatewayView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNRReplaceGatewayListView" owner:nil options:nil] firstObject];
        _gatewayView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 400.0f);
        [YFWindow addSubview:_gatewayView];
    }
    return _gatewayView;
}
///// 替换网关
//- (WFShareWechatView *)shareview {
//    if (!_shareview) {
//        _shareview = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShareWechatView" owner:nil options:nil] firstObject];
//        _shareview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 400.0f);
//        [YFWindow addSubview:_shareview];
//    }
//    return _shareview;
//}

@end
