//
//  WFDisItemsTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFGroupVipUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFDisItemsTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**修改用户信息事件*/
@property (nonatomic, copy) void (^editUserMsgBlock)(void);
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**充电次数*/
@property (weak, nonatomic) IBOutlet UILabel *chargeCount;

/**赋值*/
@property (nonatomic, strong) WFGroupVipUserModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
