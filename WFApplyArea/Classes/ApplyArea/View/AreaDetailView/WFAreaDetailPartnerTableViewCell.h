//
//  WFAreaDetailPartnerTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailPartnerModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailPartnerTableViewCell : UITableViewCell
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**电话*/
@property (weak, nonatomic) IBOutlet UILabel *phone;
/**比例*/
@property (weak, nonatomic) IBOutlet UILabel *rate;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailPartnerModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
