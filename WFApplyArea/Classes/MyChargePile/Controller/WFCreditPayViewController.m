//
//  WFCreditPayViewController.m
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "WFCreditPayViewController.h"
#import "WFCredBannerTableViewCell.h"
#import "WFCreditApplyNumTableViewCell.h"
#import "YFMediatorManager+WFUser.h"
#import "WFCreditPayTableViewCell.h"
#import "WFMyChargePileDataTool.h"
#import "WFCreditPayModel.h"
#import "WKConfig.h"

@interface WFCreditPayViewController ()<UITableViewDataSource,UITableViewDelegate>
/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
/// 数据源
@property (nonatomic, strong, nullable) WFCreditPayModel *models;
/// 底部充值按钮
@property (nonatomic, strong, nullable) UIView *bottomView;
/// 支付方式
@property (nonatomic, assign) NSInteger payType;
@end

@implementation WFCreditPayViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"授信充值";
    [self adminCreditTemplate];
}

/// 获取数据
- (void)adminCreditTemplate {
    @weakify(self)
    [WFMyChargePileDataTool adminCreditTemplateWithParams:@{} resultBlock:^(WFCreditPayModel * _Nonnull models) {
        @strongify(self)
        self.models = models;
        if (self.models.creditPaymentVOList.count != 0) {
            WFCreditPaymentVOListModel *model = self.models.creditPaymentVOList.firstObject;
            model.isSelect = YES;
        }
        
        [self.tableView reloadData];
    }];
}

/// 充值
- (void)clickAddBtn {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(self.models.deviceNum) forKey:@"deviceNum"];
    [params safeSetObject:@(self.models.money) forKey:@"money"];
    [params safeSetObject:@(self.payType) forKey:@"payMethod"];
    @weakify(self)
    [WFMyChargePileDataTool addAdminCreditTemplAteadminDepositWithParams:params resultBlock:^(WFCheditPayMothedModel * _Nonnull models) {
        @strongify(self)
        [self completionHandlerWith:models];
    }];
}

/**
 处理支付接口条用完成

 @param models mdoels
 */
- (void)completionHandlerWith:(WFCheditPayMothedModel * _Nonnull)models {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:models.appid forKey:@"wxAppId"];
    [params safeSetObject:models.appSecret forKey:@"wxAppSecret"];
    [params safeSetObject:models.partnerid forKey:@"wxPartnerId"];
    [params safeSetObject:models.partnerKey forKey:@"wxPartnerKey"];
    [params safeSetObject:models.prepayid forKey:@"wxOrderNum"];
    [params safeSetObject:models.aliPay forKey:@"aliPayJson"];
    //调用支付
    [YFMediatorManager gotoPayFreightWithParams:params];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? self.models.creditPaymentVOList.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFCredBannerTableViewCell *cell = [WFCredBannerTableViewCell cellWithTableView:tableView];
        cell.model = self.models;
        return cell;
    }else if (indexPath.section == 1) {
        WFCreditApplyNumTableViewCell *cell = [WFCreditApplyNumTableViewCell cellWithTableView:tableView];
        cell.model = self.models;
        return cell;
    }
    WFCreditPayTableViewCell *cell = [WFCreditPayTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:2];
    cell.model = [self.models.creditPaymentVOList safeObjectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *fView = [[UIView alloc] init];
    fView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return fView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KHeight(100.0f)+36.0f;
    }else if (indexPath.section == 1) {
        return 73.0f;
    }
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        for (WFCreditPaymentVOListModel *itemModel in self.models.creditPaymentVOList) {
            itemModel.isSelect = NO;
        }
        WFCreditPaymentVOListModel *model = [self.models.creditPaymentVOList safeObjectAtIndex:indexPath.row];
        model.isSelect = YES;
        self.payType = [model.name containsString:@"支付宝"] ? 0 : 1;
        
        [tableView reloadData];
    }
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.bottomView.height-SafeAreaBottom-NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-55.0f-SafeAreaBottom-NavHeight, ScreenWidth, 55.0f)];
        _bottomView.backgroundColor = UIColor.whiteColor;
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, 9.0f, ScreenWidth-30.0f, 37.0f)];
        [addBtn setTitle:@"充值" forState:UIControlStateNormal];
        [addBtn setTitleColor:UIColor.whiteColor forState:0];
        [addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        addBtn.layer.cornerRadius = 37.0f/2;
        addBtn.backgroundColor = NavColor;
        [_bottomView addSubview:addBtn];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

@end
