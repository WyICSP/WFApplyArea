//
//  WFMyAreaPileListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFSignleIntensityListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaPileListTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**小圆点*/
@property (weak, nonatomic) IBOutlet UILabel *yuanLbl;
/**桩号*/
@property (weak, nonatomic) IBOutlet UILabel *shellId;
/**信号强度*/
@property (weak, nonatomic) IBOutlet UILabel *signal;
/**progress*/
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
/**赋值*/
@property (nonatomic, strong) WFSignleIntensityListModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
