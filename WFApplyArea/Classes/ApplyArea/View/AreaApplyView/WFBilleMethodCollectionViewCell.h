//
//  WFBilleMethodCollectionViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFBillingTimeMethodModel;
@class WFBillingPriceMethodModel;
@class WFAreaDetailBillingInfosModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFBilleMethodCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *contentsView;

@property (weak, nonatomic) IBOutlet UILabel *title;
/**时间赋值操作*/
@property (nonatomic, strong) WFBillingTimeMethodModel *tModel;
/**金额赋值操作*/
@property (nonatomic, strong) WFBillingPriceMethodModel *pModel;
/**片区详情赋值操作*/
@property (nonatomic, strong) WFAreaDetailBillingInfosModel *dModel;
/**初始化方法*/
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
