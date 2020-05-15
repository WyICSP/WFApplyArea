//
//  WFProductListViewController.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFProductListViewController.h"
#import "WFSearchAddressNavBarView.h"
#import "WFShopMallSearchViewController.h"
#import "WFProductListTableViewCell.h"
#import "UITableView+YFExtension.h"
#import "WFProductMsgShareView.h"
#import "SVProgressHUD+YFHud.h"
#import "WFShopMallHeadView.h"
#import "WFProductListModel.h"
#import "WFShopDataTool.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "MJRefresh.h"
#import "WKHelp.h"

@interface WFProductListViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**导航栏*/
@property (nonatomic, strong, nullable) WFSearchAddressNavBarView *searchNavBarView;
/// 分享的弹出视图
@property (nonatomic, strong, nullable) WFProductMsgShareView *popShareView;
/// 头视图
@property (nonatomic, strong, nullable) WFShopMallHeadView *headView;
/**置顶Button*/
@property (nonatomic, strong, nullable) UIButton *goTopBtn;
/// 数据
@property (nonatomic, strong, nullable) NSMutableArray <WFProductListModel *> *models;
/// 页码
@property (nonatomic, assign) NSInteger currentPage;
/// 筛选 默认红包向上
@property (nonatomic, copy) NSString *ptype;
@end

@implementation WFProductListViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 私有方法
- (void)setUI {
    self.currentPage = 1;
    self.ptype = @"ticket_after_price_des";
    [self.view addSubview:self.searchNavBarView];
    //获取数据
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self getProductListData];
}

/// 获取商品数据
- (void)getProductListData {
//    ticket_after_price_asc 红包升序
//    ticket_after_price_des 红包降序
//    ticket_id_asc 导购券升序
//    ticket_id_des 导购券降序
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(self.currentPage) forKey:@"currentPage"];
    [params safeSetObject:@"20" forKey:@"pageSize"];
    [params safeSetObject:self.ptype forKey:@"ptype"];
    [params safeSetObject:self.searchKeys forKey:@"keyWord"];
    @weakify(self)
    [WFShopDataTool getShopMallProductsListWithParams:params resultBlock:^(NSArray<WFProductListModel *> * _Nonnull models) {
        @strongify(self)
        [self completionHandlerWithModels:models];
    } failBlock:^{
        //消失
        [SVProgressHUD dismiss];
    }];
}

- (void)completionHandlerWithModels:(NSArray <WFProductListModel *> *)models {
    //消失
    [SVProgressHUD dismiss];
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
    
    if (self.currentPage == 1)
        [self.models removeAllObjects];
    
    //将获取的数据添加到数组中
    if (models.count != 0) [self.models addObjectsFromArray:models];
    
    //是否显示空页面
    [self.tableView isShowEmptyView:self.models.count == 0];
    
    if (models.count == 0 & self.models.count != 0 & self.currentPage != 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView reloadData];
}


 ///  获取分享批次号 分享前调用
 - (void)getShareNumWithModel:(WFProductListModel *)model {
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
     [params safeSetObject:model.ticketId forKey:@"ticketId"];
     // 20191107 新增入参 productId
     [params safeSetObject:model.productId forKey:@"productId"];
     
     @weakify(self)
     [WFShopDataTool getShareNumWithParams:params resultBlock:^(NSString * _Nonnull ticketId) {
         @strongify(self)
         model.shareTicketId = ticketId;
         self.popShareView.model = model;
         self.popShareView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
     }];
 }

/// 处理筛选
/// @param tag 11 红包 12 导购券
/// @param topOrDowm 红包 筛选方向
- (void)completionHandlerScreenWithTag:(NSInteger)tag
                       topOrDowm:(BOOL)topOrDowm {
    [SVProgressHUD showWithStatus:@"加载中..."];
    if (tag == 11 && !topOrDowm) {
        //红包 朝下
        self.ptype = @"ticket_after_price_des";
    }else if (tag == 11 && topOrDowm) {
        //红包 朝上
        self.ptype = @"ticket_after_price_asc";
    }else if (tag == 12) {
        self.ptype = @"ticket_id_des";
    }
    // 重置
    self.currentPage = 1;
    //重新获取数据
    [self getProductListData];
}

/**置顶*/
- (void)clickGoTop:(UIButton *)sender {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFProductListTableViewCell *cell = [WFProductListTableViewCell cellWithTableView:tableView];
    cell.model = self.models[indexPath.row];
    @weakify(self)
    cell.clickBtnBlock = ^(NSInteger tag) {
        @strongify(self)
        [self getShareNumWithModel:self.models[indexPath.row]];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    self.goTopBtn.alpha = offset / 200;
}

#pragma mark get set 
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchNavBarView.maxY, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 127.0f;
        _tableView.separatorStyle = 0;
        [_tableView addEmptyView];
        _tableView.emptyView.emptyLbl.hidden = YES;
        _tableView.emptyView.emptyImg.image = [UIImage imageNamed:@"noMoreGoods"];
        @weakify(self)
        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.currentPage ++;
            [self getProductListData];
        }];
        [self.view addSubview:_tableView];
        [self.view addSubview:self.goTopBtn];
    }
    return _tableView;
}

/**
 导航栏的时间处理方法
 
 @param isBack 是否点击返回按钮
 @param searchKeys 搜索关键字
 */
- (void)backSearchVCWithBack:(BOOL)isBack searchKeys:(NSString *)searchKeys {
    if (isBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        //普通搜索过来的
        if (self.goBackSearchkeysBlock) {
            self.goBackSearchkeysBlock(searchKeys);
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            //智能搜索过来的
            WFShopMallSearchViewController *search = [[WFShopMallSearchViewController alloc] init];
            search.searchKeys = self.searchKeys;
            [self.navigationController pushViewController:search animated:NO];
        }
    }
}

#pragma mark get set
/**
 搜索框
 
 @return searchBarView
 */
- (WFSearchAddressNavBarView *)searchNavBarView {
    if (!_searchNavBarView) {
        _searchNavBarView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFSearchAddressNavBarView" owner:nil options:nil] firstObject];
        _searchNavBarView.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
        _searchNavBarView.searchTF.text = self.searchKeys;
        _searchNavBarView.type = WFSearchAddressProductEventType;
        @weakify(self)
        _searchNavBarView.searchBarBeginEditEventBlock = ^(BOOL isBack, NSString *searchText) {
            @strongify(self)
            [self backSearchVCWithBack:isBack searchKeys:searchText];
        };
    }
    return _searchNavBarView;
}

/// 头视图
- (WFShopMallHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallHeadView" owner:nil options:nil] firstObject];
        @weakify(self)
        _headView.screenProductBlock = ^(NSInteger tag, BOOL isTop) {
            @strongify(self)
            [self completionHandlerScreenWithTag:tag topOrDowm:isTop];
        };
    }
    return _headView;
}

/// 分享的弹出视图
- (WFProductMsgShareView *)popShareView {
    if (!_popShareView) {
        _popShareView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFProductMsgShareView" owner:nil options:nil] firstObject];
        _popShareView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self)
        _popShareView.clickApperBlock = ^{
            @strongify(self)
            [self.popShareView removeFromSuperview];
            self.popShareView = nil;
        };
        [YFWindow addSubview:_popShareView];
    }
    return _popShareView;
}

/**
 置顶

 @return goTopBtn
 */
- (UIButton *)goTopBtn {
    if (!_goTopBtn) {
        _goTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-52.0f, ScreenHeight-TabbarHeight-93.0f, 40.0f, 40.0f)];
        [_goTopBtn setImage:[UIImage imageNamed:@"goTop"] forState:0];
        _goTopBtn.alpha = 0;
        [_goTopBtn addTarget:self action:@selector(clickGoTop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goTopBtn;
}

/// 数据源
- (NSMutableArray<WFProductListModel *> *)models {
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}


@end
