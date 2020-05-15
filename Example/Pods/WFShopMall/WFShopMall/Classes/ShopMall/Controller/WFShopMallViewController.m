//
//  WFShopMallViewController.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFShopMallViewController.h"
//#import "WFShopMallSearchViewController.h"
//#import "WFProductListTableViewCell.h"
//#import "WFStrategyViewController.h"
//#import "UITableView+YFExtension.h"
//#import "WFProductMsgShareView.h"
//#import "SVProgressHUD+YFHud.h"
//#import "WFShopMallHeadView.h"
//#import "WFProductListModel.h"
//#import "WFShopMallTopView.h"
//#import "WFShopNavbarView.h"
//#import "NSString+Regular.h"
//#import "WFShopDataTool.h"
//#import "UIView+Frame.h"
//#import "SKSafeObject.h"
//#import "MJRefresh.h"
//#import "WKSetting.h"
//#import "WKHelp.h"
//#import "WFWithdrawViewController.h"
//#import "WFShopMallIncomeViewController.h"
//#import "WFShopMallTopActivityView.h"
//#import "WFShopMallPopUPView.h"
//#import "WFShopActivityViewController.h"
//#import "WFShopActivityModel.h"
//#import <SDWebImage/SDWebImage.h>
//#import "WFShopRebateStatisticsModel.h"
//#import "MMScanViewController.h"
#import "IncomeJsApiTest.h"
#import "WKSetting.h"
#import "WKHelp.h"


@interface WFShopMallViewController ()<UIGestureRecognizerDelegate>
/**tableView*/
//@property (nonatomic, strong, nullable) UITableView *tableView;
///**搜索条*/
//@property (nonatomic, strong, nullable) WFShopNavbarView *navBar;
///**tableview 头视图*/
//@property (nonatomic ,strong, nullable) UIView *tableViewHeaderView;
///**头部活动view*/
//@property (nonatomic ,strong, nullable) WFShopMallTopActivityView *topActivityView;
///**topView*/
//@property (nonatomic, strong, nullable) WFShopMallTopView *topView;
///// 分享的弹出视图
//@property (nonatomic, strong, nullable) WFProductMsgShareView *popShareView;
///// 头视图
//@property (nonatomic, strong, nullable) WFShopMallHeadView *headView;
/**置顶Button*/
//@property (nonatomic, strong, nullable) UIButton *goTopBtn;
/// 数据
//@property (nonatomic, strong, nullable) NSMutableArray <WFProductListModel *> *models;
/// 页码
//@property (nonatomic, assign) NSInteger currentPage;
///// 筛选 默认红包向上
//@property (nonatomic, copy) NSString *ptype;
/**popView */
//@property (nonatomic, strong) WFShopMallPopUPView *popView;
///**双十二活动头部model*/
//@property (nonatomic, strong) WFShopActivityModel *activityModel;
///**优惠返利统计 model*/
//@property (nonatomic, strong) WFShopRebateStatisticsModel *rebateStatisticsModel;
/// 手势是否启动
@property (nonatomic, assign) BOOL isCanUseSideBack;
@property (nonatomic, assign) BOOL isTabbarHidden;
@property (nonatomic, assign) BOOL isShowTab;
/// 重新加载时候的 url
@property (nonatomic, copy) NSString *reloadPath;
@end

@implementation WFShopMallViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressColor = UIColorFromRGB(0xFF6430);
    self.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/index",H5_SHOP_URL];
    DLog(@"%@",self.urlString);
    self.reloadPath = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/index",H5_SHOP_URL];
    
    //禁止长按弹出 UIMenuController 相关
    //禁止选择 css 配置相关
    NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    //css 选中样式取消
    NSMutableString*javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    //javascript 注入
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript
    injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController*userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:noneSelectScript];
    WKWebViewConfiguration*configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    //控件加载
    [self.dwebview.configuration.userContentController addUserScript:noneSelectScript];
    
    [self.dwebview addJavascriptObject:[[IncomeJsApiTest alloc] init] namespace:nil];
    [self.dwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.dwebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //刷新
    [YFNotificationCenter addObserver:self selector:@selector(reloadUrl) name:@"reloadUserCnter" object:nil];
    [YFNotificationCenter addObserver:self selector:@selector(reloadData) name:@"reloadServiceKeys" object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.dwebview) {
            [self.dwebview.title isEqualToString:@"服务"] ? [self hideTabbar:NO] : [self hideTabbar:YES];
        }
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.isShowTab = NO;
}

- (void)reloadUrl {
    self.isShowTab = YES;
    [super setUrlString:self.reloadPath];
    [self.dwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.dwebview reload];
}

- (void)reloadData {
    self.isShowTab = NO;
    [self.dwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

/**
 隐藏 tabbar

 @param hide 显示与隐藏
 */
- (void)hideTabbar:(BOOL)hide {
    if (self.isShowTab) return;
    // 内嵌页面 不操作tabbar
    if (![self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    // 二级页面 不操作tabbar
    if (![self isEqual:self.navigationController.viewControllers[0]]) {
        return;
    }
    
    self.isTabbarHidden = hide; // isTabbarHidden 用来保存当前tabbar的隐藏状态
    self.tabBarController.tabBar.hidden = hide;
    self.hidesBottomBarWhenPushed = hide; // 设置这个主要是用于tab间切换，切换回来的时候，保持当前页面tabbar状态不变
    
    // 调整view的大小
//    UIView *tab = self.tabBarController.view;
    if (hide) {
        self.dwebview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.dwebview.backgroundColor = UIColor.redColor;
    } else {
        self.dwebview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - TabbarHeight);
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self cancelSideBack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self startSideBack];
}

/**
 * 关闭ios右滑返回
 */
-(void)cancelSideBack{
    self.isCanUseSideBack = NO;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
/**
 开启ios右滑返回
 */
- (void)startSideBack {
    self.isCanUseSideBack=YES;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanUseSideBack;
}

- (void)dealloc {
    [self.dwebview removeObserver:self forKeyPath:@"title"];
    [YFNotificationCenter removeObserver:self name:@"reloadUserCnter" object:nil];
    [YFNotificationCenter removeObserver:self name:@"reloadServiceKeys" object:nil];
}


//#pragma mark 私有方法
//- (void)setUI {
////    self.currentPage = 1;
////    self.ptype = @"ticket_after_price_des";
////    [SVProgressHUD showWithStatus:@"加载中..."];
//    //添加 navbar
//    [self.view addSubview:self.navBar];
////    //获取数据
////    [self getProductListData];
////    //双十二 活动 头部
////    [self getActivityData];
////    // 双十二 活动 返利优惠统计
//    [self getStatisticsData];
//
//}
//
///// 获取商品数据
//- (void)getProductListData {
////    ticket_after_price_asc 红包升序
////    ticket_after_price_des 红包降序
////    ticket_id_asc 导购券升序
////    ticket_id_des 导购券降序
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params safeSetObject:@(self.currentPage) forKey:@"currentPage"];
//    [params safeSetObject:@"20" forKey:@"pageSize"];
//    [params safeSetObject:self.ptype forKey:@"ptype"];
//    @weakify(self)
//    [WFShopDataTool getShopMallProductsListWithParams:params resultBlock:^(NSArray<WFProductListModel *> * _Nonnull models) {
//        @strongify(self)
//        [self completionHandlerWithModels:models];
//    } failBlock:^{
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        //结束加载
//        [SVProgressHUD dismiss];
//    }];
//}
//
//- (void)completionHandlerWithModels:(NSArray <WFProductListModel *> *)models {
//    //结束加载
//    [SVProgressHUD dismiss];
//    // 结束刷新
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
//    if (self.currentPage == 1)
//        [self.models removeAllObjects];
//
//    //将获取的数据添加到数组中
//    if (models.count != 0) [self.models addObjectsFromArray:models];
//    self.tableView.mj_footer.hidden = self.models.count < 20;
//
//    //是否显示空页面
//    [self.tableView isShowEmptyView:self.models.count == 0];
//
//    if (models.count == 0 & self.models.count != 0 & self.currentPage != 1) {
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    } else {
//        [self.tableView.mj_footer resetNoMoreData];
//    }
//    [self.tableView reloadData];
//}
//
///**双十二活动获取数据头部广告 */
//
//-(void)getActivityData {
//
//    @weakify(self)
//    [WFShopDataTool getActivityDataResultBlock:^(WFShopActivityModel * _Nonnull model) {
//        @strongify(self)
//        self.activityModel = model;
//        self.tableView.tableHeaderView = self.tableViewHeaderView;
//        [self.tableView reloadData];
//
//    } failBlock:^{
//
//    }];
//
//}
//
///**双十二活动获取数据 特惠返利统计开关接口*/
//- (void)getStatisticsData {
//
//    [WFShopDataTool getStatisticsDataResultBlock:^(WFShopRebateStatisticsModel * _Nonnull model) {
//        self.rebateStatisticsModel = model;
//        self.navBar;
//    } failBlock:^{
//
//    }];
//
//
//
//}

//
/////  获取分享批次号 分享前调用
//- (void)getShareNumWithModel:(WFProductListModel *)model {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params safeSetObject:model.ticketId forKey:@"ticketId"];
//    [params safeSetObject:model.productId forKey:@"productId"];
//
//    @weakify(self)
//    [WFShopDataTool getShareNumWithParams:params resultBlock:^(NSString * _Nonnull ticketId) {
//        @strongify(self)
//        model.shareTicketId = ticketId;
//        self.popShareView.model = model;
//        self.popShareView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
//    }];
//}
//
///// 处理筛选
///// @param tag 11 红包 12 导购券
///// @param topOrDowm 红包 筛选方向
//- (void)completionHandlerScreenWithTag:(NSInteger)tag
//                       topOrDowm:(BOOL)topOrDowm {
//    [SVProgressHUD showWithStatus:@"加载中..."];
//    if (tag == 11 && !topOrDowm) {
//        //红包 朝下
//        self.ptype = @"ticket_after_price_des";
//    }else if (tag == 11 && topOrDowm) {
//        //红包 朝上
//        self.ptype = @"ticket_after_price_asc";
//    }else if (tag == 12) {
//        self.ptype = @"ticket_id_des";
//    }
//    // 重置
//    self.currentPage = 1;
//    //重新获取数据
//    [self getProductListData];
//}
//
///**
// 打开分享记录页面
//
// @param model 100 记录 200 分享页面
// */
//- (void)openShareRecordsOrShowShareViewWithModel:(WFProductListModel *)model {
//    [self getShareNumWithModel:model];
//}
//
///**
// 跳转搜索页面和攻略
//
// @param tag 10 搜索   20 攻略  30 收益
// */
//- (void)jumpSearchOrStrategyCtrlWithTag:(NSInteger)tag {
//    if (tag == 10) {
//        WFShopMallSearchViewController *search = [[WFShopMallSearchViewController alloc] init];
//        search.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:search animated:NO];
//    }else if(tag ==20)  {
//        self.popView.alpha == 0.0 ? [self.popView popView] : [self.popView dissmissView];
//
//    }else{
//
//        // 收益
//        WFShopMallIncomeViewController *incomeVC = [[WFShopMallIncomeViewController alloc] init];
//        incomeVC.hidesBottomBarWhenPushed = YES;
//        incomeVC.urlString =[NSString stringWithFormat:@"%@yzc-app-partner/#//profit/index?",H5_HOST] ;
//        [self.navigationController pushViewController:incomeVC animated:NO];
//    }
//}
//
///**置顶*/
//- (void)clickGoTop:(UIButton *)sender {
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//}
//
//#pragma mark UITableViewDelegate,UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.models.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WFProductListTableViewCell *cell = [WFProductListTableViewCell cellWithTableView:tableView];
//    cell.model = self.models[indexPath.row];
//    @weakify(self)
//    cell.clickBtnBlock = ^(NSInteger tag) {
//        @strongify(self)
//        [self getShareNumWithModel:self.models[indexPath.row]];
//    };
//    return cell;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return self.headView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 50.0f;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offset = scrollView.contentOffset.y;
//    self.goTopBtn.alpha = offset / 200;
//
//    if (self.popView.alpha ==1.0) {
//          [self.popView dissmissView];
//      }
//}
//
///**点击头部活动链接 跳转到活动页面*/
//- (void)activityAction {
//    WFShopActivityViewController *ActivityVC = [[WFShopActivityViewController alloc]init];
//    ActivityVC.urlString = self.activityModel.target;
//    ActivityVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:ActivityVC animated:YES];
//
//
//}
//
///**头部更多事件*/
//- (void)topMoreAction:(NSInteger)type {
//
//    if (type == 0) {
//        // 特惠统计
//        WFShopActivityViewController *ActivityVC = [[WFShopActivityViewController alloc]init];
//
//          ActivityVC.urlString = self.rebateStatisticsModel.partnerRebateRecodeUrl;
////        ActivityVC.urlString = @"http://dev.jx9n.cn/yzc-ebus-front/#/WX/WXLanding";
//        ActivityVC.hidesBottomBarWhenPushed = YES;
//          [self.navigationController pushViewController:ActivityVC animated:YES];
//
//    }else{
//        // 攻略
//        WFStrategyViewController *strategy = [[WFStrategyViewController alloc] init];
//        strategy.urlString = [NSString stringWithFormat:@"%@yzc_business_h5/page/strategy.html",H5_HOST];
//        strategy.progressColor = NavColor;
//        strategy.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:strategy animated:YES];
//
//    }
//
//
//
//}
//
//#pragma mark get set
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navBar.maxY, ScreenWidth, ScreenHeight - NavHeight - TabbarHeight) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.rowHeight = 127.0f;
//        _tableView.separatorStyle = 0;
//        _tableView.tableHeaderView = self.tableViewHeaderView;
//        [_tableView addEmptyView];
//        _tableView.emptyView.frame = CGRectMake(0, 250.0f, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight-250);
//        _tableView.emptyView.backgroundColor = UIColor.clearColor;
//        _tableView.emptyView.emptyLbl.hidden = YES;
//        _tableView.emptyView.emptyImg.image = [UIImage imageNamed:@"noMoreGoods"];
//        _tableView.emptyView.centerCons.constant = -50.0f;
//        @weakify(self)
//
//        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//                @strongify(self)
//                self.currentPage = 1;
//                [self getProductListData];
//                [self getStatisticsData];
//                [self getActivityData];
//            }];
//            header.lastUpdatedTimeLabel.hidden = YES;
//                // 设置下拉刷新时的三种状态的文本
//            [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
//            [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
//            [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
//            header.stateLabel.font = [UIFont boldSystemFontOfSize:14];
//
//            _tableView.mj_header = header;
//
//        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
//            @strongify(self)
//            self.currentPage ++;
//            [self getProductListData];
//        }];
//        [self.view addSubview:_tableView];
//        [self.view addSubview:self.goTopBtn];
//    }
//    return _tableView;
//}
//
///// navbar
//- (WFShopNavbarView *)navBar {
//    if (!_navBar) {
//        _navBar = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopNavbarView" owner:nil options:nil] firstObject];
//        _navBar.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
//        @weakify(self)
//        _navBar.clickBtnBlock = ^(NSInteger tag) {
//            @strongify(self)
//            [self jumpSearchOrStrategyCtrlWithTag:tag];
//        };
//    }
//    [_navBar hideIncomeView:self.rebateStatisticsModel.hasPartnerEarnings];
//    return _navBar;
//}
//
///// 筛选的 view
////- (WFShopMallTopView *)topView {
////    if (!_topView) {
////        _topView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallTopView" owner:nil options:nil] firstObject];
////        _topView.frame = CGRectMake(0, self.navBar.maxY, ScreenWidth, 50.0f);
////    }
////    return _topView;
////}
//
///// 分享的弹出视图
//- (WFProductMsgShareView *)popShareView {
//    if (!_popShareView) {
//        _popShareView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFProductMsgShareView" owner:nil options:nil] firstObject];
//        _popShareView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        @weakify(self)
//        _popShareView.clickApperBlock = ^{
//            @strongify(self)
//            [self.popShareView removeFromSuperview];
//            self.popShareView = nil;
//        };
//        [YFWindow addSubview:_popShareView];
//    }
//    return _popShareView;
//}
//
///// 头视图
//- (WFShopMallHeadView *)headView {
//    if (!_headView) {
//        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallHeadView" owner:nil options:nil] firstObject];
//        @weakify(self)
//        _headView.screenProductBlock = ^(NSInteger tag, BOOL isTop) {
//            @strongify(self)
//            [self completionHandlerScreenWithTag:tag topOrDowm:isTop];
//        };
//    }
//    return _headView;
//}
//
///**
// 置顶
//
// @return goTopBtn
// */
//- (UIButton *)goTopBtn {
//    if (!_goTopBtn) {
//        _goTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-52.0f, ScreenHeight-TabbarHeight-93.0f, 40.0f, 40.0f)];
//        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
//        NSString *path = [NSString getImagePathWithCurrentBundler:currentBundle PhotoName:@"goTop" bundlerName:@"WFShopMall.bundle"];
//        [_goTopBtn setImage:[UIImage imageWithContentsOfFile:path] forState:0];
//        _goTopBtn.alpha = 0;
//        [_goTopBtn addTarget:self action:@selector(clickGoTop:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _goTopBtn;
//}
//
///// 数据源
//- (NSMutableArray<WFProductListModel *> *)models {
//    if (!_models) {
//        _models = [[NSMutableArray alloc] init];
//    }
//    return _models;
//}
//
///**tableviewHeaderView*/
//- (UIView *)tableViewHeaderView{
//
//    if (!_tableViewHeaderView) {
//
//        _tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navBar.maxY, ScreenWidth, 200.0f)];
//        /**活动view*/
//        _topActivityView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallTopActivityView" owner:nil options:nil] firstObject];
//        _topActivityView.frame = CGRectMake(0.0f, 0.0f, _tableViewHeaderView.width, 150.0f);
//        @weakify(self)
//        _topActivityView.operateBlock = ^{
//            @strongify(self)
//            [self activityAction];
//        };
//        /**合伙人福利专享*/
//        _topView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallTopView" owner:nil options:nil] firstObject];
//        _topView.frame = CGRectMake(0.0f, _topActivityView.height, ScreenWidth, 50.0f);
//
//        [_tableViewHeaderView addSubview:_topActivityView];
//        [_tableViewHeaderView addSubview:_topView];
//    }
//
//    _tableViewHeaderView.height = self.activityModel.open ? 200.0f :50.0f;
//    _topActivityView.hidden = !self.activityModel.open;
//    _topView.frame = CGRectMake(0.0f, self.activityModel.open ? _topActivityView.height :0.0f, ScreenWidth, 50.0f);
//    [_topActivityView.activityImageView sd_setImageWithURL:[NSURL URLWithString:self.activityModel.value] placeholderImage:[UIImage imageNamed:@"pfang"]];
//
//
//
//    return _tableViewHeaderView;
//
//}
//
///**弹出框*/
//-(WFShopMallPopUPView *)popView {
//
//    if (!_popView) {
//        _popView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopMallPopUPView" owner:nil options:nil] firstObject];
//        _popView.frame = CGRectMake(ScreenWidth -136.0-15.0, NavHeight-4, 136.0f, 98.0f);
//        _popView.alpha = 0.0f;
//        @weakify(self)
//        _popView.operateBlock = ^(NSInteger type) {
//            @strongify(self)
//            [self topMoreAction:type];
//        };
//        [self.view addSubview:_popView];
//    }
//    _popView.height = self.rebateStatisticsModel.partnerHasRebate ? 98.0 : 50.0f;
//    _popView.specialStatisticsBut.hidden = !self.rebateStatisticsModel.partnerHasRebate;
//    [_popView.specialStatisticsBut setTitle:[NSString stringWithFormat:@"   %@",self.rebateStatisticsModel.partnerButtonTitle] forState:UIControlStateNormal];
//    _popView.horizontalLine.hidden = !self.rebateStatisticsModel.partnerHasRebate;
//
//    return _popView;
//}

@end


