//
//  WFProfitItemTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFProfitTableModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFProfitItemTableViewCell : UITableViewCell
/**功率区间*/
@property (weak, nonatomic) IBOutlet UILabel *powerLbl;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
/**销售价*/
@property (weak, nonatomic) IBOutlet UILabel *salesPrice;
/**赋值操作*/
@property (nonatomic, strong) WFProfitTableModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
