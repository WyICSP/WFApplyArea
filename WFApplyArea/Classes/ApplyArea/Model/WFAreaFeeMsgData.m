//
//  WFAreaFeeMsgData.m
//  AFNetworking
//
//  Created by 王宇 on 2019/9/18.
//

#import "WFAreaFeeMsgData.h"
#import "WFMyAreaListModel.h"
#import "WFAreaDetailModel.h"

@implementation WFAreaFeeMsgData

+ (WFAreaFeeMsgData *)shareInstace {
    static WFAreaFeeMsgData *feeMsgData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        feeMsgData = [[WFAreaFeeMsgData alloc] init];
    });
    return feeMsgData;
}


@end
