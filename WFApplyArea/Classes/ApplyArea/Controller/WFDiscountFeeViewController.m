//
//  WFDiscountFeeViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDiscountFeeViewController.h"
#import "WFDisUnifieldFeeTableViewCell.h"
#import "WFEditVipUserViewController.h"
#import "WFBilleMethodViewController.h"
#import "WFAreaVipUsersListTableViewCell.h"
#import "WFDisUnifieldSectionView.h"
#import "UITableView+YFExtension.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFDiscountFeeAddView.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"

#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "WFPopTool.h"
#import "MJRefresh.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFDiscountFeeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**添加View*/
@property (nonatomic, strong, nullable) WFDiscountFeeAddView *addView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *confirmBtn;
/**vip用户*/
@property (nonatomic, strong, nullable) NSMutableArray <WFGroupVipUserModel *> *vipData;
/**页码*/
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation WFDiscountFeeViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)dealloc {
    [YFNotificationCenter removeObserver:self name:@"refreshVipKeys" object:nil];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"优惠收费";
    self.pageNo = 1;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    if (!self.mainModel) {
        //获取默认的收费
        [self getDefaultDisCountFee];
    }else {
        //数据回显
        [self.tableView reloadData];
    }
    
    if (self.type == WFUpdateUserMsgUpdateType){
        //注册通知：刷新 vip
        [YFNotificationCenter addObserver:self selector:@selector(notificationGetVipData) name:@"refreshVipKeys" object:nil];
        [self getVipUser];
    }
}

- (void)notificationGetVipData {
    self.pageNo = 1;
    [self getVipUser];
}

/**
 获取默认的收费
 */
- (void)getDefaultDisCountFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.chargingModePlay forKey:@"chargingModePlay"];
    [params safeSetObject:self.chargingModelId forKey:@"chargingModelId"];
    @weakify(self)
    [WFApplyAreaDataTool getDefaultDisCountChargeWithParams:params resultBlock:^(NSArray<WFDefaultDiscountModel *> * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModels:models];
    }];
}

- (void)requestSuccessWithModels:(NSArray<WFDefaultDiscountModel *> * _Nonnull)models {
    if (models.count != 0) {
        self.mainModel = models.firstObject;
        if (self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length != 0) {
            //如果是修改需要重新设置值
            self.mainModel.unifiedPrice = self.editModel.unifiedPrice;
            self.mainModel.unifiedTime = self.editModel.unifiedTime;
        }
        [self.tableView refreshTableViewWithSection:0];
    }
}

/**
 获取 vip 用户
 */
- (void)getVipUser {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    [params safeSetObject:@(self.pageNo) forKey:@"pageNo"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    @weakify(self)
    [WFApplyAreaDataTool getVipUserWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
        @strongify(self)
        [self requestVipDataSuccessWith:models];
    } failBlock:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestVipDataSuccessWith:(NSArray<WFGroupVipUserModel *> * _Nonnull)models {
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
    
    if (self.pageNo == 1)
       [self.vipData removeAllObjects];
    
    //将获取的数据添加到数组中
    if (models.count != 0) [self.vipData addObjectsFromArray:models];
    
    if (models.count == 0 & self.vipData.count != 0 & self.pageNo != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView refreshTableViewWithSection:1];
}

/**
 更新优惠收费
 */
- (void)updateVipCollectFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModel.unifiedPrice forKey:@"unifiedPrice"];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    [params safeSetObject:@(self.mainModel.unifiedTime) forKey:@"unifiedTime"];
    [params safeSetObject:self.editModel.vipChargeId forKey:@"vipChargeId"];
    [params safeSetObject:self.mainModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
    [params safeSetObject:self.mainModel.chargeModelId forKey:@"chargeModelId"];
    @weakify(self)
    [WFApplyAreaDataTool updateVipCollectFeeWithParams:params resultBlock:^{
        @strongify(self)
        [self updateSuccess];
    }];
}

- (void)updateSuccess {
    [YFToast showMessage:@"修改成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YFNotificationCenter postNotificationName:@"reloadDataKeys" object:nil];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    });
}

#pragma mark 完成
- (void)clickConfirmBtn {
    [self.view endEditing:YES];

    if (![self isCompleteData]) {
        [YFToast showMessage:@"请完善优惠收费信息" inView:self.view];
        return;
    }
    
    if (self.type == WFUpdateUserMsgUpdateType){
        //修改优化收费
        [self updateVipCollectFee];
    }else if (self.type == WFUpdateUserMsgApplyType){
        //获取默认
        !self.discountFeeDataBlock ? : self.discountFeeDataBlock(self.mainModel);
        [self goBack];
    }else if (self.type == WFUpdateUserMsgUpgradeType) {
        //升级片区
        WFBilleMethodViewController *method = [[WFBilleMethodViewController alloc] init];
        method.sourceType(WFBilleMethodUpgradeType);
        [self.navigationController pushViewController:method animated:YES];
    }
}

/**
 是否把信息填写完整
 
 @return YES 是, NO 表示没有
 */
- (BOOL)isCompleteData {
    BOOL isComplete = NO;
    if (self.mainModel.unifiedPrice.floatValue >= 0 && self.mainModel.unifiedTime > 0) {
        isComplete = YES;
    }else {
        isComplete = NO;
    }
    return isComplete;
}

/**
 添加或者编辑 用户

 @param isEdit 是否编辑
 @param index 下标
 */
- (void)handleEditMsgIsEdit:(BOOL)isEdit index:(NSInteger)index {
    [self.view endEditing:YES];
    
    WFEditVipUserViewController *vip = [[WFEditVipUserViewController alloc] initWithNibName:@"WFEditVipUserViewController" bundle:[NSBundle bundleForClass:[self class]]];
    if (isEdit) {
        vip.imodel(self.vipData[index]).aGroupId(self.applyGroupId).cModelId(self.chargingModelId).
        cVipChargeId(self.editModel.vipChargeId);
    }else {
        vip.aGroupId(self.applyGroupId).cModelId(self.chargingModelId).
        cVipChargeId(self.editModel.vipChargeId);
    }
    [self.navigationController pushViewController:vip animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == WFUpdateUserMsgApplyType ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == WFUpdateUserMsgApplyType) {
        return 1;
    }
    return section == 0 ? 1 : self.vipData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFDisUnifieldFeeTableViewCell *cell = [WFDisUnifieldFeeTableViewCell cellWithTableView:tableView];
        cell.isOnlyReadView.hidden = !self.isNotAllow;
        cell.model = self.mainModel;
        return cell;
    }else {
        WFAreaVipUsersListTableViewCell *cell = [WFAreaVipUsersListTableViewCell cellWithTableView:tableView];
        cell.model = self.vipData[indexPath.row];
        cell.editBtn.hidden = NO;
        @weakify(self)
        cell.editUserMsgBlock = ^{
            @strongify(self)
            [self handleEditMsgIsEdit:YES index:indexPath.row];
        };
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *sectionView = [[UIView alloc] init];
        sectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        return sectionView;
    }else {
        WFDisUnifieldSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDisUnifieldSectionView" owner:nil options:nil] firstObject];
        @weakify(self)
        sectionView.addUserPhoneBlock = ^{
            @strongify(self)
            [self handleEditMsgIsEdit:NO index:0];
        };
        
        return (self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length == 0) ? [UIView new] : sectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10.0f : ((self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length == 0) ? CGFLOAT_MIN : 50.0f) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? KHeight(94.0f) : 140.0f;
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.confirmBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        if (self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length != 0) {
            @weakify(self)
            _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
                @strongify(self)
                self.pageNo ++;
                [self getVipUser];
            }];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/**
 添加用户

 @return addView
 */
- (WFDiscountFeeAddView *)addView {
    if (!_addView) {
        _addView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDiscountFeeAddView" owner:nil options:nil] firstObject];
//        @weakify(self)
//        _addView.addOrCancelBlock = ^(NSInteger tag) {
//            @strongify(self)
//        };
    }
    return _addView;
}

/**
 完成按钮
 
 @return applyBtn
 */
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, self.isNotAllow ? 0.0f : KHeight(45));
        [_confirmBtn setTitle:self.type == WFUpdateUserMsgUpdateType ? @"确认修改" : @"完成" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0xF78556);
        _confirmBtn.hidden = self.isNotAllow;
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

- (NSMutableArray<WFGroupVipUserModel *> *)vipData {
    if (!_vipData) {
        _vipData = [[NSMutableArray alloc] init];
    }
    return _vipData;
}

#pragma mark 链式编程
- (WFDiscountFeeViewController * _Nonnull (^)(WFUpdateUserMsgType))eType {
    return ^(WFUpdateUserMsgType eType) {
        self.type = eType;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(NSString * _Nonnull))aGroupId {
    return ^(NSString *aGroupId){
        self.applyGroupId = aGroupId;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(NSString * _Nonnull))cModelId {
    return ^(NSString *cModelId){
        self.chargingModelId = cModelId;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(NSString * _Nonnull))dChargingModePlay {
    return ^(NSString *chargingModePlay) {
        self.chargingModePlay = chargingModePlay;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(WFDefaultDiscountModel * _Nonnull))dDiscountModels {
    return ^(WFDefaultDiscountModel *discountModels){
        self.mainModel = discountModels;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(WFAreaDetailVipChargeModel * _Nonnull))editModels {
    return ^(WFAreaDetailVipChargeModel *editModel) {
        self.editModel = editModel;
        return self;
    };
}

- (WFDiscountFeeViewController * _Nonnull (^)(BOOL))isNotAllows {
    return ^(BOOL isNotAllow) {
        self.isNotAllow = isNotAllow;
        return self;
    };
}

@end
