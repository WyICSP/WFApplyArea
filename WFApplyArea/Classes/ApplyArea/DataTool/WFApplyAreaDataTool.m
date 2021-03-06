//
//  WFApplyAreaDataTool.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAreaDataTool.h"
#import <MJExtension/MJExtension.h>
#import "WFDefaultChargeFeeModel.h"
#import "WFApplyAreaOtherConfigModel.h"
#import "WFMyAreaListModel.h"
#import "WFBillMethodModel.h"
#import "WFUpgradeAreaModel.h"
#import "WFPowerIntervalModel.h"
#import "WFRemoveEquModel.h"
#import "WFAreaDetailModel.h"
#import "SKSafeObject.h"
#import "YFKeyWindow.h"
#import "WKRequest.h"
#import "WKSetting.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFApplyAreaDataTool

#pragma mark 申请片区
+ (void)getMyApplyAreaListWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(NSArray<WFMyAreaListModel *> *models))resultBlock
                           failBlock:(void(^)(void))failBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/list",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyAreaListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            failBlock();
        }
    } failure:^(NSError *error) {
        failBlock();
    }];
}

+ (void)getAreaQRcodeWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(WFMyAreaQRcodeModel *model))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/qrCode",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyAreaQRcodeModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 收费方式 和其他默认设置接口
+ (void)getChargeMethodWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(NSArray <WFApplyChargeMethod *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/charging/model",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFApplyChargeMethod mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getOtherDefaultConfigWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(WFApplyAreaOtherConfigModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/other/default/config",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:NO success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFApplyAreaOtherConfigModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 分成设置
+ (void)getUserDividintoSetWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSArray <WFMyAreaDividIntoSetModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/default/proportions",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyAreaDividIntoSetModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getUserDividIntoSetByGroupIdWithParams:(NSDictionary *)params
                                   resultBlock:(void(^)(NSArray <WFMyAreaDividIntoSetModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/partner/proportions",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyAreaDividIntoSetModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateDividIntoSetWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/partner/proportions",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getUserInfoByMobileWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(NSDictionary *info))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/admin/info",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock(baseModel.mDictionary);
        }else {
//            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 优惠收费相关接口
+ (void)addDiscountUserWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/add/vip/member",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateDiscountUserWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/vip/member",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


+ (void)getVipUserWithParams:(NSDictionary *)params
                 resultBlock:(void(^)(NSArray <WFGroupVipUserModel *> *models))resultBlock
                   failBlock:(void(^)(void))failBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/group/vip/member",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFGroupVipUserModel mj_objectArrayWithKeyValuesArray:[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"list"]]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
            failBlock();
        }
    } failure:^(NSError *error) {
        failBlock();
    }];
}

+ (void)deleteVipUserWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/delete/vip",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 获取计费方式
+ (void)getBillingMethodWithParams:(NSDictionary *)params
                       resultBlock:(void(^)(WFBillMethodModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/billing/method",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFBillMethodModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)addBillingMethodWithParams:(NSDictionary *)params
                       resultBlock:(void(^)(WFBillingPriceMethodModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/add/billing/method",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFBillingPriceMethodModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 获取默认收费模式
+ (void)getDefaultSingleChargeWithParams:(NSDictionary *)params
                             resultBlock:(void(^)(NSArray <WFDefaultChargeFeeModel *>*models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/charging/default/config",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFDefaultChargeFeeModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


+ (void)getDefaultManyTimesChargeWithParams:(NSDictionary *)params
                                resultBlock:(void(^)(WFDefaultManyTimesModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/charging/default/config",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFDefaultManyTimesModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getDefaultDisCountChargeWithParams:(NSDictionary *)params
                               resultBlock:(void(^)(NSArray<WFDefaultDiscountModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/charging/default/config",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFDefaultDiscountModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  获取查看功率区间表
+ (void)getPowerIntervalTableWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(NSArray <WFPowerIntervalModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/power/interval/time/table",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFPowerIntervalModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getProfitTableWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(NSArray <WFProfitTableModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/power/interval/billing/table",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFProfitTableModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 申请片区
+ (void)applyAreaWithParams:(NSDictionary *)params
                resultBlock:(void(^)(void))resultBlock
                  failBlock:(void(^)(void))failBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/add",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
            failBlock();
        }
    } failure:^(NSError *error) {
        failBlock();
    }];
}


+ (void)getAreaDetailWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(NSDictionary *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/get/group/info",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock((NSDictionary *)baseModel.data);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  编辑计费方式 和收费方式
+ (void)updateChargingMethodWithParams:(NSDictionary *)params
                           resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/billing/method",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateVipCollectFeeWithParams:(NSDictionary *)params
                          resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/vip/charge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateSingleFeeWithParams:(NSDictionary *)params
                      resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/sing/charge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateAreaAddressWithParams:(NSDictionary *)params
                        resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/group/base/info",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


+ (void)updateManyTimeFeeWithPamrams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/multiple/charge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)updateOtherSetWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/update/other/config",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma 删除多次收费 优惠收费

+ (void)deleteManyTimeFeeWithParams:(NSDictionary *)params
                        resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/delete/multiple/charge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)deleteVipChargeFeeWithParams:(NSDictionary *)params
                         resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/charging/group/delete/vip/charge",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 升级片区相关接口

+ (void)getOldAreaMsgWithParams:(NSDictionary *)params
                    resultBlock:(void(^)(WFUpgradeAreaModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/update/charging/group/get/old/charging/group/info",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFUpgradeAreaModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getOldAreaMonthTaoCanWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(BOOL isExist))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/update/charging/group/check/old/charging/month/taocan",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:NO success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            BOOL isHave = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"isExist"] boolValue];
            resultBlock(isHave);
        }else {
            resultBlock(NO);
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        resultBlock(NO);
    }];
}

+ (void)getOldAreaDiscountFeeWithParams:(NSDictionary *)params
                            resultBlock:(void(^)(WFUpgradeAreaDiscountModel *oldModels))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/update/charging/group/check/old/charging/vip/taocan",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFUpgradeAreaDiscountModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
    }];
}

+ (void)upgradeOldAreaToNewAreaWithParams:(NSDictionary *)params
                              resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/update/charging/group/update/old/charging",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)verificationAreaNameWithParams:(NSDictionary *)params
                           resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-group/v1/update/charging/group/check/charging/group/name",NEW_HOST_URL];
    [WKRequest getWithURLString:path parameters:params isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 搜索片区和会员
+ (void)getSearchAreaListWithParams:(NSDictionary *)params
                        resultBlock:(void(^)(NSArray <WFMyAreaListModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/applyGroupTemplate/searchGroupByUuid",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFMyAreaListModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)getSearchVipListWithParams:(NSDictionary *)params
                       resultBlock:(void(^)(NSArray <WFGroupVipUserModel *> *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner/applyGroupTemplate/searchMemberBy",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFGroupVipUserModel mj_objectArrayWithKeyValuesArray:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 设备移入和移除
+ (void)getGroupCanEquWithParams:(NSDictionary *)params
                     resultBlock:(void(^)(WFRemoveEquModel *models))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-setmeal/v1/home/pageInfo/getNotInstallCdz",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock([WFRemoveEquModel mj_objectWithKeyValues:baseModel.data]);
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)removeEquWithParams:(NSDictionary *)params
                resultBlock:(void(^)(void))resultBlock {
    //接口地址
    NSString *path = [NSString stringWithFormat:@"%@app-partner-setmeal/v1/home/pageInfo/moveInCdz",NEW_HOST_URL];
    [WKRequest postWithURLString:path parameters:params isJson:YES isShowHud:YES success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            resultBlock();
        }else {
            [YFToast showMessage:baseModel.message inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
