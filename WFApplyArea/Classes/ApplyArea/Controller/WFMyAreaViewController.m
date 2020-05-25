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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WFMyAreaSearchHeadView.h"
#import "WFMoreEquViewController.h"
#import "UIButton+GradientLayer.h"
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaListModel.h"
#import "WFMyAreaQRCodeView.h"
#import "SKSafeObject.h"
#import "WFPopTool.h"
#import "WKSetting.h"
#import "UserData.h"
#import "WKHelp.h"

@interface WFMyAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIView *bottomView;
/**二维码*/
@property (nonatomic, strong, nullable) WFMyAreaQRCodeView *qrCodeView;
/**数据*/
@property (nonatomic, strong, nullable) NSArray <WFMyAreaListModel *> *models;
/// 搜索数据
@property (nonatomic, strong, nullable) NSArray <WFMyAreaListModel *> *searchModels;
/// 搜索sectionView
@property (nonatomic, strong, nullable) WFMyAreaSearchHeadView *searchView;
/// 是否处于编辑
@property (nonatomic, assign) BOOL isBeginEdit;
@end

@implementation WFMyAreaViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self getAreaList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"我的片区";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
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

///  移入设备
- (void)moveEquipmentCtrlWithGroupId:(NSString *)groupId {
    WFMoreEquViewController *move = [[WFMoreEquViewController alloc] init];
    move.groupId = groupId;
    [self.navigationController pushViewController:move animated:YES];
}

/// 搜索片区
/// @param key 搜索关键字
- (void)getSearchAreaListWithKey:(NSString *)key {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:key forKey:@"code"];
    @weakify(self)
    [WFApplyAreaDataTool getSearchAreaListWithParams:params resultBlock:^(NSArray<WFMyAreaListModel *> * _Nonnull models) {
        @strongify(self)
        self.searchModels = models;
        self.isBeginEdit = YES;
        [self.tableView reloadData];
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
    return self.isBeginEdit ? self.searchModels.count : self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListTableViewCell *cell = [WFMyAreaListTableViewCell cellWithTableView:tableView];
    WFMyAreaListModel *itemModel = self.isBeginEdit ? [self.searchModels safeObjectAtIndex:indexPath.section] : [self.models safeObjectAtIndex:indexPath.section];
    cell.model = itemModel;
    @weakify(self)
    cell.showQRCodeBlock = ^(NSInteger tag) {
        if (tag == 100) {
            @strongify(self)
            [self getAreaQRcodeWithAreaId:itemModel.groupId areaName:itemModel.groupName];
        }else {
            [self moveEquipmentCtrlWithGroupId:itemModel.groupId];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KHeight(10.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListModel *itemModel = self.isBeginEdit ? [self.searchModels safeObjectAtIndex:indexPath.section] : [self.models safeObjectAtIndex:indexPath.section];
    if (itemModel.isNew) {
        //新片区
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = itemModel.groupId;
        detail.jumpType = WFAreaDetailJumpAreaType;
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        //老片区
        WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner-old/page/areaInfoSetmealsDetail.html?areaId=%@&groupId=%@",H5_HOST,itemModel.applyGroupId,itemModel.groupId];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.bottomView.height) style:UITableViewStyleGrouped];
        if (self.partnerRole == 3) _tableView.height = ScreenHeight - NavHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 111.0f;
        _tableView.tableHeaderView = self.searchView;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
    }
    return _tableView;
}

/// 搜索的 view
- (WFMyAreaSearchHeadView *)searchView {
    if (!_searchView) {
        _searchView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaSearchHeadView" owner:nil options:nil] firstObject];
        _searchView.textField.placeholder = @"搜索片区";
        _searchView.rType = WFAreaSearchRadiusNoLineType;
            @weakify(self)
            _searchView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
                @strongify(self)
                if (searchKeys.length == 0){
                    self.isBeginEdit = NO;
                    [self.tableView reloadData];
                }else {
                    [self getSearchAreaListWithKey:searchKeys];
                }
            };
    }
    return _searchView;
}

/**
申请片区按钮
 
 @return applyBtn
 */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 55.0f - NavHeight-SafeAreaBottom, ScreenWidth, 55.0f+SafeAreaBottom)];
        _bottomView.backgroundColor = UIColor.whiteColor;
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        applyBtn.frame = CGRectMake(15.0f, 7.5, ScreenWidth-30.0f, 40.0f);
        [applyBtn setTitle:@"申请片区" forState:UIControlStateNormal];
        [applyBtn addTarget:self action:@selector(clickApplyBtn) forControlEvents:UIControlEventTouchUpInside];
        [applyBtn setGradientLayerWithColors:@[UIColorFromRGB(0xFF6D22),UIColorFromRGB(0xFF7E3D)] cornerRadius:20.0f gradientType:WFButtonGradientTypeLeftToRight];
        applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [applyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bottomView.hidden = self.partnerRole == 3;
        [_bottomView addSubview:applyBtn];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
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
