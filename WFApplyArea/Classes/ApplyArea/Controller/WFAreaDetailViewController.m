//
//  WFAreaDetailViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailViewController.h"
#import "WFAreaDetailAddressTableViewCell.h"
#import "WFAreaDetailSingleTableViewCell.h"
#import "WFAreaDetailManyTimesTableViewCell.h"
#import "WFAreaDetailDiscountTableViewCell.h"
#import "WFAreaDetailTimeTableViewCell.h"
#import "WFMyAreaAddressTableViewCell.h"
#import "WFAreaDetailPartnerTableViewCell.h"
#import "WFAreaDetailOtherSetTableViewCell.h"
#import "WFAreaDetailSinglePowerTableViewCell.h"
#import "WFAreaOtherSetViewController.h"
#import "WFNotHaveFeeTableViewCell.h"
#import "WFSingleFeeViewController.h"
#import "WFManyTimeFeeViewController.h"
#import "WFEditAreaAddressViewController.h"
#import "WFAreaDetailCollectFeeSectionView.h"
#import "WFAreaDetailPersonTableViewCell.h"
#import "WFAreaDetailOtherSectionView.h"
#import "WFEditAreaDetailViewController.h"
#import "WFLookPowerFormViewController.h"
#import "WFBilleMethodViewController.h"
#import "WFDiscountFeeViewController.h"
#import "WFDividIntoSetViewController.h"
#import <MJExtension/MJExtension.h>
#import "UITableView+YFExtension.h"
#import "WFAreaDetailFooterView.h"
#import "WFMyAreaDetailHeadView.h"
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaChargePileView.h"
#import "WFGatewayListView.h"
#import "WFAreaDetailModel.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFAreaDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据*/
@property (nonatomic, strong, nullable) WFAreaDetailModel *mainModels;
/// 防止修改的时候再次查看的时候会保留未保存的数据
@property (nonatomic, strong, nullable) WFAreaDetailModel *showModels;
/**title*/
@property (nonatomic, strong, nullable) NSArray <WFAreaDetailSectionTitleModel *> *sectionTitles;
/**我的充电桩过来的需要显示的*/
@property (nonatomic, strong, nullable) WFMyAreaDetailHeadView *headView;
/**充电桩信号强度*/
@property (nonatomic, strong, nullable) WFMyAreaChargePileView *chargePileView;
/// 分布式 view
@property (nonatomic, strong, nullable) WFGatewayListView *gatewayListView;
/**计费类型，1:小时计费 2:金额计费*/
@property (nonatomic, assign) NSInteger billingPlay;
/** 多次收费*/
@property (nonatomic, assign) BOOL isHaveManyFee;
/**优惠收费*/
@property (nonatomic, assign) BOOL isHaveDiscountFee;
/**是否显示合伙人*/
@property (nonatomic, assign) BOOL isPartner;
/// 是否选中充电桩
@property (nonatomic, assign) BOOL isSelectPile;
/// 是否选中网关
@property (nonatomic, assign) BOOL isSelectGateway;
@end

@implementation WFAreaDetailViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainModels = self.showModels;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] && self.isUpgradeType) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)dealloc {
    [YFNotificationCenter removeObserver:self name:@"reloadDataKeys" object:nil];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"片区详情";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    //添加按钮
    [self addRightTitleBtn:@""];
    self.rightTitleBtn.width = 60.0f;
    [self.rightTitleBtn setTitleColor:UIColorFromRGB(0x666666) forState:0];
    
    //获取片区详情
    [self getAreaDetailMsg];
    //注册通知：监听充电时间变化
    [YFNotificationCenter addObserver:self selector:@selector(getAreaDetailMsg) name:@"reloadDataKeys" object:nil];
}

- (void)rightTitleButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (self.isSelectPile) {
        //充电桩
        [self.rightTitleBtn setTitle:sender.selected ? @"取消" : @"选择移出" forState:0];
        [self.chargePileView reloadDataWithEditType:sender.selected];
    } else if (self.isSelectGateway) {
        //网关
        [self.rightTitleBtn setTitle:sender.selected ? @"取消" : @"网关编辑" forState:0];
        self.gatewayListView.index = sender.selected ? 1 : 0;
    }
}

/**
 获取片区详情
 */
- (void)getAreaDetailMsg {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getAreaDetailWithParams:params resultBlock:^(NSDictionary * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModels:models];
    }];
}

- (void)requestSuccessWithModels:(NSDictionary * _Nonnull)models {
    self.mainModels = [WFAreaDetailModel mj_objectWithKeyValues:models];
    self.showModels = [WFAreaDetailModel mj_objectWithKeyValues:models];
    //是否有多次收费
    self.isHaveManyFee = self.mainModels.multipleChargesList.count != 0 ? YES : NO;
    //是否有单次收费
    self.isHaveDiscountFee = self.mainModels.vipCharge.vipChargeId.length != 0 ? YES : NO;
    //是否显示计费
    if (self.mainModels.billingInfos.count != 0) {
        WFAreaDetailBillingInfosModel *firstModel = [self.mainModels.billingInfos firstObject];
        self.billingPlay = firstModel.billingPlay;
    }
    //是否显示合伙人
    if (self.mainModels.partnerPropInfos.count != 0) {
        self.isPartner = YES;
    }
    
    //获取区头的 title
    [self getSectionTitles];
    
    [self.tableView reloadData];
}

/**
 获取区头的 title
 */
- (void)getSectionTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    //单次收费
    NSMutableDictionary *single = [NSMutableDictionary dictionary];
    NSString *singleTitle = self.mainModels.singleCharge.chargeType == 0 ? @"单次收费/统一收费" : @"单次收费/功率区间收费";
    [single safeSetObject:singleTitle forKey:@"title"];
    [single safeSetObject:self.mainModels.singleCharge.chargeType == 0 ? @0 : @1 forKey:@"isShowForm"];
    [single safeSetObject:@0 forKey:@"isShowDetail"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        [single safeSetObject:self.mainModels.isUpdate ? @1 : @0 forKey:@"isShowEditBtn"];
    }else {
        [single safeSetObject:@0 forKey:@"isShowEditBtn"];
    }
    [single safeSetObject:@"   查看利润计算表   " forKey:@"formTitle"];
    [single safeSetObject:@"" forKey:@"detailTitle"];
    [titles addObject:single];
    //多次收费
    NSMutableDictionary *manyFee = [NSMutableDictionary dictionary];
    if (self.mainModels.multipleChargesList.count != 0) {
        WFAreaDetailMultipleModel *manyModel = self.mainModels.multipleChargesList.firstObject;
        NSString *manyTitle = manyModel.chargeType == 0 ? @"包月收费/统一收费" : @"包月收费/功率区间收费";
        [manyFee safeSetObject:manyTitle forKey:@"title"];
        [manyFee safeSetObject:manyModel.chargeType == 0 ? @0 : @1 forKey:@"isShowForm"];
        [manyFee safeSetObject:@0 forKey:@"isShowDetail"];
    }else {
        [manyFee safeSetObject:@"包月收费" forKey:@"title"];
        [manyFee safeSetObject:@0 forKey:@"isShowForm"];
        [manyFee safeSetObject:@0 forKey:@"isShowDetail"];
    }
    [manyFee safeSetObject:@"   查看功率计次表   " forKey:@"formTitle"];
    [manyFee safeSetObject:@"" forKey:@"detailTitle"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        if (self.mainModels.isUpdate && self.mainModels.multipleChargesList.count != 0) {
            //如果允许修改 并且多次收费
            [manyFee safeSetObject:@1 forKey:@"isShowEditBtn"];
        }else {
            [manyFee safeSetObject:@0 forKey:@"isShowEditBtn"];
        }
    }else {
        [manyFee safeSetObject:@0 forKey:@"isShowEditBtn"];
        [manyFee safeSetObject:@"   隐 藏   " forKey:@"showManyType"];
        [manyFee safeSetObject:@(self.mainModels.isMultipleChargeShow) forKey:@"isShowManyType"];
    }
    [titles addObject:manyFee];
    //优惠收费
    NSMutableDictionary *discountFee = [NSMutableDictionary dictionary];
    [discountFee safeSetObject:@"VIP收费" forKey:@"title"];
    [discountFee safeSetObject:self.mainModels.vipCharge ? @1 : @0 forKey:@"isShowForm"];
    [discountFee safeSetObject:@0 forKey:@"isShowDetail"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        if (self.mainModels.isUpdate && self.mainModels.vipCharge.vipChargeId.length != 0) {
            //如果允许修改 并且有优惠收费
            [discountFee safeSetObject:@1 forKey:@"isShowEditBtn"];
        }else {
            [discountFee safeSetObject:@0 forKey:@"isShowEditBtn"];
        }
        [discountFee safeSetObject:@"   查看会员   " forKey:@"formTitle"];
    }else {
        [discountFee safeSetObject:@0 forKey:@"isShowEditBtn"];
        [discountFee safeSetObject:@"   编辑会员   " forKey:@"formTitle"];
    }
    [discountFee safeSetObject:@"" forKey:@"detailTitle"];
    [titles addObject:discountFee];
    //计费标准
    NSMutableDictionary *freight = [NSMutableDictionary dictionary];
    [freight safeSetObject:@"我的计费标准" forKey:@"title"];
    [freight safeSetObject:@0 forKey:@"isShowForm"];
    [freight safeSetObject:@1 forKey:@"isShowDetail"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        //是否允许编辑
        [freight safeSetObject:self.mainModels.isUpdate ? @1 : @0 forKey:@"isShowEditBtn"];
    }else {
        [freight safeSetObject:@0 forKey:@"isShowEditBtn"];
    }
    [freight safeSetObject:@"" forKey:@"formTitle"];
    [freight safeSetObject:self.billingPlay == 1 ? @"按小时计费" : @"按金额计费" forKey:@"detailTitle"];
    [titles addObject:freight];
    //我的合伙人
    NSMutableDictionary *partner = [NSMutableDictionary dictionary];
    [partner safeSetObject:@"我的合伙人" forKey:@"title"];
    [partner safeSetObject:@0 forKey:@"isShowForm"];
    [partner safeSetObject:@0 forKey:@"isShowDetail"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        [partner safeSetObject:self.mainModels.isUpdate ? @1 : @0 forKey:@"isShowEditBtn"];
    }else {
        [partner safeSetObject:@0 forKey:@"isShowEditBtn"];
    }
    [partner safeSetObject:@"" forKey:@"formTitle"];
    [partner safeSetObject:@"" forKey:@"detailTitle"];
    [titles addObject:partner];
    
    NSMutableDictionary *otherSet = [NSMutableDictionary dictionary];
    [otherSet safeSetObject:@"充满自停设置" forKey:@"title"];
    [otherSet safeSetObject:@0 forKey:@"isShowForm"];
    [otherSet safeSetObject:@0 forKey:@"isShowDetail"];
    if (self.jumpType == WFAreaDetailJumpAreaType) {
        [otherSet safeSetObject:self.mainModels.isUpdate ? @1 : @0 forKey:@"isShowEditBtn"];
    }else {
        [otherSet safeSetObject:@0 forKey:@"isShowEditBtn"];
    }
    [otherSet safeSetObject:@"" forKey:@"formTitle"];
    [otherSet safeSetObject:@"" forKey:@"detailTitle"];
    [titles addObject:otherSet];
    
    self.sectionTitles = [WFAreaDetailSectionTitleModel mj_objectArrayWithKeyValuesArray:titles];
}

/**
 显示片区还是显示信号强度

 @param tag 100 收费按钮 200 充电桩按钮 300 网关
 */
- (void)handleAreaOrPileWithTag:(NSInteger)tag {
    if (tag == 100) {
        //片区信息
        //隐藏右侧按钮
        self.rightTitleBtn.hidden = YES;
        self.tableView.hidden = NO;
        self.chargePileView.hidden = _gatewayListView.hidden = YES;
    }else if (tag == 200) {
        //充电桩按钮
        //显示右侧按钮
        self.rightTitleBtn.hidden = self.rightTitleBtn.selected = NO;
        [self.rightTitleBtn setTitle:@"选择移出" forState:0];
        
        self.chargePileView.hidden = self.isSelectGateway = NO;
        [self.chargePileView reloadDataWithEditType:NO];
        self.tableView.hidden = _gatewayListView.hidden = self.isSelectPile = YES;
    }else {
        //网关
        //显示右侧按钮
        self.rightTitleBtn.hidden = self.rightTitleBtn.selected = NO;
        self.gatewayListView.index = 0;
        [self.rightTitleBtn setTitle:@"网关编辑" forState:0];
        
        self.gatewayListView.hidden = self.isSelectPile = NO;
        self.tableView.hidden = _chargePileView.hidden = self.isSelectGateway = YES;
    }

    [self.view endEditing:YES];
}

/**
 处理区头时间
 */
- (void)handleSectionWithTitle:(NSString *)title {
    if ([title containsString:@"利润计算表"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormProfitType).unitPrices(self.mainModels.singleCharge.unitPrice).
        salesPrices(self.mainModels.singleCharge.salesPrice);
        [self.navigationController pushViewController:form animated:YES];
    }else if ([title containsString:@"功率计次表"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormPowerType);
        [self.navigationController pushViewController:form animated:YES];
    }else if ([title containsString:@"查看会员"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormVipType).groupIds(self.mainModels.groupId);
        [self.navigationController pushViewController:form animated:YES];
    }else if ([title containsString:@"编辑会员"]) {
        WFDiscountFeeViewController *vip = [[WFDiscountFeeViewController alloc] init];
        vip.eType(WFUpdateUserMsgUpdateType).dChargingModePlay(@"3").cModelId(self.mainModels.vipCharge.chargeModelId).
        aGroupId(self.mainModels.groupId).editModels(self.mainModels.vipCharge).
        cModelId(self.mainModels.vipChargeModelId).isNotAllows(YES);
        [self.navigationController pushViewController:vip animated:YES];
    }
}

/**
 跳转到合伙人 和积分方式

 @param section 区域
 */
- (void)jumpPartnerOrchargeCtrlWithSection:(NSInteger)section {
    if (section == 0) {
        //地址
        WFEditAreaAddressViewController *address = [[WFEditAreaAddressViewController alloc] initWithNibName:@"WFEditAreaAddressViewController" bundle:[NSBundle bundleForClass:[self class]]];
        address.dataModels(self.mainModels).sourceType(WFEditAddressAreaDetailType);
        [self.navigationController pushViewController:address animated:YES];
    }else if (section == 1) {
        //单次收费
        WFSingleFeeViewController *single = [[WFSingleFeeViewController alloc] init];
        single.dChargingModePlay(@"1").dChargingModelId(self.mainModels.singleCharge.chargeModelId).
        sType(WFUpdateSingleFeeUpdateType).editModels(self.mainModels.singleCharge).
        groupIds(self.mainModels.groupId);
        [self.navigationController pushViewController:single animated:YES];
    }else if (section == 2) {
        //多次收费
        WFAreaDetailMultipleModel *mModel = [self.mainModels.multipleChargesList firstObject];
        WFManyTimeFeeViewController *many = [[WFManyTimeFeeViewController alloc] init];
        many.dChargingModePlay(@"2").dChargingModelId(mModel.chargeModelId).
        itemArrays(self.mainModels.multipleChargesList).chargeTypes(mModel.chargeType).groupIds(self.mainModels.groupId).
        dChargingModelId(self.mainModels.multipleChargeModelId).sourceType(WFUpdateManyTimeFeeUpdateType).
        isShow(self.mainModels.isMultipleChargeShow);
        [self.navigationController pushViewController:many animated:YES];
    }else if (section == 3) {
        //优惠收费
        WFDiscountFeeViewController *vip = [[WFDiscountFeeViewController alloc] init];
        vip.eType(WFUpdateUserMsgUpdateType).dChargingModePlay(@"3").cModelId(self.mainModels.vipCharge.chargeModelId).
        aGroupId(self.mainModels.groupId).editModels(self.mainModels.vipCharge).
        cModelId(self.mainModels.vipChargeModelId).isNotAllows(NO);
        [self.navigationController pushViewController:vip animated:YES];
    }else if (section == 4) {
        //计费方式
        WFBilleMethodViewController *method = [[WFBilleMethodViewController alloc] init];
        method.groupIds(self.mainModels.groupId).sourceType(WFBilleMethodUpdateType);
        [self.navigationController pushViewController:method animated:YES];
    }else if (section == 5) {
        //我的合伙人
        WFDividIntoSetViewController *set = [[WFDividIntoSetViewController alloc] init];
        set.groupIds(self.mainModels.groupId).sourceType(WFDividIntoSetUpdateType);
        [self.navigationController pushViewController:set animated:YES];
    }else if (section == 6) {
        WFAreaOtherSetViewController *other = [[WFAreaOtherSetViewController alloc] initWithNibName:@"WFAreaOtherSetViewController" bundle:[NSBundle bundleForClass:[self class]]];
        other.groupIds(self.mainModels.groupId).sourceType(WFOtherSetUpdateAreaType).dataModels(self.mainModels);
        [self.navigationController pushViewController:other animated:YES];
    }
}
//
/**
 获取计费方式的高度

 @return getPriceHeight
 */
- (CGFloat)getBillHeight {
    //充电金额
    NSInteger index = self.mainModels.billingInfos.count % 3;
    //获取一共多少行
    NSInteger row = self.mainModels.billingInfos.count / 3;
    //整除的时候的高度
    NSInteger wholeHeight = row * KHeight(32.0f) +  (row - 2) * KHeight(10.0f);
    //不能整除的时候的高度
    NSInteger maxHeight = (row + 1) * KHeight(32.0f) + (row - 1) * KHeight(10.0f);

    return index == 0 ? wholeHeight + 20 : maxHeight + 20;
}

#pragma mark 删除多次收费 和优惠收费
- (void)longPressDeleteManyOrDiscontFeeWithIndex:(NSInteger)index {
    if (self.jumpType == WFAreaDetailJumpPileType) return;
    if (index == 100) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要删除包月收费吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteManyTimesFee];
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
        
    }else if (index == 200) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要删除VIP收费吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteVipChargeFee];
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

/**
 删除多次收费
 */
- (void)deleteManyTimesFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModels.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool deleteManyTimeFeeWithParams:params resultBlock:^{
        @strongify(self)
        [self deleteSuccess];
    }];
}


/**
 删除优惠收费
 */
- (void)deleteVipChargeFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModels.vipCharge.vipChargeId forKey:@"vipChargeId"];
    @weakify(self)
    [WFApplyAreaDataTool deleteVipChargeFeeWithParams:params resultBlock:^{
        @strongify(self)
        [self deleteSuccess];
    }];
}

- (void)deleteSuccess {
    [self getAreaDetailMsg];
}

- (void)goBack {
    if (self.isUpgradeType) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.isHaveManyFee ? self.mainModels.multipleChargesList.count : 1;
    }else if (section == 5) {
        return self.isPartner ? self.mainModels.partnerPropInfos.count + 1 : 0;
    }else if (section == 1) {
        return self.mainModels.singleCharge.powerIntervalConfig.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //地址 我的充电桩进来
        if (self.jumpType == WFAreaDetailJumpPileType) {
            WFMyAreaAddressTableViewCell *cell = [WFMyAreaAddressTableViewCell cellWithTableView:tableView];
            cell.model = self.mainModels;
            return cell;
        }
        WFAreaDetailAddressTableViewCell *cell = [WFAreaDetailAddressTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.mainModels];
        @weakify(self)
        cell.clickEditBtnBlock = ^{
            @strongify(self)
            [self jumpPartnerOrchargeCtrlWithSection:indexPath.section];
        };
        return cell;
    }else if (indexPath.section == 1) {
        //单次收费
        if (self.mainModels.singleCharge.chargeType == 0) {
            //统一收费
            if (indexPath.row == 0) {
                WFAreaDetailDiscountTableViewCell *cell = [WFAreaDetailDiscountTableViewCell cellWithTableView:tableView];
                cell.singleModel = self.mainModels.singleCharge;
                return cell;
            }
            WFAreaDetailSinglePowerTableViewCell *cell = [WFAreaDetailSinglePowerTableViewCell cellWithTableView:tableView];
            cell.model = [self.mainModels.singleCharge.powerIntervalConfig safeObjectAtIndex:indexPath.row-1];
            return cell;
            
        }
        WFAreaDetailSingleTableViewCell *cell = [WFAreaDetailSingleTableViewCell cellWithTableView:tableView];
        cell.model = self.mainModels.singleCharge;
        return cell;
    }else if (indexPath.section == 2) {
        //多次收费
        if (self.isHaveManyFee) {
            WFAreaDetailManyTimesTableViewCell *cell = [WFAreaDetailManyTimesTableViewCell cellWithTableView:tableView];
            cell.model = self.mainModels.multipleChargesList[indexPath.row];
            @weakify(self)
            cell.longPressDeleteBlock = ^(NSInteger index) {
                @strongify(self)
                [self longPressDeleteManyOrDiscontFeeWithIndex:index];
            };
            return cell;
        }
        WFNotHaveFeeTableViewCell *cell = [WFNotHaveFeeTableViewCell cellWithTableView:tableView];
        cell.goBtn.hidden = ![self.sectionTitles[indexPath.section+1] isShowEditBtn];
        @weakify(self)
        cell.gotoSetFeeBlock = ^{
            @strongify(self)
            [self jumpPartnerOrchargeCtrlWithSection:indexPath.section];
        };
        return cell;
        
    }else if (indexPath.section == 3) {
        //优惠收费
        if (self.isHaveDiscountFee) {
            WFAreaDetailDiscountTableViewCell *cell = [WFAreaDetailDiscountTableViewCell cellWithTableView:tableView];
            cell.model = self.mainModels.vipCharge;
            @weakify(self)
            cell.longPressDeleteBlock = ^(NSInteger index) {
                @strongify(self)
                [self longPressDeleteManyOrDiscontFeeWithIndex:index];
            };
            return cell;
        }
        WFNotHaveFeeTableViewCell *cell = [WFNotHaveFeeTableViewCell cellWithTableView:tableView];
        cell.goBtn.hidden = ![self.sectionTitles[indexPath.section+1] isShowEditBtn];
        @weakify(self)
        cell.gotoSetFeeBlock = ^{
            @strongify(self)
            [self jumpPartnerOrchargeCtrlWithSection:indexPath.section];
        };
        return cell;
    }else if (indexPath.section == 4) {
        //时间设置
        WFAreaDetailTimeTableViewCell *cell = [WFAreaDetailTimeTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.mainModels.billingInfos cellHeight:[self getBillHeight]];
        return cell;
    }else if (indexPath.section == 6) {
        //充满自停设置
        WFAreaDetailOtherSetTableViewCell *cell = [WFAreaDetailOtherSetTableViewCell cellWithTableView:tableView];
        cell.models = self.mainModels;
        return cell;
    }
    //合伙人设置
    if (indexPath.row == 0) {
        WFAreaDetailPersonTableViewCell *cell = [WFAreaDetailPersonTableViewCell cellWithTableView:tableView];
        return cell;
    }
    WFAreaDetailPartnerTableViewCell *cell = [WFAreaDetailPartnerTableViewCell cellWithTableView:tableView];
    cell.model = self.mainModels.partnerPropInfos[indexPath.row - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //地址
        return self.jumpType == WFAreaDetailJumpPileType ? 153.0f : KHeight(250.0f);
    }else if (indexPath.section == 1) {
        //单次收费
        return self.mainModels.singleCharge.chargeType == 0 ? KHeight(40.0f) : KHeight(70.0f);
    }else if (indexPath.section == 2) {
        //多次收费
        return self.isHaveManyFee ? KHeight(40.0f) : 200.0f;
    }else if (indexPath.section == 3) {
        //优惠收费
        return self.isHaveDiscountFee ? KHeight(40.0f) : 200.0f;
    }else if (indexPath.section == 4) {
        //计费方式
        return [self getBillHeight];
    }else if (indexPath.section == 6) {
        //充满自停设置
        return 70.0f;
    }
    return KHeight(44.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        WFAreaDetailOtherSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailOtherSectionView" owner:nil options:nil] firstObject];
        sectionView.model = self.sectionTitles[section-1];
        @weakify(self)
        sectionView.clickBtnBlock = ^{
            @strongify(self)
            [self jumpPartnerOrchargeCtrlWithSection:section];
        };
        sectionView.lookBtnBlock = ^(NSString * _Nonnull title) {
            @strongify(self)
            [self handleSectionWithTitle:title];
        };
        return sectionView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : KHeight(40.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0) {
        WFAreaDetailFooterView *footerView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailFooterView" owner:nil options:nil] firstObject];
        return footerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10.0f : 20.0f;
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        if (self.jumpType == WFAreaDetailJumpPileType) {
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight - NavHeight - self.headView.frame.size.height);
        }
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
 头视图

 @return headView
 */
- (WFMyAreaDetailHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaDetailHeadView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 100.0f);
        @weakify(self)
        _headView.clickBtnBlock = ^(NSInteger tag) {
            @strongify(self)
            [self handleAreaOrPileWithTag:tag];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

/**
 信号强度 view

 @return chargePileView
 */
- (WFMyAreaChargePileView *)chargePileView {
    if (!_chargePileView) {
        _chargePileView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaChargePileView" owner:nil options:nil] firstObject];
        _chargePileView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight - NavHeight - self.headView.frame.size.height);
        _chargePileView.groupId = self.groupId;
        _chargePileView.superVC = self;
        @weakify(self)
        _chargePileView.resetEditBlock = ^{
            @strongify(self)
            self.rightTitleBtn.selected = NO;
            [self.rightTitleBtn setTitle:@"选择移出" forState:0];
        };
        [self.view addSubview:_chargePileView];
    }
    return _chargePileView;
}

/// 分布式
- (WFGatewayListView *)gatewayListView {
    if (!_gatewayListView) {
        _gatewayListView = [[WFGatewayListView alloc] initWithGroupId:self.groupId];
        _gatewayListView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight - NavHeight - self.headView.frame.size.height);
        @weakify(self)
        _gatewayListView.resetEditBlock = ^{
            @strongify(self)
            self.rightTitleBtn.selected = NO;
            [self.rightTitleBtn setTitle:@"网关编辑" forState:0];
        };
        [self.view addSubview:_gatewayListView];
    }
    return _gatewayListView;
}



@end
