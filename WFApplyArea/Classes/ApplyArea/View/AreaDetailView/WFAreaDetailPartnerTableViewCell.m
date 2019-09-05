//
//  WFAreaDetailPartnerTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailPartnerTableViewCell.h"
#import "WFAreaDetailModel.h"

@implementation WFAreaDetailPartnerTableViewCell

static NSString *const cellId = @"WFAreaDetailPartnerTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailPartnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailPartnerTableViewCell" owner:nil options:nil] firstObject];
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

- (void)setModel:(WFAreaDetailPartnerModel *)model {
    self.name.text = model.name;
    self.phone.text = model.phone;
    self.rate.text = [NSString stringWithFormat:@"%ld",(long)model.rate];
}

@end
