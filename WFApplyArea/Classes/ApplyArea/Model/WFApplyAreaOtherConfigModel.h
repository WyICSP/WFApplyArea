//
//  WFApplyAreaOtherConfigModel.h
//  AFNetworking
//
//  Created by 王宇 on 2019/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOtherConfigMaxChargingTimeModel : NSObject
/// id
@property (nonatomic, copy) NSString *otherConfigId;
///0:最大充电时长 1：续充时长 2：充电起步价
@property (nonatomic, assign) NSInteger type;
/// 最小值
@property (nonatomic, assign) CGFloat minValue;
/// 最大值
@property (nonatomic, assign) CGFloat maxValue;
/// 默认值
@property (nonatomic, copy) NSString *defaultValue;
/// 提示
@property (nonatomic, copy) NSString *tips;
@end

@interface WFOtherConfigContinueChargingTimeModel : NSObject
/// id
@property (nonatomic, copy) NSString *otherConfigId;
///0:最大充电时长 1：续充时长 2：充电起步价
@property (nonatomic, assign) NSInteger type;
/// 最小值
@property (nonatomic, assign) CGFloat minValue;
/// 最大值
@property (nonatomic, assign) CGFloat maxValue;
/// 默认值
@property (nonatomic, copy) NSString *defaultValue;
/// 提示
@property (nonatomic, copy) NSString *tips;
@end

@interface WFOtherConfigStartPriceModel : NSObject
/// id
@property (nonatomic, copy) NSString *otherConfigId;
///0:最大充电时长 1：续充时长 2：充电起步价
@property (nonatomic, assign) NSInteger type;
/// 最小值
@property (nonatomic, assign) CGFloat minValue;
/// 最大值
@property (nonatomic, assign) CGFloat maxValue;
/// 默认值
@property (nonatomic, copy) NSString *defaultValue;
/// 提示
@property (nonatomic, copy) NSString *tips;
@end

@interface WFApplyAreaOtherConfigModel : NSObject
/// 最大充电时长
@property (nonatomic, strong) WFOtherConfigMaxChargingTimeModel *maxChargingTime;
/// 续充
@property (nonatomic, strong) WFOtherConfigContinueChargingTimeModel *continueChargingTime;
/// 起步价
@property (nonatomic, strong) WFOtherConfigStartPriceModel *startPrice;
@end

NS_ASSUME_NONNULL_END
