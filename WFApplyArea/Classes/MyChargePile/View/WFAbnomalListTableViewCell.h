//
//  WFAbnomalListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAbnormalPileListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAbnomalListTableViewCell : UITableViewCell
/**桩号*/
@property (weak, nonatomic) IBOutlet UILabel *pile;
/**状态*/
@property (weak, nonatomic) IBOutlet UILabel *status;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**未安装*/
@property (nonatomic, strong) WFAbnormalPileListModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
