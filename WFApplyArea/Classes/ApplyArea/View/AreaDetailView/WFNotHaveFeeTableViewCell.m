//
//  WFNotHaveFeeTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFNotHaveFeeTableViewCell.h"

@implementation WFNotHaveFeeTableViewCell

static NSString *const cellId = @"WFNotHaveFeeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFNotHaveFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNotHaveFeeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.goBtn.layer.cornerRadius = 15.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(id)sender {
    !self.gotoSetFeeBlock ? : self.gotoSetFeeBlock();
}

@end
