//
//  WFAreaOtherSetViewController.m
//  AFNetworking
//
//  Created by 王宇 on 2019/12/24.
//

#import "WFAreaOtherSetViewController.h"
#import "WFAreaDetailViewController.h"
#import "WFApplyAreaOtherConfigModel.h"
#import "WFAreaDetailModel.h"
#import "WFApplyAreaDataTool.h"
#import "WFUpgradeAreaData.h"
#import "WKConfig.h"

@interface WFAreaOtherSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentViews;
/// 充电时长
@property (weak, nonatomic) IBOutlet UITextField *maxTimeTF;
/// 起步价
@property (weak, nonatomic) IBOutlet UITextField *startPriceTF;
/// 确认按钮
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
/// 提示语
@property (weak, nonatomic) IBOutlet UILabel *markLbl;
/// 起步价提示
@property (weak, nonatomic) IBOutlet UILabel *markPriceLbl;

/// 其他设置配置
@property (nonatomic, strong, nullable) WFApplyAreaOtherConfigModel *otherConfigModel;

@end

@implementation WFAreaOtherSetViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"充满自停设置";
    self.contentViews.layer.cornerRadius = 10.0f;
    self.startPriceTF.delegate = self;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.comfireBtn setTitle:[self btnTitle] forState:0];
    
    //获取默认配置信息
    [self getOtherDefaultConfig];
}

/// 获取其他默认配置
- (void)getOtherDefaultConfig {
    @weakify(self)
    [WFApplyAreaDataTool getOtherDefaultConfigWithParams:@{} resultBlock:^(WFApplyAreaOtherConfigModel * _Nonnull models) {
        @strongify(self)
        [self requestSuccessWithModel:models];
    }];
}

/// 获取数据成功
- (void)requestSuccessWithModel:(WFApplyAreaOtherConfigModel * _Nonnull)models {
    self.otherConfigModel = models;
    
    if (self.type == WFOtherSetUpdateAreaType) {
        //修改的时候赋值改变
        self.otherConfigModel.maxChargingTime.defaultValue = self.models.maxChargingTime;
        self.otherConfigModel.startPrice.defaultValue = [NSString stringWithFormat:@"%@",self.models.startPrice];
    }
    
    self.maxTimeTF.text = self.otherConfigModel.maxChargingTime.defaultValue;
    self.maxTimeTF.placeholder = self.otherConfigModel.maxChargingTime.tips;
    
    self.startPriceTF.text = self.otherConfigModel.startPrice.defaultValue;
    self.startPriceTF.placeholder = self.otherConfigModel.startPrice.tips;
    
}

/// 判断其他设置是否填写正确
- (BOOL)isOtherConfigComplete {
    BOOL isComplete = YES;
    if (self.maxTimeTF.text.length == 0 || self.maxTimeTF.text.doubleValue < self.otherConfigModel.maxChargingTime.minValue || self.maxTimeTF.text.doubleValue > self.otherConfigModel.maxChargingTime.maxValue) {
        isComplete = NO;
    }else if (self.startPriceTF.text.length == 0 || self.startPriceTF.text.doubleValue < self.otherConfigModel.startPrice.minValue || self.startPriceTF.text.doubleValue > self.otherConfigModel.startPrice.maxValue) {
        isComplete = NO;
    }
    return isComplete;
}

#pragma mark 升级和修改片区
- (void)updateOtherSet {
    
    if (![self isOtherConfigComplete]) {
        [YFToast showMessage:@"请正确填写充满自停设置" inView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.maxTimeTF.text forKey:@"maxChargingTime"];
    [params safeSetObject:self.startPriceTF.text forKey:@"startPrice"];
    [params safeSetObject:self.models.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool updateOtherSetWithParams:params resultBlock:^{
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
 老片区升级成为新片区
 */
- (void)upgradeOldAreaToNewArea {
    
    if (![self isOtherConfigComplete]) {
        [YFToast showMessage:@"请正确填写充满自停设置" inView:self.view];
        return;
    }
    //片区详细地址
    NSString *address = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"address"]];
    //片区省市区 Id
    NSString *areaId = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"areaId"]];
    //片区名
    NSString *name = [NSString stringWithFormat:@"%@",[[WFUpgradeAreaData shareInstance].addressMsg safeJsonObjForKey:@"name"]];
    //重组数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:address forKey:@"address"];//地址
    [params safeSetObject:areaId forKey:@"areaId"];//地址
    [params safeSetObject:name forKey:@"name"];//片区名
    [params safeSetObject:self.groupId forKey:@"groupId"];//片区 Id
    if ([WFUpgradeAreaData shareInstance].multipleChargesList.count != 0) {
        //多次收费
        [params safeSetObject:[WFUpgradeAreaData shareInstance].multipleChargesList forKey:@"multipleChargesList"];
    }
    if ([WFUpgradeAreaData shareInstance].discountFee.count != 0) {
        //vip 设置
        [params safeSetObject:[WFUpgradeAreaData shareInstance].discountFee forKey:@"vipCharge"];
    }
    [params safeSetObject:[WFUpgradeAreaData shareInstance].billingPlanIds forKey:@"billingPlanIds"];//收费方式
    [params safeSetObject:[WFUpgradeAreaData shareInstance].partnerPropInfos forKey:@"partnerPropInfos"];//分成设置
    [params safeSetObject:[WFUpgradeAreaData shareInstance].singleCharge forKey:@"singleCharge"];//单次收费
    //起步价
    [params safeSetObject:self.startPriceTF.text forKey:@"startPrice"];
    //续充时间
//    [params safeSetObject:self.conTimeTF.text forKey:@"continueChargingTime"];
    //最大时长
    [params safeSetObject:self.maxTimeTF.text forKey:@"maxChargingTime"];
    @weakify(self)
    [WFApplyAreaDataTool upgradeOldAreaToNewAreaWithParams:params resultBlock:^{
        @strongify(self)
        [self oldAreaUpgradeSuccess];
    }];
}

- (void)oldAreaUpgradeSuccess {
    [YFToast showMessage:@"升级成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WFAreaDetailViewController *detail = [[WFAreaDetailViewController alloc] init];
        detail.groupId = self.groupId;
        detail.jumpType = WFAreaDetailJumpAreaType;
        detail.isUpgradeType = YES;
        [self.navigationController pushViewController:detail animated:YES];
    });
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //起步价
    if (textField == self.startPriceTF) {
        if (textField.text.doubleValue == 0) {
            self.startPriceTF.text = @"0";
        }
    }
}

#pragma mark 监听输入框
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (self.maxTimeTF == textField) {
        //最大时长
        if (textField.text.intValue > 12) {
            textField.text = @"12";
        }else if (textField.text.intValue < 1) {
            textField.text = @"";
        }
        //提示语的显示与隐藏
        self.markLbl.hidden = textField.text.intValue < 6 ? NO : YES;
    }else if (self.startPriceTF == textField) {
        //最低消费
        if (textField.text.doubleValue > 1) {
            textField.text = @"1";
        }
        //提示语的显示与隐藏
        self.markPriceLbl.hidden = (textField.text.doubleValue > 1 || textField.text.doubleValue < 0) ? NO : YES;
    }
}

/// 升级片区
- (IBAction)clickSubmitBtn:(id)sender {
    if (self.type == WFOtherSetUpdateAreaType) {
        //修改分成设置
        [self updateOtherSet];
    }else {
        //升级片区
        [self upgradeOldAreaToNewArea];
    }
    
}

#pragma mark set
/**
 按钮 title
 
 @return 按钮 title
 */
- (NSString *)btnTitle {
    NSString *title = @"";
    if (self.type == WFOtherSetUpdateAreaType) {
        title = @"确认修改";
    }else {
        title = @"7/7";
    }
    return title;
}

#pragma mark 链式编程
- (WFAreaOtherSetViewController * _Nonnull (^)(NSString * _Nonnull))groupIds {
    return ^(NSString *groupId) {
        self.groupId = groupId;
        return self;
    };
}

- (WFAreaOtherSetViewController * _Nonnull (^)(WFOtherSetSourceType))sourceType {
    return ^(WFOtherSetSourceType type) {
        self.type = type;
        return self;
    };
}

- (WFAreaOtherSetViewController * _Nonnull (^)(WFAreaDetailModel *_Nonnull))dataModels {
    return ^(WFAreaDetailModel *models) {
        self.models = models;
        return self;
    };
}



@end
