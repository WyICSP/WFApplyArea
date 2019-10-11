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
/**编辑按钮*/
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
/// 是否失效
@property (weak, nonatomic) IBOutlet UIImageView *invalidImg;

/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**赋值*/
@property (nonatomic, strong) WFGroupVipUserModel *model;
/**去编辑*/
@property (nonatomic, copy) void (^editUserMsgBlock)(void);
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
