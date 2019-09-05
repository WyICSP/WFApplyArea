//
//  WFLookPowerFormListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFLookPowerFormListTableViewCell.h"
#import "WFPowerIntervalModel.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFLookPowerFormListTableViewCell

static NSString *const cellId = @"WFLookPowerFormListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFLookPowerFormListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFLookPowerFormListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFPowerIntervalModel *)model {
    self.powerLbl.text = model.powerInterval;
    self.countLbl.text = [NSString stringWithFormat:@"%ld",(long)model.time];
}

- (void)setVModel:(WFGroupVipUserModel *)vModel {
    self.name.text = vModel.name;
    self.times.text = vModel.useCount;
}

@end
