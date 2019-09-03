//
//  WFEditVipUserViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFEditVipUserViewController.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFAddVipCountPickView.h"
#import "NSString+Regular.h"
#import "WFApplyAreaDataTool.h"
#import "WFDatePickView.h"
#import "SKSafeObject.h"
#import "WKHelp.h"
#import "YFToast.h"

@interface WFEditVipUserViewController ()
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**姓名*/
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/**次数*/
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/**事件*/
@property (weak, nonatomic) IBOutlet UITextField *timetTF;
/**按钮*/
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
/**按钮高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCons;

@end

@implementation WFEditVipUserViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.contentsView.layer.cornerRadius = 10.0f;
    self.addBtn.layer.cornerRadius = self.btnCons.constant/2;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    if (self.itemModel) {
        [self assignment];
        self.title = @"编辑VIP信息";
    }else {
        self.title = @"添加VIP手机号";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        //今年年份
        NSString *nowYear = [[strDate componentsSeparatedByString:@"-"] firstObject];
        //五年以后
        NSString *fiveYear = [NSString stringWithFormat:@"%d",nowYear.intValue + 5];
        //替换
        NSString *getYear = [strDate stringByReplacingOccurrencesOfString:nowYear withString:fiveYear];
        self.timetTF.text = getYear;
    }
}

/**
 h赋值
 */
- (void)assignment {
    self.nameTF.text = self.itemModel.name;
    self.phoneTF.text = self.itemModel.phone;
    self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.itemModel.giveCount];
    self.timetTF.text = self.itemModel.expireTime;
    self.phoneTF.enabled = NO;
    [self.addBtn setTitle:@"确认修改" forState:0];
    
}

/**
 添加用户
 */
- (void)addUser {
    [self.view endEditing:YES];

    NSString *alertMsg = @"";
    if (self.nameTF.text.length == 0) {
        alertMsg = @"姓名不能为空";
    }else if (self.phoneTF.text.length == 0) {
        alertMsg = @"手机号不能为空";
    }else if (![NSString validateMobile:self.phoneTF.text]) {
        alertMsg = @"请输入正确的手机号";
    }else if (self.timetTF.text.length == 0) {
        alertMsg = @"请选择到期时间";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.timetTF.text forKey:@"expireTime"];
    [params safeSetObject:self.countTF.text forKey:@"giveCount"];
    [params safeSetObject:self.phoneTF.text forKey:@"phone"];
    [params safeSetObject:self.nameTF.text forKey:@"vipName"];
    [params safeSetObject:self.applyGroupId forKey:@"groupId"];
    [params safeSetObject:self.chargingModelId forKey:@"chargingModelId"];
    @weakify(self)
    [WFApplyAreaDataTool addDiscountUserWithParams:params resultBlock:^{
        @strongify(self)
        [YFToast showMessage:@"添加成功" inView:self.view];
        [self handleAddSuccess];
    }];
}

/**
 添加成功
 */
- (void)handleAddSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [YFNotificationCenter postNotificationName:@"refreshVipKeys" object:nil];
    });
}

/**
 修改 vip 信息
 */
- (void)updateVipMsg {
    
    NSString *alertMsg = @"";
    if (self.nameTF.text.length == 0) {
        alertMsg = @"请输入姓名";
    }else if (self.timetTF.text.length == 0) {
        alertMsg = @"请选择到期时间";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.timetTF.text forKey:@"expireTime"];
    [params safeSetObject:self.countTF.text forKey:@"giveCount"];
    [params safeSetObject:self.itemModel.vipId forKey:@"vipId"];
    [params safeSetObject:self.nameTF.text forKey:@"vipName"];
    @weakify(self)
    [WFApplyAreaDataTool updateDiscountUserWithParams:params resultBlock:^{
        @strongify(self)
        [YFToast showMessage:@"修改成功" inView:self.view];
        [self handleAddSuccess];
    }];
}

/**
 时间
 */
- (void)loadingTime {
    [self.view endEditing:YES];
    
    WFDatePickView *datePickView = [[WFDatePickView alloc] init];
    WS(weakSelf)
    datePickView.chooseDateMsgString = ^(NSString * _Nonnull date) {
        weakSelf.timetTF.text = date;
    };
    [YFWindow addSubview:datePickView];
}

/**
 次数
 */
- (void)loadingCount {
    WFAddVipCountPickView *countPickView = [[WFAddVipCountPickView alloc] init];
    WS(weakSelf)
    countPickView.chooseCountMsgBlock = ^(NSString * _Nonnull count) {
        weakSelf.countTF.text = count;
    };
    [YFWindow addSubview:countPickView];
}

- (IBAction)clickAddBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (sender.tag == 10) {
        //次数
        [self loadingCount];
    }else if (sender.tag == 20) {
        //选择时间
        [self loadingTime];
    }else if (sender.tag == 30) {
        //确定
        if (self.itemModel) {
            //编辑
            [self updateVipMsg];
        }else {
            //添加
            [self addUser];
        }
    }
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.nameTF) {
        if (textField.text.length > 10)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 10)];
    }else if (textField == self.phoneTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        }
    }
}

#pragma mark 链式编程
- (WFEditVipUserViewController * _Nonnull (^)(WFEditAddUserType))eType {
    return ^(WFEditAddUserType eType) {
        self.type = eType;
        return self;
    };
}

- (WFEditVipUserViewController * _Nonnull (^)(NSString * _Nonnull))aGroupId {
    return ^(NSString *aGroupId){
        self.applyGroupId = aGroupId;
        return self;
    };
}

- (WFEditVipUserViewController * _Nonnull (^)(NSString * _Nonnull))cModelId {
    return ^(NSString *cModelId){
        self.chargingModelId = cModelId;
        return self;
    };
}

- (WFEditVipUserViewController * _Nonnull (^)(WFGroupVipUserModel * _Nonnull))imodel {
    return ^(WFGroupVipUserModel *itemModel) {
        self.itemModel = itemModel;
        return self;
    };
}


@end
