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

@interface WFViewController ()

@end

@implementation WFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
	// Do any additional setup after loading the view, typically from a nib.
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    textField.backgroundColor = UIColor.yellowColor;
    textField.text = @"30";
    [self.view addSubview:textField];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [textField.rightView addSubview:rightView];
    rightView.backgroundColor = UIColor.blueColor;
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    WFMyAreaViewController *area = [[WFMyAreaViewController alloc] init];
//    area.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:area animated:YES];
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:@"shareIcon" bundlerName:@"WFApplyArea.bundle"];
    [WFShareHelpTool shareTextBySystemWithText:@"领取充点券" shareUrl:@"hss" shareImage:[UIImage imageWithContentsOfFile:showImgPath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
