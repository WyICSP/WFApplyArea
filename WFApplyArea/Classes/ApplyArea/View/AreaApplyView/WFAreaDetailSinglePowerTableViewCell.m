//
//  WFAreaDetailSinglePowerTableViewCell.m
//  AFNetworking
//
//  Created by 王宇 on 2020/1/8.
//

#import "WFAreaDetailSinglePowerTableViewCell.h"
#import "WFDefaultChargeFeeModel.h"

@implementation WFAreaDetailSinglePowerTableViewCell

static NSString *const cellId = @"WFAreaDetailSinglePowerTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailSinglePowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailSinglePowerTableViewCell" owner:nil options:nil] firstObject];
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

- (void)setModel:(WFChargeFeePowerConfigModel *)model {
    //功率
    self.powerLbl.text = [NSString stringWithFormat:@"%ld-%ldW",(long)model.minPower,(long)model.maxPower];
    NSString *time = [NSString stringWithFormat:@"%@ 元  %@ 小时",[NSString stringWithFormat:@"%@",@(model.price.doubleValue/100.0f)],[self notRounding:model.time afterPoint:1]];
    self.timeLbl.text = time;
}

/// 向上 四舍五入
/// @param price 数字
/// @param position 保留的小数位数
- (NSString *)notRounding:(double)price afterPoint:(int)position{
    //向上四舍五入
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
