//
//  WFAreaDetailDiscountTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailDiscountTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@implementation WFAreaDetailDiscountTableViewCell

static NSString *const cellId = @"WFAreaDetailDiscountTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailDiscountTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    SKViewsBorder(self.contentsView, 0, 0.5, UIColorFromRGB(0xE4E4E4));
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFAreaDetailVipChargeModel *)model {
    self.price.text = [NSString stringWithFormat:@"%@",@(model.unifiedPrice.floatValue/100)];
    self.time.text = [NSString stringWithFormat:@"%ld",model.unifiedTime];
}

@end
