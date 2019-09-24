//
//  WFDividIntoSetViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDividIntoSetViewController.h"
#import "WFDividIntoSetTableViewCell.h"
#import "WFDiviIntoSetEditTableViewCell.h"
#import "WFDiviIntoSetHeadTableViewCell.h"
#import "WFAreaDetailViewController.h"
#import "UITableView+YFExtension.h"
#import "WFMyAreaListModel.h"
#import "WFApplyAreaDataTool.h"
#import "WFUpgradeAreaData.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"
#import "UserData.h"

@interface WFDividIntoSetViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *confirmBtn;
/**公司的占比*/
@property (nonatomic, strong, nullable) WFMyAreaDividIntoSetModel *comModel;
/**合伙人占比*/
@property (nonatomic, strong, nullable) WFMyAreaDividIntoSetModel *parModel;
@end

@implementation WFDividIntoSetViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"分成设置";
    if (self.models.count == 0) {
        //获取默认的
        [self getDividIntoSet];
    }else {
        //获取已经设置的
        [self.tableView reloadData];
    }
}

/**
 获取默认分成设置
 */
- (void)getDividIntoSet {
    if (self.type == WFDividIntoSetApplyType || self.type == WFDividIntoSetUpgradeType) {
        //获取默认分成设置
        @weakify(self)
        [WFApplyAreaDataTool getUserDividintoSetWithParams:@{} resultBlock:^(NSArray<WFMyAreaDividIntoSetModel *> * _Nonnull models) {
            @strongify(self)
            [self requestSuccessWithModels:models];
        }];
    }else if (self.type == WFDividIntoSetUpdateType){
        //根据片区 Id 获取分成设置
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params safeSetObject:self.groupId forKey:@"groupId"];
        @weakify(self)
        [WFApplyAreaDataTool getUserDividIntoSetByGroupIdWithParams:params resultBlock:^(NSArray<WFMyAreaDividIntoSetModel *> * _Nonnull models) {
            @strongify(self)
            [self requestSuccessWithModels:models];
        }];
    }
}

- (void)requestSuccessWithModels:(NSArray <WFMyAreaDividIntoSetModel *> *)models {
    [self.models addObjectsFromArray:models];
    [self.tableView reloadData];
}

/**
 更新分成设置
 */
- (void)updateDividIntoSet {
    
    //判断信息是否填写正确
    if (![self isComplete]) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.chargingModelId forKey:@"chargingModelId"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:self.partnerPropInfos forKey:@"partnerPropInfos"];
    @weakify(self)
    [WFApplyAreaDataTool updateDividIntoSetWithParams:params resultBlock:^{
        @strongify(self)
        [self updateSuccess];
    }];
}

- (void)updateSuccess {
    [YFToast showMessage:@"更新成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YFNotificationCenter postNotificationName:@"reloadDataKeys" object:nil];
        [self goBack];
    });
}

/**
 添加数据
 */
- (void)addItemData {
    //每次添加的需要在合伙人的分成比例上减
    WFMyAreaDividIntoSetModel *firstModel = self.parModel;
    if (firstModel.rate < 10) {
        [YFToast showMessage:@"合伙人比值为整数且相加不能超过100%" inView:self.view];
        return;
    }else if (self.models.count >= 5) {
        [YFToast showMessage:@"最多只能添加3个用户" inView:self.view];
        return;
    }
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    WFMyAreaDividIntoSetModel *itemModel = [[WFMyAreaDividIntoSetModel alloc] init];
    itemModel.rate = 10;
    itemModel.chargePersonFlag = 2;//标记
    firstModel.rate -= 10;
    [itemArray addObject:itemModel];
    [self.models addObjectsFromArray:itemArray];
    [self.tableView reloadData];
}

/**
 提示是否删除合伙人
 */
- (void)showDeleteAlertWithIndex:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除此合伙人吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reduceItemDataWithIndex:index];
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

/**
 删除某一个数据

 @param index 第几的的一条数据
 */
- (void)reduceItemDataWithIndex:(NSInteger)index {
    //删除的数据
    WFMyAreaDividIntoSetModel *selectModel = [self.models objectAtIndex:index];
    //合伙人数据
    WFMyAreaDividIntoSetModel *firstModel = self.parModel;
    firstModel.rate += selectModel.rate;
    
    [self.models removeObjectAtIndex:index];
    
    [self.tableView reloadData];
}

/**
 校验输入的数据

 @param present 百分比
 @param index 第几的的一条数据
 */
- (void)checkInputTextWithPresent:(NSInteger)present
                            index:(NSInteger)index {
    
    //当前编辑的那条数据
    WFMyAreaDividIntoSetModel *selectModel = [self.models objectAtIndex:index];
    //得到能输入的最大值
    NSInteger maxPresent = self.parModel.rate + selectModel.rate;
    //合伙人数据
    WFMyAreaDividIntoSetModel *firstModel = self.parModel;
    //公司的占比
    firstModel.rate = maxPresent-present;
    if (firstModel.rate <= 0) {
        firstModel.rate = 0;
        selectModel.rate = maxPresent;
        [self.tableView reloadData];
    }else {
        selectModel.rate = present;
        //刷新合伙人那一行
        [self.tableView refreshTableViewWithSection:0 indexPath:2];
    }
}

/**
 计算百分比总和

 @return 百分比总和
 */
- (int)totalPresent {
    int sum = 0;
    for (WFMyAreaDividIntoSetModel *model in self.models) {
        sum += model.rate;
    }
    return sum;
}

- (int)otherPresent {
    //合伙人数据
    WFMyAreaDividIntoSetModel *firstModel = [self.models firstObject];
    return [self totalPresent] - (int)firstModel.rate;
}

/**
 获取合伙人分成配置
 
 @return partnerPropInfos
 */
- (NSArray *)partnerPropInfos {
    
    NSMutableArray *dArray = [NSMutableArray new];
    for (WFMyAreaDividIntoSetModel *dModel in self.models) {
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
 老片区升级成为新片区
 */
- (void)upgradeOldAreaToNewArea {
    //片区详细地址
    NSString *address = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"address"]];
    //片区省市区 Id
    NSString *areaId = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"areaId"]];
    //片区名
    NSString *name = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"name"]];
    //重组数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:address forKey:@"address"];//地址
    [params safeSetObject:areaId forKey:@"areaId"];//地址
    [params safeSetObject:name forKey:@"name"];//片区名
    [params safeSetObject:self.groupId forKey:@"groupId"];//片区 Id
    if ([WFUpgradeAreaData shareInstance].multipleChargesList.count != 0) {
        //多次收费
        [params safeSetObject:[WFUpgradeAreaData shareInstance].multipleChargesList forKey:@"multipleChargesList"];
    }
    if ([WFUpgradeAreaData shareInstance].discountFee.count != 0) {
        //vip 设置
        [params safeSetObject:[WFUpgradeAreaData shareInstance].discountFee forKey:@"vipCharge"];
    }
    [params safeSetObject:[WFUpgradeAreaData shareInstance].billingPlanIds forKey:@"billingPlanIds"];//收费方式
    [params safeSetObject:[WFUpgradeAreaData shareInstance].partnerPropInfos forKey:@"partnerPropInfos"];//分成设置
    [params safeSetObject:[WFUpgradeAreaData shareInstance].singleCharge forKey:@"singleCharge"];//单次收费
    
    @weakify(self)
    [WFApplyAreaDataTool upgradeOldAreaToNewAreaWithParams:params resultBlock:^{
        @strongify(self)
        [self oldAreaUpgradeSuccess];
    }];
}

- (void)oldAreaUpgradeSuccess {
    [YFToast showMessage:@"升级成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = self.groupId;
        detail.jumpType = WFAreaDetailJumpAreaType;
        detail.isUpgradeType = YES;
        [self.navigationController pushViewController:detail animated:YES];
    });
}

#pragma mark 完成
- (void)clickConfirmBtn {
    if (self.type == WFDividIntoSetApplyType) {
        //判断是否信息是否填写正确
        if (![self isComplete]) return;
        
        
        //获取默认设置
        !self.dividIntoDataBlock ? : self.dividIntoDataBlock(self.models);
        [self goBack];
    }else if (self.type == WFDividIntoSetUpdateType){
        //更新合伙人设置
        [self updateDividIntoSet];
    }else if (self.type == WFDividIntoSetUpgradeType) {
        //保存数据
        [WFUpgradeAreaData shareInstance].partnerPropInfos = [self partnerPropInfos];
        //升级片区
        [self upgradeOldAreaToNewArea];
    }
}

/**
 警示
 */
- (BOOL)isComplete {
    //如果用户信息没有填写完成 需要提醒
    for (WFMyAreaDividIntoSetModel *model in self.models) {
        if (model.name.length == 0 || model.phone.length == 0) {
            [YFToast showMessage:@"请完善用户信息" inView:self.view];
            return NO;
        }else if (![NSString validateMobile:model.phone]) {
            [YFToast showMessage:@"请填写正确的手机号" inView:self.view];
            return NO;
        }
    }
    return YES;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WFDiviIntoSetHeadTableViewCell *cell = [WFDiviIntoSetHeadTableViewCell cellWithTableView:tableView];
        WS(weakSelf)
        cell.addItemBlock = ^{
            //添加数据
            [weakSelf addItemData];
        };
        return cell;
    }else if (indexPath.row == 1) {
        WFDividIntoSetTableViewCell *cell = [WFDividIntoSetTableViewCell cellWithTableView:tableView];
        return cell;
    }
    WFDiviIntoSetEditTableViewCell *cell = [WFDiviIntoSetEditTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:self.models.count+2];
    [cell bindToCellWithModel:self.models[indexPath.row-2] maxPresent:self.parModel];
    
    WS(weakSelf)
    cell.deleteItemBlock = ^{
        //删除数据
        [weakSelf showDeleteAlertWithIndex:indexPath.row-2];
    };
    cell.checkPresentBlock = ^(NSInteger present) {
        //检查输入值的有效性
        [weakSelf checkInputTextWithPresent:present index:indexPath.row-2];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(12.0f);
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.confirmBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = KHeight(44.0f);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/**
 申请片区按钮
 
 @return applyBtn
 */
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_confirmBtn setTitle:[self btnTitle] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0xF78556);
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

/**
 按钮 title
 
 @return 按钮 title
 */
- (NSString *)btnTitle {
    NSString *title = @"";
    if (self.type == WFDividIntoSetUpdateType) {
        title = @"确认修改";
    }else if (self.type == WFDividIntoSetUpgradeType) {
        title = @"下一步(6/6)";
    }else {
        title = @"完成";
    }
    return title;
}

/**
 获取公司占比

 @return comModel
 */
- (WFMyAreaDividIntoSetModel *)comModel {
    for (WFMyAreaDividIntoSetModel *cModel in self.models) {
        if (cModel.chargePersonFlag == 0) {
            return cModel;
        }
    }
    return nil;
}

/**
 获取合伙人占比

 @return parModel
 */
- (WFMyAreaDividIntoSetModel *)parModel {
    for (WFMyAreaDividIntoSetModel *cModel in self.models) {
        if (cModel.chargePersonFlag == 1) {
            return cModel;
        }
    }
    return nil;
}

- (NSMutableArray<WFMyAreaDividIntoSetModel *> *)models {
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

#pragma mark 链式编程
- (WFDividIntoSetViewController * _Nonnull (^)(NSMutableArray<WFMyAreaDividIntoSetModel *> * _Nonnull))dividIntoData {
    return ^(NSMutableArray <WFMyAreaDividIntoSetModel *> *models){
        self.models = models;
        return self;
    };
}

- (WFDividIntoSetViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId) {
        self.groupId = groupId;
        return self;
    };
}

- (WFDividIntoSetViewController * _Nonnull (^)(NSString * _Nonnull))chargingModelIds {
    return ^(NSString *chargingModelId) {
        self.chargingModelId = chargingModelId;
        return self;
    };
}

- (WFDividIntoSetViewController * _Nonnull (^)(WFDividIntoSetSourceType))sourceType {
    return ^(WFDividIntoSetSourceType type) {
        self.type = type;
        return self;
    };
}


@end
