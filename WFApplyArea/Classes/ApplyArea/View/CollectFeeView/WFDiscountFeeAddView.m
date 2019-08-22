//
//  WFDiscountFeeAddView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDiscountFeeAddView.h"
#import "WKHelp.h"

@interface WFDiscountFeeAddView()<UITextFieldDelegate>

@end

@implementation WFDiscountFeeAddView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dateTF.delegate = self;
    self.countTF.delegate = self;
    self.phoneTF.delegate = self;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.phoneView.layer.cornerRadius = self.dateView.layer.cornerRadius = self.countView.layer.cornerRadius = 16.0f;
    self.cancelBtn.layer.cornerRadius = self.comfireBtn.layer.cornerRadius = 15.0f;
    self.cancelBtn.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.cancelBtn.layer.borderWidth = 0.7;
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.addOrCancelBlock ? : self.addOrCancelBlock(sender.tag);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.centercX.constant = -80.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.centercX.constant = 0.0f;
}


@end
