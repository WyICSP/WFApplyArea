//
//  WFApplyAreaItemTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAreaItemTableViewCell.h"
#import "WFMyAreaListModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFApplyAreaItemTableViewCell

static NSString *const cellId = @"WFApplyAreaItemTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount {
    WFApplyAreaItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFApplyAreaItemTableViewCell" owner:nil options:nil] firstObject];
    }
    if (dataCount != 0 && indexPath.row == dataCount - 1) {
        cell.contentsView.backgroundColor = UIColor.clearColor;
        cell.lineLbl.hidden = YES;
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(44.0f))];
    }else if (dataCount == 0){
        cell.contentsView.backgroundColor = UIColor.clearColor;
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(44.0f))];
    }else {
        cell.contentsView.backgroundColor = UIColor.whiteColor;
        cell.lineLbl.hidden = NO;
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

- (void)setModel:(WFApplyChargeMethod *)model {
    self.title.text = model.chargingModelName;
    self.detaillbl.hidden = !model.isNecessary;
}

@end
