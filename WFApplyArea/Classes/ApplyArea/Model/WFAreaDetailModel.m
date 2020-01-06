//
//  WFAreaDetailModel.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/16.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailModel.h"
#import <MJExtension/MJExtension.h>
#import "WFDefaultChargeFeeModel.h"

@implementation WFAreaDetailSingleChargeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"powerIntervalConfig":@"powerIntervalList"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"powerIntervalConfig":@"WFChargeFeePowerConfigModel"};
}

@end

@implementation WFAreaDetailVipChargeModel

@end

@implementation WFAreaDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"billingInfos":@"WFAreaDetailBillingInfosModel",
             @"multipleChargesList":@"WFAreaDetailMultipleModel",
             @"partnerPropInfos":@"WFAreaDetailPartnerModel"
             };
}

@end


@implementation WFAreaDetailBillingInfosModel

@end


@implementation WFAreaDetailMultipleModel

@end


@implementation WFAreaDetailPartnerModel

@end

@implementation WFAreaDetailSectionTitleModel

@end
