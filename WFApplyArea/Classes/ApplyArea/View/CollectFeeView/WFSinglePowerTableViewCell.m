//
//  WFSinglePowerTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFSinglePowerTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"
#import "UITextField+RYNumberKeyboard.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFSinglePowerTableViewCell

static NSString *const cellId = @"WFSinglePowerTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFSinglePowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFSinglePowerTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.lookBtn.layer.cornerRadius = self.lookBtn.frame.size.height/2;
    self.lookBtn.layer.borderWidth = 0.5;
    self.lookBtn.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(135.0f))];
    [self.costPriceLbl setMoneyKeyboard];
    [self.salePriceLbl setMoneyKeyboard];
    //通过 KVC 监听 moneyTF 的 text
    [self.costPriceLbl addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    //通过 KVC 监听 moneyTF 的 text
    [self.salePriceLbl addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)setModel:(WFDefaultChargeFeeModel *)model {
    _model = model;
    self.costPriceLbl.text = [NSString stringWithFormat:@"%@",@(model.unitPrice.floatValue/100)];
    self.salePriceLbl.text = [NSString stringWithFormat:@"%@",@(model.salesPrice.floatValue/100)];
}

- (IBAction)clickLookForm:(id)sender {
    !self.clickLookBtnBlock ? : self.clickLookBtnBlock();
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.costPriceLbl) {
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        self.model.unitPrice = @(textField.text.floatValue *100);
    }else if (textField == self.salePriceLbl) {
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        self.model.salesPrice = @(textField.text.floatValue*100);
    }
    self.model.isChange = YES;
}

- (void)dealloc {
    [self.costPriceLbl removeObserver:self forKeyPath:@"text"];
    [self.salePriceLbl removeObserver:self forKeyPath:@"text"];
}

@end
