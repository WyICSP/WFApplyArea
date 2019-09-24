//
//  WFUpgradeAreaModel.m
//  AFNetworking
//
//  Created by 王宇 on 2019/9/19.
//

#import "WFUpgradeAreaModel.h"
#import "WFDefaultChargeFeeModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFUpgradeAreaModel

@end

@implementation WFUpgradeAreaDiscountModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"vipMemberList":@"WFGroupVipUserModel"};
}

@end
