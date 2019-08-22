//
//  WFDiviIntoSetHeadTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDiviIntoSetHeadTableViewCell.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFDiviIntoSetHeadTableViewCell

static NSString *const cellId = @"WFDiviIntoSetHeadTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFDiviIntoSetHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFDiviIntoSetHeadTableViewCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopRight | WFRadiusRectCornerTopLeft imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KHeight(24.0f), KHeight(44.0f))];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAddBtn:(id)sender {
    !self.addItemBlock ? : self.addItemBlock();
}

@end
