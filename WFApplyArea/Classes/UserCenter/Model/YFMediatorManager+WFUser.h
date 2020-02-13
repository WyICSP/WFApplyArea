//
//  YFMediatorManager+WFUser.h
//  AFNetworking
//
//  Created by 王宇 on 2019/8/29.
//

#import <WFBasics/YFMediatorManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFMediatorManager (WFUser)

/**
 退出登录 打开登录页面
 */
+ (void)loginOutByOpenLoginCtrl;


/// 修改密码
+ (void)changePassword;

/**
 去支付

 @param params 支付相关数据
 */
+ (void)gotoPayFreightWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
