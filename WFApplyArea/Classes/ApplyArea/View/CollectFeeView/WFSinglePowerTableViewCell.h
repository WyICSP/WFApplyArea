//
//  WFSinglePowerTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFDefaultChargeFeeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFSinglePowerTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**成本价*/
@property (weak, nonatomic) IBOutlet UITextField *costPriceLbl;
/**销售价*/
@property (weak, nonatomic) IBOutlet UITextField *salePriceLbl;
/**查看按钮*/
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
/**查看利润表*/
@property (nonatomic, copy) void (^clickLookBtnBlock)(void);
/**赋值操作*/
@property (nonatomic, strong) WFDefaultChargeFeeModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
