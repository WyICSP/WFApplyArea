//
//  WFApplyAreaOtherTableViewCell.h
//  AFNetworking
//
//  Created by 王宇 on 2019/12/20.
//

#import <UIKit/UIKit.h>

@class WFApplyAreaOtherConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaOtherTableViewCell : UITableViewCell
/// contentsView
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 最大时长
@property (weak, nonatomic) IBOutlet UITextField *maxTimeTF;
/// 起步价
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/// 是否编辑
@property (copy, nonatomic) void (^textFieldInputTypeBlock)(BOOL isEdit);
/// 赋值操作
@property (strong, nonatomic) WFApplyAreaOtherConfigModel *mdoels;
/// 初始化
/// @param tableView tableView
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
