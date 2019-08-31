//
//  WFEditAreaAddressViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFEditAreaAddressViewController.h"
#import "WFApplyAreaDataTool.h"
#import "YFAddressPickView.h"
#import "WFAreaDetailModel.h"
#import "WFHomeSaveDataTool.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFEditAreaAddressViewController ()
/**地址*/
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
/**详细地址*/
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
/**片名*/
@property (weak, nonatomic) IBOutlet UITextField *areaNameTF;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**片区 Id*/
@property (nonatomic, copy) NSString *areaId;

@end

@implementation WFEditAreaAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)setUI {
    self.title = @"片区信息";
    self.contentsView.layer.cornerRadius = 10.0f;
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.addressBtn setTitle:self.models.areaName forState:0];
    self.detailAddressTF.text = self.models.address;
    self.areaNameTF.text = self.models.name;
}

/**
 选择地址
 */
- (IBAction)chooseAddressBtn:(id)sender {
    YFAddressPickView *addressPickView = [YFAddressPickView shareInstance];
    addressPickView.addressDatas = [[WFHomeSaveDataTool shareInstance] readAddressFile];
    WS(weakSelf)
    addressPickView.startPlaceBlock = ^(NSString *address, NSString *addressId) {
        DLog(@"地址=%@-addressId=%@",address,addressId);
        weakSelf.areaId = addressId;
        [weakSelf.addressBtn setTitle:address forState:UIControlStateNormal];
    };
    [YFWindow addSubview:addressPickView];
}

/**
 确定
 */
- (IBAction)clickSaveBtn:(id)sender {
    NSString *alertMsg = @"";
    if (self.detailAddressTF.text.length == 0) {
        alertMsg = @"详细地址，例：16号楼5层501室";
    }else if (self.areaNameTF.text.length == 0) {
        alertMsg = @"请输入市+区+小区名";
    }
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.detailAddressTF.text forKey:@"address"];
    [params safeSetObject:self.areaId forKey:@"areaId"];
    [params safeSetObject:self.models.groupId forKey:@"groupId"];
    [params safeSetObject:self.areaNameTF.text forKey:@"name"];
    @weakify(self)
    [WFApplyAreaDataTool updateAreaAddressWithParams:params resultBlock:^{
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

@end
