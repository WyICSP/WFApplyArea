//
//  WFApplyAreaViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAreaViewController.h"
#import "WFDividIntoSetViewController.h"
#import "WFApplyAreaItemTableViewCell.h"
#import "WFApplyAddressTableViewCell.h"
#import "WFDividIntoSetViewController.h"
#import "WFBilleMethodViewController.h"
#import "WFDiscountFeeViewController.h"
#import "WFManyTimeFeeViewController.h"
#import "WFSingleFeeViewController.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFApplyAreaHeadView.h"
#import "WFApplyAreaFooterView.h"
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaListModel.h"
#import "WFPowerIntervalModel.h"
#import "WFBillMethodModel.h"
#import "WFMyAreaListModel.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFApplyAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
/**scrollView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *nextBtn;
/**收费方式*/
@property (nonatomic, strong, nullable) NSMutableArray <WFApplyChargeMethod *> *models;
/**地址*/
@property (nonatomic, strong, nullable) WFApplyAreaAddressModel *addressModel;
/**头部标题*/
@property (nonatomic, strong, nullable) NSArray *headTitleArrays;
/**计费方式数据*/
@property (nonatomic, strong, nullable) WFBillMethodModel *billMethodModel;
/**分成设置数据*/
@property (nonatomic, strong, nullable) NSArray <WFMyAreaDividIntoSetModel *> *diviIntoDatas;
/**优惠收费数据*/
@property (nonatomic, strong, nullable) WFDefaultDiscountModel *discountModels;
/**多次收费数据*/
@property (nonatomic, strong, nullable) WFDefaultManyTimesModel *manyTimesModel;
/**单次收费数据*/
@property (nonatomic, strong, nullable) NSArray <WFDefaultChargeFeeModel *> *singleFeeData;
@end

@implementation WFApplyAreaViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"申请片区";
    self.headTitleArrays = @[@"片区信息",@"收费方式",@"计费方式",@"分成设置"];
    [self getChargeMthod];
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
    [self.models addObjectsFromArray:models];
    [self.tableView reloadData];
}

#pragma mark 提交申请片区
- (void)clickNextBtn {
    
    NSString *alertMsg = @"";
    if ([NSString isBlankString:self.addressModel.addressId]) {
        alertMsg = @"请选择省市区";
    }else if ([NSString isBlankString:self.addressModel.detailAddress]) {
        alertMsg = @"请填写详细地址";
    }else if ([NSString isBlankString:self.addressModel.areaName]) {
        alertMsg = @"请输入市+区+小区名";
    }else if (!self.singleFeeData) {
        alertMsg = @"请选择单次收费";
    }else if (!self.billMethodModel) {
        alertMsg = @"请选择计费方式";
    }else if (self.diviIntoDatas.count == 0) {
        alertMsg = @"请添加合伙人分成设置";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    //禁止重复点击
    self.nextBtn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.addressModel.detailAddress forKey:@"address"];//详细地址
    [params safeSetObject:self.addressModel.addressId forKey:@"areaId"];//区的 Id
    [params safeSetObject:self.addressModel.areaName forKey:@"name"];//片区名
    [params safeSetObject:[self billingPlanIds] forKey:@"billingPlanIds"];//计费方式数组
    [params safeSetObject:[self multipleChargesList] forKey:@"multipleChargesList"];//多次收费
    [params safeSetObject:[self partnerPropInfos] forKey:@"partnerPropInfos"];//合伙人分成设置
    [params safeSetObject:[self singleCharge] forKey:@"singleCharge"];//单次收费
    [params safeSetObject:[self vipCharge] forKey:@"vipCharge"];//优惠收费
    @weakify(self)
    [WFApplyAreaDataTool applyAreaWithParams:params resultBlock:^{
        @strongify(self)
        [self applyAreaSuccess];
    }];
}

- (void)applyAreaSuccess {
    self.nextBtn.enabled = YES;
    [YFToast showMessage:@"申请成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !self.reloadDataBlock ? : self.reloadDataBlock();
        [self goBack];
    });
    
}

#pragma mark 申请片区的数据组合
/**
 获取计费方式数组

 @return billingPlanIds
 */
- (NSArray *)billingPlanIds {
    
    NSMutableArray *array = [NSMutableArray new];
    
    if (self.billMethodModel.isSelectFirstSection) {
        //如果选择的是充电时长
        for (WFBillingTimeMethodModel *tModel in self.billMethodModel.billingTimeMethods) {
            if (tModel.isSelect) {
                [array addObject:tModel.billingPlanId];
            }
        }
    }else if (self.billMethodModel.isSelectSecondSection) {
        //如果选择的是充电价格
        for (WFBillingPriceMethodModel *pModel in self.billMethodModel.billingPriceMethods) {
            if (pModel.isSelect) {
                [array addObject:pModel.billingPlanId];
            }
        }
    }
    return array;
}

/**
 获取合伙人分成配置

 @return partnerPropInfos
 */
- (NSArray *)partnerPropInfos {
    
    NSMutableArray *dArray = [NSMutableArray new];
    for (WFMyAreaDividIntoSetModel *dModel in self.diviIntoDatas) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:@(dModel.chargePersonFlag) forKey:@"chargePersonFlag"];
        [dict safeSetObject:dModel.name forKey:@"name"];
        [dict safeSetObject:dModel.phone forKey:@"phone"];
        [dict safeSetObject:@(dModel.rate) forKey:@"rate"];
        [dArray addObject:dict];
    }
    return dArray;
}

/**
 获取优惠收费

 @return vipCharge
 */
- (NSDictionary *)vipCharge {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict safeSetObject:self.discountModels.chargeModelId forKey:@"chargeModelId"];
    [dict safeSetObject:self.discountModels.unifiedPrice forKey:@"unifiedPrice"];
    [dict safeSetObject:@(self.discountModels.unifiedTime) forKey:@"unifiedTime"];
    [dict safeSetObject:self.discountModels.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
    return dict;
}

/**
 获取多次收费

 @return multipleCharges
 */
- (NSArray *)multipleChargesList {
    NSMutableArray *mArray = [NSMutableArray new];
    if (self.manyTimesModel.isSelectFirstSection) {
        //如果选择的是统一收费
        for (WFDefaultUnifiedListModel *uniModel in self.manyTimesModel.multipleChargesUnifiedList) {
            if (uniModel.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict safeSetObject:uniModel.chargeModelId forKey:@"chargeModelId"];
                [dict safeSetObject:@(uniModel.chargeType) forKey:@"chargeType"];
                [dict safeSetObject:uniModel.monthCount forKey:@"monthCount"];
                [dict safeSetObject:uniModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
                [dict safeSetObject:uniModel.optionName forKey:@"optionName"];
                [dict safeSetObject:uniModel.proposalPrice forKey:@"proposalPrice"];
                [dict safeSetObject:@(uniModel.proposalTimes) forKey:@"proposalTimes"];
                [mArray addObject:dict];
            }
        }
    }else if (self.manyTimesModel.isSelectSecondSection) {
        //如果选择的功率收费
        for (WFDefaultPowerListModel *pModel in self.manyTimesModel.multipleChargesPowerList) {
            if (pModel.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict safeSetObject:pModel.chargeModelId forKey:@"chargeModelId"];
                [dict safeSetObject:@(pModel.chargeType) forKey:@"chargeType"];
                [dict safeSetObject:pModel.monthCount forKey:@"monthCount"];
                [dict safeSetObject:pModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
                [dict safeSetObject:pModel.optionName forKey:@"optionName"];
                [dict safeSetObject:pModel.proposalPrice forKey:@"proposalPrice"];
                [dict safeSetObject:@(pModel.proposalTimes) forKey:@"proposalTimes"];
                [mArray addObject:dict];
            }
        }
    }
    return mArray;
}

/**
 获取单次收费 必填

 @return singleCharge
 */
- (NSDictionary *)singleCharge {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WFDefaultChargeFeeModel *sModel in self.singleFeeData) {
        if (sModel.isSelectFirstSection) {
            //单一收费
            [dict safeSetObject:sModel.chargeModelId forKey:@"chargeModelId"];
            [dict safeSetObject:@(sModel.chargeType) forKey:@"chargeType"];
            [dict safeSetObject:@(sModel.salesPrice.integerValue) forKey:@"salesPrice"];
            [dict safeSetObject:sModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
            [dict safeSetObject:@(sModel.unifiedPrice.integerValue) forKey:@"unifiedPrice"];
            [dict safeSetObject:@(sModel.unifiedTime) forKey:@"unifiedTime"];
            [dict safeSetObject:@(sModel.unitPrice.integerValue) forKey:@"unitPrice"];
        }else if (sModel.isSelectSecondSection) {
            //统一收费
            [dict safeSetObject:sModel.chargeModelId forKey:@"chargeModelId"];
            [dict safeSetObject:@(sModel.chargeType) forKey:@"chargeType"];
            [dict safeSetObject:@(sModel.salesPrice.integerValue) forKey:@"salesPrice"];
            [dict safeSetObject:sModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
            [dict safeSetObject:@(sModel.unifiedPrice.integerValue) forKey:@"unifiedPrice"];
            [dict safeSetObject:@(sModel.unifiedTime) forKey:@"unifiedTime"];
            [dict safeSetObject:@(sModel.unitPrice.integerValue) forKey:@"unitPrice"];
        }
    }
    return dict;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? self.models.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFApplyAddressTableViewCell *cell = [WFApplyAddressTableViewCell cellWithTableView:tableView];
        cell.model = self.addressModel;
        return cell;
    }else if (indexPath.section == 1) {
        WFApplyAreaItemTableViewCell *cell = [WFApplyAreaItemTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:self.models.count];
        cell.model = self.models[indexPath.row];
        return cell;
    }
    WFApplyAreaItemTableViewCell *cell = [WFApplyAreaItemTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:0];
    cell.lineLbl.hidden = YES;
    cell.title.text = indexPath.section == 2 ? @"选择计费方式" : @"合伙人分成设置";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KHeight(120.0f);
    }
    return KHeight(44.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WFApplyAreaHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFApplyAreaHeadView" owner:nil options:nil] firstObject];
    headView.title.text = self.headTitleArrays[section];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(35.0f)+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    
    if (indexPath.section == 1) {
        WFApplyChargeMethod *model = self.models[indexPath.row];
        if (indexPath.row == 0) {
            //单次收费
            WFSingleFeeViewController *single = [[WFSingleFeeViewController alloc] init];
            single.dChargingModelId(model.chargeModelId).dChargingModePlay(model.chargingModePlay).
            mainModels(self.singleFeeData).sType(WFUpdateSingleFeeApplyType);
            @weakify(self)
            single.singleFeeData = ^(NSArray<WFDefaultChargeFeeModel *> * _Nonnull models) {
                @strongify(self)
                self.singleFeeData = models;
            };
            [self.navigationController pushViewController:single animated:YES];
        }else if (indexPath.row == 1) {
            //多次收费
            WFManyTimeFeeViewController *many = [[WFManyTimeFeeViewController alloc] init];
            many.dChargingModelId(model.chargeModelId).dChargingModePlay(model.chargingModePlay).
            dDefaultManyTimesBlock(self.manyTimesModel);
            @weakify(self)
            many.mainModelBlock = ^(WFDefaultManyTimesModel * _Nonnull mainModel) {
                @strongify(self)
                self.manyTimesModel = mainModel;
            };
            [self.navigationController pushViewController:many animated:YES];
        }else if (indexPath.row == 2) {
            //优惠收费
            WFDiscountFeeViewController *discount = [[WFDiscountFeeViewController alloc] init];
            discount.eType(0).dChargingModePlay(model.chargingModePlay).cModelId(model.chargeModelId).
            dDiscountModels(self.discountModels);
            @weakify(self)
            discount.discountFeeDataBlock = ^(WFDefaultDiscountModel * _Nonnull discountModels) {
                @strongify(self)
                self.discountModels = discountModels;
            };
            [self.navigationController pushViewController:discount animated:YES];
        }
        
    }else if (indexPath.section == 2) {
        //计费方式
        WFBilleMethodViewController *method = [[WFBilleMethodViewController alloc] init];
        method.billMethodModels(self.billMethodModel);
        @weakify(self)
        method.billMethodDataBlock = ^(WFBillMethodModel * _Nonnull datas) {
            @strongify(self)
            self.billMethodModel = datas;
        };
        [self.navigationController pushViewController:method animated:YES];
    }else if (indexPath.section == 3) {
        //分成设置
        WFDividIntoSetViewController *set = [[WFDividIntoSetViewController alloc] init];
        set.dividIntoData((NSMutableArray *)self.diviIntoDatas);
        @weakify(self)
        set.dividIntoDataBlock = ^(NSArray<WFMyAreaDividIntoSetModel *> * _Nonnull models) {
            @strongify(self)
            self.diviIntoDatas = models;
        };
        [self.navigationController pushViewController:set animated:YES];
    }
    
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.nextBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/**
 申请片区按钮
 
 @return applyBtn
 */
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextBtn.backgroundColor = UIColorFromRGB(0xF78556);
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}

- (NSMutableArray<WFApplyChargeMethod *> *)models {
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}


/**
 初始化地址

 @return 地址
 */
- (WFApplyAreaAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[WFApplyAreaAddressModel alloc] init];
    }
    return _addressModel;
}



@end
