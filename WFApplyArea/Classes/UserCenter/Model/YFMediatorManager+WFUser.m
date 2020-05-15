//
//  YFMediatorManager+WFUser.m
//  AFNetworking
//
//  Created by 王宇 on 2019/8/29.
//

#import "YFMediatorManager+WFUser.h"

@implementation YFMediatorManager (WFUser)

+ (void)loginOutByOpenLoginCtrl {
   [self performTarget:@"WFLoginPublicAPI" action:@"loginOutAndJumpLogin" params:nil isRequiredReturnValue:NO];
}

/// 修改密码
+ (void)changePassword {
    [self performTarget:@"WFLoginPublicAPI" action:@"changePassword" params:nil isRequiredReturnValue:NO];
}

+ (void)gotoPayFreightWithParams:(NSDictionary *)params {
    [self performTarget:@"WFPayPublicAPI" action:@"gotoPayWithParams:" params:params isRequiredReturnValue:NO];
}

+ (void)gotoWithdrawController:(UIViewController *)controller {
    [self performTarget:@"WFShopPublicAPI" action:@"gotoWithdrawController:" params:controller isRequiredReturnValue:NO];
}

+ (void)openShareWithParams:(NSDictionary *)params {
    [self performTarget:@"WFShopPublicAPI" action:@"openShareViewCtrlWithParams:" params:params isRequiredReturnValue:NO];
}

+ (NSString *)scanQRCode {
    NSString *msg = [self performTarget:@"WFShopPublicAPI" action:@"jumpScanCtrl:" params:nil isRequiredReturnValue:YES];
    return msg;
}


@end
