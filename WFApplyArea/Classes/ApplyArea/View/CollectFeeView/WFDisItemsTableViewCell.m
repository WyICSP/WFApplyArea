//
//  WFDisItemsTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDisItemsTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFDisItemsTableViewCell

static NSString *const cellId = @"WFDisItemsTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFDisItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDisItemsTableViewCell" owner:nil options:nil] firstObject];
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

- (IBAction)clickEditBtn:(id)sender {
    !self.editUserMsgBlock ? : self.editUserMsgBlock();
}

- (void)setModel:(WFGroupVipUserModel *)model {
    self.name.text = model.name;
    self.chargeCount.text = [NSString stringWithFormat:@"充电次数   %@次",model.useCount];
}

@end
