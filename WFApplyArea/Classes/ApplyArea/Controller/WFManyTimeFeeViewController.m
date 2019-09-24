//
//  WFManyTimeFeeViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFManyTimeFeeViewController.h"
#import "WFManyTimesUnifiedTableViewCell.h"
#import "WFMantTimesPowerTableViewCell.h"
#import "WFLookPowerFormViewController.h"
#import "WFDiscountFeeViewController.h"
#import "WFManyTimesFooterView.h"
#import "WFBilleMethodSectionView.h"
#import "WFApplyAreaDataTool.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFAreaDetailModel.h"
#import "WFAreaFeeMsgData.h"
#import "WFMyAreaListModel.h"
#import "WFUpgradeAreaData.h"

#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFManyTimeFeeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *confirmBtn;
/**headView*/
@property (nonatomic, strong, nullable) UIView *headView;
/**老片区是否有月卡套餐*/
@property (nonatomic, assign) BOOL isExist;
@end

@implementation WFManyTimeFeeViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"多次收费";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    if (!self.mainModel) {
        //如果是升级片区
        if (self.type == WFUpdateManyTimeFeeUpgradeType) {
            for (WFApplyChargeMethod *model in [WFAreaFeeMsgData shareInstace].feeData) {
                if (model.chargingModePlay.integerValue == 2) {
                    //单次收费
                    self.chargingModePlay = model.chargingModePlay;
                    self.chargingModelId = model.chargeModelId;
                }
            }
            
            //获取老片区是否有月卡套餐
            @weakify(self)
            [self getOldAreaMonthTaoCanWithSuccessBlock:^(BOOL isExist) {
                @strongify(self)
                self.isExist = isExist;
                //获取默认数据
                [self getManyTimesDefalutFee];
            }];
        }else {
            //获取默认数据
            [self getManyTimesDefalutFee];
        }
    }else {
        //数据回显
        [self.tableView reloadData];
    }
}

/**
 获取默认的价格
 */
- (void)getManyTimesDefalutFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.chargingModePlay forKey:@"chargingModePlay"];
    [params safeSetObject:self.chargingModelId forKey:@"chargingModelId"];
    @weakify(self)
    [WFApplyAreaDataTool getDefaultManyTimesChargeWithParams:params resultBlock:^(WFDefaultManyTimesModel * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModels:models];
    }];
}

- (void)requestSuccessWithModels:(WFDefaultManyTimesModel *)models {
    self.mainModel = models;
    if (self.itemArray.count == 0) {
        //默认设置统一收费打开 并把第一个区域选中
        self.mainModel.isOpenFirstSection = YES;
        self.mainModel.isSelectFirstSection = YES;
    }else if (self.itemArray.count != 0) {
        //修改多次收费回显
        if (self.chargeType == 0) {
            //统一收费
            self.mainModel.isOpenFirstSection = YES;
            self.mainModel.isSelectFirstSection = YES;
            //遍历去选中数据
            for (WFAreaDetailMultipleModel *dModel in self.itemArray) {
                for (WFDefaultUnifiedListModel *uModel in self.mainModel.multipleChargesUnifiedList) {
                    if ([dModel.chargingDefaultConfigId isEqualToString:uModel.chargingDefaultConfigId]) {
                        uModel.isSelect = YES;
                        uModel.proposalPrice = dModel.proposalPrice;
                        uModel.proposalTimes = dModel.proposalTimes;
                    }
                }
            }
        }else {
            //功率收费
            self.mainModel.isOpenSecondSection = YES;
            self.mainModel.isSelectSecondSection = YES;
            //遍历去选中数据
            for (WFAreaDetailMultipleModel *dModel in self.itemArray) {
                for (WFDefaultPowerListModel *pModel in self.mainModel.multipleChargesPowerList) {
                    if ([dModel.chargingDefaultConfigId isEqualToString:pModel.chargingDefaultConfigId]) {
                        pModel.isSelect = YES;
                        pModel.proposalPrice = dModel.proposalPrice;
                        pModel.proposalTimes = dModel.proposalTimes;
                    }
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

/**
 获取老片区是否有月卡套餐
 */
- (void)getOldAreaMonthTaoCanWithSuccessBlock:(void(^)(BOOL isExist))successBlock {
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas safeSetObject:self.groupId forKey:@"groupId"];
    [WFApplyAreaDataTool getOldAreaMonthTaoCanWithParams:parmas resultBlock:^(BOOL isExist) {
        successBlock(isExist);
    }];
}

/**
 修改多次收费
 */
- (void)updateManyTimeFee {
    if ([self multipleChargesList].count == 0) {
        [YFToast showMessage:@"请选择收费方式" inView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:[self multipleChargesList] forKey:@"multipleChargesList"];
    
    @weakify(self)
    [WFApplyAreaDataTool updateManyTimeFeeWithPamrams:params resultBlock:^{
        @strongify(self)
        [self updateSuccess];
    }];
}

- (void)updateSuccess {
    [YFToast showMessage:@"修改成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YFNotificationCenter postNotificationName:@"reloadDataKeys" object:nil];
        [self goBack];
    });
}

/**
 处理打开或者隐藏的逻辑的方法
 
 @param section 区
 @param index 10 选中, 20 打开关闭
 */
- (void)handleOpenOrChoseSectionViewWithSection:(NSInteger)section
                                          index:(NSInteger)index {
    if (index == 10) {
        //控制选中未选中
        if (section == 0) {
            //打开次区域
            self.mainModel.isOpenFirstSection = YES;
            //选中此区域
            self.mainModel.isSelectFirstSection = YES;
            self.mainModel.isSelectSecondSection = NO;
            //如果头部没有选中 则该区域的数据都不应该选中
            if (!self.mainModel.isSelectFirstSection) {
                for (WFDefaultUnifiedListModel *unModel in self.mainModel.multipleChargesUnifiedList) {
                    unModel.isSelect = NO;
                }
            }
            //将功率收费全部置为 No
            for (WFDefaultPowerListModel *pModel in self.mainModel.multipleChargesPowerList) {
                pModel.isSelect = NO;
            }
            
        }else if (section == 1) {
            //打开次区域
            self.mainModel.isOpenSecondSection = YES;
            //选中此区域
            self.mainModel.isSelectSecondSection = YES;
            self.mainModel.isSelectFirstSection = NO;
            //如果头部没有选中 则该区域的数据都不应该选中
            if (!self.mainModel.isSelectSecondSection) {
                for (WFDefaultPowerListModel *powModel in self.mainModel.multipleChargesPowerList) {
                    powModel.isSelect = NO;
                }
            }
            //将统一收费全部置为No
            for (WFDefaultUnifiedListModel *unModel in self.mainModel.multipleChargesUnifiedList) {
                unModel.isSelect = NO;
            }
        }
    }else if (index == 20) {
        //控制打开关闭
        if (section == 0) {
            self.mainModel.isOpenFirstSection = !self.mainModel.isOpenFirstSection;
        }else if (section == 1) {
            self.mainModel.isOpenSecondSection = !self.mainModel.isOpenSecondSection;
        }
    }
   
    [self.tableView reloadData];
}

/**
 获取多次收费
 
 @return multipleCharges
 */
- (NSArray *)multipleChargesList {
    NSMutableArray *mArray = [NSMutableArray new];
    if (self.mainModel.isSelectFirstSection) {
        //如果选择的是统一收费
        for (WFDefaultUnifiedListModel *uniModel in self.mainModel.multipleChargesUnifiedList) {
            if (uniModel.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict safeSetObject:@(uniModel.chargeType) forKey:@"chargeType"];
                [dict safeSetObject:uniModel.chargeModelId forKey:@"chargeModelId"];
                [dict safeSetObject:uniModel.monthCount forKey:@"monthCount"];
                [dict safeSetObject:uniModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
                [dict safeSetObject:uniModel.optionName forKey:@"optionName"];
                [dict safeSetObject:uniModel.proposalPrice forKey:@"proposalPrice"];
                [dict safeSetObject:@(uniModel.proposalTimes) forKey:@"proposalTimes"];
                [mArray addObject:dict];
            }
        }
    }else if (self.mainModel.isSelectSecondSection) {
        //如果选择的功率收费
        for (WFDefaultPowerListModel *pModel in self.mainModel.multipleChargesPowerList) {
            if (pModel.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict safeSetObject:@(pModel.chargeType) forKey:@"chargeType"];
                [dict safeSetObject:pModel.chargeModelId forKey:@"chargeModelId"];
                [dict safeSetObject:pModel.monthCount forKey:@"monthCount"];
                [dict safeSetObject:pModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
                [dict safeSetObject:pModel.optionName forKey:@"optionName"];
                [dict safeSetObject:pModel.proposalPrice forKey:@"proposalPrice"];
                [dict safeSetObject:@(pModel.proposalTimes) forKey:@"proposalTimes"];
                [mArray addObject:dict];
            }
        }
    }
    return mArray;
}

#pragma mark 完成操作
- (void)clickConfirmBtn {
    [self.view endEditing:YES];
    
    //如果没有选中数据需要提示 升级片区 而且老片区有套餐的时候必须设置套餐, 没有的套餐的就不是必选的
    if ((self.type == WFUpdateManyTimeFeeUpgradeType && self.isExist == YES) || self.type != WFUpdateManyTimeFeeUpgradeType) {
        if ([self getSelectFeeCount] == 0) {
            [YFToast showMessage:@"请选择具体的收费模式" inView:self.view];
            return;
        }
    }
    
    if (![self isCompleteData] && [self getSelectFeeCount] != 0) {
        [YFToast showMessage:@"请完善信息" inView:self.view];
        return;
    }
    
    if (self.type == WFUpdateManyTimeFeeApplyType) {
        //获取默认数据
        !self.mainModelBlock ? : self.mainModelBlock(self.mainModel);
        [self goBack];
    }else if (self.type == WFUpdateManyTimeFeeUpdateType) {
        //修改
        [self updateManyTimeFee];
    }else if (self.type == WFUpdateManyTimeFeeUpgradeType) {
        //升级
        //保存数据
        [WFUpgradeAreaData shareInstance].multipleChargesList = [self multipleChargesList];
        
        //填写优惠收费
        WFDiscountFeeViewController *method = [[WFDiscountFeeViewController alloc] init];
        method.eType(WFUpdateUserMsgUpgradeType).aGroupId(self.groupId);
        [self.navigationController pushViewController:method animated:YES];
    }
}


/**
 获取选中数据的条数

 @return 返回条数
 */
- (NSInteger)getSelectFeeCount {
    NSInteger totalData = 0;
    if (self.mainModel.isSelectFirstSection) {
        for (WFDefaultUnifiedListModel *model in self.mainModel.multipleChargesUnifiedList) {
            if (model.isSelect) {
                totalData += 1;
            }
        }
    }else if (self.mainModel.isSelectSecondSection) {
        for (WFDefaultPowerListModel *model in self.mainModel.multipleChargesPowerList) {
            if (model.isSelect) {
                totalData += 1;
            }
        }
    }
    return totalData;
}

/**
 是否把信息填写完整

 @return YES 是, NO 表示没有
 */
- (BOOL)isCompleteData {
    BOOL isComplete = NO;
    if (self.mainModel.isSelectFirstSection) {
        //统一收费
        NSInteger complete = 0;
        for (WFDefaultUnifiedListModel *model in self.mainModel.multipleChargesUnifiedList) {
            if (model.isSelect) {
                if (model.proposalPrice.floatValue >= 0 && model.proposalTimes > 0) {
                    complete = 1;
                }else {
                    complete = 0;
                    break;
                }
            }
        }
        isComplete = complete == 1 ? YES : NO;
        
    }else if (self.mainModel.isSelectSecondSection) {
        //功率收费
        NSInteger complete = 0;
        for (WFDefaultPowerListModel *model in self.mainModel.multipleChargesPowerList) {
            if (model.isSelect) {
                if (model.proposalPrice.floatValue >= 0 && model.proposalTimes > 0) {
                    complete = 1;
                }else {
                    complete = 0;
                    break;
                }
            }
        }
        isComplete = complete == 1 ? YES : NO;
    }
    return isComplete;
}

/**
 查看功率表
 */
- (void)lookFormCtrl {
    WFLookPowerFormViewController *powerForm = [[WFLookPowerFormViewController alloc] init];
    powerForm.formType = WFLookFormPowerType;
    [self.navigationController pushViewController:powerForm animated:YES];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isExist ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.mainModel.isOpenFirstSection ? self.mainModel.multipleChargesUnifiedList.count : 0;
    }
    return self.mainModel.isOpenSecondSection ? self.mainModel.multipleChargesPowerList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFManyTimesUnifiedTableViewCell *cell = [WFManyTimesUnifiedTableViewCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        [cell bindToCellWithUnifiedModel:self.mainModel.multipleChargesUnifiedList[indexPath.row] section:indexPath.section];
    }else {
        [cell bindToCellWithPowerModel:self.mainModel.multipleChargesPowerList[indexPath.row] section:indexPath.section];
    }
    @weakify(self)
    cell.clickLookFormBlock = ^{
        @strongify(self)
        [self lookFormCtrl];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WFBilleMethodSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodSectionView" owner:nil options:nil] firstObject];
    sectionView.title.text = section == 0 ? @"统一收费" : @"功率收费";
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    if (section == 0) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.mainModel.isOpenFirstSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.mainModel.isSelectFirstSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        //设置圆角
        WFRadiusRectCorner radiusRect = self.mainModel.isOpenFirstSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    }else if (section == 1) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.mainModel.isOpenSecondSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.mainModel.isSelectSecondSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        //设置圆角
        WFRadiusRectCorner radiusRect = self.mainModel.isOpenSecondSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    }
    
    @weakify(self)
    sectionView.clickSectionBlock = ^(NSInteger index){
        @strongify(self)
        [self handleOpenOrChoseSectionViewWithSection:section index:index];
    };
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-KWidth(24.0f), 10.0f)];
        footerView.hidden = !self.mainModel.isOpenFirstSection;
        footerView.backgroundColor = UIColor.clearColor;
        [footerView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), 10.0f)];
        return footerView;
        
    }else{
        WFManyTimesFooterView *footerView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFManyTimesFooterView" owner:nil options:nil] firstObject];
        footerView.lookBtn.hidden = footerView.contentsView.hidden = !self.mainModel.isOpenSecondSection;
        footerView.yuanViews.hidden = !self.mainModel.isOpenSecondSection;
        footerView.yuanViews.backgroundColor = UIColor.clearColor;
        [footerView.yuanViews setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), 10.0f)];
        @weakify(self)
        footerView.clickLookBtnBlock = ^{
            @strongify(self)
            [self lookFormCtrl];
        };
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.mainModel.isOpenFirstSection ? 20.0f : 10.0f;
    }
    return self.mainModel.isOpenSecondSection ? 55.0f : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(50.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //选中统一收费
        WFDefaultUnifiedListModel *uModel = self.mainModel.multipleChargesUnifiedList[indexPath.row];
        uModel.isSelect = !uModel.isSelect;
        self.mainModel.isSelectFirstSection = YES;
        self.mainModel.isSelectSecondSection = NO;
        
        
        //将功率收费全部置为 No
        for (WFDefaultPowerListModel *pModel in self.mainModel.multipleChargesPowerList) {
            pModel.isSelect = NO;
        }
        
    }else if (indexPath.section == 1) {
        //功率收费
        WFDefaultPowerListModel *pModel = self.mainModel.multipleChargesPowerList[indexPath.row];
        pModel.isSelect = !pModel.isSelect;
        self.mainModel.isSelectFirstSection = NO;
        self.mainModel.isSelectSecondSection = YES;
        
        //将统一收费全部置为No
        for (WFDefaultUnifiedListModel *unModel in self.mainModel.multipleChargesUnifiedList) {
            unModel.isSelect = NO;
        }
    }
    [tableView reloadData];
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(12.0f), 0, ScreenWidth-KWidth(24.0f), ScreenHeight - NavHeight - self.confirmBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.rowHeight = KHeight(45.0f);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.contentInset = UIEdgeInsetsMake(KHeight(44.0f), 0, 0, 0);
        [_tableView addSubview:self.headView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -KHeight(44.0f), ScreenWidth, KHeight(44.0f))];
        _headView.backgroundColor = UIColor.clearColor;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, KHeight(20.0f), 200, KHeight(17.0f))];
        title.text = @"*多次收费为单选";
        title.font = [UIFont systemFontOfSize:14.0f];
        title.textColor = UIColorFromRGB(0x999999);
        [_headView addSubview:title];
    }
    return _headView;
}

/**
 完成按钮
 
 @return applyBtn
 */
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_confirmBtn setTitle:[self btnTitle] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0xF78556);
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

/**
 按钮 title
 
 @return 按钮 title
 */
- (NSString *)btnTitle {
    NSString *title = @"";
    if (self.type == WFUpdateManyTimeFeeUpdateType) {
        title = @"确认修改";
    }else if (self.type == WFUpdateManyTimeFeeUpgradeType) {
        title = @"下一步(3/6)";
    }else {
        title = @"完成";
    }
    return title;
}


#pragma mark 链式编程
- (WFManyTimeFeeViewController * _Nonnull (^)(NSString * _Nonnull))dChargingModePlay {
    return ^(NSString *chargingModePlay) {
        self.chargingModePlay = chargingModePlay;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(NSString * _Nonnull))dChargingModelId {
    return ^(NSString *chargingModelId){
        self.chargingModelId = chargingModelId;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(WFDefaultManyTimesModel * _Nonnull))dDefaultManyTimesBlock {
    return ^(WFDefaultManyTimesModel *mainModel) {
        self.mainModel = mainModel;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(NSArray<WFAreaDetailMultipleModel *> * _Nonnull))itemArrays {
    return ^(NSArray <WFAreaDetailMultipleModel *> *itemArray) {
        self.itemArray = itemArray;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(NSInteger))chargeTypes {
    return ^(NSInteger chargeType) {
        self.chargeType = chargeType;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId) {
        self.groupId = groupId;
        return self;
    };
}

- (WFManyTimeFeeViewController * _Nonnull (^)(WFUpdateManyTimeType))sourceType {
    return ^(WFUpdateManyTimeType type) {
        self.type = type;
        return self;
    };
}

@end
