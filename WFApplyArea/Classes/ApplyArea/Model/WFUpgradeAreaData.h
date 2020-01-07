//
//  WFUpgradeAreaData.h
//  AFNetworking
//
//  Created by 王宇 on 2019/9/19.
//

#import <Foundation/Foundation.h>

@class WFDefaultChargeFeeModel;

//NS_ASSUME_NONNULL_BEGIN

@interface WFUpgradeAreaData : NSObject

/**
 片区 iD
 */
@property (nonatomic, copy) NSString *groupId;

///  是否存在单次收费或者多次收费
@property (nonatomic, assign) BOOL isExistence;

/**
 地址信息
 */
@property (nonatomic, strong) NSDictionary *addressMsg;

/**
 单次收费信息
 */
@property (nonatomic, strong) NSDictionary *singleCharge;

/**
 多次收费
 */
@property (nonatomic, strong) NSArray *multipleChargesList;

/**
 优惠收费
 */
@property (nonatomic, strong) NSDictionary *discountFee;

/**
 收费方式
 */
@property (nonatomic, strong) NSArray *billingPlanIds;

/**
 分成设置
 */
@property (nonatomic, strong) NSArray *partnerPropInfos;

/**
 初始化

 @return 当前对象
 */
+ (instancetype)shareInstance;


/**
 销毁对象
 */
- (void)destructionUpgrade;

@end

//NS_ASSUME_NONNULL_END
