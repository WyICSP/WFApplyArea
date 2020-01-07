//
//  WFEditAreaAddressViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFEditAreaAddressViewController.h"
#import "WFSingleFeeViewController.h"
#import "WFApplyAreaDataTool.h"
#import "WFUpgradeAreaModel.h"
#import "YFAddressPickView.h"
#import "WFAreaDetailModel.h"
#import "WFHomeSaveDataTool.h"
#import "WFMyAreaListModel.h"
#import "WFAreaFeeMsgData.h"
#import "WFUpgradeAreaData.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFEditAreaAddressViewController ()
/**地址*/
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
/**详细地址*/
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
/**片名*/
@property (weak, nonatomic) IBOutlet UITextField *areaNameTF;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/**片区 Id*/
@property (nonatomic, copy) NSString *areaId;
/**1 = 单次收费2 = 多次收费3 = 优惠收费*/
@property (nonatomic, copy) NSString *chargingModePlay;
/**收费标准id*/
@property (nonatomic, copy) NSString *chargeModelId;

@end

@implementation WFEditAreaAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)dealloc {
    DLog(@"%s",__func__);
    [[WFUpgradeAreaData shareInstance] destructionUpgrade];
}

- (void)setUI {
    self.title = @"片区信息";
    self.contentsView.layer.cornerRadius = 10.0f;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    //设置底部按钮
    [self.saveBtn setTitle:self.type == WFEditAddressAreaDetailType ? @"确认修改" : @"下一步(1/7)" forState:0];
    //升级片区获取收费信息
    if (self.type == WFEditAddressAreauUpgradeType) {
        //获取老片区信息
        [self getOldAreaData];
        //获取收费信息
        [self getChargeMthod];
    }else {
        //赋值
        [self.addressBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
        [self.addressBtn setTitle:self.models.areaName forState:0];
        self.detailAddressTF.text = self.models.address;
        self.areaNameTF.text = self.models.name;
        self.areaId = self.models.areaId;
    }
}

/**
 获取老片区信息
 */
- (void)getOldAreaData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getOldAreaMsgWithParams:params resultBlock:^(WFUpgradeAreaModel * _Nonnull models) {
        @strongify(self)
        if (models.address.length != 0) {
            [self.addressBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
            [self.addressBtn setTitle:models.cityName forState:0];
            self.areaId = models.regionId;
        }
        self.detailAddressTF.text = models.address;
        self.areaNameTF.text = models.name;
    }];
}

/**
 获取收费信息 
 */
- (void)getChargeMthod {
    @weakify(self)
    [WFApplyAreaDataTool getChargeMethodWithParams:@{} resultBlock:^(NSArray<WFApplyChargeMethod *> * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModels:models];
    }];
}

- (void)requestSuccessWithModels:(NSArray <WFApplyChargeMethod *> *)models {
    [WFAreaFeeMsgData shareInstace].feeData = (NSMutableArray *)models;
    for (WFApplyChargeMethod *model in models) {
        if (model.chargingModePlay.integerValue == 1) {
            //单次收费
            self.chargingModePlay = model.chargingModePlay;
            self.chargeModelId = model.chargeModelId;
        }
    }
}

/// 验证片区名是否可用
- (void)verificationAreaName {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:self.areaNameTF.text forKey:@"name"];
    @weakify(self)
    [WFApplyAreaDataTool verificationAreaNameWithParams:params resultBlock:^{
        @strongify(self)
        [self goSetFee];
    }];
}

/// 名称可用 去设置收费
- (void)goSetFee {
    //升级片区 保存数据
    [WFUpgradeAreaData shareInstance].addressMsg = [self addressMsg];
    //去选择单次收费
    WFSingleFeeViewController *single = [[WFSingleFeeViewController alloc] init];
    single.sType(WFUpdateSingleFeeUpgradeType).dChargingModePlay(self.chargingModePlay).
    dChargingModelId(self.chargeModelId).groupIds(self.groupId);
    [self.navigationController pushViewController:single animated:YES];
}

/**
 选择地址
 */
- (IBAction)chooseAddressBtn:(id)sender {
    [self.view endEditing:YES];
    YFAddressPickView *addressPickView = [YFAddressPickView shareInstance];
    addressPickView.addressDatas = [[WFHomeSaveDataTool shareInstance] readAddressFile];
    WS(weakSelf)
    addressPickView.startPlaceBlock = ^(NSString *address, NSString *addressId) {
        DLog(@"地址=%@-addressId=%@",address,addressId);
        weakSelf.areaId = addressId;
        [weakSelf.addressBtn setTitle:address forState:UIControlStateNormal];
        [weakSelf.addressBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
    };
    [YFWindow addSubview:addressPickView];
}

/**
 确定
 */
- (IBAction)clickSaveBtn:(UIButton *)sender {
    
    NSString *alertMsg = @"";
    if (self.areaId.length == 0) {
        alertMsg = @"请选择省市区";
    }else if (self.detailAddressTF.text.length == 0) {
        alertMsg = @"请输入详细地址";
    }else if (self.areaNameTF.text.length == 0) {
        alertMsg = @"请输入市+区+小区名";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    if (self.type == WFEditAddressAreaDetailType) {
        //修改片区信息
        [self submitAddressData];
    }else {
        //升级片区
        [self verificationAreaName];
    }
}

- (NSDictionary *)addressMsg {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.detailAddressTF.text forKey:@"address"];
    [params safeSetObject:self.areaId forKey:@"areaId"];
    [params safeSetObject:self.models.groupId forKey:@"groupId"];
    [params safeSetObject:self.areaNameTF.text forKey:@"name"];
    return params;
}

/**
 编辑的时候提交
 */
- (void)submitAddressData {
    @weakify(self)
    [WFApplyAreaDataTool updateAreaAddressWithParams:[self addressMsg] resultBlock:^{
        @strongify(self)
        [self updateSuccess];
    }];
}

- (void)updateSuccess {
    [YFToast showMessage:@"修改成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YFNotificationCenter postNotificationName:@"reloadDataKeys" object:nil];
        [self goBack];
    });
}

#pragma mark 参数
- (WFEditAreaAddressViewController * _Nonnull (^)(WFAreaDetailModel * _Nonnull))dataModels {
    return ^(WFAreaDetailModel *models){
        self.models = models;
        return self;
    };
}

- (WFEditAreaAddressViewController * _Nonnull (^)(WFEditAddressJumpType))sourceType {
    return ^(WFEditAddressJumpType type) {
        self.type = type;
        return self;
    };
}

- (WFEditAreaAddressViewController * _Nonnull (^)(NSString * _Nonnull))areaGroupId {
    return ^(NSString *groupId) {
        [WFUpgradeAreaData shareInstance].groupId = groupId;
        self.groupId = groupId;
        return self;
    };
}

@end
