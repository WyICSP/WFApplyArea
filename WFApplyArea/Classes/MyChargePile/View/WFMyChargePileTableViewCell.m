//
//  WFMyChargePileTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileTableViewCell.h"
#import "WFMyChargePileModel.h"

@implementation WFMyChargePileTableViewCell

static NSString *const cellId = @"WFMyChargePileTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMyChargePileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyChargePileTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.title.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 我的充电桩
 */
- (void)setMModel:(WFMyCdzListListModel *)mModel {
    self.title.text = mModel.name;
    NSString *present = @"%";
    self.rate.text = [NSString stringWithFormat:@"安装使用率 %.2f%@",mModel.utilizationRate,present];
    self.count.text = [NSString stringWithFormat:@"充电桩 %ld台",(long)mModel.cdzNumber];
}

/**
 异常充电桩
 */
- (void)setAModel:(WFAbnormalCdzListModel *)aModel {
    self.title.text = aModel.name;
    self.rate.text = [NSString stringWithFormat:@"充电桩 %ld台",(long)aModel.cdzNumber];
    self.count.hidden = YES;
}

/**
 未安装充电桩
 */
- (void)setNmModel:(WFNotInstalledCdzListModel *)nmModel {
    self.title.text = nmModel.shellId;
    self.rate.text = [NSString stringWithFormat:@"发货时间%@",nmModel.createDate];
    self.count.hidden = self.nextImg.hidden =YES;
}

@end
