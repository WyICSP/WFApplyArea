//
//  WFDefaultChargeFeeModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFDefaultChargeFeeModel : NSObject
/**默认Id*/
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**计费名称*/
@property (nonatomic, copy) NSString *chargeModelId;
/**chargrType 1 功率收费 0 统一收费*/
@property (nonatomic, assign) NSInteger chargeType;
/**默认*/
@property (nonatomic, strong) NSNumber *unifiedPrice;
/**次数*/
@property (nonatomic, assign) NSInteger unifiedTime;
/**成本价*/
@property (nonatomic, strong) NSNumber *unitPrice;
/**售价*/
@property (nonatomic, strong) NSNumber *salesPrice;
/**是否打开第一个区域*/
@property (nonatomic, assign) BOOL isOpenFirstSection;
/**是否选中第一个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectFirstSection;
/**是否打开第二个区域*/
@property (nonatomic, assign) BOOL isOpenSecondSection;
/**是否选中第二个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectSecondSection;
/**是否有更换数据*/
@property (nonatomic, assign) BOOL isChange;
@end


@interface WFDefaultDiscountModel : NSObject
/**售价*/
@property (nonatomic, strong) NSNumber *unifiedPrice;
/**次数*/
@property (nonatomic, assign) NSInteger unifiedTime;
/**充电桩片区id*/
@property (nonatomic, copy) NSString *chargeModelId;
/**vipId*/
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**是否有修改*/
@property (nonatomic, assign) BOOL isChange;
@end

@interface WFDefaultManyTimesModel : NSObject
/**功率收费*/
@property (nonatomic, strong) NSArray *multipleChargesPowerList;
/**是否打开第一个区域*/
@property (nonatomic, assign) BOOL isOpenFirstSection;
/**是否选中第一个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectFirstSection;

/**统一收费*/
@property (nonatomic, strong) NSArray *multipleChargesUnifiedList;
/**是否打开第二个区域*/
@property (nonatomic, assign) BOOL isOpenSecondSection;
/**是否选中第二个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectSecondSection;
@end

@interface WFDefaultUnifiedListModel : NSObject
@property (nonatomic, copy) NSString *chargeModelId;
@property (nonatomic, assign) NSInteger chargeType;
@property (nonatomic, copy) NSString *monthCount;
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**名字*/
@property (nonatomic, copy) NSString *optionName;
/**价格*/
@property (nonatomic, strong) NSNumber *proposalPrice;
/**次数*/
@property (nonatomic, assign) NSInteger proposalTimes;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end

@interface WFDefaultPowerListModel : NSObject
@property (nonatomic, copy) NSString *chargeModelId;
@property (nonatomic, assign) NSInteger chargeType;
@property (nonatomic, copy) NSString *monthCount;
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**名字*/
@property (nonatomic, copy) NSString *optionName;
/**价格次数*/
@property (nonatomic, strong) NSNumber *proposalPrice;
/**次数*/
@property (nonatomic, assign) NSInteger proposalTimes;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end


@interface WFGroupVipUserModel : NSObject
/**uuid*/
@property (nonatomic, copy) NSString *uuid;
/**电话*/
@property (nonatomic, copy) NSString *phone;
/**名字*/
@property (nonatomic, copy) NSString *name;
/**次数*/
@property (nonatomic, copy) NSString *useCount;
/**剩余次数*/
@property (nonatomic, assign) NSInteger remainCount;
/**时间*/
@property (nonatomic, copy) NSString *useTime;
/**多少次*/
@property (nonatomic, assign) NSInteger giveCount;
/**时间*/
@property (nonatomic, copy) NSString *expireTime;
/**vipId*/
@property (nonatomic, copy) NSString *vipId;
/// 是否过期
@property (nonatomic, assign) BOOL isValid;
@end



NS_ASSUME_NONNULL_END
