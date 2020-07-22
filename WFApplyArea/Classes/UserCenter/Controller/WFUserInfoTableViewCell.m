//
//  WFUserInfoTableViewCell.m
//  WFKit
//
//  Created by 王宇 on 2020/3/27.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "WFUserInfoTableViewCell.h"

@implementation WFUserInfoTableViewCell

static NSString *const cellId = @"WFUserInfoTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount {
    WFUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFUserInfoTableViewCell" owner:nil options:nil] firstObject];
    }
    //判断分割线
    cell.dashLine.hidden = ((dataCount > 1 && indexPath.row == dataCount - 1) || (dataCount == 1)) ? YES : NO;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
