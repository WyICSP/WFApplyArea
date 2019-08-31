//
//  WFAreaVipUsersListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFGroupVipUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaVipUsersListTableViewCell : UITableViewCell
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**手机号*/
@property (weak, nonatomic) IBOutlet UILabel *phone;
/**总次数*/
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
/**剩余数*/
@property (weak, nonatomic) IBOutlet UILabel *surplusCount;
/**到期时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**赋值*/
@property (nonatomic, strong) WFGroupVipUserModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
