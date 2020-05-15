//
//  WFShopActivityViewController.m
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import "WFShopActivityViewController.h"
#import "IncomeJsApiTest.h"
#import "WKHelp.h"

@interface WFShopActivityViewController ()

@end

@implementation WFShopActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressColor = UIColorFromRGB(0xFF6430);
    
    [self.dwebview addJavascriptObject:[[IncomeJsApiTest alloc] init] namespace:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
