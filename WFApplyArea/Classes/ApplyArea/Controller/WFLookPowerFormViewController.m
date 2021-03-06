//
//  WFLookPowerFormViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFLookPowerFormViewController.h"
#import "WFLookPowerFormListTableViewCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WFLookPowerFormHeadView.h"
#import "WFProfitItemTableViewCell.h"
#import "WFAreaVipUsersListTableViewCell.h"
#import "WFMyAreaSearchHeadView.h"
#import "WFLookProfitFormHeadView.h"
#import "WFPowerIntervalModel.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFApplyAreaDataTool.h"
#import "SKSafeObject.h"
#import "MJRefresh.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFLookPowerFormViewController ()<UITableViewDelegate,UITableViewDataSource>
///searchController
@property (nonatomic,retain) UISearchController *searchController;
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**功率区间*/
@property (nonatomic, strong, nullable) NSArray <WFPowerIntervalModel *> *powerModels;
/**利润区间*/
@property (nonatomic, strong, nullable) NSArray <WFProfitTableModel *> *profitModels;
/**vip用户*/
@property (nonatomic, strong, nullable) NSMutableArray <WFGroupVipUserModel *> *vipData;
/// vip 搜索数据
@property (nonatomic, strong, nullable) NSArray <WFGroupVipUserModel *> *vipSearchData;
/// 搜索sectionView
@property (nonatomic, strong, nullable) WFMyAreaSearchHeadView *searchView;
/// 是否处于编辑 是否已经编辑
@property (nonatomic, assign) BOOL isBeginEdit;
/**页码*/
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation WFLookPowerFormViewController

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

#pragma mark 私有方法
- (void)setUI {
    if (self.formType == WFLookFormProfitType) {
        self.title = @"查看利润计算表";
        [self getProfitTable];
    }else if (self.formType == WFLookFormPowerType){
        self.title = @"查看功率区间计次表";
        [self getPowerIntervalTable];
    }else {
        self.title = @"查看会员";
        self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
        self.pageNo = 1;
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
    //将获取的数据添加到数组中
    if (models.count != 0) [self.vipData addObjectsFromArray:models];
    
    //如果没有数据隐藏 footer
    self.tableView.mj_footer.hidden = self.vipData.count < 10 ? YES : NO;
    
    if (models.count == 0 & self.vipData.count != 0 & self.pageNo != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView reloadData];
}

/// 搜索数据
/// @param key 搜索关键字
- (void)getSearchVipListWithKey:(NSString *)key {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:key forKey:@"code"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getSearchVipListWithParams:params resultBlock:^(NSArray<WFGroupVipUserModel *> * _Nonnull models) {
        @strongify(self)
        self.vipSearchData = models;
        self.isBeginEdit = self.tableView.mj_header.hidden = YES;
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
    return self.isBeginEdit ? self.vipSearchData.count : self.vipData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.formType == WFLookFormProfitType) {
        //利润
        WFProfitItemTableViewCell *cell = [WFProfitItemTableViewCell cellWithTableView:tableView];
        cell.model = self.profitModels[indexPath.row];
        return cell;
    }else if (self.formType == WFLookFormPowerType) {
        //功率
        WFLookPowerFormListTableViewCell *cell = [WFLookPowerFormListTableViewCell cellWithTableView:tableView];
        cell.model = self.powerModels[indexPath.row];
        cell.vipContentView.hidden = YES;
        return cell;
    }
    WFAreaVipUsersListTableViewCell *cell = [WFAreaVipUsersListTableViewCell cellWithTableView:tableView];
    cell.lineHeight.constant = indexPath.row == 0 ? 0 : 10.0f;
    WFGroupVipUserModel *itemModel = self.isBeginEdit ? [self.vipSearchData safeObjectAtIndex:indexPath.row] : [self.vipData safeObjectAtIndex:indexPath.row];
    cell.model = itemModel;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.formType == WFLookFormProfitType) {
        WFLookProfitFormHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFLookProfitFormHeadView" owner:nil options:nil] firstObject];
        return headView;
    }
    WFLookPowerFormHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFLookPowerFormHeadView" owner:nil options:nil] firstObject];
    headView.vipContentView.hidden = self.formType == WFLookFormPowerType;
    return self.formType == WFLookFormVipType ? [UIView new] : headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.formType == WFLookFormVipType ? CGFLOAT_MIN : KHeight(37.0f);
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(17.0f), 10.0f, ScreenWidth-KWidth(34.0f), ScreenHeight-NavHeight) style:UITableViewStylePlain];
        if (self.formType == WFLookFormVipType) {
            _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight);
            _tableView.tableHeaderView = self.searchView;
            _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
            _tableView.estimatedRowHeight = 140.0f;
        }else {
            _tableView.backgroundColor = UIColor.whiteColor;
            _tableView.rowHeight = KHeight(37.0f);
             _tableView.estimatedRowHeight = 0.0f;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        if (self.formType == WFLookFormVipType) {
            @weakify(self)
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self)
                self.pageNo ++;
                [self getGroupVipUser];
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

- (NSMutableArray<WFGroupVipUserModel *> *)vipData {
    if (!_vipData) {
        _vipData = [[NSMutableArray alloc] init];
    }
    return _vipData;
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
