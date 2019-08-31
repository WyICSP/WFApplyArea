//
//  WFAreaDetailSingleTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailSingleTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@implementation WFAreaDetailSingleTableViewCell

static NSString *const cellId = @"WFAreaDetailSingleTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailSingleTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.borderWidth = 0.5;
    self.contentsView.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFAreaDetailSingleChargeModel *)model {
    self.unitPrice.text = [NSString stringWithFormat:@"%@ 元/度",@(model.unitPrice.floatValue/100)];
    self.salesPrice.text = [NSString stringWithFormat:@"%@ 元/度",@(model.salesPrice.floatValue/100)];
}

@end
