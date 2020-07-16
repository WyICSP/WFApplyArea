//
//  WFGatewayDataTool.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/24.
//

#import "WFGatewayDataTool.h"
#import <MJExtension/MJExtension.h>
#import "WFGatewayListModel.h"
#import "WFMyChargePileModel.h"
#import "YFKeyWindow.h"
#import "WKRequest.h"
#import "WKSetting.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFGatewayDataTool

+ (void)untyingChargingWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/untyingCharging",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)untyingGatewayWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/replaceGateWay",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)untyingDistributedChargingPileWithParams:(NSDictionary *)params
                                     resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/untying",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getGatewayListWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(NSArray <WFGatewayListModel *> *models))resultBlock
                       failBlock:(void(^)(void))failBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/getChargeByGroupId",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFGatewayListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)queryReplaceGatewayWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFFindAllGateWayModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/findAllGateWay",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFFindAllGateWayModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getSearchGatewayListWithParams:(NSDictionary *)params
                           resultBlock:(void(^)(NSArray <WFGatewayListModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@yzsh-partner-apply/V1/partnerCharging/searchByCode",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFGatewayListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 搜索
+ (void)getSearchCDZBycodeWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(NSDictionary *dict))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@yzsh-partner-apply/V1/partnerCharging/searchCharge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock(baseModel.mDictionary);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


+ (void)getSearchNormalBycodeWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(NSArray <WFSignleIntensityListModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/loraTemplate/searchByCode",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFSignleIntensityListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
