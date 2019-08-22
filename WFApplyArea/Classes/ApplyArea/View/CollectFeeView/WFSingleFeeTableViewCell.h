//
//  WFSingleFeeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFDefaultChargeFeeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFSingleFeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**钱背景*/
@property (weak, nonatomic) IBOutlet UIView *moneyView;
/**次数背景*/
@property (weak, nonatomic) IBOutlet UIView *countView;
/**钱的输入框*/
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/**次数输入框*/
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/**赋值操作*/
@property (nonatomic, strong) WFDefaultChargeFeeModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
