//
//  WFNRGatewayTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFNRGatewayTableViewCell : UITableViewCell
/// title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 初始化
/// @param tableView tableView
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
