//
//  WFMyChargePileViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileViewController.h"
#import "WFMyChargePileTableViewCell.h"
#import "WFAbnormalPileViewController.h"
#import "WFAreaDetailViewController.h"
#import "WFMyChargePileSectionView.h"
#import "WFMyChargePileHeadView.h"
#import "WFMyChargePileDataTool.h"
#import "WFMyChargePileModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@interface WFMyChargePileViewController ()<UITableViewDelegate,UITableViewDataSource>
/**头视图*/
@property (nonatomic, strong, nullable) WFMyChargePileHeadView *pHeadView;
/**充电桩状态*/
@property (nonatomic, strong, nullable) WFMyChargePileSectionView *cpView;
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据*/
@property (nonatomic, strong, nullable) WFMyChargePileModel *models;
@end

@implementation WFMyChargePileViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    DLog(@"11");
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"充电桩";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self getMyChargePile];
}

/**
 获取我的充电桩
 */
- (void)getMyChargePile {
    @weakify(self)
    [WFMyChargePileDataTool getMyChargePileWithParams:@{} resultBlock:^(WFMyChargePileModel * _Nonnull models) {
        @strongify(self)
        self.models = models;
        self.models.isSelectPile = YES;
        [self.tableView reloadData];
    }];
}

/**
 处理区头点击事件

 @param index 10 充电桩详情 20 异常充电桩 30 未安装
 */
- (void)handleSectionWithIndex:(NSInteger)index {
    if (index == 10) {
        self.models.isSelectPile = YES;
        self.models.isSelectAbnormalPile = self.models.isNoInstallPile = NO;
    }else if (index == 20) {
        self.models.isSelectAbnormalPile = YES;
        self.models.isSelectPile = self.models.isNoInstallPile = NO;
    }else if (index == 30) {
        self.models.isNoInstallPile = YES;
        self.models.isSelectAbnormalPile = self.models.isSelectPile = NO;
    }
    //重新刷新数据
    self.cpView.model = self.models;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.models.isSelectPile) {
        //我的充电桩
        return self.models.myCdzListList.count;
    }else if (self.models.isSelectAbnormalPile) {
        //异常充电桩
        return self.models.abnormalCdzList.count;
    }
    //未安装
    return self.models.notInstalledCdzList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyChargePileTableViewCell *cell = [WFMyChargePileTableViewCell cellWithTableView:tableView];
    if (self.models.isSelectPile) {
        cell.mModel = self.models.myCdzListList[indexPath.section];
    }else if (self.models.isSelectAbnormalPile) {
        cell.aModel = self.models.abnormalCdzList[indexPath.section];
    }else if (self.models.isNoInstallPile) {
        cell.nmModel = self.models.notInstalledCdzList[indexPath.section];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return KHeight(10.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.models.isSelectAbnormalPile) {
        WFAbnormalCdzListModel *model = self.models.abnormalCdzList[indexPath.section];
        WFAbnormalPileViewController *abnor = [[WFAbnormalPileViewController alloc] init];
        abnor.groupId = model.groupId;
        [self.navigationController pushViewController:abnor animated:YES];
    }else if (self.models.isSelectPile) {
        WFMyCdzListListModel *model = self.models.myCdzListList[indexPath.section];
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = model.groupId;
        detail.jumpType = WFAreaDetailJumpPileType;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(12.0f), self.pHeadView.maxY, ScreenWidth-KWidth(24.0f), ScreenHeight - NavHeight - self.pHeadView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.estimatedRowHeight = KHeight(64);
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.tableHeaderView = self.cpView;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (WFMyChargePileHeadView *)pHeadView {
    if (!_pHeadView) {
        _pHeadView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyChargePileHeadView" owner:nil options:nil] firstObject];
        _pHeadView.models = self.models;
        _pHeadView.frame = CGRectMake(0, 0, ScreenWidth, KHeight(85.0f));
        _pHeadView.autoresizingMask = 0;
        [self.view addSubview:_pHeadView];
    }
    return _pHeadView;
}

- (WFMyChargePileSectionView *)cpView {
    if (!_cpView) {
        _cpView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyChargePileSectionView" owner:nil options:nil] firstObject];
        _cpView.frame = CGRectMake(0, 0, ScreenWidth, KHeight(71.0f));
        _cpView.model = self.models;
        @weakify(self)
        _cpView.clickBtnBlock = ^(NSInteger index) {
            @strongify(self)
            [self handleSectionWithIndex:index];
        };
    }
    return _cpView;
}

@end
