//
//  WFUserInfoTableViewCell.h
//  WFKit
//
//  Created by 王宇 on 2020/3/27.
//  Copyright © 2020 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFUserInfoTableViewCell : UITableViewCell
/// title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 分割线
@property (weak, nonatomic) IBOutlet UILabel *dashLine;
/// 描述
@property (weak, nonatomic) IBOutlet UILabel *desc;

/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount;
@end

NS_ASSUME_NONNULL_END
