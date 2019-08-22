//
//  WFSingleFeeTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFSingleFeeTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"
#import "UITextField+RYNumberKeyboard.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFSingleFeeTableViewCell

static NSString *const cellId = @"WFSingleFeeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFSingleFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFSingleFeeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.moneyView.layer.cornerRadius = 14.5f;
    self.countView.layer.cornerRadius = 14.5f;
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), 50.0f)];
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

- (void)setModel:(WFDefaultChargeFeeModel *)model {
    _model = model;
    self.moneyTF.text = [NSString stringWithFormat:@"%@",@(model.unifiedPrice.floatValue/100)];
    self.countTF.text = [NSString stringWithFormat:@"%ld",model.unifiedTime];
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.moneyTF) {
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        
        self.model.unifiedPrice = @(textField.text.floatValue *100);
    }else if (textField == self.countTF) {
        self.model.unifiedTime = textField.text.integerValue;
    }
    self.model.isChange = YES;
}

- (void)dealloc {
    [self.moneyTF removeObserver:self forKeyPath:@"text"];
}


@end
