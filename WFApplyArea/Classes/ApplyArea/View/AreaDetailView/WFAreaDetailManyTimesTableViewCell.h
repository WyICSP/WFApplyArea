//
//  WFAreaDetailManyTimesTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailMultipleModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailManyTimesTableViewCell : UITableViewCell
/**整体背景*/
@property (weak, nonatomic) IBOutlet UIView *bgView;
/**套餐信息*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
//左边的收费宽度
@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
/**赋值*/
@property (nonatomic, strong) NSArray <WFAreaDetailMultipleModel *> *models;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
