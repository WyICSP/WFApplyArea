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

@end

NS_ASSUME_NONNULL_END
