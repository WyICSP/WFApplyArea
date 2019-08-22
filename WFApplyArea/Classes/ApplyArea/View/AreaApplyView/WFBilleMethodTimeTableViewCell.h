//
//  WFBilleMethodTimeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WFBillingTimeMethodModel;

@interface WFBilleMethodTimeTableViewCell : UITableViewCell
/**充电时间*/
@property (nonatomic, strong) NSArray <WFBillingTimeMethodModel *> *models;
/**cell高度*/
@property (nonatomic, assign) CGFloat cellHeight;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 绑定数据

 @param models 数据源
 @param cellHeight 高度
 */
- (void)bindToCell:(NSArray <WFBillingTimeMethodModel *> *)models
        cellHeight:(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
