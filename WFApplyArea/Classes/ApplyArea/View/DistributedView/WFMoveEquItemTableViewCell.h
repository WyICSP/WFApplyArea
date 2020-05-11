//
//  WFMoveEquItemTableViewCell.h
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import <UIKit/UIKit.h>

@class WFRemoveEquItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMoveEquItemTableViewCell : UITableViewCell
/// title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// btn
@property (weak, nonatomic) IBOutlet UIButton *btn;
/// 赋值
@property (nonatomic, strong) WFRemoveEquItemModel *model;
/// 初始化
/// @param tableView tableView
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
