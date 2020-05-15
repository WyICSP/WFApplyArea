//
//  WFShopDataTool.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WFProductListModel;
@class WFWithdrawModel;
@class WFShopActivityModel;
@class WFShopRebateStatisticsModel;
@interface WFShopDataTool : NSObject

#pragma mark 获取导购券商品列表数据
/// 获取导购券数据
/// @param params 参数
/// @param resultBlock 返回结果
+ (void)getShopMallProductsListWithParams:(NSDictionary *)params
                              resultBlock:(void(^)(NSArray <WFProductListModel *> *models))resultBlock failBlock:(void(^)(void))failBlock;


/// 获取分享批次号 分享前调用
/// @param params 参数
/// @param resultBlock 返回结果
+ (void)getShareNumWithParams:(NSDictionary *)params
                  resultBlock:(void(^)(NSString *ticketId))resultBlock;



#pragma mark- 提现

/**
获取绑定信息和 可提现余额
@param params 参数
@param resultBlock 返回结果
*/
+ (void)getWithdrawDataWithParams:(NSDictionary *)params
                      resultBlock:(void(^)( WFWithdrawModel *model))resultBlock
                        failBlock:(void(^)(void))failBlock;







/**
 绑定支付宝发送验证码

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)bindAlipaySendCodeWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock;




/**
 绑定支付宝

 @param params 参数
 @param resultBlock 返回结果
 */
+ (void)bindAlipayWithParams:(NSDictionary *)params
                 resultBlock:(void(^)(void))resultBlock;






/**提现
 @param params 参数
 @param resultBlock 返回结果
 */

+ (void)WithdrawWithParams:(NSDictionary *)params
                      resultBlock:(void(^)( NSDictionary *detailDic))resultBlock
                        failBlock:(void(^)(void))failBlock;





/**
 双十二活动 获取商城头部活动广告
 这个链接是url写死的 下次要用
 @param resultBlock 返回结果
 
 */
+ (void)getActivityDataResultBlock:(void(^)( WFShopActivityModel *model))resultBlock
                         failBlock:(void(^)(void))failBlock;




/**
 双十二活动 获取优惠统计返利开关接口
 这个链接是url写死的 下次要用
 @param resultBlock 返回结果
 */
+ (void)getStatisticsDataResultBlock:(void(^)( WFShopRebateStatisticsModel *model))resultBlock
                           failBlock:(void(^)(void))failBlock;
@end

NS_ASSUME_NONNULL_END
