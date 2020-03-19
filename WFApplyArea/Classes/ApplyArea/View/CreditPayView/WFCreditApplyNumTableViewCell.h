//
//  WFCreditApplyNumTableViewCell.h
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCreditPayModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFCreditApplyNumTableViewCell : UITableViewCell<UITextFieldDelegate>
/// contentView
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 单价
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;
/// 数量
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/// 总价
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/// 改变数量的 view
@property (weak, nonatomic) IBOutlet UIView *countView;
/// 减
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
/// 初始化数量
@property (nonatomic, assign) NSInteger num;
/// 赋值
@property (nonatomic, strong) WFCreditPayModel *model;
/// 初始化
/// @param tableView tableview
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
