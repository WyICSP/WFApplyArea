//
//  WFDefaultChargeFeeModel.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDefaultChargeFeeModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFDefaultChargeFeeModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"powerIntervalConfig":@"WFChargeFeePowerConfigModel"};
}

@end

@implementation WFChargeFeePowerConfigModel


@end

@implementation WFDefaultDiscountModel

@end

@implementation WFDefaultManyTimesModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"multipleChargesUnifiedList":@"WFDefaultUnifiedListModel",
             @"multipleChargesPowerList":@"WFDefaultPowerListModel"};
}

@end

@implementation WFDefaultUnifiedListModel

@end

@implementation WFDefaultPowerListModel

@end


@implementation WFGroupVipUserModel

@end

