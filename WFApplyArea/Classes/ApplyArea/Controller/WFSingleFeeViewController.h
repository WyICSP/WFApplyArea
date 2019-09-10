//
//  WFSingleFeeViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFDefaultChargeFeeModel;
@class WFAreaDetailSingleChargeModel;

typedef NS_ENUM(NSInteger, WFUpdateSingleType) {
    WFUpdateSingleFeeApplyType = 0,//申请片区的时候
    WFUpdateSingleFeeUpdateType,   //修改片区
    WFUpdateSingleFeeUpgradeType   //升级片区
};

NS_ASSUME_NONNULL_BEGIN

@interface WFSingleFeeViewController : YFBaseViewController
/**1 = 单次收费2 = 多次收费3 = 优惠收费*/
@property (nonatomic, copy) NSString *chargingModePlay;
/**收费配置id*/
@property (nonatomic, copy) NSString *chargingModelId;
/**判断来源*/
@property (nonatomic, assign) WFUpdateSingleType type;
/**修改单次收费*/
@property (nonatomic, strong) WFAreaDetailSingleChargeModel *editModel;
/**片区Id*/
@property (nonatomic, copy) NSString *groupId;
/**数据源*/
@property (nonatomic, strong) NSArray <WFDefaultChargeFeeModel *> *models;

@property (nonatomic, copy) void (^singleFeeData)(NSArray <WFDefaultChargeFeeModel *> *models);

@property (nonatomic, copy) WFSingleFeeViewController *(^dChargingModePlay)(NSString *chargingModePlay);
@property (nonatomic, copy) WFSingleFeeViewController *(^dChargingModelId)(NSString *chargingModelId);
@property (nonatomic, copy) WFSingleFeeViewController *(^editModels)(WFAreaDetailSingleChargeModel *editModel);
@property (nonatomic, copy) WFSingleFeeViewController *(^mainModels)(NSArray <WFDefaultChargeFeeModel *> *models);
@property (nonatomic, copy) WFSingleFeeViewController *(^sType)(WFUpdateSingleType type);
@property (nonatomic, copy) WFSingleFeeViewController *(^groupIds)(NSString *groupId);
@end

NS_ASSUME_NONNULL_END
