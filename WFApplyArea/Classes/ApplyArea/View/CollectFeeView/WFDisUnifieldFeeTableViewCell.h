//
//  WFDisUnifieldFeeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFDefaultDiscountModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFDisUnifieldFeeTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**钱View*/
@property (weak, nonatomic) IBOutlet UIView *moneyView;
/**时间*/
@property (weak, nonatomic) IBOutlet UIView *dateView;
/**输入钱*/
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/**输入的时间*/
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
/**赋值操作*/
@property (nonatomic, strong) WFDefaultDiscountModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
