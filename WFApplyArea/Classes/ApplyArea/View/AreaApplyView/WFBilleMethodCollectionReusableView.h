//
//  WFBilleMethodCollectionReusableView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFBilleMethodCollectionReusableView : UICollectionReusableView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**titleBtn*/
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
/**详情*/
@property (weak, nonatomic) IBOutlet UIImageView *showDetailImg;

/**初始化*/
+ (instancetype)reusableViewWithCollectionView:(UICollectionView *)collevtionView
                                     indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
