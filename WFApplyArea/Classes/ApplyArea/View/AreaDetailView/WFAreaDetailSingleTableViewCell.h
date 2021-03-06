//
//  WFAreaDetailSingleTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailSingleChargeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailSingleTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
/**销售价*/
@property (weak, nonatomic) IBOutlet UILabel *salesPrice;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailSingleChargeModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
