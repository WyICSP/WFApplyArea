//
//  WFPCenterViewController.m
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#define BtnWidths 44.0f

#import "WFPersonCenterViewController.h"
#import "WFCurrentWebViewController.h"
//#import "YFMediatorManager+WFLogin.h"
#import "WFMyChargePileDataTool.h"
#import "WFBaseWebViewController.h"
#import "WFUserCenterPublicAPI.h"
#import "WFUserCenterModel.h"
#import "NSString+Regular.h"
#import <MJRefresh/MJRefresh.h>
#import "WFNewUserHeadView.h"
#import "WFUserInfoTableViewCell.h"
#import "WFNewMineFooterView.h"
#import "WFHomeDataTool.h"
#import "MLMenuView.h"
#import "WKSetting.h"
#import "WKConfig.h"

@interface WFPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
///// headView
@property (nonatomic, strong, nullable) WFNewUserHeadView *headView;
/// 菜单
@property (nonatomic, strong, nullable) MLMenuView *menuView;
/// 客服
@property (nonatomic, strong, nullable) WFMineCustomerServicModel *cModel;
///// 个人中心数据
@property (nonatomic, strong, nullable) WFUserCenterModel *mainModel;
///// titles
@property (nonatomic, strong, nullable) NSArray *titles;
///// 合伙人数量和活动金
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self disableSideBack];
    // 获取未读消息
    [self getUserUnReadMessage];
    // 获取数据
    [self getUserInfo];
    // 获取客服数据
    [self getCustomerServic];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
//
#pragma mark 页面相关逻辑方法
- (void)setUI {
    self.titles = [self titles];
    // 昨天客服
    [self addLeftImageBtn:@"new_service"];
    self.leftImageBtn.width = 40;
    self.leftImageBtn.hidden = YES;
    
    [self addRightItems:2 rightItem1Name:@"new_setting" isImage1:YES rightItem2:@"new_msg" isImage2:YES];
    self.rightItem1.width = 48;
    self.rightItem2.width = 48;
    
    [self.tableView reloadData];
    
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
        if (self.mainModel.isManager) {
            self.dataInfo = @[@(models.adminNum),[NSString getNullOrNoNull:activityPrice]];
        }else {
            self.dataInfo = @[@"",activityPrice];
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
        if (![NSString isBlankString:self.cModel.customerMobile] && ![NSString isBlankString:self.cModel.customerServiceUrl]) {
           self.leftImageBtn.hidden = NO;
        }
    }];
}

- (void)leftImageButtonClick:(UIButton *)sender {
    [self gotoUserInfoCtrlWithTag:10];
}

- (void)rightItem1ButtonClick:(UIButton *)sender {
    [self gotoUserInfoCtrlWithTag:30];
}

- (void)rightItem2ButtonClick:(UIButton *)sender {
    [self gotoUserInfoCtrlWithTag:20];
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
        url = [NSString stringWithFormat:@"%@yzsh-app-partner/#/msg/index",H5_HOST];
    }else if (tag == 30) {
        // 设置
        url = [NSString stringWithFormat:@"%@yzsh-app-partner/#/userCenter/setting/index",H5_HOST];
    }else if (tag == 40) {
        // 个人资料
        url = [NSString stringWithFormat:@"%@yzsh-app-partner/#/userCenter/my/userInfo",H5_HOST];
    }else if (tag == 50) {
        // 分享充点券
//        url = [NSString stringWithFormat:@"%@yzc-union-fe/page/coupon/shareCoupon.html",H5_HOST];
    }else if (tag == 60) {
        // 钱包
        url = [NSString stringWithFormat:@"%@yzsh-app-partner/#/myWallet/index",H5_HOST];
    }else if (tag == 70) {
        // 头像
        url = [NSString stringWithFormat:@"%@yzsh-app-partner/#/userCenter/my/userInfo",H5_HOST];
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
    NSArray *datas = [self.titles safeObjectAtIndex:indexPath.section];
    WFUserInfoTableViewCell *cell = [WFUserInfoTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:datas.count];
    cell.title.text = [[datas safeObjectAtIndex:indexPath.row] safeJsonObjForKey:@"title"];
    BOOL isCan = [[[datas safeObjectAtIndex:indexPath.row] safeJsonObjForKey:@"isCanUse"] boolValue];
    cell.title.textColor = isCan ? UIColorFromRGB(0x333333) : UIColorFromRGB(0x999999);
    if (indexPath.section == 1 && self.dataInfo.count != 0) {
        cell.desc.text = [NSString stringWithFormat:@"%@",[self.dataInfo safeObjectAtIndex:indexPath.row]];
        cell.desc.hidden = NO;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WFNewMineFooterView *footerView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNewMineFooterView" owner:nil options:nil] firstObject];
    footerView.backgroundColor = UIColorFromRGB(0xF5f5f5);
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
    footerView.backgroundColor = UIColorFromRGB(0xF5f5f5);
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5f)];
    line.backgroundColor = UIColorFromRGB(0xE4E4E4);
    [footerView addSubview:line];
    return section == self.titles.count - 1 ? footerView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.titles.count - 1 ? 10.0f : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *datas = [self.titles safeObjectAtIndex:indexPath.section];
    BOOL isCan = [[[datas safeObjectAtIndex:indexPath.row] safeJsonObjForKey:@"isCanUse"] boolValue];
    if (isCan) {
        // 这个版本能使用的
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                // 我的合伙人
                WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
                web.urlString = [NSString stringWithFormat:@"%@yzsh-app-partner/#/myPartner/index",H5_HOST];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }else if (indexPath.section == 2) {
            // 设备转让
            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
            web.urlString = [NSString stringWithFormat:@"%@yzsh-app-partner/#/deviceTransfer/index",H5_HOST];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}


//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            // 社区服务
//            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
//            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/index",H5_HOST];
//            web.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:web animated:YES];
//        } else if (indexPath.row == 1) {
//            // 奖励中心
//            [YFMediatorManager openRewardCtrlWithController:self];
//        }
//    } else if (indexPath.section == 1) {
//        if (indexPath.row == 0 && self.mainModel.isManage) {
//            // 合伙人
//            WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
//            web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/myPartner/index",H5_HOST];
//            web.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:web animated:YES];
//        } else {
//            // 活动金
//            [YFMediatorManager openActivityOrRewardCtrlWithController:self type:1];
//        }
//    } else if (indexPath.section == 2) {
//        // 设备转让
//        WFCurrentWebViewController *web = [[WFCurrentWebViewController alloc] init];
//        web.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/deviceTransfer/index",H5_HOST];
//        web.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:web animated:YES];
//    }
//}
//
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
- (WFNewUserHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNewUserHeadView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 225.0f);
        @weakify(self)
        _headView.rechargeBlock = ^(NSInteger tag) {
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
        _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(23, -4, 10, 10)];
        _countLbl.textColor = [UIColor whiteColor];
        _countLbl.backgroundColor = UIColorFromRGB(0xFC3712);
        _countLbl.layer.masksToBounds = YES;
        _countLbl.layer.cornerRadius = 5;
        _countLbl.hidden = YES;
        _countLbl.font = [UIFont systemFontOfSize:9];
        _countLbl.textAlignment = NSTextAlignmentCenter;
        [self.rightItem2 addSubview:_countLbl];
    }
    return _countLbl;
}

- (NSArray *)titles {
    if (self.mainModel.isManager) {
        return @[@[@{@"title":@"奖励中心",@"isCanUse":@"0"}],
        @[@{@"title":@"我的合伙人",@"isCanUse":@"1"},@{@"title":@"活动金",@"isCanUse":@"0"}],
        @[@{@"title":@"设备转让",@"isCanUse":@"1"}]];
    }
    
    return @[@[@{@"title":@"奖励中心",@"isCanUse":@"0"}],
             @[@{@"title":@"活动金",@"isCanUse":@"0"}],
             @[@{@"title":@"设备转让",@"isCanUse":@"1"}]];
}


@end
