//
//  WFAbnomalListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAbnomalListTableViewCell.h"
#import "WFMyChargePileModel.h"

@implementation WFAbnomalListTableViewCell

static NSString *const cellId = @"WFAbnomalListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAbnomalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAbnomalListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.time.adjustsFontSizeToFitWidth = YES;
    self.status.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 异常充电桩
 */
- (void)setModel:(WFAbnormalPileListModel *)model {
    self.pile.text = model.shellId;
    self.status.text = model.abType;
    self.time.text = model.lastUseTime;
}

@end
