//
//  WFBilleMethodViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodViewController.h"
#import "WFBilleMethodTimeTableViewCell.h"
#import "WFBilleMethodMoneyTableViewCell.h"
#import "WFBilleMethodSectionView.h"
#import "UITableView+YFExtension.h"
#import "WFApplyAreaDataTool.h"
#import "WFBillMethodModel.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFBilleMethodViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**申请片区按钮*/
@property (nonatomic, strong, nullable) UIButton *confirmBtn;
/**headView*/
@property (nonatomic, strong, nullable) UIView *headView;
/**充电金额数据*/
@property (nonatomic, strong, nullable) NSMutableArray <WFBillingPriceMethodModel *> *billPriceMethodArray;
/**时间区域高度*/
@property (nonatomic, assign) CGFloat billMethodTimeHeight;
/**价格区域高度*/
@property (nonatomic, assign) CGFloat billMethodPriceHeight;
@end

@implementation WFBilleMethodViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    [YFNotificationCenter removeObserver:self name:@"MonitorMoneyKeys" object:nil];
    [YFNotificationCenter removeObserver:self name:@"MonitorTimeKeys" object:nil];
    [YFNotificationCenter removeObserver:self name:@"AddTimeKeys" object:nil];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"选择计费方式";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    //注册通知：监听充电金额变化
    [YFNotificationCenter addObserver:self selector:@selector(monitorMoneyDataChange:) name:@"MonitorMoneyKeys" object:nil];
    //注册通知：监听充电时间变化
    [YFNotificationCenter addObserver:self selector:@selector(monitorTimeDataChange:) name:@"MonitorTimeKeys" object:nil];
    //注册通知：监听充电时间变化
    [YFNotificationCenter addObserver:self selector:@selector(addCustom:) name:@"AddTimeKeys" object:nil];
    //获取积计费方式
    if (!self.models) {
        [self getBillMethod];
    }else {
        //添加数据
        [self.billPriceMethodArray addObjectsFromArray:self.models.billingPriceMethods];
        
        //获取充电时间高度
        self.billMethodTimeHeight = [self getTimeHeight];
        //获取充电金额高度
        self.billMethodPriceHeight = [self getPriceHeight];
        
        [self.tableView reloadData];
    }
}

#pragma mark 获取计费方式
- (void)getBillMethod {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getBillingMethodWithParams:params resultBlock:^(WFBillMethodModel * _Nonnull models) {
        @strongify(self)
        [self requestWithSuccessWithModels:models];
    }];
}

- (void)requestWithSuccessWithModels:(WFBillMethodModel *)models {
    self.models = models;
    
    //添加自定义的输入金额数据
    [self.billPriceMethodArray addObjectsFromArray:self.models.billingPriceMethods];
    [self.billPriceMethodArray addObject:[self customPriceModel]];
    
    self.models.billingPriceMethods = self.billPriceMethodArray;
    
    //计算充电时长选中的个数
    for (WFBillingTimeMethodModel *tModel in self.models.billingTimeMethods) {
        if (tModel.isSelect) {
            self.models.firstSelectNum += 1;
        }
    }
    //如果不等于 0 那么久应该打开
    self.models.isSelectFirstSection = self.models.isOpenFirstSection = self.models.firstSelectNum != 0;
    
    //计算充电金额选中的个数
    for (WFBillingPriceMethodModel *pModel in self.models.billingPriceMethods) {
        if (pModel.isSelect) {
            self.models.secondSelectNum += 1;
        }
    }
    //如果不等于 0 那么久应该打开
    self.models.isSelectSecondSection = self.models.isOpenSecondSection = self.models.secondSelectNum != 0;
    
    //获取充电时间高度
    self.billMethodTimeHeight = [self getTimeHeight];
    //获取充电金额高度
    self.billMethodPriceHeight = [self getPriceHeight];
    
    [self.tableView reloadData];
}

/**
 更新收费数据
 */
- (void)updateBilleMehtod {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    [params safeSetObject:[self billingPlanIds] forKey:@"billingPlanIds"];
    @weakify(self)
    [WFApplyAreaDataTool updateChargingMethodWithParams:params resultBlock:^{
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
 选中的收费方式

 @return billingPlanIds
 */
- (NSArray *)billingPlanIds {
    
    NSMutableArray *array = [NSMutableArray new];
    
    if (self.models.isSelectFirstSection) {
        //如果选择的是充电时长
        for (WFBillingTimeMethodModel *tModel in self.models.billingTimeMethods) {
            if (tModel.isSelect) {
                [array addObject:tModel.billingPlanId];
            }
        }
    }else if (self.models.isSelectSecondSection) {
        //如果选择的是充电价格
        for (WFBillingPriceMethodModel *pModel in self.models.billingPriceMethods) {
            if (pModel.isSelect) {
                [array addObject:pModel.billingPlanId];
            }
        }
    }
    return array;
}

/**
 添加自定义的金额数据

 @return WFBillingPriceMethodModel
 */
- (WFBillingPriceMethodModel *)customPriceModel {
    WFBillingPriceMethodModel *newModel = [[WFBillingPriceMethodModel alloc] init];
    newModel.billingPlanId = @"";
    newModel.billingPlay = 2;
    newModel.billingName = @"其他";
    newModel.billingValue = @(0);
    newModel.billingUnit = @"分";
    newModel.elec = 0.0;
    newModel.isSelect = NO;
    return newModel;
}

#pragma mark 获取充电时间 充电金额 高度
/**
 获取充电时间高度

 @return getTimeHeight
 */
- (CGFloat)getTimeHeight {
    //充电时长
    NSInteger index = self.models.billingTimeMethods.count % 4;
    //整除的时候的高度
    NSInteger wholeHeight = self.models.billingTimeMethods.count / 4 * KHeight(43.0f);
    //不能整除的时候的高度
    NSInteger maxHeight = (self.models.billingTimeMethods.count / 4 + 1) * KHeight(43.0f);
    return index == 0 ? wholeHeight : maxHeight;
}

/**
 获取充电金额

 @return getPriceHeight
 */
- (CGFloat)getPriceHeight {
    //充电金额
    NSInteger index = self.models.billingPriceMethods.count % 4;
    //整除的时候的高度
    NSInteger wholeHeight = self.models.billingPriceMethods.count / 4 * KHeight(43.0f);
    //不能整除的时候的高度
    NSInteger maxHeight = (self.models.billingPriceMethods.count / 4 + 1) * KHeight(43.0f);
    return index == 0 ? wholeHeight : maxHeight;
}

/**
 处理打开或者隐藏的逻辑的方法

 @param section 区
 @param index 10 选中 未选中 20 打开关闭
 */
- (void)handleOpenOrChoseSectionViewWithSection:(NSInteger)section
                                          index:(NSInteger)index  {
    if (index == 10 && section == 0) {
        //选中时间
        for (WFBillingPriceMethodModel *tModel in self.models.billingPriceMethods) {
            tModel.isSelect = NO;
        }
        self.models.isSelectFirstSection = YES;
        self.models.isSelectSecondSection = NO;
        self.models.secondSelectNum = 0;
        
    }else if (index == 10 && section == 1) {
        //选中价格
        for (WFBillingTimeMethodModel *tModel in self.models.billingTimeMethods) {
            tModel.isSelect = NO;
        }
        self.models.isSelectFirstSection = NO;
        self.models.isSelectSecondSection = YES;
        self.models.firstSelectNum = 0;
    }else if (index == 20 && section == 0) {
        //打开或者关闭
        self.models.isOpenFirstSection = !self.models.isOpenFirstSection;
    }else if (index == 20 && section == 1) {
        //打开或者关闭
        self.models.isOpenSecondSection = !self.models.isOpenSecondSection;
    }
    
    [self.tableView reloadData];
}

#pragma mark 监听通知方法
//实现监听充电时间方法
- (void)monitorTimeDataChange:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSInteger dataNum = [[dict objectForKey:@"dataNum"] integerValue];
    self.models.isSelectFirstSection = dataNum != 0;
    self.models.firstSelectNum = dataNum;
    self.models.isChange = YES;
    
    //将充电时长的数据都置为未选中
    for (WFBillingPriceMethodModel *tModel in self.models.billingPriceMethods) {
        tModel.isSelect = NO;
        self.models.secondSelectNum = 0;
        self.models.isSelectSecondSection = NO;
    }
    [self.tableView reloadData];
}

//实现监听金额方法
- (void)monitorMoneyDataChange:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSInteger dataNum = [[dict objectForKey:@"dataNum"] integerValue];
    self.models.isSelectSecondSection = dataNum != 0;
    self.models.secondSelectNum = dataNum;
    self.models.isChange = YES;
    
    //将充电时长的数据都置为未选中
    for (WFBillingTimeMethodModel *tModel in self.models.billingTimeMethods) {
        tModel.isSelect = NO;
        self.models.firstSelectNum = 0;
        self.models.isSelectFirstSection = NO;
    }
    [self.tableView reloadData];
}

//实现监听输入的金额方法
- (void)addCustom:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    //输入的金额
    NSString *price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"inputKeys"]];
    
    //校验输入的和后台返回的有没有重复的
    for (WFBillingPriceMethodModel *itemModel in self.models.billingPriceMethods) {
        if (price.floatValue *100 == itemModel.billingValue.floatValue) {
            itemModel.isSelect = YES;
            //处理选择状态
            [self handleSelectPriceMethod];
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(price.floatValue*100) forKey:@"price"];
    @weakify(self)
    [WFApplyAreaDataTool addBillingMethodWithParams:params resultBlock:^(WFBillingPriceMethodModel * _Nonnull models) {
        @strongify(self)
        
        if (self.billPriceMethodArray.count >= 1) {
            models.isSelect = YES;
            [self.billPriceMethodArray insertObject:models atIndex:self.models.billingPriceMethods.count-1];
        }
        self.models.billingPriceMethods = self.billPriceMethodArray;
        //重新获取充电金额高度
        self.billMethodPriceHeight = [self getPriceHeight];
        //处理选择状态
        [self handleSelectPriceMethod];
    }];
}

/**
 处理选择选择价格方法
 */
- (void)handleSelectPriceMethod {
    //表示当前数据经过修改
    self.models.isChange = YES;
    //将时间设置未选中
    for (WFBillingTimeMethodModel *tModel in self.models.billingTimeMethods) {
        tModel.isSelect = NO;
        self.models.firstSelectNum = 0;
        self.models.isSelectFirstSection = NO;
    }
    //计算几条选中数据
    NSInteger totalCount = 0;
    for (WFBillingPriceMethodModel *newModel in self.models.billingPriceMethods) {
        if (newModel.isSelect) {
            totalCount += 1;
        }
    }
    //选中价格
    self.models.isSelectSecondSection = YES;
    self.models.secondSelectNum = totalCount;
    [self.tableView reloadData];
}

#pragma mark 确定数据
- (void)clickConfirmBtn {
    
    //如果没有选中数据需要提示
    if ([self getSelectMethodCount] == 0) {
        [YFToast showMessage:@"请选择具体的计费模式" inView:self.view];
        return;
    }
    
    if (self.groupId.length == 0) {
        //默认收费方式
        !self.billMethodDataBlock ? : self.billMethodDataBlock(self.models);
        [self goBack];
    }else if (self.groupId.length != 0){
        if (self.models.isChange) {
            //修改收费方式
            [self updateBilleMehtod];
        }else {
            [self goBack];
        }
    }
}

- (NSInteger)getSelectMethodCount {
    NSInteger totalData = 0;
    if (self.models.isSelectFirstSection) {
        for (WFBillingTimeMethodModel *model in self.models.billingTimeMethods) {
            if (model.isSelect) {
                totalData += 1;
            }
        }
    }else if (self.models.isSelectSecondSection) {
        for (WFBillingPriceMethodModel *model in self.models.billingPriceMethods) {
            if (model.isSelect) {
                totalData += 1;
            }
        }
    }
    return totalData;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.models.isOpenFirstSection : self.models.isOpenSecondSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WFBilleMethodTimeTableViewCell *cell = [WFBilleMethodTimeTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.models.billingTimeMethods cellHeight:self.billMethodTimeHeight];
        return cell;
    }else {
        WFBilleMethodMoneyTableViewCell *cell = [WFBilleMethodMoneyTableViewCell cellWithTableView:tableView];
        [cell bindToCell:self.models.billingPriceMethods cellHeight:self.billMethodPriceHeight];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __weak WFBilleMethodSectionView *sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodSectionView" owner:nil options:nil] firstObject];
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    if (section == 0) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.models.isOpenFirstSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.models.isSelectFirstSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        
        NSString *btnTitle = [NSString stringWithFormat:@"选择充电时长(%ld/6)",self.models.firstSelectNum];
        sectionView.title.text = btnTitle;
        //设置圆角
        WFRadiusRectCorner radiusRect = self.models.isOpenFirstSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
        [sectionView.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    }else if (section == 1) {
        //得到图片的路径
        NSString *showImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.models.isOpenSecondSection ? @"showTop" : @"showBottom" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.showImgBtn setImage:[UIImage imageWithContentsOfFile:showImgPath] forState:0];
        //得到图片的路径
        NSString *timeImgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:self.models.isSelectSecondSection ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
        [sectionView.timeBtn setImage:[UIImage imageWithContentsOfFile:timeImgPath] forState:0];
        
        NSString *btnTitle = [NSString stringWithFormat:@"选择充电金额(%ld/6)",self.models.secondSelectNum];
        sectionView.title.text = btnTitle;
        //设置圆角
        WFRadiusRectCorner radiusRect = self.models.isOpenSecondSection ? (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight) : WFRadiusRectCornerAllCorners;
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
    return KHeight(10.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(50.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? self.billMethodTimeHeight : self.billMethodPriceHeight;
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth(12.0f), 0, ScreenWidth-KWidth(24.0f), ScreenHeight - NavHeight - self.confirmBtn.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.showsVerticalScrollIndicator = NO;
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
        title.text = @"*选择计费方式为单选";
        title.font = [UIFont systemFontOfSize:14.0f];
        title.textColor = UIColorFromRGB(0x999999);
        [_headView addSubview:title];
    }
    return _headView;
}


/**
 充电金额数据

 @return billPriceMethodArray
 */
- (NSMutableArray<WFBillingPriceMethodModel *> *)billPriceMethodArray {
    if (!_billPriceMethodArray) {
        _billPriceMethodArray = [[NSMutableArray alloc] init];
    }
    return _billPriceMethodArray;
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
- (WFBilleMethodViewController * _Nonnull (^)(WFBillMethodModel * _Nonnull))billMethodModels {
    return ^(WFBillMethodModel *models) {
        self.models = models;
        return self;
    };
}

- (WFBilleMethodViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId) {
        self.groupId = groupId;
        return self;
    };
}


@end
