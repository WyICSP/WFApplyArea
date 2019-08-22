//
//  WFMyAreaPileListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaPileListTableViewCell.h"
#import "WFMyChargePileModel.h"
#import "WKHelp.h"

@implementation WFMyAreaPileListTableViewCell

static NSString *const cellId = @"WFMyAreaPileListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMyAreaPileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaPileListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.yuanLbl.layer.cornerRadius = 7.0/2;
    self.yuanLbl.layer.backgroundColor = NavColor.CGColor;
    for (UIImageView *imgView in self.progress.subviews) {
        imgView.layer.cornerRadius = 4;
        imgView.clipsToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFSignleIntensityListModel *)model {
    self.shellId.text = model.shellId;
    self.signal.text = [NSString stringWithFormat:@"%ld",(long)model.qos];
    CGFloat pro = model.qos/100.0f;
    [self.progress setProgress:pro];
}

@end
