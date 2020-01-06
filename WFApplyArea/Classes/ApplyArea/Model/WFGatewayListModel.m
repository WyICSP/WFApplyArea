//
//  WFGatewayListModel.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/24.
//

#import "WFGatewayListModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFGatewayListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"loraChargeVOList":@"WFGatewayLoarListModel"};
}

@end

@implementation WFGatewayLoarListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"socketParamVOList":@"WFPileSocketParamVOSModel"};
}
@end

@implementation WFFindAllGateWayModel

@end

//@implementation WFSocketParamVOListModel
//
//
//@end
