//
//  WFManyTimeFeeViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFDefaultManyTimesModel;
@class WFAreaDetailMultipleModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFUpdateManyTimeType) {
    WFUpdateManyTimeFeeApplyType = 0,//申请片区的时候
    WFUpdateManyTimeFeeUpdateType,   //修改片区
    WFUpdateManyTimeFeeUpgradeType   //升级片区
};

@interface WFManyTimeFeeViewController : YFBaseViewController
/**1 = 单次收费2 = 多次收费3 = 优惠收费*/
@property (nonatomic, copy) NSString *chargingModePlay;
/**收费配置id*/
@property (nonatomic, copy) NSString *chargingModelId;
/**用户设置多次收费的id 数组*/
@property (nonatomic, strong) NSArray <WFAreaDetailMultipleModel *> *itemArray;
/**修改多次收费的时候判断是统一收费还是功率收费 0 是统一, 1 功率收费*/
@property (nonatomic, assign) NSInteger chargeType;
/// 是否显示多次收费开关
@property (nonatomic, assign) BOOL isMultipleChargeShow;
/**片区 Id*/
@property (nonatomic, copy) NSString *groupId;
/**默认数据*/
@property (nonatomic, strong) WFDefaultManyTimesModel *mainModel;
/**来源*/
@property (nonatomic, assign) WFUpdateManyTimeType type;

@property (nonatomic, copy) void (^mainModelBlock)(WFDefaultManyTimesModel *mainModel);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^dChargingModePlay)(NSString *chargingModePlay);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^dChargingModelId)(NSString *chargingModelId);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^dDefaultManyTimesBlock)(WFDefaultManyTimesModel *mainModel);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^itemArrays)(NSArray <WFAreaDetailMultipleModel *> *itemArray);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^chargeTypes)(NSInteger chargeType);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^sourceType)(WFUpdateManyTimeType type);
@property (nonatomic, copy) WFManyTimeFeeViewController *(^isShow)(BOOL isMultipleChargeShow);
@end

NS_ASSUME_NONNULL_END
