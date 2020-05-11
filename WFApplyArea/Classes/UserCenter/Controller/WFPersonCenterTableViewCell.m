//
//  WFPersonCenterTableViewCell.m
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#import "WFPersonCenterTableViewCell.h"
#import "WKConfig.h"

@implementation WFPersonCenterTableViewCell

static NSString *const cellId = @"WFPersonCenterTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount {
    WFPersonCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFPersonCenterTableViewCell" owner:nil options:nil] firstObject];
    }
    
    if (dataCount == 1) {
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerAllCorners imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-30.0f, 49.0f)];
        cell.dashline.hidden = YES;
    }else if (dataCount > 1 && indexPath.row == 0){
        //设置圆角
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-30.0f, 49.0f)];
        cell.dashline.hidden = NO;
    }else if (dataCount > 1 && indexPath.row == dataCount - 1) {
        [cell.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-30.0f, 49.0f)];
        cell.dashline.hidden = YES;
    }
    
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
//    self.contentsView.layer.cornerRadius = 10.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
