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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WFMyAreaSearchHeadView.h"
#import "WFDisUnifieldSectionView.h"
#import "UITableView+YFExtension.h"
#import "UIButton+GradientLayer.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFDiscountFeeAddView.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"
#import "WFAreaFeeMsgData.h"
#import "WFMyAreaListModel.h"
#import "WFUpgradeAreaData.h"
#import "WFUpgradeAreaModel.h"

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
@property (nonatomic, strong, nullable) UIView *bottomView;
/**vip用户*/
@property (nonatomic, strong, nullable) NSMutableArray <WFGroupVipUserModel *> *vipData;
/// vip 搜索数据
@property (nonatomic, strong, nullable) NSArray <WFGroupVipUserModel *> *vipSearchData;
/**老片区数据*/
@property (nonatomic, strong, nullable) WFUpgradeAreaDiscountModel *oldAreaModel;
/// 搜索sectionView
@property (nonatomic, strong, nullable) WFMyAreaSearchHeadView *searchView;
/// 是否处于编辑 是否已经搜索
@property (nonatomic, assign) BOOL isBeginEdit;
/**升级老片区是否开通优惠套餐*/
@property (nonatomic, assign) BOOL isSelect;
/**页码*/
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation WFDiscountFeeViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)dealloc {
    [YFNotificationCenter removeObserver:self name:@"refreshVipKeys" object:nil];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"VIP收费";
    self.pageNo = 1;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    if (!self.mainModel) {
        for (WFApplyChargeMethod *model in [WFAreaFeeMsgData shareInstace].feeData) {
            if (model.chargingModePlay.integerValue == 3) {
                //优惠收费
                self.chargingModePlay = model.chargingModePlay;
                self.chargingModelId = model.chargeModelId;
                //获取优惠收费信息
                [self getOldAreaDiscountFee];
            }
        }
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
    
    self.tableView.mj_footer.hidden = self.vipData.count < 10 ? YES : NO;
    
    if (models.count == 0 & self.vipData.count != 0 & self.pageNo != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView reloadData];
}

/**
 修改优惠收费参数

 @return 优惠收费数据
 */
- (NSDictionary *)discountDataMsg {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModel.unifiedPrice forKey:@"unifiedPrice"];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    [params safeSetObject:@(self.mainModel.unifiedTime) forKey:@"unifiedTime"];
    [params safeSetObject:self.editModel.vipChargeId forKey:@"vipChargeId"];
    [params safeSetObject:self.mainModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
    [params safeSetObject:self.mainModel.chargeModelId forKey:@"chargeModelId"];
    return params;
}

/**
 更新优惠收费
 */
- (void)updateVipCollectFee {
    @weakify(self)
    [WFApplyAreaDataTool updateVipCollectFeeWithParams:[self discountDataMsg] resultBlock:^{
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

/**
 老片区 获取用户 vip 用户
 */
- (void)getOldAreaDiscountFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getOldAreaDiscountFeeWithParams:params resultBlock:^(WFUpgradeAreaDiscountModel * _Nonnull oldModels) {
        @strongify(self)
        self.oldAreaModel = oldModels;
        self.isSelect = [WFUpgradeAreaData shareInstance].isExistence = oldModels.isExist;
        [self requestVipDataSuccessWith:oldModels.vipMemberList];
    }];
}

/// 删除 vip 会员
/// @param vipId 用户 ID
-(void)alertDeleteVipUserWithVipId:(NSString *)vipId {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除该会员吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteVipUserWithVipId:vipId];
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

/// 删除 vip ID
/// @param vipId 用户 ID
- (void)deleteVipUserWithVipId:(NSString *)vipId {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:vipId forKey:@"vipId"];
    @weakify(self)
    [WFApplyAreaDataTool deleteVipUserWithParams:params resultBlock:^{
        @strongify(self)
        [self notificationGetVipData];
    }];
}

/// 搜索数据
/// @param key 搜索关键字
- (void)getSearchVipListWithKey:(NSString *)key {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:key forKey:@"code"];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    [params safeSetObject:@(self.pageNo) forKey:@"pageNo"];
    [params safeSetObject:@(100) forKey:@"pageSize"];
    @weakify(self)
    [WFApplyAreaDataTool getVipUserWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
        @strongify(self)
        self.vipSearchData = models;
        self.isBeginEdit = self.tableView.mj_header.hidden = YES;
        [self.tableView reloadData];
    } failBlock:^{
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
    }];
//    @weakify(self)
//    [WFApplyAreaDataTool getSearchVipListWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
//        @strongify(self)
//        self.vipSearchData = models;
//        self.isBeginEdit = self.tableView.mj_header.hidden = YES;
//        [self.tableView reloadData];
//    }];
}

#pragma mark 完成
- (void)clickConfirmBtn {
    [self.view endEditing:YES];
    
    NSString *alertMsg = @"";
    if (self.type == WFUpdateUserMsgUpgradeType) {
        if (self.oldAreaModel.isExist || self.isSelect) {
            //老片区有优惠套餐必须要选中
            alertMsg = ![self isCompleteData] ? @"请完善VIP收费信息" : @"";
        }
    }else {
        alertMsg = ![self isCompleteData] ? @"请完善VIP收费信息" : @"";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
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
        //保存优惠收费数据
        if (self.isSelect)
        [WFUpgradeAreaData shareInstance].discountFee = [self discountDataMsg];
        
        //收货方式
        WFBilleMethodViewController *method = [[WFBilleMethodViewController alloc] init];
        method.sourceType(WFBilleMethodUpgradeType).groupIds(self.applyGroupId);
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
        WFGroupVipUserModel *model = self.isBeginEdit ? [self.vipSearchData safeObjectAtIndex:index] : [self.vipData safeObjectAtIndex:index];
        vip.imodel(model).aGroupId(self.applyGroupId).cModelId(self.chargingModelId).
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
    return section == 0 ? 1 : (self.isBeginEdit ? self.vipSearchData.count : self.vipData.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFDisUnifieldFeeTableViewCell *cell = [WFDisUnifieldFeeTableViewCell cellWithTableView:tableView];
        cell.isOnlyReadView.hidden = !self.isNotAllow;
        if (self.type == WFUpdateUserMsgUpgradeType) {
            //升级老片区
            cell.selectBtnWidth.constant = cell.titleLeftCons.constant = 45.0f;
            cell.selectBtn.selected = self.oldAreaModel.isExist;
            //如果isExist 为 yes 则必须选中
            cell.selectBtn.userInteractionEnabled = !self.oldAreaModel.isExist;
        }else {
            cell.selectBtnWidth.constant = 0.0f;
            cell.titleLeftCons.constant = 12.0f;
        }
        @weakify(self)
        cell.clickSelectItemBlock = ^(BOOL isSelect) {
            @strongify(self)
            self.isSelect = isSelect;
        };
        cell.model = self.mainModel;
        return cell;
    }else {
        WFAreaVipUsersListTableViewCell *cell = [WFAreaVipUsersListTableViewCell cellWithTableView:tableView];
        WFGroupVipUserModel *model = self.isBeginEdit ? [self.vipSearchData safeObjectAtIndex:indexPath.row] : [self.vipData safeObjectAtIndex:indexPath.row];
        cell.model = model;
        cell.editBtn.hidden = self.type == WFUpdateUserMsgUpgradeType;
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
        
        return ((self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length == 0) || (self.type == WFUpdateUserMsgUpgradeType)) ? [UIView new] : sectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length != 0) ? CGFLOAT_MIN : 10.0f;
    }
    return (((self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length == 0) || (self.type == WFUpdateUserMsgUpgradeType)) ? CGFLOAT_MIN : 50.0f) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 94.0f : 140.0f;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *cancel =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        WFGroupVipUserModel *model = self.isBeginEdit ? [self.vipSearchData safeObjectAtIndex:indexPath.row] : [self.vipData safeObjectAtIndex:indexPath.row];
        [self alertDeleteVipUserWithVipId:model.vipId];
    }];
    cancel.backgroundColor = NavColor;
    return indexPath.section == 0 ? @[] : @[cancel];
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.bottomView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        if (self.type == WFUpdateUserMsgUpdateType && self.editModel.vipChargeId.length != 0) {
            _tableView.tableHeaderView = self.searchView;
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

/// 搜索的 view
- (WFMyAreaSearchHeadView *)searchView {
    if (!_searchView) {
        _searchView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaSearchHeadView" owner:nil options:nil] firstObject];
        _searchView.textField.placeholder = @"搜索会员";
        _searchView.rType = WFAreaSearchRadiusNoLineType;
            @weakify(self)
            _searchView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
                @strongify(self)
                if (searchKeys.length == 0){
                    self.isBeginEdit = self.tableView.mj_header.hidden = NO;
                    [self.tableView reloadData];
                }else {
                    [self getSearchVipListWithKey:searchKeys];
                }
            };
    }
    return _searchView;
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
 按钮 title
 
 @return 按钮 title
 */
- (NSString *)btnTitle {
    NSString *title = @"";
    if (self.type == WFUpdateUserMsgUpdateType) {
        title = @"确认修改";
    }else if (self.type == WFUpdateUserMsgUpgradeType) {
        title = @"下一步(4/7)";
    }else {
        title = @"完成";
    }
    return title;
}

/**
 完成按钮
 
 @return applyBtn
 */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 55.0f - NavHeight-SafeAreaBottom, ScreenWidth, 55.0f+SafeAreaBottom)];
        _bottomView.backgroundColor = UIColor.whiteColor;
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(15.0f, 7.5, ScreenWidth-30.0f, self.isNotAllow ? 0.0f : 40.0f);
        [confirmBtn setTitle:[self btnTitle] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setGradientLayerWithColors:@[UIColorFromRGB(0xFFBD00),UIColorFromRGB(0xFFCF00)] cornerRadius:20.0f gradientType:WFButtonGradientTypeLeftToRight];
        confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [confirmBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        confirmBtn.hidden = self.isNotAllow;
        [_bottomView addSubview:confirmBtn];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
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
