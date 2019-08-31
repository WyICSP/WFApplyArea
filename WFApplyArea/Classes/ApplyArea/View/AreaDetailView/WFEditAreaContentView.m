//
//  WFEditAreaContentView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/17.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFEditAreaContentView.h"
#import "WFSingleFeeViewController.h"
#import "WFManyTimeFeeViewController.h"
#import "WFDiscountItemTableViewCell.h"
#import "WFDiscountFeeViewController.h"
#import "WFApplyAreaDataTool.h"
#import "WFAreaDetailModel.h"

#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "YFKeyWindow.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFEditAreaContentView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation WFEditAreaContentView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.singleView.layer.cornerRadius = self.manyTimeView.layer.cornerRadius = self.vipView.layer.cornerRadius = 10.0f;
    SKViewsBorder(self.singleContentView, 0, 0.5, UIColorFromRGB(0xE4E4E4));
    SKViewsBorder(self.manyContentView, 0, 0.5, UIColorFromRGB(0xE4E4E4));
    SKViewsBorder(self.vipContentView, 0, 0.5, UIColorFromRGB(0xE4E4E4));
    
}

- (void)setMainModel:(WFAreaDetailModel *)mainModel {
    _mainModel = mainModel;
    
    //单次收费
    if (self.mainModel.singleCharge.chargeModelId.length != 0) {
        self.singleHeight.constant = 140.0f;
        self.singleTitle.text = self.mainModel.singleCharge.chargeType == 0 ? @"统一收费" : @"功率收费";
        if (self.mainModel.singleCharge.chargeType == 0) {
            self.sUnliPrice.text = [NSString stringWithFormat:@"%@",@(self.mainModel.singleCharge.unifiedPrice.floatValue/100)];
            self.sSalesPrice.text = [NSString stringWithFormat:@"%ld",self.mainModel.singleCharge.unifiedTime];
        }else if (self.mainModel.singleCharge.chargeType == 1) {
            self.sUnliPrice.text = [NSString stringWithFormat:@"%@",@(self.mainModel.singleCharge.unitPrice.floatValue/100)];
            self.sSalesPrice.text = [NSString stringWithFormat:@"%@",@(self.mainModel.singleCharge.salesPrice.floatValue/100)];
        }
    }else {
        [self.singleView removeAllSubview];
        self.singleHeight.constant = 0.0f;
    }
    
    //多次收费
    if (self.mainModel.multipleChargesList.count != 0) {
        self.manyHeight.constant = 70.0f + 37.0f*(self.mainModel.multipleChargesList.count+1);
        [self.tableView reloadData];
    }else {
        [self.manyBaseView removeAllSubview];
        self.manyHeight.constant = 0.0f;
    }
    
    //优惠收费
    if (self.mainModel.vipCharge.chargeModelId.length != 0) {
        self.vipHeight.constant = 150.0f;
        self.vUnliPrice.text = [NSString stringWithFormat:@"%@",@(self.mainModel.vipCharge.unifiedPrice.floatValue/100)];
        self.vSalesPrice.text = [NSString stringWithFormat:@"%ld",self.mainModel.vipCharge.unifiedTime];
    }else {
        [self.vipBaseView removeAllSubview];
        self.vipHeight.constant = 0.0f;
    }
}

#pragma mark 删除多次收费 和优惠收费

/**
 删除多次收费
 */
- (void)deleteManyTimesFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModel.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool deleteManyTimeFeeWithParams:params resultBlock:^{
        @strongify(self)
        [self deleteSuccess];
    }];
}


/**
 删除优惠收费
 */
- (void)deleteVipChargeFee {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.mainModel.vipCharge.vipChargeId forKey:@"vipChargeId"];
    @weakify(self)
    [WFApplyAreaDataTool deleteVipChargeFeeWithParams:params resultBlock:^{
        @strongify(self)
        [self deleteSuccess];
    }];
}

- (void)deleteSuccess {
    [YFToast showMessage:@"删除成功" inView:self.superVC.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YFNotificationCenter postNotificationName:@"reloadDataKeys" object:nil];
        [self.superVC.navigationController popToViewController:[self.superVC.navigationController.viewControllers objectAtIndex:2] animated:YES];
    });
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainModel.multipleChargesList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFDiscountItemTableViewCell *cell = [WFDiscountItemTableViewCell cellWithTableView:tableView];
    cell.model = self.mainModel.multipleChargesList[indexPath.row];
    return cell;
}

#pragma mark get set
/**
 tableView
 
 @return  总共把 contentsView 分为了 7份,按照 1.5:1:1 的比例分配就是 3:2:2
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-44-(ScreenWidth-44)/7*1.5, 37*self.mainModel.multipleChargesList.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 37.0f;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        [self.manyDataView addSubview:_tableView];
    }
    return _tableView;
}

/**
 编辑按钮
 10 单次 20 多次 30 优惠
 */
- (IBAction)clickEditBtn:(UIButton *)sender {
    if (sender.tag == 10) {
        //单次收费
        WFSingleFeeViewController *single = [[WFSingleFeeViewController alloc] init];
        single.dChargingModePlay(@"1").dChargingModelId(self.mainModel.singleCharge.chargeModelId).
        sType(WFUpdateSingleFeeUpdateType).editModels(self.mainModel.singleCharge).groupIds(self.mainModel.groupId);
        !self.jumpCtrlBlock ? : self.jumpCtrlBlock(single);
    }else if (sender.tag == 20) {
        //多次收费
        WFAreaDetailMultipleModel *mModel = [self.mainModel.multipleChargesList firstObject];
        WFManyTimeFeeViewController *many = [[WFManyTimeFeeViewController alloc] init];
        many.dChargingModePlay(@"2").dChargingModelId(mModel.chargeModelId).
        itemArrays(self.mainModel.multipleChargesList).chargeTypes(mModel.chargeType).groupIds(self.mainModel.groupId);
        !self.jumpCtrlBlock ? : self.jumpCtrlBlock(many);
    }else if (sender.tag == 30) {
        //优惠收费
        WFDiscountFeeViewController *vip = [[WFDiscountFeeViewController alloc] init];
        vip.eType(WFUpdateUserMsgUpdateType).dChargingModePlay(@"3").cModelId(self.mainModel.vipCharge.chargeModelId).
        aGroupId(self.mainModel.groupId).editModels(self.mainModel.vipCharge);
        !self.jumpCtrlBlock ? : self.jumpCtrlBlock(vip);
    }
}

/**
 删除按钮
 40 多次
 50 优惠
 */
- (IBAction)clickDeleteBtn:(UIButton *)sender {
    if (sender.tag == 40) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要删除多次收费吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteManyTimesFee];
        }]];

        [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
        
    }else if (sender.tag == 50) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要删除优惠收费吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteVipChargeFee];
        }]];
        
        [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
        
    }
}




@end
