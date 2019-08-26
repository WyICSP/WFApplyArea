//
//  WFMyAreaAddressTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaAddressTableViewCell.h"
#import "WFAreaDetailModel.h"

@implementation WFMyAreaAddressTableViewCell

static NSString *const cellId = @"WFMyAreaAddressTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMyAreaAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaAddressTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFAreaDetailModel *)model {
    NSString *address = [NSString stringWithFormat:@"%@%@",model.areaName,model.address];
    self.address.text = [NSString stringWithFormat:@"%@",address];
}

@end
