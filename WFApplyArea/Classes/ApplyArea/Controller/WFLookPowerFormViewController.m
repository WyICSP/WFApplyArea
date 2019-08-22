//
//  WFLookPowerFormViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFLookPowerFormViewController.h"
#import "WFLookPowerFormListTableViewCell.h"
#import "WFLookPowerFormHeadView.h"
#import "WFProfitItemTableViewCell.h"
#import "WFLookProfitFormHeadView.h"
#import "WFPowerIntervalModel.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFApplyAreaDataTool.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFLookPowerFormViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**功率区间*/
@property (nonatomic, strong, nullable) NSArray <WFPowerIntervalModel *> *powerModels;
/**利润区间*/
@property (nonatomic, strong, nullable) NSArray <WFProfitTableModel *> *profitModels;
/**vip用户*/
@property (nonatomic, strong, nullable) NSArray <WFGroupVipUserModel *> *vipData;
@end

@implementation WFLookPowerFormViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    if (self.formType == WFLookFormProfitType) {
        self.title = @"查看利润计算表";
        [self getProfitTable];
    }else if (self.formType == WFLookFormPowerType){
        self.title = @"查看功率区间记次表";
        [self getPowerIntervalTable];
    }else {
        self.title = @"查看会员";
        [self getGroupVipUser];
    }
    
}

/**
 查看功率区间
 */
- (void)getPowerIntervalTable {
    @weakify(self)
    [WFApplyAreaDataTool getPowerIntervalTableWithParams:@{} resultBlock:^(NSArray<WFPowerIntervalModel *> * _Nonnull models) {
        @strongify(self)
        self.powerModels = models;
        [self.tableView reloadData];
    }];
}

/**
 获取利润区间表
 */
- (void)getProfitTable {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.salesPrice forKey:@"salesPrice"];
    [params safeSetObject:self.unitPrice forKey:@"unitPrice"];
    @weakify(self)
    [WFApplyAreaDataTool getProfitTableWithParams:params resultBlock:^(NSArray<WFProfitTableModel *> * _Nonnull models) {
        @strongify(self)
        self.profitModels = models;
        [self.tableView reloadData];
    }];
}

/**
 获取 vip 用户
 */
- (void)getGroupVipUser {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getVipUserWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
        @strongify(self)
        self.vipData = models;
        
        if (self.vipData.count == 0)
        [YFToast showMessage:@"暂无数据"];
        
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.formType == WFLookFormProfitType) {
        return self.profitModels.count;
    }else if (self.formType == WFLookFormPowerType) {
        return self.powerModels.count;
    }
    return self.vipData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.formType == WFLookFormProfitType) {
        //利润
        WFProfitItemTableViewCell *cell = [WFProfitItemTableViewCell cellWithTableView:tableView];
        cell.model = self.profitModels[indexPath.row];
        return cell;
    }
    //功率
    WFLookPowerFormListTableViewCell *cell = [WFLookPowerFormListTableViewCell cellWithTableView:tableView];
    if (self.formType == WFLookFormPowerType) {
        cell.model = self.powerModels[indexPath.row];
        cell.vipContentView.hidden = YES;
    }else {
        cell.vModel = self.vipData[indexPath.row];
        cell.vipContentView.hidden = NO;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.formType == WFLookFormProfitType) {
        WFLookProfitFormHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFLookProfitFormHeadView" owner:nil options:nil] firstObject];
        return headView;
    }
    WFLookPowerFormHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFLookPowerFormHeadView" owner:nil options:nil] firstObject];
    headView.vipContentView.hidden = self.formType == WFLookFormPowerType;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(37.0f);
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(17.0f), 10.0f, ScreenWidth-KWidth(34.0f), ScreenHeight-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = KHeight(37.0f);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 链式编程
- (WFLookPowerFormViewController * _Nonnull (^)(WFLookFormType))formTypes {
    return ^(WFLookFormType formType){
        self.formType = formType;
        return self;
    };
}

- (WFLookPowerFormViewController * _Nonnull (^)(NSNumber * _Nonnull))salesPrices {
    return ^(NSNumber *salesPrice){
        self.salesPrice = salesPrice;
        return self;
    };
}

- (WFLookPowerFormViewController * _Nonnull (^)(NSNumber * _Nonnull))unitPrices {
    return ^(NSNumber *unitPrice){
        self.unitPrice = unitPrice;
        return self;
    };
}

- (WFLookPowerFormViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId){
        self.groupId = groupId;
        return self;
    };
}

@end
