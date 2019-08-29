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

@end
