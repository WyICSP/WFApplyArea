//
//  WFAreaDetailAddressTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailAddressTableViewCell : UITableViewCell
/**状态*/
@property (weak, nonatomic) IBOutlet UILabel *status;
/**地址信息*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**地址的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHeight;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 绑定数据

 @param model 数据源
 @param addressHeight 地址高度
 */
- (void)bindToCell:(WFAreaDetailModel *)model
     addressHeight:(CGFloat)addressHeight;
@end

NS_ASSUME_NONNULL_END
