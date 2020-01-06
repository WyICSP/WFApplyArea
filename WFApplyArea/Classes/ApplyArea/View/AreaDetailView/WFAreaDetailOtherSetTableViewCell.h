//
//  WFAreaDetailOtherSetTableViewCell.h
//  AFNetworking
//
//  Created by 王宇 on 2020/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WFAreaDetailModel;

@interface WFAreaDetailOtherSetTableViewCell : UITableViewCell
/// 最大时长
@property (weak, nonatomic) IBOutlet UILabel *maxTime;
/// 起步价
@property (weak, nonatomic) IBOutlet UILabel *startPrice;
/// 赋值
@property (nonatomic, strong) WFAreaDetailModel *models;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
