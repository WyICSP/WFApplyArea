//
//  WFAreaDetailOtherSetTableViewCell.m
//  AFNetworking
//
//  Created by 王宇 on 2020/1/6.
//

#import "WFAreaDetailOtherSetTableViewCell.h"
#import "WFAreaDetailModel.h"

@implementation WFAreaDetailOtherSetTableViewCell

static NSString *const cellId = @"WFAreaDetailOtherSetTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailOtherSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailOtherSetTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModels:(WFAreaDetailModel *)models {
    if (models.maxChargingTime.length == 0) {
        self.maxTime.text = @"12 小时";
    }else {
        self.maxTime.text = [NSString stringWithFormat:@"%@ 小时",models.maxChargingTime];
    }
    self.startPrice.text = [NSString stringWithFormat:@"%@ 元",@(models.startPrice.doubleValue)];
}

@end
