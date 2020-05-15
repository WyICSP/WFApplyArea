//
//  WFShopPublicAPI.m
//  AFNetworking
//
//  Created by YZC on 2019/11/21.
//

#import "WFShopPublicAPI.h"
#import "WFShareWechatView.h"
#import "MMScanViewController.h"
#import "WKTabbarController.h"
#import "WFWithdrawViewController.h"
#import "YFKeyWindow.h"
#import "WKSetting.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@interface WFShopPublicAPI ()
/// 分享
@property (nonatomic, strong, nullable) WFShareWechatView *shareView;
@end

@implementation WFShopPublicAPI

+ (instancetype)shareInstance {
    static WFShopPublicAPI *pApi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pApi = [[WFShopPublicAPI alloc] init];
    });
    return pApi;
}


/**打开分享页面*/
- (void)openShareViewCtrlWithParams:(NSDictionary *)params {

    if ([params isKindOfClass:[NSDictionary class]]) {
        self.shareView.hidden = NO;
        self.shareView.dict = params;
        [UIView animateWithDuration:0.25 animations:^{
            self.shareView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.299];
            self.shareView.y = -200;
        }];
    }
}


#pragma mark get
/// 分享
- (WFShareWechatView *)shareView {
    if (!_shareView) {

        _shareView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShareWechatView" owner:nil options:nil] firstObject];
        _shareView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 200);
        [YFWindow addSubview:_shareView];
    }
    return _shareView;
}

- (NSDictionary *)scanQRCodeWithParams:(NSDictionary *)params {
    self.qrcodeInfo = params;
    return params;
}

- (void)jumpScanCtrl:(void(^)(NSDictionary *codeInfo))resultBlock {
        
    MMScanViewController *scan = [[MMScanViewController alloc] init];
    scan.hidesBottomBarWhenPushed = YES;
    scan.scanInfoBlock = ^(NSDictionary *codeInfo) {
        resultBlock(codeInfo);
    };
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController pushViewController:scan animated:YES];
}

- (void)gotoWithdrawController:(UIViewController *)controller {
    WFWithdrawViewController *withDrawVC = [[WFWithdrawViewController alloc] initWithNibName:@"WFWithdrawViewController" bundle:[NSBundle bundleForClass:[self class]]];
    withDrawVC.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:withDrawVC animated:YES];
}

@end
