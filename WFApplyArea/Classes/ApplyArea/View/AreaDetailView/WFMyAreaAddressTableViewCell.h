//
//  WFMyAreaAddressTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaAddressTableViewCell : UITableViewCell
/**地址*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
