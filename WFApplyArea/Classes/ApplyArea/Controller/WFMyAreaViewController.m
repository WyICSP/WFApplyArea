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
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaListModel.h"
#import "WFMyAreaQRCodeView.h"
#import "SKSafeObject.h"
#import "WFPopTool.h"
#import "WKSetting.h"
#import "UserData.h"
#import "WKHelp.h"

@interface WFMyAreaViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>
///searchController
@property (nonatomic,retain) UISearchController *searchController;
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *applyBtn;
/**二维码*/
@property (nonatomic, strong, nullable) WFMyAreaQRCodeView *qrCodeView;
/**数据*/
@property (nonatomic, strong, nullable) NSArray <WFMyAreaListModel *> *models;
/// 搜索数据
@property (nonatomic, strong, nullable) NSArray <WFMyAreaListModel *> *searchModels;
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
    self.isBeginEdit = self.searchController.active = NO;
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"我的片区";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:self.tableView];
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

/// 搜索片区
/// @param key 搜索关键字
- (void)getSearchAreaListWithKey:(NSString *)key {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:key forKey:@"code"];
    @weakify(self)
    [WFApplyAreaDataTool getSearchAreaListWithParams:params resultBlock:^(NSArray<WFMyAreaListModel *> * _Nonnull models) {
        @strongify(self)
        self.searchModels = models;
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
    if (self.isBeginEdit && self.searchModels.count == 0) {
        return self.models.count;
    }
    return self.isBeginEdit ? self.searchModels.count : self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListTableViewCell *cell = [WFMyAreaListTableViewCell cellWithTableView:tableView];
    WFMyAreaListModel *itemModel = nil;
    if (self.isBeginEdit && self.searchModels.count == 0) {
        itemModel = [self.models safeObjectAtIndex:indexPath.section];
    }else {
        itemModel = self.isBeginEdit ? [self.searchModels safeObjectAtIndex:indexPath.section] : [self.models safeObjectAtIndex:indexPath.section];
    }
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
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaListModel *itemModel = nil;
    if (self.isBeginEdit && self.searchModels.count == 0) {
        itemModel = [self.models safeObjectAtIndex:indexPath.section];
    }else {
        itemModel = self.isBeginEdit ? [self.searchModels safeObjectAtIndex:indexPath.section] : [self.models safeObjectAtIndex:indexPath.section];
    }
    if (itemModel.isNew) {
        //新片区
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = itemModel.groupId;
        detail.jumpType = WFAreaDetailJumpAreaType;
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        //老片区
        WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@yzc_business_h5/page/areaInfoSetmealsDetail.html?areaId=%@&groupId=%@",H5_HOST,itemModel.applyGroupId,itemModel.groupId];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark - UISearchControllerDelegate代理

//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *searchString = [self.searchController.searchBar text];
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //刷新表格
//    [self.tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController {

}

- (void)didPresentSearchController:(UISearchController *)searchController {
    //申请按钮显示
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    self.applyBtn.hidden = self.isBeginEdit = NO;
    [self.tableView reloadData];
    [self.searchController.searchBar setPositionAdjustment:UIOffsetMake(self.searchController.searchBar.frame.size.width/2-80, 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
}

- (void)presentSearchController:(UISearchController *)searchController {
    //设置 placehodler 的位置
    [self.searchController.searchBar setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.applyBtn.hidden = self.isBeginEdit = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length != 0)
    [self getSearchAreaListWithKey:searchBar.text];
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - self.applyBtn.height-SafeAreaBottom) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 111.0f;
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
    }
    return _tableView;
}


/// searchController
- (UISearchController *)searchController {
    if (!_searchController) {
        //创建UISearchController
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        //设置代理
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        //包着搜索框外层的颜色
        _searchController.searchBar.barTintColor = UIColorFromRGB(0xF5F5F5);
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:NavColor];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
        if (@available(iOS 13.0, *)) {
            _searchController.searchBar.searchTextField.backgroundColor = UIColor.whiteColor;
        }else {
            UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
            searchField.backgroundColor = UIColor.whiteColor;
        }
        //提醒字眼
        _searchController.searchBar.placeholder= @"搜索片区";
        //设置内容居中
        [_searchController.searchBar setPositionAdjustment:UIOffsetMake(_searchController.searchBar.frame.size.width/2-80, 0) forSearchBarIcon:UISearchBarIconSearch];
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[_searchController.searchBar class]]] setTitle:@"取消"];
        //设置UISearchController的显示属性，以下3个属性默认为YES
        //搜索时，背景变暗色
        _searchController.dimsBackgroundDuringPresentation = NO;
        [_searchController.searchBar setContentMode:UIViewContentModeTop];
        _searchController.searchBar.layer.borderWidth = 1;
        _searchController.searchBar.layer.borderColor = UIColorFromRGB(0xF5F5F5).CGColor;
        //搜索时，背景变模糊
        //    self.searchController.obscuresBackgroundDuringPresentation = NO;
        //点击搜索的时候,是否隐藏导航栏
//            self.searchController.hidesNavigationBarDuringPresentation = NO;
        //位置
        _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x, 0, _searchController.searchBar.frame.size.width, 55.0);
//#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
        self.definesPresentationContext=YES;
    }
    return _searchController;
}

/**
 申请片区按钮

 @return applyBtn
 */
- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _applyBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight-SafeAreaBottom, ScreenWidth, KHeight(45));
        [_applyBtn setTitle:@"申请片区" forState:UIControlStateNormal];
        [_applyBtn addTarget:self action:@selector(clickApplyBtn) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_applyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _applyBtn.backgroundColor = UIColorFromRGB(0xF78556);
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
