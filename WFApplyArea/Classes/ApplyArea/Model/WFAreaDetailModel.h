//
//  WFAreaDetailModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/16.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailSingleChargeModel : NSObject
/**收费标准id*/
@property (nonatomic, copy) NSString *chargeModelId;
/**默认Id*/
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/// 功率区间
@property (nonatomic, strong) NSArray *powerIntervalConfig;
/**0:统一收费 1:功率收费*/
@property (nonatomic, assign) NSInteger chargeType;
/**片区id*/
@property (nonatomic, copy) NSString *groupId;
/**按功率收费销售单价*/
@property (nonatomic, strong) NSNumber *salesPrice;
/**id号*/
@property (nonatomic, copy) NSString *singleChargeId;
/**统一收费价格*/
@property (nonatomic, strong) NSNumber *unifiedPrice;
/**统一收费次数*/
@property (nonatomic, assign) NSInteger unifiedTime;
/**按功率收费单价*/
@property (nonatomic, strong) NSNumber *unitPrice;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end

@interface WFAreaDetailVipChargeModel : NSObject
/**收费标准id*/
@property (nonatomic, copy) NSString *chargeModelId;
/**默认id*/
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**片区id*/
@property (nonatomic, copy) NSString *groupId;
/**统一收费设置金额*/
@property (nonatomic, strong) NSNumber *unifiedPrice;
/**统一收费设置时间*/
@property (nonatomic, assign) NSInteger unifiedTime;
/**id号*/
@property (nonatomic, copy) NSString *vipChargeId;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end


@interface WFAreaDetailModel : NSObject
/**地址*/
@property (nonatomic, copy) NSString *address;
/**区域Id*/
@property (nonatomic, copy) NSString *areaId;
/**省市区*/
@property (nonatomic, copy) NSString *areaName;
/**片区Id*/
@property (nonatomic, copy) NSString *groupId;
/**片区名*/
@property (nonatomic, copy) NSString *name;
/**多次收费默认Id*/
@property (nonatomic, copy) NSString *multipleChargeModelId;
/**优惠收费默认Id*/
@property (nonatomic, copy) NSString *vipChargeModelId;
/// 最大充电时长
@property (nonatomic, copy) NSString *maxChargingTime;
/// 充电起步价
@property (nonatomic, strong) NSNumber *startPrice;
/**是否选中多次*/
@property (nonatomic, assign) BOOL isSelectMany;
/**是否有单次收费*/
@property (nonatomic, assign) BOOL isHaveSinge;
/**是否有多次收费*/
@property (nonatomic, assign) BOOL isHaveManyTime;
/**是否有优惠收费*/
@property (nonatomic, assign) BOOL isHaveVip;
/**是否可以编辑*/
@property (nonatomic, assign) BOOL isUpdate;
/// 是否显示多次收费
@property (nonatomic, assign) BOOL isMultipleChargeShow;
/// 0:停用 1:启用
@property (nonatomic, assign) BOOL status;
/**状态0：申请中 1：申请通过 2：申请驳回*/
@property (nonatomic, assign) NSInteger auditStatus;
/**计费方式数据*/
@property (nonatomic, strong) NSArray *billingInfos;
/**多次收费数据*/
@property (nonatomic, strong) NSArray *multipleChargesList;
/**合伙人分成设置*/
@property (nonatomic, strong) NSArray *partnerPropInfos;
/**单次收费*/
@property (nonatomic, strong) WFAreaDetailSingleChargeModel *singleCharge;
/**优惠收费*/
@property (nonatomic, strong) WFAreaDetailVipChargeModel *vipCharge;
@end

@interface WFAreaDetailBillingInfosModel : NSObject
/**计费id*/
@property (nonatomic, copy) NSString *billingPlanId;
/**计费类型，1:小时计费 2:金额计费*/
@property (nonatomic, assign) NSInteger billingPlay;
/**计费名称*/
@property (nonatomic, copy) NSString *billingName;
/**计费值*/
@property (nonatomic, strong) NSNumber *billingValue;
/**单位*/
@property (nonatomic, copy) NSString *billingUnit;
/**电量*/
@property (nonatomic, copy) NSString *elec;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end

@interface WFAreaDetailMultipleModel : NSObject
@property (nonatomic, copy) NSString *multipeChargeId;
@property (nonatomic, copy) NSString *groupId;
/**收费配置 Id*/
@property (nonatomic, copy) NSString *chargeModelId;
/**默认Id*/
@property (nonatomic, copy) NSString *chargingDefaultConfigId;
/**0:统一收费 1:功率收费*/
@property (nonatomic, assign) NSInteger chargeType;
/**月数*/
@property (nonatomic, assign) NSInteger monthCount;
/**名字*/
@property (nonatomic, copy) NSString *optionName;
/**价格*/
@property (nonatomic, strong) NSNumber *proposalPrice;
/**次数*/
@property (nonatomic, assign) NSInteger proposalTimes;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end

@interface WFAreaDetailPartnerModel : NSObject
/**名字*/
@property (nonatomic, copy) NSString *name;
/**手机号*/
@property (nonatomic, copy) NSString *phone;
/**占比*/
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, assign) NSInteger chargePersonFlag;
@end

@interface WFAreaDetailSectionTitleModel : NSObject
/**title*/
@property (nonatomic, copy) NSString *title;
/**是否显示按钮*/
@property (nonatomic, assign) BOOL isShowForm;
/**是否显示详细 title*/
@property (nonatomic, assign) BOOL isShowDetail;
/**是否显示编辑按钮*/
@property (nonatomic, assign) BOOL isShowEditBtn;
/// 是否显示多次收费隐藏按钮
@property (nonatomic, assign) BOOL isShowManyType;
/**按钮 title*/
@property (nonatomic, copy) NSString *formTitle;
/**详细 title*/
@property (nonatomic, copy) NSString *detailTitle;
/// 多次收费
@property (nonatomic, copy) NSString *showManyType;
@end

NS_ASSUME_NONNULL_END
