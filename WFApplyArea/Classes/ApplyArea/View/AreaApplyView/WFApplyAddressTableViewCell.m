//
//  WFApplyAddressTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAddressTableViewCell.h"
#import "YFMediatorManager+WFUser.h"
#import "WFPowerIntervalModel.h"
#import "WFHomeSaveDataTool.h"
#import "YFAddressPickView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFApplyAddressTableViewCell

static NSString *const cellId = @"WFApplyAddressTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFApplyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFApplyAddressTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.addressLbl.adjustsFontSizeToFitWidth = YES;
    self.addressLbl.minimumScaleFactor = 0.5;
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, ISIPHONEX ? KHeight(80.0f) + 8.0f : KHeight(80.0f))];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickbtn:(id)sender {
    [self endEditing:YES];
//    YFAddressPickView *addressPickView = [YFAddressPickView shareInstance];
//    addressPickView.addressDatas = [[WFHomeSaveDataTool shareInstance] readAddressFile];
//    WS(weakSelf)
//    addressPickView.startPlaceBlock = ^(NSString *address, NSString *addressId) {
//        DLog(@"地址=%@-addressId=%@",address,addressId);
//        [weakSelf.addressBtn setTitle:address forState:UIControlStateNormal];
//        [weakSelf.addressBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
//        weakSelf.model.address = address;
//        weakSelf.model.addressId = addressId;
//    };
//    [YFWindow addSubview:addressPickView];
    
    /// 选择地图
    [YFMediatorManager openChooseMap];
    
}

- (void)setModel:(WFApplyAreaAddressModel *)model {
    _model = model;
    if (model.address.length != 0) {
        self.addressLbl.text = model.address;
        self.addressLbl.textColor = UIColorFromRGB(0x333333);
    }
    
    if (model.areaName.length != 0) {
        self.areaTF.text = model.areaName;
    }
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
     if (textField == self.areaTF) {
        if (textField == self.areaTF && textField.text.length > 30)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 30)];
        
         self.model.areaName = textField.text;
    }
}

@end
