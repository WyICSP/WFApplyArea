//
//  WFMyChargePileTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMyCdzListListModel;
@class WFAbnormalCdzListModel;
@class WFNotInstalledCdzListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyChargePileTableViewCell : UITableViewCell
/**名字*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**占比*/
@property (weak, nonatomic) IBOutlet UILabel *rate;
/**充电桩台数*/
@property (weak, nonatomic) IBOutlet UILabel *count;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImg;

/**我的充电桩*/
@property (nonatomic, strong) WFMyCdzListListModel *mModel;
/**异常充电桩*/
@property (nonatomic, strong) WFAbnormalCdzListModel *aModel;
/**未安装*/
@property (nonatomic, strong) WFNotInstalledCdzListModel *nmModel;

/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
