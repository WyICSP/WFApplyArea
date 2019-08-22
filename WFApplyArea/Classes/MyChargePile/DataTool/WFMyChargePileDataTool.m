//
//  WFMyChargePileDataTool.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileDataTool.h"
#import <MJExtension/MJExtension.h>
#import "WFMyChargePileModel.h"
#import "WKRequest.h"
#import "YFKeyWindow.h"
#import "WKSetting.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFMyChargePileDataTool

+ (void)getMyChargePileWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(WFMyChargePileModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/home/cdz/queryMyCdz",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyChargePileModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {

    }];
}

+ (void)getAbnormalPileListWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFAbnormalPileListModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/home/cdz/queryAbnormalGroup",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFAbnormalPileListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getAreaPilesignalIntensitWithParams:(NSDictionary *)params
                                resultBlock:(void(^)(NSArray <WFSignleIntensityListModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/home/cdz/queryGroup",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFSignleIntensityListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
