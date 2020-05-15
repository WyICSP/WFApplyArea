//
//  WFIssuingCircleTableViewCell.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/11.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFIssuingCircleTableViewCell.h"

@implementation WFIssuingCircleTableViewCell

static NSString *const cellId = @"WFIssuingCircleTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFIssuingCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFIssuingCircleTableViewCell" owner:nil options:nil] firstObject];
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
