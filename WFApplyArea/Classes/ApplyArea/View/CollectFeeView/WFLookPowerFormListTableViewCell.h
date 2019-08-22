//
//  WFLookPowerFormListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFPowerIntervalModel;
@class WFGroupVipUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFLookPowerFormListTableViewCell : UITableViewCell
/**功率区间*/
@property (weak, nonatomic) IBOutlet UILabel *powerLbl;
/**次数*/
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
/**vip 个数*/
@property (weak, nonatomic) IBOutlet UIView *vipContentView;
/**姓名*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**充电次数*/
@property (weak, nonatomic) IBOutlet UILabel *times;
/**赋值*/
@property (nonatomic, strong) WFPowerIntervalModel *model;
/**vip赋值*/
@property (nonatomic, strong) WFGroupVipUserModel *vModel;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
