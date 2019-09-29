//
//  WFUpgradeAreaData.m
//  AFNetworking
//
//  Created by 王宇 on 2019/9/19.
//

#import "WFUpgradeAreaData.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFUpgradeAreaData

static WFUpgradeAreaData *_upgrade = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _upgrade = [[WFUpgradeAreaData alloc] init];
    });
    return _upgrade;
}

- (void)destructionUpgrade {
    onceToken = 0;
    _upgrade = nil;
    //重置数据
    self.addressMsg = nil;
    self.singleCharge = nil;
    self.multipleChargesList = nil;
    self.discountFee = nil;
    self.billingPlanIds = nil;
    self.partnerPropInfos = nil;
    self.groupId = nil;
    self.isExistence = nil;
}



@end
