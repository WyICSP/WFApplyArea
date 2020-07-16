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

/// 跳转到提现页面
/// @param controller 当前页面
+ (void)gotoWithdrawController:(UIViewController *)controller;

/// 打开分享
/// @param params 参数
+ (void)openShareWithParams:(NSDictionary *)params;

/// 扫描二维码
+ (NSString *)scanQRCode;

/// 打开地图
+ (void)openChooseMap;

@end

NS_ASSUME_NONNULL_END
