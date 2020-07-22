//
//  WFSingleFeeViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFSingleFeeViewController.h"
#import "WFLookPowerFormViewController.h"
#import "WFManyTimeFeeViewController.h"
#import "WFBilleMethodSectionView.h"
#import "WFSingleFeeUnifiedView.h"
#import "WFSinglePowerTableViewCell.h"
#import "WFSingleFeeTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"
#import "UIButton+GradientLayer.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"
#import "WFUpgradeAreaData.h"

#import "NSString+Regular.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFSingleFeeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIView *bottomView;
/**headView*/
@property (nonatomic, strong, nullable) UIView *headView;
/**统一收费*/
@property (nonatomic, strong, nullable) WFDefaultChargeFeeModel *unifiedModel;
/**功率收费*/
@property (nonatomic, strong, nullable) WFDefaultChargeFeeModel *powerModel;
@end

@implementation WFSingleFeeViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"单次收费";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
    if (self.models.count == 0) {
        //获取默认数据
        [self getSingleChargeFee];
    }else {
        for (WFDefaultChargeFeeModel *itemModel in self.models) {
            if (itemModel.chargeType == 0) {
                //统一收费
                self.unifiedModel = itemModel;
            } else if (itemModel.chargeType == 1) {
                //功率收费
                self.powerModel = itemModel;
            }
        }
        [self.tableView reloadData];
    }
}


//chargrType 1 功率收费 0 统一收费
- (void)getSingleChargeFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.chargingModePlay forKey:@"chargingModePlay"];
    [params safeSetObject:self.chargingModelId forKey:@"chargingModelId"];
    @weakify(self)
    [WFApplyAreaDataTool getDefaultSingleChargeWithParams:params resultBlock:^(NSArray<WFDefaultChargeFeeModel *> * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModel:models];
    }];
}

- (void)requestSuccessWithModel:(NSArray <WFDefaultChargeFeeModel *> *)models {
    self.models = models;
    
    for (WFDefaultChargeFeeModel *itemModel in self.models) {
        if (self.type == WFUpdateSingleFeeApplyType || self.type == WFUpdateSingleFeeUpgradeType) {
            if (itemModel.chargeType == 0) {
                //统一收费
                self.unifiedModel = itemModel;
                self.unifiedModel.isSelectFirstSection = YES;
                self.unifiedModel.isOpenFirstSection = YES;
            }else if (itemModel.chargeType == 1) {
                //功率收费
                self.powerModel = itemModel;
                self.powerModel.isOpenSecondSection = YES;
            }
        }else if (self.type == WFUpdateSingleFeeUpdateType){
            //修改回显的时候
            if (self.editModel.chargeType == 0) {
                if (itemModel.chargeType == 0) {
                    //统一收费
                    self.unifiedModel = itemModel;
                    self.unifiedModel.unifiedPrice = self.editModel.unifiedPrice;
                    self.unifiedModel.unifiedTime = self.editModel.unifiedTime;
                    self.unifiedModel.powerIntervalConfig = self.editModel.powerIntervalConfig;
                    self.unifiedModel.isSelectFirstSection = self.unifiedModel.isOpenFirstSection = YES;
                }else if (itemModel.chargeType == 1) {
                    //功率收费
                    self.powerModel = itemModel;
                    self.powerModel.isOpenSecondSection = YES;
                }
            }else if (self.editModel.chargeType == 1){
                if (itemModel.chargeType == 1) {
                    //功率收费
                    self.powerModel = itemModel;
                    self.powerModel.unitPrice = self.editModel.unitPrice;
                    self.powerModel.salesPrice = self.editModel.salesPrice;
                    self.powerModel.isSelectSecondSection = self.powerModel.isOpenSecondSection = YES;
                }else if (itemModel.chargeType == 0) {
                    //统一收费
                    self.unifiedModel = itemModel;
                    self.unifiedModel.isOpenFirstSection = YES;
                }
            }
        }
    }
    [self.tableView reloadData];
}

/**
 修改单次收费
 */
- (void)updateSingleFee {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:[self singleCharge] forKey:@"singleCharge"];
    
    @weakify(self)
    [WFApplyAreaDataTool updateSingleFeeWithParams:params resultBlock:^{
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
 获取单次收费 必填
 
 @return singleCharge
 */
- (NSDictionary *)singleCharge {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (WFDefaultChargeFeeModel *sModel in self.models) {
        if (sModel.isSelectFirstSection) {
            //单一收费
            [dict safeSetObject:@(sModel.chargeType) forKey:@"chargeType"];
            [dict safeSetObject:sModel.chargeModelId forKey:@"chargeModelId"];
            [dict safeSetObject:sModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
            [dict safeSetObject:@(sModel.salesPrice.doubleValue) forKey:@"salesPrice"];
            [dict safeSetObject:self.editModel.singleChargeId forKey:@"singleChargeId"];
            [dict safeSetObject:@(sModel.unifiedPrice.integerValue) forKey:@"unifiedPrice"];
            [dict safeSetObject:@(sModel.unifiedTime) forKey:@"unifiedTime"];
            [dict safeSetObject:@(sModel.unitPrice.doubleValue) forKey:@"unitPrice"];
            NSArray *powerConfigArray = [self getSingleFeeConfigWithSmodel:sModel];
            if (self.type == WFUpdateSingleFeeUpgradeType) {
                //升级
                [dict safeSetObject:powerConfigArray forKey:@"powerIntervalConfig"];
            }else {
                //申请或者修改
                [dict safeSetObject:powerConfigArray forKey:@"powerIntervalList"];
            }
        }else if (sModel.isSelectSecondSection) {
            //统一收费
            [dict safeSetObject:@(sModel.chargeType) forKey:@"chargeType"];
            [dict safeSetObject:sModel.chargeModelId forKey:@"chargeModelId"];
            [dict safeSetObject:sModel.chargingDefaultConfigId forKey:@"chargingDefaultConfigId"];
            [dict safeSetObject:@(sModel.salesPrice.doubleValue) forKey:@"salesPrice"];
            [dict safeSetObject:self.editModel.singleChargeId forKey:@"singleChargeId"];
            [dict safeSetObject:@(sModel.unifiedPrice.integerValue) forKey:@"unifiedPrice"];
            [dict safeSetObject:@(sModel.unifiedTime) forKey:@"unifiedTime"];
            [dict safeSetObject:@(sModel.unitPrice.doubleValue) forKey:@"unitPrice"];
            if (self.type == WFUpdateSingleFeeUpgradeType) {
                //升级
                [dict safeSetObject:@[] forKey:@"powerIntervalConfig"];
            }else {
                //申请或者修改
                [dict safeSetObject:@[] forKey:@"powerIntervalList"];
            }
        }
    }
    return dict;
}

/// 获取单次收费功能配置信息
- (NSMutableArray *)getSingleFeeConfigWithSmodel:(WFDefaultChargeFeeModel *)sModel {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (WFChargeFeePowerConfigModel *pModel in sModel.powerIntervalConfig) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict safeSetObject:@(pModel.maxPower) forKey:@"maxPower"];
        [dict safeSetObject:@(pModel.minPower) forKey:@"minPower"];
        [dict safeSetObject:pModel.price forKey:@"price"];
        [dict safeSetObject:pModel.singleChargingPowerIntervalId forKey:@"singleChargingPowerIntervalConfigId"];
        [dict safeSetObject:@(pModel.time) forKey:@"time"];
        [dict safeSetObject:@(pModel.proportion) forKey:@"proportion"];
        [array addObject:dict];
    }
    return array;
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
            //打开此区域
            self.unifiedModel.isOpenFirstSection = YES;
            //选中地区与
            self.unifiedModel.isSelectFirstSection = YES;
            self.powerModel.isSelectSecondSection = NO;
        }else if (section == 1) {
            //打开此区域
            self.powerModel.isOpenSecondSection = YES;
            //选中地区与
            self.powerModel.isSelectSecondSection = YES;
            self.unifiedModel.isSelectFirstSection = NO;
        }
    }else if (index == 20) {
        //控制打开关闭
        if (section == 0) {
            self.unifiedModel.isOpenFirstSection = !self.unifiedModel.isOpenFirstSection;
        }else if (section == 1) {
            self.powerModel.isOpenSecondSection = !self.powerModel.isOpenSecondSection;
        }
    }
    [self.tableView reloadData];
}


/// 刷新数据
/// @param time 时间
/// @param type 1 时间, 2 价格
/// @param price 价格
- (void)updatePowerTimeWithTime:(double)time
                           type:(NSInteger)type
                          price:(NSNumber *)price {
    for (WFChargeFeePowerConfigModel *pModel in self.unifiedModel.powerIntervalConfig) {
        if (type == 1) {
            pModel.time = pModel.proportion *time;
        }else {
            pModel.price = price;
        }
    }
    [self.tableView reloadData];
}

/**
 查看利润表
 */
- (void)jumpFormCtrl {
    WFLookPowerFormViewController *form = [[WFLookPowerFormViewController alloc] init];
    form.formTypes(WFLookFormProfitType).unitPrices(self.powerModel.unitPrice).salesPrices(self.powerModel.salesPrice);
    [self.navigationController pushViewController:form animated:YES];
}

#pragma mark  确定
- (void)clickConfirmBtn {
    
    if (![self isCompleteData]) {
        [YFToast showMessage:@"请完善单次收费信息" inView:self.view];
        return;
    }
    
    if (self.type == WFUpdateSingleFeeUpdateType) {
        //编辑单次收费
        [self updateSingleFee];
    }else if (self.type == WFUpdateSingleFeeUpgradeType) {
        //升级片区
        //保存数据
        [WFUpgradeAreaData shareInstance].singleCharge = [self singleCharge];
        //去填写多次收费
        WFManyTimeFeeViewController *manyTime = [[WFManyTimeFeeViewController alloc] init];
        manyTime.sourceType(WFUpdateManyTimeFeeUpgradeType).groupIds(self.groupId);
        [self.navigationController pushViewController:manyTime animated:YES];
    }else {
        //获取默认单次收费
        !self.singleFeeData ? : self.singleFeeData(self.models);
        [self goBack];
    }
}

/**
 是否把信息填写完整
 
 @return YES 是, NO 表示没有
 */
- (BOOL)isCompleteData {
    BOOL isComplete = NO;
    for (WFDefaultChargeFeeModel *sModel in self.models) {
        if (sModel.isSelectFirstSection) {
            //单一收费
            if (sModel.unifiedPrice.floatValue >= 0 && sModel.unifiedTime > 0) {
                isComplete = YES;
            }else {
                return NO;
            }
            //下面的功率
            for (WFChargeFeePowerConfigModel *cModel in sModel.powerIntervalConfig) {
                if (cModel.price.floatValue >= 0 && cModel.time > 0) {
                    isComplete = YES;
                }else {
                    return NO;
                }
            }
        }else if (sModel.isSelectSecondSection) {
            //统一收费
            if (sModel.unitPrice.floatValue >= 0 && sModel.salesPrice.floatValue >= 0) {
                isComplete = YES;
            }else {
                isComplete = NO;
            }
        }
    }
    return isComplete;
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.unifiedModel.powerIntervalConfig.count : self.powerModel.isOpenSecondSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFSingleFeeTableViewCell *cell = [WFSingleFeeTableViewCell cellWithTableView:tableView indexPath:indexPath dataCount:self.unifiedModel.powerIntervalConfig.count];
        cell.model = [self.unifiedModel.powerIntervalConfig safeObjectAtIndex:indexPath.row];
        return cell;
    }
    WFSinglePowerTableViewCell *cell = [WFSinglePowerTableViewCell cellWithTableView:tableView];
    cell.model = self.powerModel;
    @weakify(self)
    cell.clickLookBtnBlock = ^{
        @strongify(self)
        [self jumpFormCtrl];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    if (section == 0) {
        //得到图片的路径
        WFSingleFeeUnifiedView *unifiedView = [[currentBundler loadNibNamed:@"WFSingleFeeUnifiedView" owner:nil options:nil] firstObject];
        unifiedView.model = self.unifiedModel;
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.unifiedModel.isSelectFirstSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [unifiedView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        @weakify(self)
        unifiedView.clickSectionBlock = ^(NSInteger index) {
            @strongify(self)
            [self handleOpenOrChoseSectionViewWithSection:section index:index];
        };
        unifiedView.reloadTimePriceBlock = ^(NSInteger time, NSInteger type, NSNumber * _Nonnull price) {
            @strongify(self)
            [self updatePowerTimeWithTime:time type:type price:price];
        };
        return unifiedView;
    }else if (section == 1) {
        WFBilleMethodSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodSectionView" owner:nil options:nil] firstObject];
        sectionView.title.text = @"功率区间收费";
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.powerModel.isOpenSecondSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.powerModel.isSelectSecondSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        //设置圆角
        WFRadiusRectCorner radiusRect = self.powerModel.isOpenSecondSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
        [sectionView.showImgBtn setTitle:@"" forState:0];
        @weakify(self)
        sectionView.clickSectionBlock = ^(NSInteger index){
            @strongify(self)
            [self handleOpenOrChoseSectionViewWithSection:section index:index];
        };
        return sectionView;
    }
    return [UIView new];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(50.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 50.0f : 135.0f;
}


#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(12.0f), 0, ScreenWidth-KWidth(24.0f), ScreenHeight - NavHeight - self.bottomView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
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
        title.text = @"*单次收费为单选";
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
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 55.0f - NavHeight-SafeAreaBottom, ScreenWidth, 55.0f+SafeAreaBottom)];
        _bottomView.backgroundColor = UIColor.whiteColor;
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(15.0f, 7.5, ScreenWidth-30.0f, 40.0f);
        [confirmBtn setTitle:[self btnTitle] forState:0];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setGradientLayerWithColors:@[UIColorFromRGB(0xFFBD00),UIColorFromRGB(0xFFCF00)] cornerRadius:20.0f gradientType:WFButtonGradientTypeLeftToRight];
        confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [confirmBtn setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        [_bottomView addSubview:confirmBtn];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

/**
 按钮 title

 @return 按钮 title
 */
- (NSString *)btnTitle {
    NSString *title = @"";
    if (self.type == WFUpdateSingleFeeUpdateType) {
        title = @"确认修改";
    }else if (self.type == WFUpdateSingleFeeUpgradeType) {
        title = @"下一步(2/7)";
    }else {
        title = @"完成";
    }
    return title;
}

#pragma mark 链式编程
- (WFSingleFeeViewController * _Nonnull (^)(NSString * _Nonnull))dChargingModePlay {
    return ^(NSString *chargingModePlay) {
        self.chargingModePlay = chargingModePlay;
        return self;
    };
}

- (WFSingleFeeViewController * _Nonnull (^)(NSString * _Nonnull))dChargingModelId {
    return ^(NSString *chargingModelId){
        self.chargingModelId = chargingModelId;
        return self;
    };
}

- (WFSingleFeeViewController * _Nonnull (^)(WFAreaDetailSingleChargeModel * _Nonnull))editModels {
    return ^(WFAreaDetailSingleChargeModel *editModel) {
        self.editModel = editModel;
        return self;
    };
}

- (WFSingleFeeViewController * _Nonnull (^)(NSArray<WFDefaultChargeFeeModel *> * _Nonnull))mainModels {
    return ^(NSArray <WFDefaultChargeFeeModel *> *models){
        self.models = models;
        return self;
    };
}

- (WFSingleFeeViewController * _Nonnull (^)(WFUpdateSingleType))sType {
    return ^(WFUpdateSingleType type){
        self.type = type;
        return self;
    };
}

- (WFSingleFeeViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId){
        self.groupId = groupId;
        return self;
    };
}


@end
