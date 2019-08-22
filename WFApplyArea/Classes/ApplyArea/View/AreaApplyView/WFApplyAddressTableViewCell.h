//
//  WFApplyAddressTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFApplyAreaAddressModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAddressTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**城市*/
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
/**具体地址*/
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
/**小区名*/
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
/**地址*/
@property (nonatomic, strong) WFApplyAreaAddressModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
