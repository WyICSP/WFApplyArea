//
//  WFMyAreaChargePileView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaChargePileView.h"
#import "WFMyAreaPileListTableViewCell.h"
#import "UITableView+YFExtension.h"
#import "WFMyChargePileDataTool.h"
#import "WFChargePileSearchView.h"
#import "WFMyChargePileModel.h"
#import "WFGatewayDataTool.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "YFKeyWindow.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFMyAreaChargePileView ()<UITableViewDelegate,UITableViewDataSource>
/// 解绑按钮
@property (weak, nonatomic) IBOutlet UIButton *untyingBtn;
/// 分割线
@property (weak, nonatomic) IBOutlet UILabel *line;
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong, nullable) NSArray <WFSignleIntensityListModel *> *models;
/**搜索数据源*/
@property (nonatomic, strong, nullable) NSArray <WFSignleIntensityListModel *> * searchModels;
/// 搜索 view
@property (nonatomic, strong, nullable) WFChargePileSearchView *searchBarView;
/// 搜索关键字
@property (nonatomic, copy, nullable) NSString *searchKeys;
/// 处于搜索转态
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation WFMyAreaChargePileView

#pragma mark 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark 自定义方法
/**
 获取信号强度
 */
- (void)getSignleIntensity {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFMyChargePileDataTool getAreaPilesignalIntensitWithParams:params resultBlock:^(NSArray<WFSignleIntensityListModel *> * _Nonnull models) {
        @strongify(self)
        self.models = models;
        self.isSearch = NO;
        self.untyingBtn.hidden = self.line.hidden = YES;
        [self.tableView reloadData];
    }];
}

/// 搜索数据
- (void)getNomalSearchBycodePile {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.searchKeys forKey:@"code"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool getSearchNormalBycodeWithParams:params resultBlock:^(NSArray<WFSignleIntensityListModel *> * _Nonnull models) {
        @strongify(self)
        self.searchModels = models;
        self.isSearch = YES;
        [self.tableView reloadData];
    }];
}

/// 刷新 tableView
- (void)reloadDataWithEditType:(BOOL)editType {
    self.editType = editType;
    
    self.untyingBtn.hidden = self.line.hidden = !self.editType;
    
    //充值选中状态
    for (WFSignleIntensityListModel *model in self.models) {
        model.isSelect = NO;
    }
    
    [self.tableView reloadData];
}

/// 处理搜索结果方法
/// @param keys 搜索关键字
- (void)complateHandlerSearchResultWithKeys:(NSString *)keys {
    if (keys.length == 0) {
        self.isSearch = NO;
        [self.tableView reloadData];
    }else {
        self.searchKeys = keys;
        [self getNomalSearchBycodePile];
    }
}

/// 解绑
- (IBAction)clickUntyingBtn:(id)sender {
    if ([[self chargingIds] count] == 0) {
        [YFToast showMessage:@"请选择您要解绑的充电桩" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
         return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否解除绑定?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertactionUntyingDistributed];
    }]];
    
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
}

/// 解绑充电桩弹框
- (void)showAlertactionUntyingDistributed {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[self chargingIds] forKey:@"chargingIds"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool untyingChargingWithParams:params resultBlock:^{
        @strongify(self)
        self.searchBarView.textField.text = @"";
        self.editType = NO;
        !self.resetEditBlock ? : self.resetEditBlock();
        [self getSignleIntensity];
    }];
}

/// 充电桩 id
- (NSArray *)chargingIds {
    NSMutableArray *Ids = [[NSMutableArray alloc] init];
    if (self.isSearch) {
        //搜索
        for (WFSignleIntensityListModel *model in self.searchModels) {
            if (model.isSelect) {
                [Ids addObject:model.Id];
            }
        }
    }else {
        //全部数据
        for (WFSignleIntensityListModel *model in self.models) {
            if (model.isSelect) {
                [Ids addObject:model.Id];
            }
        }
    }
    return Ids;
}

/// 处理选中和打开
/// @param tag 100 选中 200 打开
/// @param open 选中还是
/// @param indexPath 行
- (void)handleItemSelectOpenTypeWithTag:(NSInteger)tag
                                   open:(BOOL)open
                              indexPath:(NSIndexPath *)indexPath {
    if (tag == 100) {
        if (!self.editType) return;
        //左边选中情况
        WFSignleIntensityListModel *model = self.isSearch ? self.searchModels[indexPath.row] : self.models[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
        
    }else if (tag == 200) {
        //打开子设备
        [self.tableView refreshTableViewWithSection:indexPath.section indexPath:indexPath.row];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSearch ? self.searchModels.count : self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaPileListTableViewCell *cell = [WFMyAreaPileListTableViewCell cellWithTableView:tableView];
    cell.model = self.isSearch ? self.searchModels[indexPath.row] : self.models[indexPath.row];
    cell.leftCons.constant = self.editType ? 40.0f : 15.0f;
    @weakify(self)
    cell.selectItemBlock = ^(NSInteger tag, BOOL isSelect) {
        @strongify(self)
        [self handleItemSelectOpenTypeWithTag:tag open:isSelect indexPath:indexPath];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBarView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFSignleIntensityListModel *model = self.isSearch ? self.searchModels[indexPath.row] : self.models[indexPath.row];
    return model.isOpen ? 160.0f : 44.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.superVC.view endEditing:YES];
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-100.0f-45.0f) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)setGroupId:(NSString *)groupId {
    _groupId = groupId;
    //获取信号强度
    [self getSignleIntensity];
}

/// 搜索
- (WFChargePileSearchView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFChargePileSearchView" owner:nil options:nil] firstObject];
        _searchBarView.frame = CGRectMake(0, 0, ScreenWidth, 90.0f);
        _searchBarView.autoresizingMask = 0;
        _searchBarView.textField.placeholder = @"请输入充电桩外壳条码ID";
        @weakify(self)
        _searchBarView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
            @strongify(self)
            [self complateHandlerSearchResultWithKeys:searchKeys];
        };
    }
    return _searchBarView;
}

@end
