//
//  WFDisUnifieldFeeTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDisUnifieldFeeTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"
#import "UITextField+RYNumberKeyboard.h"

@implementation WFDisUnifieldFeeTableViewCell

static NSString *const cellId = @"WFDisUnifieldFeeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFDisUnifieldFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDisUnifieldFeeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.moneyView.layer.cornerRadius = 14.5f;
    self.dateView.layer.cornerRadius = 14.5f;
    
    [self.moneyTF setMoneyKeyboard];
    //通过 KVC 监听 moneyTF 的 text
    [self.moneyTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}

/**
 监听数据
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        //监听输入框
        UITextField *textField = (UITextField *)object;
        [self textFieldDidChange:textField];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFDefaultDiscountModel *)model {
    _model = model;
    self.onlyPriceLbl.text = self.moneyTF.text = [NSString stringWithFormat:@"%@",@(model.unifiedPrice.floatValue/100)];
    self.onlyTimeLbl.text = self.dateTF.text = [NSString stringWithFormat:@"%ld",(long)model.unifiedTime];    
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.moneyTF) {
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        
        //发现包含小数点，并且小数点在倒数第三位就，如果再多就截掉。
        NSInteger loca = [textField.text rangeOfString:@"."].location;
        if (loca + 3 < textField.text.length && loca > 0) {
            textField.text = [textField.text substringToIndex:loca + 3];
        }
        
        self.model.unifiedPrice = @(textField.text.floatValue *100);
    }else if (textField == self.dateTF) {
        self.model.unifiedTime = textField.text.integerValue;
    }
    //设置这个 监听用户已经修改过了
    self.model.isChange = YES;
}

- (void)dealloc {
    [self.moneyTF removeObserver:self forKeyPath:@"text"];
}


@end
