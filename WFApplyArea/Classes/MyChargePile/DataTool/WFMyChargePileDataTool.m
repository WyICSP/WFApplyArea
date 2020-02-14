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
#import "WFCreditPayModel.h"
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

#pragma mark 个人中心上传头像
+ (void)uploadModHeadWithParams:(NSDictionary *)params
                    resultBlock:(void (^)(NSString *str))resultBlock {
    //接口地址POST
    NSString *path = [NSString stringWithFormat:@"%@admin/uploadPicture",HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:NO isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock(baseModel.data);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 授信相关接口
+ (void)adminCreditTemplateWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(WFCreditPayModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/adminCreditTemplate/getAdminPayMethod",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFCreditPayModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)addAdminCreditTemplAteadminDepositWithParams:(NSDictionary *)params
                                         resultBlock:(void(^)(WFCheditPayMothedModel *models))resultBlock {
    //接口地址POST
    NSString *path = [NSString stringWithFormat:@"%@app-partner/adminCreditTemplate/adminDeposit",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFCheditPayMothedModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
