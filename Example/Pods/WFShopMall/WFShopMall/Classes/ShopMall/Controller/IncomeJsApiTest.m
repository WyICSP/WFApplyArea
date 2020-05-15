//
//  IncomeJsApiTest.m
//  AFNetworking
//
//  Created by YZC on 2019/11/13.
//

#import "IncomeJsApiTest.h"
#import "WFWithdrawViewController.h"
#import "YFKeyWindow.h"
#import "dsbridge.h"
#import "UserData.h"
#import "WKHelp.h"
#import "WFWithdrawViewController.h"
#import "WFShopPublicAPI.h"
#import "WKTabbarController.h"

@implementation IncomeJsApiTest

/**跳转到提现页面*/
- (void)gotoWithdrawController:(NSString *)msg :(JSCallback) completionHandler{
    
    WFWithdrawViewController *withDrawVC = [[WFWithdrawViewController alloc] initWithNibName:@"WFWithdrawViewController" bundle:[NSBundle bundleForClass:[self class]]];
    withDrawVC.hidesBottomBarWhenPushed = YES;
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController pushViewController:withDrawVC animated:YES];
    completionHandler(msg,YES);
    
}


/**返回*/
- (void)goBack:(NSString *)msg :(JSCallback)completionHandler{

        // 如果用户提现成功 就返回到根视图
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"withdeawToRoot"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"withdeawToRoot"];
//        [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
//           completionHandler(msg,YES);
//
//    }else{
        [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popViewControllerAnimated:YES];
        completionHandler(msg,YES);
//    }
}

/// 提现成功后返回并刷新页面
- (void)goBackToRoot:(NSString *)msg :(JSCallback)completionHandler {
    [YFNotificationCenter postNotificationName:@"reloadServiceKeys" object:nil];
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popToRootViewControllerAnimated:YES];
    completionHandler(msg,YES);
}

/**分享*/
- (void)openProfit:(NSDictionary *)msg :(JSCallback) completionHandler
{
    WFShopPublicAPI *api = [[WFShopPublicAPI alloc] init];
    [api openShareViewCtrlWithParams:msg];
    completionHandler(@"",YES);
    
}

/**判断时候隐藏当前导航栏*/
- (void)showNativeTitle:(BOOL )msg :(JSCallback) completionHandler{
    if (!msg) {
        [[NSNotificationCenter defaultCenter ]postNotificationName:@"showNativeTitle" object:nil];
    }
    completionHandler(@"",YES);
}

/** 获取版本号*/
- (NSString *)getAppVersion:(NSString *)msg {
    return APP_VERSION;
}

/**UUID*/
- (NSString *)getUserId:(NSString *)msg {
    return [UserData userInfo].uuid;
}

/**扫描二维码*/
- (void)scanQRCode:(NSDictionary *)msg :(JSCallback) completionHandler
{
    [[WFShopPublicAPI shareInstance] jumpScanCtrl:^(NSDictionary * _Nonnull codeInfo) {
        [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popViewControllerAnimated:NO];
        completionHandler(codeInfo,YES);
    }];
}

/**联系客服*/
- (void)phoneCilck:(NSString *)msg :(JSCallback) completionHandler
{
    NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",msg];
    if (msg.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    }
    completionHandler(msg,YES);
}

@end
