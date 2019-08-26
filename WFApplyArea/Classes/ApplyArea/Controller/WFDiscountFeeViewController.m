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
#import "WFDisItemsTableViewCell.h"
#import "WFDisUnifieldSectionView.h"
#import "UITableView+YFExtension.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFDiscountFeeAddView.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"

#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "WFPopTool.h"
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
@property (nonatomic, strong, nullable) NSArray <WFGroupVipUserModel *> *vipData;

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
        [YFNotificationCenter addObserver:self selector:@selector(getVipUser) name:@"refreshVipKeys" object:nil];
        [self getVipUser];
    }
    
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
        if (self.type == WFUpdateUserMsgUpdateType) {
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
    @weakify(self)
    [WFApplyAreaDataTool getVipUserWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
         @strongify(self)
        self.vipData = models;
        [self.tableView refreshTableViewWithSection:1];
    }];
}

/**
 更新优惠收费
 */
- (void)updateVipCollectFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModel.unifiedPrice forKey:@"unifiedPrice"];
    [params safeSetObject:@(self.mainModel.unifiedTime) forKey:@"unifiedTime"];
    [params safeSetObject:self.editModel.vipChargeId forKey:@"vipChargeId"];
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

/**
 完成
 */
- (void)clickConfirmBtn {
    [self.view endEditing:YES];
    
    if (self.type == WFUpdateUserMsgUpdateType && self.mainModel.isChange){
        //修改优化收费
        [self updateVipCollectFee];
    }else {
        //获取默认
        !self.discountFeeDataBlock ? : self.discountFeeDataBlock(self.mainModel);
        [self goBack];
    }
    
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
        vip.imodel(self.vipData[index]).aGroupId(self.applyGroupId).cModelId(self.chargingModelId);
    }else {
        vip.aGroupId(self.applyGroupId).cModelId(self.chargingModelId);
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
        cell.model = self.mainModel;
        return cell;
    }else {
        WFDisItemsTableViewCell *cell = [WFDisItemsTableViewCell cellWithTableView:tableView];
        cell.model = self.vipData[indexPath.row];
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
        return sectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? KHeight(10.0f) : 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? KHeight(94.0f) : KHeight(74.0f);
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(12.0f), 0, ScreenWidth-KWidth(24.0f), ScreenHeight - NavHeight - self.confirmBtn.height) style:UITableViewStyleGrouped];
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
        _confirmBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0xF78556);
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
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

@end