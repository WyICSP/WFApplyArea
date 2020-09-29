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
#import "WFCurrentWebViewController.h"
#import "WFMyAreaSearchHeadView.h"
#import "WFMyChargePileHeadView.h"
#import "WFMyChargePileDataTool.h"
#import "WFMyChargePileModel.h"
#import "WFGatewayDataTool.h"
#import <MJExtension/MJExtension.h>
#import "NSString+Regular.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "UserData.h"
#import "WKSetting.h"
#import "WKHelp.h"

@interface WFMyChargePileViewController ()<UITableViewDelegate,UITableViewDataSource>
/**头视图*/
@property (nonatomic, strong, nullable) WFMyChargePileHeadView *pHeadView;
/**充电桩状态*/
@property (nonatomic, strong, nullable) WFMyChargePileSectionView *cpView;
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/// 搜索sectionView
@property (nonatomic, strong, nullable) WFMyAreaSearchHeadView *searchView;
/**数据*/
@property (nonatomic, strong, nullable) WFMyChargePileModel *models;
/**title 数组*/
@property (nonatomic, strong, nullable) NSArray *titles;
/// 正常搜索关键字
@property (nonatomic, copy, nullable) NSString *searchKeys;
/// 0.充电桩详情 1.异常充电桩 2. 未安装充电桩
@property (nonatomic, assign) NSInteger type;
/// 搜索的正常充电桩
@property (nonatomic, strong, nullable) NSArray <WFMyCdzListListModel *> *searchNomDatas;
/// 搜索异常充电桩
@property (nonatomic, strong, nullable) NSArray <WFAbnormalCdzListModel *> *searchAbnormalDatas;
/// 搜索未安装数据
@property (nonatomic, strong, nullable) NSArray <WFNotInstalledCdzListModel *> *searchNoInstallDatas;
/// 正常充电桩的搜索, 异常充电桩的搜索 未安装充电桩搜索
@property (nonatomic, copy, nullable) NSString *numSearchKey,*abmSearchKey,*noInsSearchKey;
/// //0 全部, 1 自己
@property (nonatomic, assign) NSInteger myType;
/// 正常充电桩的搜索
@property (nonatomic, assign) BOOL isNomSearch;
/// 异常充电桩的搜索
@property (nonatomic, assign) BOOL isabmSearch;
/// 未安装充电桩的搜索
@property (nonatomic, assign) BOOL isNoInsSearch;

@end

@implementation WFMyChargePileViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"我的设备";
    self.type = self.myType = 0;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    //设置按钮
    [self addRightImageBtn:@"screen_all"];
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:@"screen_all" bundlerName:@"WFApplyArea.bundle"];
    [self.rightImageBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
    
    [self getMyChargePile];
}

- (void)rightImageButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.myType = sender.selected ? 1 : 0;
    // 重置数据
    [self resetData];
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    NSString *normalImg = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:@"screen_all" bundlerName:@"WFApplyArea.bundle"];
    NSString *select_Img = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:@"screen_own" bundlerName:@"WFApplyArea.bundle"];
    [self.rightImageBtn setImage:[UIImage imageWithContentsOfFile:normalImg] forState:UIControlStateNormal];
    [self.rightImageBtn setImage:[UIImage imageWithContentsOfFile:select_Img] forState:UIControlStateSelected];
 
    [self getMyChargePile];
}

/// 重置数据
- (void)resetData {
    // 设置默认不选中 搜索
    self.isNomSearch =  self.isabmSearch = self.isNoInsSearch = NO;
    // 重置搜索框
    self.numSearchKey = self.abmSearchKey = self.noInsSearchKey = self.searchView.textField.text = @"";
}

/**
 获取我的充电桩
 */
- (void)getMyChargePile {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(self.myType) forKey:@"type"]; //0 全部, 1 自己
    @weakify(self)
    [WFMyChargePileDataTool getMyChargePileWithParams:params resultBlock:^(WFMyChargePileModel * _Nonnull models) {
        @strongify(self)
        [self getMyChargePileSuccessWith:models];
    }];
}

- (void)getMyChargePileSuccessWith:(WFMyChargePileModel * _Nonnull)models {
    self.models = models;
    self.models.isSelectPile = YES;
    //正常充电桩
    NSString *normalPileTitle = @"   充电桩详情   ";
    //异常充电桩
    NSString *abnormalPileTitle = [NSString stringWithFormat:@"   异常充电桩(%ld)   ",(long)self.models.abnormalCount];
    //未安装
    NSString *notInstallPileTitle = [NSString stringWithFormat:@"   未安装(%ld)   ",(long)self.models.notInstalledCount];
    self.titles = @[normalPileTitle,abnormalPileTitle,notInstallPileTitle];
    //设置头部选中状态
    self.cpView.model = self.models;
    // 刷新页面
    [self.tableView reloadData];
    // 赋值
    self.pHeadView.models = self.models;
}

/// 搜索充电桩
/// @param searchKey 搜索关键字
- (void)getSearchPileDataWithSearchKeys:(NSString *)searchKey {
    self.searchKeys = searchKey;
    if (searchKey.length == 0) {
        self.isNomSearch = self.isabmSearch = self.isNoInsSearch = NO;
        self.numSearchKey = self.abmSearchKey = self.noInsSearchKey = @"";
        [self.tableView reloadData];
    }else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params safeSetObject:searchKey forKey:@"code"];
        [params safeSetObject:@(self.type) forKey:@"type"];//0.充电桩详情 1.异常充电桩 2. 未安装充电桩
        [params safeSetObject:@(self.myType) forKey:@"completeType"];
        @weakify(self)
        [WFGatewayDataTool getSearchCDZBycodeWithParams:params resultBlock:^(NSDictionary * _Nonnull dict) {
            @strongify(self)
            [self setSearchSelectTypeWithDict:dict];
        }];
    }
}

- (void)setSearchSelectTypeWithDict:(NSDictionary *)dict {
    if (self.type == 0) {
        //正常充电桩详情
        self.isNomSearch = YES;
        self.isabmSearch = self.isNoInsSearch = NO;
        //搜索的关键字
        self.numSearchKey = self.searchKeys;
        //搜索数据
        self.searchNomDatas = [WFMyCdzListListModel mj_objectArrayWithKeyValuesArray:[[dict safeJsonObjForKey:@"data"] safeJsonObjForKey:@"param"]];
    }else if (self.type == 1) {
        self.isabmSearch = YES;
        self.isNomSearch = self.isNoInsSearch = NO;
        //搜索的关键字
        self.abmSearchKey = self.searchKeys;
        //搜索数据
        self.searchAbnormalDatas = [WFAbnormalCdzListModel mj_objectArrayWithKeyValuesArray:[[dict safeJsonObjForKey:@"data"] safeJsonObjForKey:@"param"]];
    }else if (self.type == 2) {
        self.isNoInsSearch = YES;
        self.isNomSearch = self.isabmSearch = NO;
        //搜索的关键字
        self.noInsSearchKey = self.searchKeys;
        //搜索数据
        self.searchNoInstallDatas = [WFNotInstalledCdzListModel mj_objectArrayWithKeyValuesArray:[[dict safeJsonObjForKey:@"data"] safeJsonObjForKey:@"param"]];
    }
    [self.tableView reloadData];
}

/**
 处理区头点击事件

 @param index 10 充电桩详情 20 异常充电桩 30 未安装
 */
- (void)handleSectionWithIndex:(NSInteger)index {
    [self.view endEditing:YES];
    if (index == 10) {
        self.type = 0;
        //切换赋值
        self.searchView.textField.text = self.numSearchKey;
        //设置选中转态
        self.models.isSelectPile = YES;
        self.models.isSelectAbnormalPile = self.models.isNoInstallPile = NO;
        self.searchView.textField.placeholder = @"请输入片区名称";
    }else if (index == 20) {
        self.type = 1;
        //切换赋值
        self.searchView.textField.text = self.abmSearchKey;
        //设置选中转态
        self.models.isSelectAbnormalPile = YES;
        self.models.isSelectPile = self.models.isNoInstallPile = NO;
        self.searchView.textField.placeholder = @"请输入片区名称";
    }else if (index == 30) {
        self.type = 2;
        //切换赋值
        self.searchView.textField.text = self.noInsSearchKey;
        //设置选中转态
        self.models.isNoInstallPile = YES;
        self.models.isSelectAbnormalPile = self.models.isSelectPile = NO;
        self.searchView.textField.placeholder = @"请输入设备的外壳条码ID";
    }
    //重新刷新数据
    self.cpView.model = self.models;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.models.isSelectPile) {
        //我的充电桩
        return self.isNomSearch ? self.searchNomDatas.count : self.models.myCdzListList.count;
    }else if (self.models.isSelectAbnormalPile) {
        //异常充电桩
        return self.isabmSearch ? self.searchAbnormalDatas.count : self.models.abnormalCdzList.count;
    }
    //未安装
    return self.isNoInsSearch ? self.searchNoInstallDatas.count : self.models.notInstalledCdzList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyChargePileTableViewCell *cell = [WFMyChargePileTableViewCell cellWithTableView:tableView];
    if (self.models.isSelectPile) {
        cell.mModel = self.isNomSearch ? self.searchNomDatas[indexPath.row] : self.models.myCdzListList[indexPath.row];
    }else if (self.models.isSelectAbnormalPile) {
        cell.aModel = self.isabmSearch ? self.searchAbnormalDatas[indexPath.row] : self.models.abnormalCdzList[indexPath.row];
    }else if (self.models.isNoInstallPile) {
        cell.nmModel = self.isNoInsSearch ? self.searchNoInstallDatas[indexPath.row] : self.models.notInstalledCdzList[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.models.isSelectAbnormalPile) {
        WFAbnormalCdzListModel *model = self.isabmSearch ? self.searchAbnormalDatas[indexPath.row] : self.models.abnormalCdzList[indexPath.row];
        WFAbnormalPileViewController *abnor = [[WFAbnormalPileViewController alloc] init];
        abnor.groupId = model.groupId;
        [self.navigationController pushViewController:abnor animated:YES];
    }else if (self.models.isSelectPile) {
        WFMyCdzListListModel *model = self.isNomSearch ? self.searchNomDatas[indexPath.row] : self.models.myCdzListList[indexPath.row];
        if (model.isNew) {
            //新片区
            WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
            detail.groupId = model.groupId;
            detail.jumpType = WFAreaDetailJumpPileType;
            [self.navigationController pushViewController:detail animated:YES];
        }else {
            //老片区
            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner-old/page/areaInfoSetmeals.html?code=%@",H5_HOST,model.groupId];
            web.title = @"片区详情";
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(0.0f), self.pHeadView.maxY, ScreenWidth-KWidth(0.0f), ScreenHeight - NavHeight - self.pHeadView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.estimatedRowHeight = KHeight(64);
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.cpView;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

/// 安装台数, 和使用率
- (WFMyChargePileHeadView *)pHeadView {
    if (!_pHeadView) {
        _pHeadView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyChargePileHeadView" owner:nil options:nil] firstObject];
        _pHeadView.frame = CGRectMake(0, 0, ScreenWidth, KHeight(85.0f));
        _pHeadView.autoresizingMask = 0;
        [self.view addSubview:_pHeadView];
    }
    return _pHeadView;
}

/// 充电桩 异常充电桩 未安装 的按钮
- (WFMyChargePileSectionView *)cpView {
    if (!_cpView) {
        _cpView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyChargePileSectionView" owner:nil options:nil] firstObject];
        _cpView.frame = CGRectMake(0, 0, ScreenWidth, KHeight(71.0f));
        _cpView.titles = self.titles;
        @weakify(self)
        _cpView.clickBtnBlock = ^(NSInteger index) {
            @strongify(self)
            [self handleSectionWithIndex:index];
        };
    }
    return _cpView;
}

/// 搜索的 view
- (WFMyAreaSearchHeadView *)searchView {
    if (!_searchView) {
        _searchView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaSearchHeadView" owner:nil options:nil] firstObject];
        _searchView.rType = WFAreaSearchRadiusLineType;
            @weakify(self)
            _searchView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
                @strongify(self)
                [self getSearchPileDataWithSearchKeys:searchKeys];
            };
    }
    return _searchView;
}


@end
