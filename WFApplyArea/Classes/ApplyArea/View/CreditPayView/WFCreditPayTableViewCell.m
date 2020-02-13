//
//  WFCreditPayTableViewCell.m
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "WFCreditPayTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WFCreditPayModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFCreditPayTableViewCell

static NSString *const cellId = @"WFCreditPayTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount {
    WFCreditPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFCreditPayTableViewCell" owner:nil options:nil] firstObject];
    }
    if (dataCount != 0 && indexPath.row == 0) {
        //设置圆角
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, 60.0f)];
        cell.line.hidden = NO;
    }else if (dataCount != 0 && indexPath.row == dataCount - 1) {
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomRight | WFRadiusRectCornerBottomLeft imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, 60.0f)];
        cell.line.hidden = YES;
    }
    cell.contentsView.backgroundColor = UIColor.clearColor;
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

- (void)setModel:(WFCreditPaymentVOListModel *)model {
    [self.itemIcon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"fang"]];
    self.title.text = model.name;
    
    self.selectBtn.selected = model.isSelect;
}

@end
