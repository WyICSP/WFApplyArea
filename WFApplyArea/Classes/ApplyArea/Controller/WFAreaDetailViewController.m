//
//  WFAreaDetailViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailViewController.h"
#import "WFAreaDetailAddressTableViewCell.h"
#import "WFAreaDetailSingleTableViewCell.h"
#import "WFAreaDetailManyTimesTableViewCell.h"
#import "WFAreaDetailDiscountTableViewCell.h"
#import "WFAreaDetailTimeTableViewCell.h"
#import "WFMyAreaAddressTableViewCell.h"
#import "WFAreaDetailPartnerTableViewCell.h"
#import "WFAreaDetailCollectFeeSectionView.h"
#import "WFAreaDetailPersonTableViewCell.h"
#import "WFAreaDetailOtherSectionView.h"
#import "WFEditAreaDetailViewController.h"
#import "WFLookPowerFormViewController.h"
#import "WFBilleMethodViewController.h"
#import "WFDiscountFeeViewController.h"
#import "WFDividIntoSetViewController.h"
#import "UITableView+YFExtension.h"
#import "WFAreaDetailFooterView.h"
#import "WFMyAreaDetailHeadView.h"
#import "WFApplyAreaDataTool.h"
#import "WFMyAreaChargePileView.h"
#import "WFAreaDetailModel.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "WKHelp.h"

@interface WFAreaDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据*/
@property (nonatomic, strong, nullable) WFAreaDetailModel *mainModels;
/**我的充电桩过来的需要显示的*/
@property (nonatomic, strong, nullable) WFMyAreaDetailHeadView *headView;
/**充电桩信号强度*/
@property (nonatomic, strong, nullable) WFMyAreaChargePileView *chargePileView;
/**计费类型，1:小时计费 2:金额计费*/
@property (nonatomic, assign) NSInteger billingPlay;
/**是否显示收费*/
@property (nonatomic, assign) BOOL isCollectFee;
/**是否显示计费*/
@property (nonatomic, assign) BOOL isMeterFee;
/**是否显示合伙人*/
@property (nonatomic, assign) BOOL isPartner;
@end

@implementation WFAreaDetailViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)dealloc {
    [YFNotificationCenter removeObserver:self name:@"reloadDataKeys" object:nil];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"片区详情";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    //获取片区详情
    [self getAreaDetailMsg];
    //注册通知：监听充电时间变化
    [YFNotificationCenter addObserver:self selector:@selector(getAreaDetailMsg) name:@"reloadDataKeys" object:nil];
    
}

/**
 获取片区详情
 */
- (void)getAreaDetailMsg {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getAreaDetailWithParams:params resultBlock:^(WFAreaDetailModel * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModels:models];
    }];
}

- (void)requestSuccessWithModels:(WFAreaDetailModel * _Nonnull)models {
    self.mainModels = models;
    //设置默认选中
    [self setDefaultSelectFee];
    
//    //判断是否显示收费模块
    if (self.mainModels.singleCharge || self.mainModels.vipCharge || self.mainModels.multipleChargesList.count != 0) {
        self.isCollectFee = YES;
    }
    //是否显示计费
    if (self.mainModels.billingInfos.count != 0) {
        WFAreaDetailBillingInfosModel *firstModel = [self.mainModels.billingInfos firstObject];
        self.billingPlay = firstModel.billingPlay;
        self.isMeterFee = YES;
    }
    //是否显示合伙人
    if (self.mainModels.partnerPropInfos.count != 0) {
        self.isPartner = YES;
    }
    
    [self.tableView reloadData];
}

/**
 设置默认选中
 */
- (void)setDefaultSelectFee {
    if (![NSString isBlankString:self.mainModels.singleCharge.singleChargeId]) {
        //默认选中单次收费
        self.mainModels.isHaveSinge = self.mainModels.singleCharge.isSelect = YES;
        self.showType = WFAreaDetailSingleType;
        return;
    }else if (self.mainModels.multipleChargesList.count != 0) {
        WFAreaDetailMultipleModel *itemModel = [self.mainModels.multipleChargesList firstObject];
        self.mainModels.isHaveManyTime = itemModel.isSelect = YES;
        self.showType = WFAreaDetailManyTimesType;
        return;
    }else if (![NSString isBlankString:self.mainModels.vipCharge.vipChargeId]) {
        self.mainModels.isHaveVip = self.mainModels.vipCharge.isSelect = YES;
        self.showType = WFAreaDetailDiscountType;
        return;
    }
}

/**
 获取地址 cell 的高度 areaName

 @return getAddressHeight
 */
- (CGFloat)getAddressHeight {
    NSString *address = [NSString stringWithFormat:@"%@%@",self.mainModels.areaName,self.mainModels.address];
    CGSize size = [NSString getStringSize:16.0f withString:address andWidth:ScreenWidth-96.0f];
    return size.height + 31;
}

/**
 处理区头时间
 */
- (void)handleSectionWithTitle:(NSString *)title {
    if ([title containsString:@"单次收费"]) {
        self.showType = WFAreaDetailSingleType;
        self.mainModels.singleCharge.isSelect = YES;
        self.mainModels.vipCharge.isSelect = self.mainModels.isSelectMany = NO;
    }else if ([title containsString:@"多次收费"]) {
        self.showType = WFAreaDetailManyTimesType;
        self.mainModels.isSelectMany = YES;
        self.mainModels.singleCharge.isSelect = self.mainModels.vipCharge.isSelect = NO;
    }else if ([title containsString:@"优惠收费"]) {
        self.showType = WFAreaDetailDiscountType;
        self.mainModels.vipCharge.isSelect = YES;
        self.mainModels.singleCharge.isSelect = self.mainModels.isSelectMany = NO;
    }else if ([title containsString:@"利润计算表"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormProfitType).unitPrices(self.mainModels.singleCharge.unitPrice).
        salesPrices(self.mainModels.singleCharge.salesPrice);
        [self.navigationController pushViewController:form animated:YES];
        return;
    }else if ([title containsString:@"功率计次表"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormPowerType);
        [self.navigationController pushViewController:form animated:YES];
        return;
    }else if ([title containsString:@"查看会员"]) {
        WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
        form.formTypes(WFLookFormVipType).groupIds(self.mainModels.groupId);
        [self.navigationController pushViewController:form animated:YES];
        return;
    }else if ([title containsString:@"编辑"]) {
        WFEditAreaDetailViewController *edit = [[WFEditAreaDetailViewController alloc] init];
        edit.models = self.mainModels;
        [self.navigationController pushViewController:edit animated:YES];
        return;
    }
    [self.tableView reloadData];
}

/**
 显示片区还是显示信号强度

 @param tag 100 收费按钮 200 充电桩按钮
 */
- (void)handleAreaOrPileWithTag:(NSInteger)tag {
    if (tag == 100) {
        self.tableView.hidden = NO;
        self.chargePileView.hidden = YES;
    }else if (tag == 200) {
        self.chargePileView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

/**
 跳转到合伙人 和积分方式

 @param section 区域
 */
- (void)jumpPartnerOrchargeCtrlWithSection:(NSInteger)section {
    if (section == 2) {
        WFBilleMethodViewController *method = [[WFBilleMethodViewController alloc] init];
        method.groupIds(self.mainModels.groupId);
        [self.navigationController pushViewController:method animated:YES];
    }else if(section == 3) {
        //优惠收费
        WFDividIntoSetViewController *set = [[WFDividIntoSetViewController alloc] init];
        set.groupIds(self.mainModels.groupId);
        [self.navigationController pushViewController:set animated:YES];
    }
}

/**
 获取计费方式的高度
 
 @return getPriceHeight
 */
- (CGFloat)getBillHeight {
    //充电金额
    NSInteger index = self.mainModels.billingInfos.count % 3;
    //获取一共多少行
    NSInteger row = self.mainModels.billingInfos.count / 3;
    //整除的时候的高度
    NSInteger wholeHeight = row * KHeight(32.0f) +  (row - 2) * KHeight(10.0f);
    //不能整除的时候的高度
    NSInteger maxHeight = (row + 1) * KHeight(32.0f) + (row - 1) * KHeight(10.0f);
    
    return index == 0 ? wholeHeight + 20 : maxHeight + 20;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        //收费
        return self.isCollectFee ? 1 : 0;
    }else if (section == 2) {
        //计费
        return self.isMeterFee ? 1 : 0;
    }else if (section == 3) {
        //合伙人
        return self.isPartner ? self.mainModels.partnerPropInfos.count + 1 : 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //地址 我的片区进来
        if (self.jumpType == WFAreaDetailJumpPileType) {
            WFMyAreaAddressTableViewCell *cell = [WFMyAreaAddressTableViewCell cellWithTableView:tableView];
            cell.model = self.mainModels;
            return cell;
        }
        WFAreaDetailAddressTableViewCell *cell = [WFAreaDetailAddressTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.mainModels addressHeight:[self getAddressHeight]];
        return cell;
    }else if (indexPath.section == 1) {
        if (self.showType == WFAreaDetailSingleType) {
            //单次收费
            WFAreaDetailSingleTableViewCell *cell = [WFAreaDetailSingleTableViewCell cellWithTableView:tableView];
            cell.model = self.mainModels.singleCharge;
            return cell;
        }else if (self.showType == WFAreaDetailManyTimesType) {
            //多次收费
            WFAreaDetailManyTimesTableViewCell *cell = [WFAreaDetailManyTimesTableViewCell cellWithTableView:tableView];
            cell.models = self.mainModels.multipleChargesList;
            return cell;
        }
        //优惠收费
        WFAreaDetailDiscountTableViewCell *cell = [WFAreaDetailDiscountTableViewCell cellWithTableView:tableView];
        cell.model = self.mainModels.vipCharge;
        return cell;
    }else if (indexPath.section == 2) {
        //时间设置
        WFAreaDetailTimeTableViewCell *cell = [WFAreaDetailTimeTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.mainModels.billingInfos cellHeight:[self getBillHeight]];
        return cell;
    }
    //合伙人设置
    if (indexPath.row == 0) {
        WFAreaDetailPersonTableViewCell *cell = [WFAreaDetailPersonTableViewCell cellWithTableView:tableView];
        return cell;
    }
    WFAreaDetailPartnerTableViewCell *cell = [WFAreaDetailPartnerTableViewCell cellWithTableView:tableView];
    cell.model = self.mainModels.partnerPropInfos[indexPath.row - 1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        WFAreaDetailCollectFeeSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailCollectFeeSectionView" owner:nil options:nil] firstObject];
        sectionView.model = self.mainModels;
        WS(weakSelf)
        sectionView.clickBtnBlock = ^(NSString * _Nonnull btnTitle) {
            [weakSelf handleSectionWithTitle:btnTitle];
        };
        return self.isCollectFee ? sectionView : [UIView new];
    }else if (section == 2 || section == 3) {
        WFAreaDetailOtherSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailOtherSectionView" owner:nil options:nil] firstObject];
        sectionView.title.text = section == 2 ? @"我的计费标准" : @"我的合伙人";
        sectionView.detailLbl.hidden = section != 2;
        sectionView.detailLbl.text = self.billingPlay == 1 ? @"按小时计费" : @"按金额计费";
        @weakify(self)
        sectionView.clickBtnBlock = ^{
            @strongify(self)
            [self jumpPartnerOrchargeCtrlWithSection:section];
        };
        if (section == 2) {
            return self.isMeterFee ? sectionView : [UIView new];
        }else if (section == 3) {
            return self.isPartner ? sectionView : [UIView new];
        }
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0) {
        WFAreaDetailFooterView *footerView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailFooterView" owner:nil options:nil] firstObject];
        if (section == 1) {
            return self.isCollectFee ? footerView : [UIView new];
        }else if (section == 2) {
            return self.isMeterFee ? footerView : [UIView new];
        }
        return self.isPartner ? footerView : [UIView new];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //地址
        return self.jumpType == WFAreaDetailJumpPileType ? [self getAddressHeight] : KHeight(115.0f) + [self getAddressHeight]/2;
    }else if (indexPath.section == 1) {
        //收费标准
        if (self.showType == WFAreaDetailSingleType) {
            //单次收费
            return KHeight(80.0f);
        }else if (self.showType == WFAreaDetailManyTimesType) {
            //多次收费 +1 是头部高度
            return 10.0f+37.0f*(self.mainModels.multipleChargesList.count+1);
        }
        //优惠收费
        return KHeight(80.0f);
    }else if (indexPath.section == 2) {
        //时间设置
        return [self getBillHeight];
    }
    //合伙人
    return KHeight(44.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.isCollectFee ? KHeight(95.0f) : CGFLOAT_MIN;
    }else if (section == 2) {
        return self.isMeterFee ? KHeight(44.0f) : CGFLOAT_MIN;
    }else if (section == 3) {
        return self.isPartner ? KHeight(44.0f) : CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    }else if (section == 1) {
        return self.isCollectFee ? 20.0f : CGFLOAT_MIN;
    }else if (section == 2) {
        return self.isMeterFee ? 20.0f : CGFLOAT_MIN;
    }else if (section == 3) {
        return self.isPartner ? 20.0f : CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}


#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) style:UITableViewStyleGrouped];
        if (self.jumpType == WFAreaDetailJumpPileType) {
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight - NavHeight - self.headView.frame.size.height);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/**
 头视图

 @return headView
 */
- (WFMyAreaDetailHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaDetailHeadView" owner:nil options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 100.0f);
        @weakify(self)
        _headView.clickBtnBlock = ^(NSInteger tag) {
            @strongify(self)
            [self handleAreaOrPileWithTag:tag];
        };
        [self.view addSubview:_headView];
    }
    return _headView;
}

/**
 信号强度 view

 @return chargePileView
 */
- (WFMyAreaChargePileView *)chargePileView {
    if (!_chargePileView) {
        _chargePileView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaChargePileView" owner:nil options:nil] firstObject];
        _chargePileView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), ScreenWidth, ScreenHeight - NavHeight - self.headView.frame.size.height);
        _chargePileView.groupId = self.groupId;
        [self.view addSubview:_chargePileView];
    }
    return _chargePileView;
}



@end
