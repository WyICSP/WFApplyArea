//
//  WFAreaVipUsersListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaVipUsersListTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFAreaVipUsersListTableViewCell

static NSString *const cellId = @"WFAreaVipUsersListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaVipUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaVipUsersListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFGroupVipUserModel *)model {
    self.name.text = model.name;
    self.phone.text = [NSString stringWithFormat:@"手机号码: %@",model.phone];
    self.totalCount.text = [NSString stringWithFormat:@"总次数: %ld",(long)model.giveCount];
    self.surplusCount.text = [NSString stringWithFormat:@"%ld",(long)model.remainCount];
    self.time.text = [NSString stringWithFormat:@"到期时间: %@",model.expireTime];
}

@end
