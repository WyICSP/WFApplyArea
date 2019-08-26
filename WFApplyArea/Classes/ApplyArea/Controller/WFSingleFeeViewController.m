//
//  WFSingleFeeViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFSingleFeeViewController.h"
#import "WFLookPowerFormViewController.h"
#import "WFBilleMethodSectionView.h"
#import "WFSinglePowerTableViewCell.h"
#import "WFSingleFeeTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"

#import "NSString+Regular.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFSingleFeeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *confirmBtn;
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
        if (self.type == WFUpdateSingleFeeApplyType) {
            //获取默认的时候默认选中第一个
            if (itemModel.chargeType == 0) {
                //统一收费
                self.unifiedModel = itemModel;
                self.unifiedModel.isSelectFirstSection = YES;
                self.unifiedModel.isOpenFirstSection = YES;
            }else if (itemModel.chargeType == 1) {
                //功率收费
                self.powerModel = itemModel;
            }
        }else if (self.type == WFUpdateSingleFeeUpdateType){
            //修改回显的时候
            if (self.editModel.chargeType == 0) {
                if (itemModel.chargeType == 0) {
                    //统一收费
                    self.unifiedModel = itemModel;
                    self.unifiedModel.unifiedPrice = self.editModel.unifiedPrice;
                    self.unifiedModel.unifiedTime = self.editModel.unifiedTime;
                    self.unifiedModel.isSelectFirstSection = self.unifiedModel.isOpenFirstSection = YES;
                }else if (itemModel.chargeType == 1) {
                    //功率收费
                    self.powerModel = itemModel;
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
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
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
            
        }
    }
    return dict;
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
            self.unifiedModel.isSelectFirstSection = !self.unifiedModel.isSelectFirstSection;
            self.powerModel.isSelectSecondSection = NO;
        }else if (section == 1) {
            self.powerModel.isSelectSecondSection = !self.powerModel.isSelectSecondSection;
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
    if (self.type == WFUpdateSingleFeeUpdateType) {
        //编辑单次收费
        [self updateSingleFee];
    }else {
        //获取默认单次收费
        !self.singleFeeData ? : self.singleFeeData(self.models);
        [self goBack];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.unifiedModel.isOpenFirstSection : self.powerModel.isOpenSecondSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFSingleFeeTableViewCell *cell = [WFSingleFeeTableViewCell cellWithTableView:tableView];
        cell.model = self.unifiedModel;
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
    WFBilleMethodSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodSectionView" owner:nil options:nil] firstObject];
    sectionView.title.text = section == 0 ? @"统一收费" : @"功率收费";
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    if (section == 0) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.unifiedModel.isOpenFirstSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.unifiedModel.isSelectFirstSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        //设置圆角
        WFRadiusRectCorner radiusRect = self.unifiedModel.isOpenFirstSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    }else if (section == 1) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.powerModel.isOpenSecondSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.powerModel.isSelectSecondSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        //设置圆角
        WFRadiusRectCorner radiusRect = self.powerModel.isOpenSecondSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    }
    
    @weakify(self)
    sectionView.clickSectionBlock = ^(NSInteger index){
        @strongify(self)
        [self handleOpenOrChoseSectionViewWithSection:section index:index];
    };
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(50.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 50.0f : KHeight(135.0f);
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
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(KWidth(20.0f), KHeight(20.0f), 200, KHeight(17.0f))];
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
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.frame = CGRectMake(0, ScreenHeight - KHeight(45.0f) - NavHeight, ScreenWidth, KHeight(45));
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = UIColorFromRGB(0xF78556);
        [self.view addSubview:_confirmBtn];
    }
    return _confirmBtn;
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