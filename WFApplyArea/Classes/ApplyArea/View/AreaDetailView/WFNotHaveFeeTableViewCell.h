//
//  WFNotHaveFeeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFNotHaveFeeTableViewCell : UITableViewCell
/**去设置*/
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
/**去设置套餐*/
@property (nonatomic, strong) void (^gotoSetFeeBlock)(void);
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
