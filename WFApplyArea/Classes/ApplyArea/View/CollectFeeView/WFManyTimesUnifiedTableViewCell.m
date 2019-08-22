//
//  WFManyTimesUnifiedTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFManyTimesUnifiedTableViewCell.h"
#import "UITextField+RYNumberKeyboard.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFManyTimesUnifiedTableViewCell

static NSString *const cellId = @"WFManyTimesUnifiedTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFManyTimesUnifiedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFManyTimesUnifiedTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.moneyView.layer.cornerRadius = 14.5f;
    self.countView.layer.cornerRadius = 14.5f;
    self.formBtn.layer.cornerRadius = 14.5f;
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


- (IBAction)clickLookFormBtn:(id)sender {
    !self.clickLookFormBlock ? : self.clickLookFormBlock();
}

/**
 绑定统一收费
 */
- (void)bindToCellWithUnifiedModel:(WFDefaultUnifiedListModel *)unModel
                           section:(NSInteger)section {
    _unModel = unModel;
    _section = section;
    self.moneyTF.text = [NSString stringWithFormat:@"%@",@(unModel.proposalPrice.floatValue/100)];
    self.countTF.text = [NSString stringWithFormat:@"%ld",unModel.proposalTimes];
    self.title.text = unModel.optionName;
    self.selectBtn.selected = unModel.isSelect;
}

/**
 绑定功率收费
 */
- (void)bindToCellWithPowerModel:(WFDefaultPowerListModel *)powModel
                         section:(NSInteger)section {
    _powModel = powModel;
    _section = section;
    self.moneyTF.text = [NSString stringWithFormat:@"%@",@(powModel.proposalPrice.floatValue/100)];
    self.countTF.text = [NSString stringWithFormat:@"%ld",powModel.proposalTimes];
    self.title.text = powModel.optionName;
    self.selectBtn.selected = powModel.isSelect;
}

/**
 监听输入框变化
 */
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (self.section == 0) {
        if (textField == self.moneyTF) {
            if (textField.text.doubleValue > 99999)
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
            
            self.unModel.proposalPrice = @(textField.text.floatValue*100);
        }else if (textField == self.countTF) {
            self.unModel.proposalTimes = textField.text.integerValue;
        }
    }else if (self.section == 1) {
        if (textField == self.moneyTF) {
            if (textField.text.doubleValue > 99999)
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
            
            self.powModel.proposalPrice = @(textField.text.floatValue*100);
        }else if (textField == self.countTF) {
            self.powModel.proposalTimes = textField.text.integerValue;
        }
    }
}

- (void)dealloc {
    [self.moneyTF removeObserver:self forKeyPath:@"text"];
}


@end
