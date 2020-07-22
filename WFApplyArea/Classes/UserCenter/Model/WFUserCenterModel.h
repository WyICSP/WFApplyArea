//
//  WFUserCenterModel.h
//  AFNetworking
//
//  Created by 王宇 on 2020/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFUserCenterModel : NSObject
/// 活动金
@property (nonatomic, strong) NSNumber *activityPrice;
/// 合伙人
@property (nonatomic, assign) NSInteger adminNum;
/// 点哈
@property (nonatomic, copy) NSString *mobile;
/// 昵称
@property (nonatomic, copy) NSString *nickname;
/// 头像
@property (nonatomic, copy) NSString *headUrl;
/// 余额
@property (nonatomic, copy) NSString *price;
/// 是否是管理合伙人
@property (nonatomic, assign) BOOL isManager;
@end

@interface WFMineCustomerServicModel : NSObject
/// 在线客服
@property (nonatomic, copy) NSString *customerServiceUrl;
/// 电话
@property (nonatomic, copy) NSString *customerMobile;
@end

NS_ASSUME_NONNULL_END
