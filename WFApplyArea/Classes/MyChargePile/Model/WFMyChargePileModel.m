//
//  WFMyChargePileModel.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFMyChargePileModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"abnormalCdzList":@"WFAbnormalCdzListModel",
             @"myCdzListList":@"WFMyCdzListListModel",
             @"notInstalledCdzList":@"WFNotInstalledCdzListModel"};
}

@end

@implementation WFAbnormalCdzListModel

@end

@implementation WFMyCdzListListModel

@end

@implementation WFNotInstalledCdzListModel

@end

@implementation WFAbnormalPileListModel

@end

@implementation WFSignleIntensityListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"socketParamVOS":@"WFPileSocketParamVOSModel"};
}


@end

@implementation WFPileSocketParamVOSModel


@end
