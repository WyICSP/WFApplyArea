//
//  WFMyAreaListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMyAreaListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaListTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**片区名*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *money;
/**地址*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**时间*/
@property (weak, nonatomic) IBOutlet UILabel *time;
/**审核状态*/
@property (weak, nonatomic) IBOutlet UILabel *state;
/**二维码*/
@property (weak, nonatomic) IBOutlet UIButton *qrBtn;
/**显示二维码*/
@property (nonatomic, copy) void (^showQRCodeBlock)(void);
/**赋值操作*/
@property (nonatomic, strong) WFMyAreaListModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
