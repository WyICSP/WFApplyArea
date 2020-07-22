//
//  WFMyChargePileDataTool.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFMyChargePileModel;
@class WFAbnormalPileListModel;
@class WFSignleIntensityListModel;
@class WFCreditPayModel;
@class WFCheditPayMothedModel;
@class WFUserCenterModel;
@class WFMineCustomerServicModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyChargePileDataTool : NSObject

/**
 我的片区

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getMyChargePileWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(WFMyChargePileModel *models))resultBlock;


/**
 获取异常充电桩

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getAbnormalPileListWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFAbnormalPileListModel *> *models))resultBlock;


/**
 获取信号强度

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)getAreaPilesignalIntensitWithParams:(NSDictionary *)params
                                resultBlock:(void(^)(NSArray <WFSignleIntensityListModel *> *models))resultBlock;



#pragma mark 上传头像接口
/**
 上传头像

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)uploadModHeadWithParams:(NSDictionary *)params
                    resultBlock:(void (^)(NSString *str))resultBlock;

/**
 上传图片

 @param params 参数
 @param photoImage 图片对象
 @param resultBlock 返回的链接
 */
+ (void)uploadFileWithParams:(NSDictionary *)params
                    photoImage:(UIImage *)photoImage
                    resultBlock:(void(^)(NSString *str))resultBlock;

#pragma mark  授信相关接口
/// 授信接口
/// @param params 参数
/// @param resultBlock 返回数据
+ (void)adminCreditTemplateWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(WFCreditPayModel *models))resultBlock;


/// 授信充值
/// @param params 参数
/// @param resultBlock 返回数据
/// @param changeBlock 价格改变 block
+ (void)addAdminCreditTemplAteadminDepositWithParams:(NSDictionary *)params
                                         resultBlock:(void(^)(WFCheditPayMothedModel *models))resultBlock
                                         changeBlock:(void(^)(NSInteger money))changeBlock;


/// 获取个人中心数据
/// @param params 参数
/// @param resultBlock 返回
+ (void)getUserInfoWithParams:(NSDictionary *)params
                  resultBlock:(void(^)(WFUserCenterModel *models))resultBlock
                    failBlock:(void(^)(void))failBlock;



/// 获取客服联系方式
/// @param params 参数
/// @param resultBlock 返回结构
+ (void)getCustomerServiceWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(WFMineCustomerServicModel *cModel))resultBlock;

@end

NS_ASSUME_NONNULL_END
