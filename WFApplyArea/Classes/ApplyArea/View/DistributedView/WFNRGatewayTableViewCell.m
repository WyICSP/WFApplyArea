//
//  WFNRGatewayTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFNRGatewayTableViewCell.h"

@implementation WFNRGatewayTableViewCell

static NSString *const cellId = @"WFNRGatewayTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFNRGatewayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFNRGatewayTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
