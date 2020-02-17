//
//  WFCreditApplyNumTableViewCell.m
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//


#import "WFCreditApplyNumTableViewCell.h"
#import "WFCreditPayModel.h"
#import "AttributedLbl.h"
#import "WKConfig.h"

@implementation WFCreditApplyNumTableViewCell

static NSString *const cellId = @"WFCreditApplyNumTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFCreditApplyNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFCreditApplyNumTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.countTF.delegate = self;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.countView.layer.borderWidth = 0.5;
    self.countView.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFCreditPayModel *)model {
    _model = model;
    self.itemPrice.text = [NSString stringWithFormat:@"*每台设备保证金为%@元",@(self.model.devicePrice.doubleValue/100.0f)];
    self.num = self.model.deviceNum;
    self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.num];
    // 获取总价*每台设备保证金为100元
    [self getTotalPrice];
}

/// 10 减 20 加
- (IBAction)clickBtn:(UIButton *)sender {
    
    if (sender.tag == 10) {
        self.num -= 1;
        // num 不能为 0
        if (self.num <= 0)self.num = 0;
    }else if (sender.tag == 20) {
        self.num += 1;
    }
    self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.num];
    // 获取总价
    [self getTotalPrice];
    
}

/// 获取总价
- (void)getTotalPrice {
    double sum = self.model.devicePrice.doubleValue/100.0f *self.num;
    
    NSString *doubleString = [NSString stringWithFormat:@"%lf", sum];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    
    NSString *totalPrice = [NSString stringWithFormat:@"¥%@",[decNumber stringValue]];
    
    [AttributedLbl setRichTextOnlyFont:self.totalPrice titleString:totalPrice textFont:[UIFont systemFontOfSize:12] fontRang:NSMakeRange(0, 1)];
    
    // 总价
    self.model.money = self.model.devicePrice.integerValue * self.num;
    //数量
    self.model.deviceNum = self.num;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.integerValue <= 0) {
        [self getTotalPrice];
    }
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    self.num = sender.text.integerValue;
    [self getTotalPrice];
}

@end
