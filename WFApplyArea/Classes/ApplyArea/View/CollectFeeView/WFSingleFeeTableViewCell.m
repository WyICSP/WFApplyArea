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
#import "WKConfig.h"

@implementation WFSingleFeeTableViewCell

static NSString *const cellId = @"WFSingleFeeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount {
    WFSingleFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFSingleFeeTableViewCell" owner:nil options:nil] firstObject];
    }
    if (dataCount != 0 && indexPath.row == dataCount - 1) {
        cell.contentsView.backgroundColor = UIColor.clearColor;
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), 50.0f)];
    }else {
        cell.contentsView.backgroundColor = UIColor.whiteColor;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.moneyView.layer.cornerRadius = 14.5f;
    self.countView.layer.cornerRadius = 14.5f;
    self.contentsView.backgroundColor = UIColor.clearColor;
    
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

- (void)setModel:(WFChargeFeePowerConfigModel *)model {
    _model = model;
    //功率
    self.powerLbl.text = [NSString stringWithFormat:@"%ld-%ldw",(long)model.minPower,(long)model.maxPower];
    
    //小于 0 的时候不显示
    if (model.price.floatValue <= 0) {
        self.moneyTF.text = @"0";
    }else {
        self.moneyTF.text = [NSString stringWithFormat:@"%@",@(model.price.doubleValue/100.0f)];
    }
    //等于 0 的时候 不显示
    if (model.time == 0) {
        self.countTF.text = @"0";
    }else {
        NSString *newTime = [NSString stringWithFormat:@"%.1f",model.time];
        NSNumber *numTime = @(newTime.doubleValue);
        self.countTF.text = [NSString stringWithFormat:@"%@",numTime];
    }
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
        
        //如果为输入为空的的时候 就给他一个负值,方便区分
        if (textField.text.length == 0) {
            self.model.price = @(-1);
        }else {
            self.model.price = @(textField.text.floatValue*100);
        }
        
    }else if (textField == self.countTF) {
        //次数不能输入0
        if (textField.text.doubleValue == 0 && textField.text.length > 2) {
            textField.text = @"0";
        }        
        self.model.time = textField.text.doubleValue;
    }
}

- (void)dealloc {
    [self.moneyTF removeObserver:self forKeyPath:@"text"];
}


@end
