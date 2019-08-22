//
//  WFAreaDetailDiscountTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailVipChargeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailDiscountTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**销售价*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailVipChargeModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
