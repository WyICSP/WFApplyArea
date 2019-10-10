//
//  WFDiviIntoSetEditTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDiviIntoSetEditTableViewCell.h"
#import "WFMyAreaListModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFDiviIntoSetEditTableViewCell

static NSString *const cellId = @"WFDiviIntoSetEditTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount  {
    WFDiviIntoSetEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDiviIntoSetEditTableViewCell" owner:nil options:nil] firstObject];
    }
    if (dataCount != 0 && indexPath.row == dataCount - 1) {
        cell.contentsView.backgroundColor = UIColor.clearColor;
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KHeight(24.0f), KHeight(44.0f))];
    }else {
        cell.contentsView.backgroundColor = UIColor.whiteColor;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.percentTF.layer.cornerRadius = 15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickDeleteBtn:(id)sender {
    !self.deleteItemBlock ? : self.deleteItemBlock();
}

- (void)bindToCellWithModel:(WFMyAreaDividIntoSetModel *)model
                 maxPresent:(WFMyAreaDividIntoSetModel *)maxModel {
    _model = model;
    _maxModel = maxModel;
    self.nameTF.text = model.name;
    self.phoneTF.text = model.phone;
    self.percentTF.text = [NSString stringWithFormat:@"%ld",(long)model.rate];
    self.nameTF.enabled = self.phoneTF.enabled = self.percentTF.enabled =model.chargePersonFlag == 2;
    self.deleteBtn.hidden = model.chargePersonFlag != 2;
    self.percentTF.backgroundColor = model.chargePersonFlag == 2 ? UIColorFromRGB(0xF5F5F5) : UIColor.whiteColor;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField  == self.nameTF) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length > 6) {
                textField.text = [textField.text substringToIndex:6];
                self.model.name = textField.text;
             }
        }
    }else if (textField == self.phoneTF) {
        //电话
        if (textField == self.phoneTF && textField.text.length > 11)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        
        self.model.phone = textField.text;
    }else if (textField == self.percentTF) {
        
        if (textField.text.integerValue > 0) {
            textField.text = [NSString stringWithFormat:@"%ld",(long)textField.text.integerValue];
        }
        //百分占比
        !self.checkPresentBlock ? : self.checkPresentBlock(self.percentTF.text.integerValue);
        
        if (textField.text.integerValue == 0) {
            textField.text = @"0";
            self.model.rate = 0;
        }
    }
}


@end
