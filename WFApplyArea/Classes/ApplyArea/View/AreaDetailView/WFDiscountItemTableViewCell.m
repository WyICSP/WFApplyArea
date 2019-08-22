//
//  WFDiscountItemTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDiscountItemTableViewCell.h"
#import "WFAreaDetailModel.h"

@implementation WFDiscountItemTableViewCell

static NSString *const cellId = @"WFDiscountItemTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFDiscountItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDiscountItemTableViewCell" owner:nil options:nil] firstObject];
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

- (void)setModel:(WFAreaDetailMultipleModel *)model {
    self.name.text = model.optionName;
    self.price.text = [NSString stringWithFormat:@"%@",@(model.proposalPrice.floatValue/100)];
    self.times.text = [NSString stringWithFormat:@"%ld",(long)model.proposalTimes];
}

@end
