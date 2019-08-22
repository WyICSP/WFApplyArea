//
//  WFApplyAreaItemTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFApplyChargeMethod;

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**详细*/
@property (weak, nonatomic) IBOutlet UILabel *detaillbl;
/**分割线*/
@property (weak, nonatomic) IBOutlet UILabel *lineLbl;
/**赋值*/
@property (nonatomic, strong) WFApplyChargeMethod *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount;
@end

NS_ASSUME_NONNULL_END
