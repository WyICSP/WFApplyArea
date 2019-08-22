//
//  WFDiscountItemTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailMultipleModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFDiscountItemTableViewCell : UITableViewCell
/**套餐说明*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**价格*/
@property (weak, nonatomic) IBOutlet UILabel *price;
/**次数*/
@property (weak, nonatomic) IBOutlet UILabel *times;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailMultipleModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
