//
//  WFAreaDetailTimeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailBillingInfosModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**数据*/
@property (nonatomic, strong) NSArray <WFAreaDetailBillingInfosModel *> *billDatas;
/**collectionView 高度*/
@property (nonatomic, assign) CGFloat cellHeight;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 绑定数据

 @param billDatas 数据
 @param cellHeight 高度
 */
- (void)bindToCell:(NSArray <WFAreaDetailBillingInfosModel *> *)billDatas
        cellHeight:(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
