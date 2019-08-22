//
//  WFApplyAreaDataTool.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMyAreaListModel;
@class WFMyAreaQRcodeModel;
@class WFMyAreaDividIntoSetModel;
@class WFApplyChargeMethod;
@class WFBillMethodModel;
@class WFDefaultChargeFeeModel;
@class WFDefaultDiscountModel;
@class WFDefaultManyTimesModel;
@class WFBillingPriceMethodModel;
@class WFPowerIntervalModel;
@class WFProfitTableModel;
@class WFAreaDetailModel;
@class WFGroupVipUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaDataTool : NSObject

#pragma mark 申请片区
/**
 获取申请片区接口

 @param params 参数
 @param resultBlock 返回数据
 @param failBlock 失败数据
 */
+ (void)getMyApplyAreaListWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(NSArray<WFMyAreaListModel *> *models))resultBlock
                           failBlock:(void(^)(void))failBlock;


/**
 获取片区二维码

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getAreaQRcodeWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(WFMyAreaQRcodeModel *model))resultBlock;



#pragma mark 收费方式接口
/**
 获取收费信息

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getChargeMethodWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(NSArray <WFApplyChargeMethod *> *models))resultBlock;

#pragma mark 分成设置
/**
 获取默认分成设置

 @param params 参数
 @param resultBlock 返回数据
 */
+ (void)getUserDividintoSetWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFMyAreaDividIntoSetModel *> *models))resultBlock;


/**
 根据片区 Id 获取合伙人分成设置

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getUserDividIntoSetByGroupIdWithParams:(NSDictionary *)params
                                   resultBlock:(void(^)(NSArray <WFMyAreaDividIntoSetModel *> *models))resultBlock;


/**
 更新分成设置信息

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateDividIntoSetWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock;


#pragma mark 优惠收费相关接口
/**
 添加vip手机号

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)addDiscountUserWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock;


/**
 修改 vip 手机号相关信息

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateDiscountUserWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock;


/**
 根据片区 id 获取相关 vip 用户

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getVipUserWithParams:(NSDictionary *)params
                 resultBlock:(void(^)(NSArray <WFGroupVipUserModel *> *models))resultBlock;


#pragma mark 获取计费方式
/**
 获取计费方式

 @param params 参数
 @param resultBlock 返回数据
 */
+ (void)getBillingMethodWithParams:(NSDictionary *)params
                       resultBlock:(void(^)(WFBillMethodModel *models))resultBlock;


/**
 添加计费方式

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)addBillingMethodWithParams:(NSDictionary *)params
                       resultBlock:(void(^)(WFBillingPriceMethodModel *models))resultBlock;


#pragma mark 获取默认收费方式
/**
 获取单次默认收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getDefaultSingleChargeWithParams:(NSDictionary *)params
                             resultBlock:(void(^)(NSArray <WFDefaultChargeFeeModel *>*models))resultBlock;


/**
 获取多次默认收费
 
 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getDefaultManyTimesChargeWithParams:(NSDictionary *)params
                             resultBlock:(void(^)(WFDefaultManyTimesModel *models))resultBlock;


/**
 获取优惠默认收费
 
 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getDefaultDisCountChargeWithParams:(NSDictionary *)params
                             resultBlock:(void(^)(NSArray<WFDefaultDiscountModel *> *models))resultBlock;



/**
 获取查看功率区间表

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getPowerIntervalTableWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(NSArray <WFPowerIntervalModel *> *models))resultBlock;


/**
 查看利润区间

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getProfitTableWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(NSArray <WFProfitTableModel *> *models))resultBlock;


#pragma mark 申请片区

/**
 申请片区接口

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)applyAreaWithParams:(NSDictionary *)params
                resultBlock:(void(^)(void))resultBlock;


/**
 获取片区详情接口

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getAreaDetailWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(WFAreaDetailModel *models))resultBlock;


#pragma mark  编辑计费方式 和收费方式
/**
 编辑计费方式

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateChargingMethodWithParams:(NSDictionary *)params
                           resultBlock:(void(^)(void))resultBlock;


/**
 修改 VIP收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateVipCollectFeeWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(void))resultBlock;


/**
 修改单次收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateSingleFeeWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock;


/**
 修改多次收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)updateManyTimeFeeWithPamrams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock;


#pragma mark 删除多次收费 和单次收费

/**
 删除多次收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)deleteManyTimeFeeWithParams:(NSDictionary *)params
                        resultBlock:(void(^)(void))resultBlock;


/**
 删除单次收费

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)deleteVipChargeFeeWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock;


@end

NS_ASSUME_NONNULL_END
