//
//  WFMyAreaViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaViewController.h"
#import "WFApplyAreaViewController.h"
#import "WFAreaDetailViewController.h"
#import "WFCurrentWebViewController.h"
#import "WFMyAreaListTableViewCell.h"
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaListModel.h"
#import "WFMyAreaQRCodeView.h"
#import "SKSafeObject.h"
#import "WFPopTool.h"
#import "WKSetting.h"
#import "UserData.h"
#import "WKHelp.h"

#import "WFEditAreaAddressViewController.h"

@interface WFMyAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *applyBtn;
/**二维码*/
@property (nonatomic, strong, nullable) WFMyAreaQRCodeView *qrCodeView;
/**数据*/
@property (nonatomic, strong, nullable) NSArray <WFMyAreaListModel *> *models;

@end

@implementation WFMyAreaViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAreaList];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"我的片区";
    [self.view addSubview:self.applyBtn];
    
}

/**
 获取我的片区数据
 */
- (void)getAreaList {
    @weakify(self)
    [WFApplyAreaDataTool getMyApplyAreaListWithParams:@{} resultBlock:^(NSArray<WFMyAreaListModel *> * _Nonnull models) {
        @strongify(self)
        self.models = models;
        [self.tableView reloadData];
    } failBlock:^{
        
    }];
}

/**
 根据片区 Id 获取二维码

 @param areaId 片区 id
 @param areaName 片区名称
 */
- (void)getAreaQRcodeWithAreaId:(NSString *)areaId
                       areaName:(NSString *)areaName {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:areaId forKey:@"chargingGroupId"];
    @weakify(self)
    [WFApplyAreaDataTool getAreaQRcodeWithParams:params resultBlock:^(WFMyAreaQRcodeModel * _Nonnull model) {
        @strongify(self)
        self.qrCodeView.imgUrl = [NSString stringWithFormat:@"%@?qrCode_id=%@&timestamp=%@",model.shareUrl,model.Id,model.expirationMsec];
        self.qrCodeView.name.text = areaName;
        [[WFPopTool sharedInstance] popView:self.qrCodeView animated:YES];
    }];
}

/**
 申请片区
 */
- (void)clickApplyBtn {
    WFApplyAreaViewController *applyVC = [[WFApplyAreaViewController alloc] init];
    WS(weakSelf)
    applyVC.reloadDataBlock = ^{
        [weakSelf getAreaList];
    };
    [self.navigationController pushViewController:applyVC animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListTableViewCell *cell = [WFMyAreaListTableViewCell cellWithTableView:tableView];
    WFMyAreaListModel *itemModel = self.models[indexPath.section];
    cell.model = itemModel;
    @weakify(self)
    cell.showQRCodeBlock = ^{
        @strongify(self)
        [self getAreaQRcodeWithAreaId:itemModel.groupId areaName:itemModel.groupName];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KHeight(10.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? KHeight(10.0f) : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListModel *itemModel = self.models[indexPath.section];
    if (itemModel.isNew) {
        //新片区
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = itemModel.groupId;
        detail.jumpType = WFAreaDetailJumpAreaType;
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        //老片区
        WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@page/areaInfoSetmealsDetail.html?areaId=%@&uuid=%@",H5_HOST,itemModel.applyGroupId,USER_UUID];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.applyBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 100.0f;
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
- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _applyBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_applyBtn setTitle:@"申请片区" forState:UIControlStateNormal];
        [_applyBtn addTarget:self action:@selector(clickApplyBtn) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_applyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _applyBtn.backgroundColor = UIColorFromRGB(0xF78556);
//        [self.view addSubview:_applyBtn];
    }
    return _applyBtn;
}

/**
 二维码

 @return 返回qrCodeView
 */
- (WFMyAreaQRCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaQRCodeView" owner:nil options:nil] firstObject];
        _qrCodeView.closeCodeViewBlock = ^{
            [[WFPopTool sharedInstance] closeAnimated:YES];
        };
    }
    return _qrCodeView;
}

@end
