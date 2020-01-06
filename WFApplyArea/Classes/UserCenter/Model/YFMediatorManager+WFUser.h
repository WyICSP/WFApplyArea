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

@end

NS_ASSUME_NONNULL_END
