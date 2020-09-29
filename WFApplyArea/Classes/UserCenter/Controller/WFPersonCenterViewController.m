//
//  WFPCenterViewController.m
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#import "WFPersonCenterViewController.h"
#import "WFPersonCenterTableViewCell.h"
#import "WFCurrentWebViewController.h"
#import "YFMediatorManager+WFLogin.h"
#import "WFMyChargePileDataTool.h"
#import "WFBaseWebViewController.h"
#import "WFUserCenterPublicAPI.h"
#import "WFUserCenterModel.h"
#import "NSString+Regular.h"
#import <MJRefresh/MJRefresh.h>
#import "WFPersonHeadView.h"
#import "WFHomeDataTool.h"
#import "MLMenuView.h"
#import "WKSetting.h"
#import "WKConfig.h"

@interface WFPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
/// headView
@property (nonatomic, strong, nullable) WFPersonHeadView *headView;
/// 菜单
@property (nonatomic, strong, nullable) MLMenuView *menuView;
/// 客服
@property (nonatomic, strong, nullable) WFMineCustomerServicModel *cModel;
/// 个人中心数据
@property (nonatomic, strong, nullable) WFUserCenterModel *mainModel;
/// titles
@property (nonatomic, strong, nullable) NSArray *titles;
/// 合伙人数量和活动金
@property (nonatomic, strong, nullable) NSArray *dataInfo;
/// 是否打开
@property (nonatomic, assign) BOOL isOpenService;
///是否可以侧滑
@property (nonatomic,assign) BOOL isCanSideBack;
/**消息未读*/
@property (nonatomic, strong) UILabel *countLbl;
@end

@implementation WFPersonCenterViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self disableSideBack];
    // 获取未读消息
    [self getUserUnReadMessage];
    // 获取数据
    [self getUserInfo];
    
    // 如果等于 3 的话不显示客服
    NSString *partnerRole = [NSString stringWithFormat:@"%@",[YFUserDefaults objectForKey:@"partnerRole"]];
    self.headView.leftBtn.hidden = [partnerRole integerValue] == 3 ? YES : NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

///禁用侧滑返回
- (void)disableSideBack{
    self.isCanSideBack = NO;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

#pragma mark 页面相关逻辑方法
- (void)setUI {
    self.titles = [self titles];
    [self.tableView reloadData];
    // 获取客服数据
    [self getCustomerServic];
}

/// 获取数据
- (void)getUserInfo {
    @weakify(self)
    [WFMyChargePileDataTool getUserInfoWithParams:@{} resultBlock:^(WFUserCenterModel * _Nonnull models) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        self.mainModel = models;
        // 获取数据
        self.titles = [self titles];
        self.headView.model = self.mainModel;
        // 活动金
        NSString *activityPrice = [NSString stringWithFormat:@"¥%.3f",[NSString decimalPriceWithDouble:models.activityPrice.doubleValue/1000]];
        
        // 添加到数组中
        if (self.mainModel.isManage) {
            self.dataInfo = @[@(models.adminNum),activityPrice];
        }else {
            self.dataInfo = @[activityPrice];
        }
        
        [self.tableView reloadData];
    }failBlock:^{
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 获取用户未读消息
 */
- (void)getUserUnReadMessage {
    @weakify(self)
    [WFHomeDataTool getMessageUnReadCountWithParams:@{} resultBlock:^(NSDictionary * _Nonnull dict) {
        @strongify(self)
        NSString *dataCount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"data"]];
        self.countLbl.hidden = [dataCount intValue] == 0;
    }];
}

- (void)getCustomerServic {
    @weakify(self)
    [WFMyChargePileDataTool getCustomerServiceWithParams:@{} resultBlock:^(WFMineCustomerServicModel * _Nonnull cModel) {
        @strongify(self)
        self.cModel = cModel;
        self.cModel.customerMobile = cModel.customerMobile.length == 0 ? @"4003231232" : cModel.customerMobile;
        self.cModel.customerServiceUrl = cModel.customerServiceUrl.length == 0 ? @"https://chat.sobot.com/chat/h5/v2/index.html?sysnum=5671d20094344db1abd7c0386cdbd5a8&source=2" : cModel.customerServiceUrl;
    }];
}

/// 跳转
/// @param tag 10 客服 20 消息 30 设置 40 个人资料 50 充点券 60 钱包
- (void)gotoUserInfoCtrlWithTag:(NSInteger)tag {
    NSString *url = @"";
    if (tag == 10) {
        self.isOpenService = !self.isOpenService;
        if (self.isOpenService) {
            [self.menuView showMenuEnterAnimation:MLEnterAnimationStyleRight];
        }else {
            [self.menuView hidMenuExitAnimation:MLEnterAnimationStyleRight];
        }
    }else if (tag == 20) {
        // 消息
        url = [NSString stringWithFormat:@"%@yzc-app-partner/#/msg/index",H5_HOST];
    }else if (tag == 30) {
        // 设置
        url = [NSString stringWithFormat:@"%@yzc-app-partner-old/page/setting.html",H5_HOST];
    }else if (tag == 40) {
        // 个人资料
        url = [NSString stringWithFormat:@"%@yzc-app-partner-old/page/userInfo.html",H5_HOST];
    }else if (tag == 50) {
        // 分享充点券
        url = [NSString stringWithFormat:@"%@yzc-union-fe/page/coupon/shareCoupon.html",H5_HOST];
    }else if (tag == 60) {
        // 钱包
        url = [NSString stringWithFormat:@"%@yzc-app-partner/#/myWallet/index",H5_HOST];
    }else if (tag == 70) {
        // 头像
        url = [NSString stringWithFormat:@"%@yzc-app-partner-old/page/userInfo.html",H5_HOST];
    }
    [self handleWebJumpWithUrl:url];
}

/// 页面跳转
/// @param url 网址链接
- (void)handleWebJumpWithUrl:(NSString *)url {
    if (url.length == 0) return;
    
    WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
    web.urlString = url;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)customerServiceCompleleWithIndex:(NSInteger)index {
    // 改变按钮转态
    self.leftImageBtn.selected = NO;
    
    if (index == 0) {
        // 在线客服
        WFBaseWebViewController *web = [[WFBaseWebViewController alloc] init];
        web.urlString = self.cModel.customerServiceUrl;
        web.hidesBottomBarWhenPushed = YES;
        web.progressColor = NavColor;
        [self.navigationController pushViewController:web animated:YES];
    }else {
        // 电话客服
        [WFUserCenterPublicAPI callPhoneWithNumber:self.cModel.customerMobile];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.titles safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [[self.titles safeObjectAtIndex:indexPath.section] count];
    WFPersonCenterTableViewCell *cell = [WFPersonCenterTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:count];
    NSString *title = [[[self.titles safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row] safeJsonObjForKey:@"title"];
    cell.title.text = title;
    if (indexPath.section == 1 && self.dataInfo.count != 0) {
        cell.desc.text = [NSString stringWithFormat:@"%@",[self.dataInfo safeObjectAtIndex:indexPath.row]];
        cell.desc.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 社区服务
            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/index",H5_HOST];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        } else if (indexPath.row == 1) {
            // 奖励中心
            [YFMediatorManager openRewardCtrlWithController:self];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0 && self.mainModel.isManage) {
            // 合伙人
            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/myPartner/index",H5_HOST];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        } else {
            // 活动金
            [YFMediatorManager openActivityOrRewardCtrlWithController:self type:1];
        }
    } else if (indexPath.section == 2) {
        // 设备转让
        WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/deviceTransfer/index",H5_HOST];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark set get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 49.0f;
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        if (@available(iOS 11.0, *))
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.tableHeaderView = self.headView;
        @weakify(self)
        _tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self getUserInfo];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;;
}

/// headView
- (WFPersonHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFPersonHeadView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, ISIPHONEX ? (260.0f+XHEIGHT) : 263);
        @weakify(self)
        _headView.clickEventBlock = ^(NSInteger tag) {
            @strongify(self)
            [self gotoUserInfoCtrlWithTag:tag];
        };
    }
    return _headView;
}

/// 菜单
- (MLMenuView *)menuView {
    NSArray *titles = @[@"在线客服",self.cModel.customerMobile];
    NSArray *images = @[@"new_pop_service",@"new_phone"];
    if (!_menuView) {
        _menuView = [[MLMenuView alloc] initWithFrame:CGRectMake(10, 0, 130, 44 * 4) WithTitles:titles WithImageNames:images WithMenuViewOffsetTop:NavHeight WithTriangleOffsetLeft:20];
        _menuView.showType = WFShowNoHasNavBarType;
        @weakify(self)
        _menuView.didSelectBlock = ^(NSInteger index) {
            @strongify(self)
            [self customerServiceCompleleWithIndex:index];
        };
        _menuView.dissaperBlock = ^{
            @strongify(self)
            // 设置按钮选中情况
            self.isOpenService = NO;
        };
    }
    return _menuView;
}

/**
 消息数量

 @return countLbl
 */
- (UILabel *)countLbl {
    if (!_countLbl) {
        _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(19, 2, 10, 10)];
        _countLbl.textColor = [UIColor whiteColor];
        _countLbl.backgroundColor = UIColorFromRGB(0xFC3712);
        _countLbl.layer.masksToBounds = YES;
        _countLbl.layer.cornerRadius = 5;
        _countLbl.hidden = YES;
        _countLbl.font = [UIFont systemFontOfSize:9];
        _countLbl.textAlignment = NSTextAlignmentCenter;
        [self.headView.mesBtn addSubview:_countLbl];
    }
    return _countLbl;
}

- (NSArray *)titles {
    if (self.mainModel.isManage) {
        return @[@[@{@"title":@"社区服务"},@{@"title":@"奖励中心"}],
                 @[@{@"title":@"我的合伙人"},@{@"title":@"活动金"}],
                 @[@{@"title":@"设备转让"}]];
    }
    return @[@[@{@"title":@"社区服务"},@{@"title":@"奖励中心"}],
             @[@{@"title":@"活动金"}],
             @[@{@"title":@"设备转让"}]];
}


@end
