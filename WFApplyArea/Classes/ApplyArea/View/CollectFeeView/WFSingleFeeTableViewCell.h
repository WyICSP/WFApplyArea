//
//  WFSingleFeeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/7.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFChargeFeePowerConfigModel;

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
/// 功率
@property (weak, nonatomic) IBOutlet UILabel *powerLbl;
/**赋值操作*/
@property (nonatomic, strong) WFChargeFeePowerConfigModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount;
@end

NS_ASSUME_NONNULL_END
