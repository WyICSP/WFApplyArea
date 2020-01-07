//
//  WFGatewayListView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/21.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFGatewayListView.h"
#import "WFGatewayListTableViewCell.h"
#import "WFChargePileSearchView.h"
#import "WFGatewayListSectionView.h"
#import "WFGatewayBottomView.h"
#import "WFNRReplaceGatewayListView.h"
#import "WFGatewayDataTool.h"
#import "UITableView+YFExtension.h"
#import "WFGatewayListModel.h"
#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "MJRefresh.h"
#import "YFKeyWindow.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFGatewayListView ()<UITableViewDelegate,UITableViewDataSource>
/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
/// 搜索 view
@property (nonatomic, strong, nullable) WFChargePileSearchView *searchBarView;
/// 解绑替换 view
@property (nonatomic, strong, nullable) WFGatewayBottomView *bottomView;
/// 替换网关 view
@property (nonatomic, strong, nullable) WFNRReplaceGatewayListView *gatewayView;
/// 网关数据
@property (nonatomic, strong, nullable) NSMutableArray <WFGatewayListModel *> *models;
/// 搜索出来的数据
@property (nonatomic, strong, nullable) NSArray <WFGatewayListModel *> *searchModels;
/// 能替换的网关数据
@property (nonatomic, strong, nullable) NSArray <WFFindAllGateWayModel *> *replaceDatas;
/// 选中网关 Id
@property (nonatomic, copy, nullable) NSString *gateWayId;
/// 搜索关键字
@property (nonatomic, copy, nullable) NSString *searchKeys;
/// 处于搜索转态
@property (nonatomic, assign) BOOL isSearch;
/// 是否需要重置
@property (nonatomic, assign) BOOL isNeedReset;
/// 页码
@property (nonatomic, assign) NSInteger pageNumber;
@end

@implementation WFGatewayListView

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        self.groupId = groupId;
        [self setUI];
    }
    return self;
}

#pragma mark 私有方法 接口调用相关接口
- (void)setUI{
    //默认页码
    self.pageNumber = 1;
    //获取数据
    [self getGatewayListData];
}

/// 获取网关数据
- (void)getGatewayListData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:@(self.pageNumber) forKey:@"pageNumber"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    @weakify(self)
    [WFGatewayDataTool getGatewayListWithParams:params resultBlock:^(NSArray<WFGatewayListModel *> * _Nonnull models) {
        @strongify(self)
        [self requestVipDataSuccessWith:models];
    } failBlock:^{
//        @strongify(self)
    }];
}

- (void)requestVipDataSuccessWith:(NSArray<WFGatewayListModel *> * _Nonnull)models {
    //模式不是搜索
    self.isSearch = self.bottomView.replaceBtn.enabled = NO;
    [self.bottomView.replaceBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
    
    //如果页码为1的时候 把数据清除掉
    if (self.pageNumber == 1) [self.models removeAllObjects];
    
    //将获取的数据添加到数组中
    if (models.count != 0) [self.models addObjectsFromArray:models];
    
    //重置 编辑按钮
    if (self.isNeedReset) {
        self.index = 0;
        !self.resetEditBlock ? : self.resetEditBlock();
    }
    //如果数据不足 10 条直接隐藏
    self.tableView.mj_footer.hidden = (self.pageNumber == 1 && self.models.count < 10);
    
    if (models.count == 0 & self.models.count != 0 & self.pageNumber != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView reloadData];
}

/// 查询片区下面的可以用来替换网关
- (void)queryGateway {
    
    NSArray *gateWayIds = [self oldGatewayIds];
    if (gateWayIds.count == 0) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gateWayIds forKey:@"gateWayId"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool queryReplaceGatewayWithParams:params resultBlock:^(NSArray<WFFindAllGateWayModel *> * _Nonnull models) {
        @strongify(self)
        self.replaceDatas = models;
        if (self.replaceDatas.count == 0) {
            [YFToast showMessage:@"暂无可替换网关" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
            return;
        }
        [self showGatewayView];
    }];
}

/// 替换网关
/// @param gateWayId 新网关 id
- (void)showAlertActionWithGatewayId:(NSString *)gateWayId
                         gatewayName:(NSString *)gatewayName {
    NSArray *oldGatewayIds = [self oldGatewayIds];
    if (oldGatewayIds.count == 0) return;
    //网关名
    NSArray *names = [self oldGatewayNames];
    
    NSString *title = [NSString stringWithFormat:@"是否将%@网关替换成%@网关",[names componentsJoinedByString:@","],gatewayName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self untyingGatewayWithGatewayId:gateWayId];
        }]];
        
        [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
}

/// 替换网关
/// @param gateWayId 新网关 id
- (void)untyingGatewayWithGatewayId:(NSString *)gateWayId {
    
    NSArray *oldGatewayIds = [self oldGatewayIds];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gateWayId forKey:@"newGateWayId"];
    [params safeSetObject:oldGatewayIds forKey:@"oldGateWayId"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool untyingGatewayWithParams:params resultBlock:^{
        @strongify(self)
        [YFToast showMessage:@"替换成功" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        //重新获取数据
        [self retrieveData];
    }];
}

/// 解绑充电桩弹框
- (void)showAlertactionUntyingDistributed {
    
    NSArray *gatewayUntyingList = [self gatewayUntyingList];
    if (gatewayUntyingList.count == 0) {
        [YFToast showMessage:@"请选择您需要解绑的设备" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否解除绑定?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self untyingDistributedChargingPile];
    }]];
    
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
}

/// 解绑分布式充电桩
- (void)untyingDistributedChargingPile {
    //解绑充电桩数据
    NSArray *gatewayUntyingList = [self gatewayUntyingList];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:gatewayUntyingList forKey:@"gateWayUntyingVOList"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool untyingDistributedChargingPileWithParams:params resultBlock:^{
        @strongify(self)
        [YFToast showMessage:@"解绑成功" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        //重新获取数据
        [self retrieveData];
    }];
}

/// 重新获取数据
- (void)retrieveData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isNeedReset = YES;
        //重新获取数据
        [self setUI];
    });
}

/// 搜索网关数据
- (void)getSearchGatewayList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.searchKeys forKey:@"code"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFGatewayDataTool getSearchGatewayListWithParams:params resultBlock:^(NSArray<WFGatewayListModel *> * _Nonnull models) {
        @strongify(self)
        self.isSearch = YES;
        self.searchModels = models;
        [self.tableView reloadData];
    }];
}

#pragma mark 接口调用之前或者之后协助的相关方法
/// 替换网关 参数
- (NSArray *)oldGatewayIds {
    NSMutableArray *gatewayIds = [[NSMutableArray alloc] init];
    for (WFGatewayListModel *model in (self.isSearch ? self.searchModels : self.models)) {
        if (model.isSelect) {
            [gatewayIds addObject:model.gateWayId];
        }
    }
    return gatewayIds;
}

/// 名字
- (NSArray *)oldGatewayNames {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (WFGatewayListModel *model in (self.isSearch ? self.searchModels : self.models)) {
        if (model.isSelect) {
            [names addObject:model.gateWayCode];
        }
    }
    return names;
}

/// 解绑充电桩的参数
- (NSArray *)gatewayUntyingList {
    NSMutableArray *untyingList = [[NSMutableArray alloc] init];
    for (WFGatewayListModel *lModel in (self.isSearch ? self.searchModels : self.models)) {
        //遍历整个数据
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *pileArray = [[NSMutableArray alloc] init];
        for (WFGatewayLoarListModel *itemModel in lModel.loraChargeVOList) {
            //遍历单条数据
            if (itemModel.isSelect) {
                //将选中的数据添加到数组中
                [pileArray addObject:itemModel.chargeId];
            }
        }
        if (pileArray.count != 0 || lModel.isSelect) {
            [dict safeSetObject:pileArray forKey:@"chargingId"];
            [dict safeSetObject:lModel.gateWayId forKey:@"gateWayId"];
            [dict safeSetObject:@(lModel.isSelect) forKey:@"flag"];
            [untyingList addObject:dict];
        }
    }
    return untyingList;
}

/// 处理解绑 和替换
/// @param tag 10 解绑 20 替换
- (void)complateHandleReplaceWithTag:(NSInteger)tag {
    if (tag == 10) {
        //解绑
        [self showAlertactionUntyingDistributed];
    } else if (tag == 20) {
        //替换
        [self queryGateway];
    }
}

/// 处理网关的选中和打开关闭
/// @param tag 10 选中未选中 20 打开关闭
/// @param index 选中的第几个区
- (void)complateHandlerGatewayWithTag:(NSInteger)tag
                                index:(NSInteger)index {
    WFGatewayListModel *model = (self.isSearch ? self.searchModels : self.models)[index];
    if (tag == 10) {
        if (self.index == 0) return;
        //选中or未选中 选中了这个那么久需要选中 下面的子设备
        model.isSelect = !model.isSelect;
        //选中子设备
        for (WFGatewayLoarListModel *childModel in model.loraChargeVOList) {
            childModel.isSelect = model.isSelect;
        }
        
        //替换按钮是否高亮
        BOOL isCanReplace = [self isCanReplace];
        self.bottomView.replaceBtn.enabled = isCanReplace;
        [self.bottomView.replaceBtn setTitleColor:isCanReplace ? NavColor : UIColorFromRGB(0x999999) forState:0];
        
    }else if (tag == 20) {
        //打开 or 关闭
        model.isOpen = !model.isOpen;
    }
    [self.tableView reloadData];
}

/// 是否能替换
- (BOOL)isCanReplace {
    BOOL isReplace = NO;
    for (WFGatewayListModel *model in (self.isSearch ? self.searchModels : self.models)) {
        if (model.isSelect) {
            isReplace = YES;
        }
    }
    return isReplace;
}

/// 处理搜索结果方法
/// @param keys 搜索关键字
- (void)complateHandlerSearchResultWithKeys:(NSString *)keys {
    if (keys.length == 0) {
        //隐藏 footer
        self.tableView.mj_footer.hidden = YES;
        self.isSearch = NO;
        [self.tableView reloadData];
    }else {
        self.searchKeys = keys;
        [self getSearchGatewayList];
    }
}

- (void)showGatewayView {
    self.gatewayView.hidden = NO;
    self.gatewayView.models = self.replaceDatas;
    [UIView animateWithDuration:0.25 animations:^{
        self.gatewayView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.299];
        self.gatewayView.y = -468;
    }];
}

/// 处理选中和打开
/// @param tag 100 选中 200 打开
/// @param open 选中还是
/// @param indexPath 行
- (void)handleItemSelectOpenTypeWithTag:(NSInteger)tag
                                   open:(BOOL)open
                              indexPath:(NSIndexPath *)indexPath {
    if (tag == 100) {
        //选中网关就必须选中设备 选中设备可以不选中网关
        WFGatewayListModel *fModel = (self.isSearch ? self.searchModels : self.models)[indexPath.section];
        //选中设备
        WFGatewayLoarListModel *model = self.isSearch ? [self.searchModels[indexPath.section] loraChargeVOList][indexPath.row] : [self.models[indexPath.section] loraChargeVOList][indexPath.row];
        model.isSelect = !model.isSelect;
        
        if (fModel.isSelect) {
            self.bottomView.replaceBtn.enabled = YES;
            [self.bottomView.replaceBtn setTitleColor:NavColor forState:0];
        }
        [self.tableView reloadData];
    }else if (tag == 200) {
        //打开子设备
        [self.tableView refreshTableViewWithSection:indexPath.section indexPath:indexPath.row];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isSearch ? self.searchModels.count : self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return [self.searchModels[section] isOpen] ? [[self.searchModels[section] loraChargeVOList] count] : 0;
    }
    return [self.models[section] isOpen] ? [[self.models[section] loraChargeVOList] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFGatewayListTableViewCell *cell = [WFGatewayListTableViewCell cellWithTableView:tableView];
    cell.leftCons.constant = self.index == 1 ? 50.0f : 25.0f;
    cell.collectionLeftCons.constant = self.index == 1 ? 35.0f : 10.0f;
    if (self.isSearch) {
        cell.model = [self.searchModels[indexPath.section] loraChargeVOList][indexPath.row];
    }else {
        cell.model = [self.models[indexPath.section] loraChargeVOList][indexPath.row];
    }
    @weakify(self)
    cell.selectItemBlock = ^(NSInteger tag, BOOL isSelect) {
        @strongify(self)
        [self handleItemSelectOpenTypeWithTag:tag open:isSelect indexPath:indexPath];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WFGatewayListSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFGatewayListSectionView" owner:nil options:nil] firstObject];
    sectionView.model = self.isSearch ? self.searchModels[section] : self.models[section];
    sectionView.leftCons.constant = self.index == 1 ? 40.0f : 15.0f;
    @weakify(self)
    sectionView.selectOrOpenPileBlock = ^(NSInteger tag) {
        @strongify(self)
        [self complateHandlerGatewayWithTag:tag index:section];
    };
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFGatewayLoarListModel *fModel = self.isSearch ? [self.searchModels[indexPath.section] loraChargeVOList][indexPath.row] : [self.models[indexPath.section] loraChargeVOList][indexPath.row];
    return fModel.isOpen ? 114.0f : 44.0f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //选中网关就必须选中设备 选中设备可以不选中网关
//    WFGatewayListModel *fModel = (self.isSearch ? self.searchModels : self.models)[indexPath.section];
////    if (fModel.isSelect) return;
//    //选中设备
//    WFGatewayLoarListModel *model = self.isSearch ? [self.searchModels[indexPath.section] loraChargeVOList][indexPath.row] : [self.models[indexPath.section] loraChargeVOList][indexPath.row];
//    model.isSelect = !model.isSelect;
//
//    //如果有一个没有选中, 那么久不选中网关
////    BOOL isSelectFather = YES;
////    for (WFGatewayLoarListModel *sModel in (self.isSearch ? [self.searchModels[indexPath.section] loraChargeVOList] : [self.models[indexPath.section] loraChargeVOList])) {
////        if (!sModel.isSelect) {
////            isSelectFather = NO;
////        }
////    }
////
////    fModel.isSelect = isSelectFather;
//    if (fModel.isSelect) {
//        self.bottomView.replaceBtn.enabled = YES;
//        [self.bottomView.replaceBtn setTitleColor:NavColor forState:0];
//    }
//
//    [tableView reloadData];
//}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- NavHeight-self.bottomView.height-100.0f) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchBarView;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        @weakify(self)
        _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.pageNumber ++;
            [self getGatewayListData];
        }];
        [self addSubview:_tableView];
    }
    return _tableView;
}

/// 搜索
- (WFChargePileSearchView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFChargePileSearchView" owner:nil options:nil] firstObject];
        _searchBarView.frame = CGRectMake(0, 0, ScreenWidth, 90.0f);
        _searchBarView.title.text = @"网关编号";
        _searchBarView.count.text = @"设备绑定数";
        _searchBarView.textField.placeholder = @"请输入设备外壳条码ID";
        @weakify(self)
        _searchBarView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
            @strongify(self)
            [self complateHandlerSearchResultWithKeys:searchKeys];
        };
        _searchBarView.autoresizingMask = 0;
    }
    return _searchBarView;
}

/// 底部解绑和替换w view
- (WFGatewayBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFGatewayBottomView" owner:nil options:nil] firstObject];
        _bottomView.frame = CGRectMake(0, self.tableView.maxY, ScreenWidth, 45.0f);
        _bottomView.autoresizingMask = 0;
        @weakify(self)
        _bottomView.clickBotomBtnBlock = ^(NSInteger tag) {
            @strongify(self)
            [self complateHandleReplaceWithTag:tag];
        };
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

/// 替换网关
- (WFNRReplaceGatewayListView *)gatewayView {
    if (!_gatewayView) {
        _gatewayView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNRReplaceGatewayListView" owner:nil options:nil] firstObject];
        _gatewayView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 468.0f);
        @weakify(self)
        _gatewayView.replaceGatewayBlock = ^(NSString * _Nonnull gatewayId, NSString * _Nonnull gatewayName) {
            @strongify(self)
            [self showAlertActionWithGatewayId:gatewayId gatewayName:gatewayName];
        };
        [YFWindow addSubview:_gatewayView];
    }
    return _gatewayView;
}

/// 初始化
- (NSMutableArray<WFGatewayListModel *> *)models {
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    self.bottomView.hidden = index == 0;
    //重置选中状态
    for (WFGatewayListModel *fModel in self.models) {
        fModel.isSelect = NO;
        for (WFGatewayLoarListModel *iModel in fModel.loraChargeVOList) {
            iModel.isSelect = NO;
        }
    }
    
    [self.tableView reloadData];
}

@end
