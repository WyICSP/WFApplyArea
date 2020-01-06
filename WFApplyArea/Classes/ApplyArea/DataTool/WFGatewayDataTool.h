//
//  WFGatewayDataTool.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/24.
//

#import <Foundation/Foundation.h>

@class WFGatewayListModel;
@class WFFindAllGateWayModel;
@class WFMyCdzListListModel;
@class WFSignleIntensityListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayDataTool : NSObject

#pragma mark 解绑 和替换
/// 解绑2G 4G充电桩
/// @param params 参数
/// @param resultBlock 返回成功结果
+ (void)untyingChargingWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock;

/// 替换网关
/// @param params 参数
/// @param resultBlock 返回数据
+ (void)untyingGatewayWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(void))resultBlock;


/// 解绑分布式充电桩
/// @param params 参数
/// @param resultBlock 返回结果
+ (void)untyingDistributedChargingPileWithParams:(NSDictionary *)params
                                     resultBlock:(void(^)(void))resultBlock;

#pragma mark 网关

/// 根据片区 Id 获取网关数据
/// @param params 参数
/// @param resultBlock 返回数据
/// @param failBlock 返回失败
+ (void)getGatewayListWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(NSArray <WFGatewayListModel *> *models))resultBlock
                       failBlock:(void(^)(void))failBlock;


/// 查询片区下面的替换网关
/// @param params 参数
/// @param resultBlock 返回数据
+ (void)queryReplaceGatewayWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFFindAllGateWayModel *> *models))resultBlock;


/// 搜索网关数据
/// @param params 参数
/// @param resultBlock 返回数据
+ (void)getSearchGatewayListWithParams:(NSDictionary *)params
                           resultBlock:(void(^)(NSArray <WFGatewayListModel *> *models))resultBlock;


#pragma  mark 搜索充电桩
/// 我的充电桩里面 根据小区编号、充电桩编号或者网关编号进行搜索 搜索片区
/// @param params 参数
/// @param resultBlock 返回
+ (void)getSearchCDZBycodeWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(NSDictionary *dict))resultBlock;


/// 搜索普通充电桩设备
/// @param params 参数
/// @param resultBlock 返回数据
+ (void)getSearchNormalBycodeWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(NSArray <WFSignleIntensityListModel *> *models))resultBlock;





@end

NS_ASSUME_NONNULL_END
