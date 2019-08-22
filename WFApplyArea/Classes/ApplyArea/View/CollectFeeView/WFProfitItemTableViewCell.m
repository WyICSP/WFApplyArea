//
//  WFProfitItemTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFProfitItemTableViewCell.h"
#import "WFPowerIntervalModel.h"

@implementation WFProfitItemTableViewCell

static NSString *const cellId = @"WFProfitItemTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFProfitItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFProfitItemTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFProfitTableModel *)model {
    self.powerLbl.text = model.powerInterval;
    self.unitPrice.text = [NSString stringWithFormat:@"%@",@(model.unitPrice.floatValue/100)];
    self.salesPrice.text = [NSString stringWithFormat:@"%@",@(model.salesPrice.floatValue/100)];
}

@end
