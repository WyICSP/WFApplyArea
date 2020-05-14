//
//  WFPCenterViewController.m
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#import "WFPersonCenterViewController.h"
#import "WFPersonCenterTableViewCell.h"
#import "WFUserCenterViewController.h"
#import "YFMediatorManager+WFLogin.h"
#import "WFMyChargePileDataTool.h"
#import "WFBaseWebViewController.h"
#import "WFUserCenterPublicAPI.h"
#import "WFUserCenterModel.h"
#import "NSString+Regular.h"
#import "WFPersonHeadView.h"
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
/// titles
@property (nonatomic, strong, nullable) NSArray *titles;
/// 合伙人数量和活动金
@property (nonatomic, strong, nullable) NSArray *dataInfo;
/// 是否打开
@property (nonatomic, assign) BOOL isOpenService;
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
    // 获取数据
    [self getUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark 页面相关逻辑方法
- (void)setUI {
    [self.tableView reloadData];
    self.titles = [self titles];
    // 获取客服数据
    [self getCustomerServic];
}

/// 获取数据
- (void)getUserInfo {
    @weakify(self)
    [WFMyChargePileDataTool getUserInfoWithParams:@{} resultBlock:^(WFUserCenterModel * _Nonnull models) {
        @strongify(self)
        self.headView.model = models;
        // 活动金
        NSString *activityPrice = [NSString stringWithFormat:@"¥%@",[NSString decimalNumberWithDouble:models.activityPrice.doubleValue/1000]];
        
        // 添加到数组中
        self.dataInfo = @[@(models.adminNum),activityPrice];
        
        [self.tableView reloadData];
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
        url = [NSString stringWithFormat:@"%@yzc_business_h5/page/userInfo.html",H5_HOST];
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
    
    WFUserCenterViewController *web = [[WFUserCenterViewController alloc] init];
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
        // 社区服务
        WFUserCenterViewController *web = [[WFUserCenterViewController alloc] init];
        web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/index",H5_HOST];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 合伙人
            WFUserCenterViewController *web = [[WFUserCenterViewController alloc] init];
            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/myPartner/index",H5_HOST];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        } else if (indexPath.row){
            // 活动金
            [YFMediatorManager openActivityOrRewardCtrlWithController:self type:1];
        }
    } else if (indexPath.section == 2) {
        // 设备转让
        WFUserCenterViewController *web = [[WFUserCenterViewController alloc] init];
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

- (NSArray *)titles {
    return @[@[@{@"title":@"社区服务"}],
             @[@{@"title":@"我的合伙人"},@{@"title":@"活动金"}],
             @[@{@"title":@"设备转让"}]];
}


@end
