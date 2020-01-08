//
//  WFAreaDetailSinglePowerTableViewCell.h
//  AFNetworking
//
//  Created by 王宇 on 2020/1/8.
//

#import <UIKit/UIKit.h>

@class WFChargeFeePowerConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailSinglePowerTableViewCell : UITableViewCell
/// 功率区间
@property (weak, nonatomic) IBOutlet UILabel *powerLbl;
/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
/// 赋值
@property (nonatomic, strong) WFChargeFeePowerConfigModel *model;
/// 初始化
/// @param tableView tableView
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
