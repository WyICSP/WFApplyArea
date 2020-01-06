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

@end
