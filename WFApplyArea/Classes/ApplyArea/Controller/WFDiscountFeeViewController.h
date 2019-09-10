//
//  WFDiscountFeeViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFDefaultDiscountModel;
@class WFAreaDetailVipChargeModel;

typedef NS_ENUM(NSInteger, WFUpdateUserMsgType) {
    WFUpdateUserMsgApplyType = 0,//申请片区的时候
    WFUpdateUserMsgUpdateType,    //修改片区
    WFUpdateUserMsgUpgradeType   //升级片区
};

NS_ASSUME_NONNULL_BEGIN

@interface WFDiscountFeeViewController : YFBaseViewController
/**类型*/
@property (nonatomic, assign) WFUpdateUserMsgType type;
/**申请片区 id*/
@property (nonatomic, copy) NSString *applyGroupId;
/**充电桩片区id*/
@property (nonatomic, copy) NSString *chargingModelId;
/**1 = 单次收费2 = 多次收费3 = 优惠收费*/
@property (nonatomic, copy) NSString *chargingModePlay;
/**是否不允许编辑*/
@property (nonatomic, assign) BOOL isNotAllow;
/**编辑优惠收费*/
@property (nonatomic, strong) WFAreaDetailVipChargeModel *editModel;
/**默认数据*/
@property (nonatomic, strong) WFDefaultDiscountModel *mainModel;
/**返回数据*/
@property (nonatomic, copy) void (^discountFeeDataBlock)(WFDefaultDiscountModel *discountModels);
/**链式编程*/
@property (nonatomic, copy) WFDiscountFeeViewController *(^eType)(WFUpdateUserMsgType type);
@property (nonatomic, copy) WFDiscountFeeViewController *(^aGroupId)(NSString *applyGroupId);
@property (nonatomic, copy) WFDiscountFeeViewController *(^cModelId)(NSString *chargingModelId);
@property (nonatomic, copy) WFDiscountFeeViewController *(^dChargingModePlay)(NSString *chargingModePlay);
@property (nonatomic, copy) WFDiscountFeeViewController *(^editModels)(WFAreaDetailVipChargeModel *editModel);
@property (nonatomic, copy) WFDiscountFeeViewController *(^dDiscountModels)(WFDefaultDiscountModel *discountModels);
@property (nonatomic, copy) WFDiscountFeeViewController *(^isNotAllows)(BOOL isNotAllow);
@end

NS_ASSUME_NONNULL_END
