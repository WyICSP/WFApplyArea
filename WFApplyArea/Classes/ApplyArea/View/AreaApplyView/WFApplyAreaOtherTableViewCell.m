//
//  WFApplyAreaOtherTableViewCell.m
//  AFNetworking
//
//  Created by 王宇 on 2019/12/20.
//

#import "WFApplyAreaOtherTableViewCell.h"
#import "WFApplyAreaOtherConfigModel.h"
#import "WKConfig.h"

@interface WFApplyAreaOtherTableViewCell () <UITextFieldDelegate>

@end

@implementation WFApplyAreaOtherTableViewCell

static NSString *const cellId = @"WFApplyAreaOtherTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFApplyAreaOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFApplyAreaOtherTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.maxTimeTF.delegate = self;
    self.moneyTF.delegate = self;
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(88.0f))];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMdoels:(WFApplyAreaOtherConfigModel *)mdoels {
    _mdoels = mdoels;
    //最大时长
    self.maxTimeTF.text = mdoels.maxChargingTime.defaultValue;
    self.maxTimeTF.placeholder = mdoels.maxChargingTime.tips;
    //充电起步价
    self.moneyTF.text = mdoels.startPrice.defaultValue;
    self.moneyTF.placeholder = mdoels.startPrice.tips;
    self.markPriceLbl.text = mdoels.startPrice.tips;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    !self.textFieldInputTypeBlock ? : self.textFieldInputTypeBlock(YES);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    !self.textFieldInputTypeBlock ? : self.textFieldInputTypeBlock(NO);
    //起步价
    if (textField == self.moneyTF) {
        if (textField.text.doubleValue == 0) {
            self.moneyTF.text = @"0";
        }
    }
}

/// 监听输入框的变化
/// @param textField 输入框对象
- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (self.maxTimeTF == textField) {
        //最大时长
        if (textField.text.intValue > 12) {
            textField.text = @"12";
        }else if (textField.text.intValue < 1) {
            textField.text = @"";
        }
        //提示语的显示与隐藏
        self.markLbl.hidden = textField.text.intValue < 6 ? NO : YES;
        //赋值
        self.mdoels.maxChargingTime.defaultValue = textField.text;
    }else if (self.moneyTF == textField) {
        //最低消费
        if (textField.text.doubleValue > 1) {
            textField.text = @"1";
        }else if (textField.text.length > 3) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 3)];
        }
        //提示语的显示与隐藏
        self.markPriceLbl.hidden = (textField.text.doubleValue > 1 || textField.text.doubleValue < 0) ? NO : YES;
        //赋值
        self.mdoels.startPrice.defaultValue = textField.text;
    }
}

@end
