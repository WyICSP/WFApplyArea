//
//  WFPileItemCollectionViewCell.h
//  AFNetworking
//
//  Created by 王宇 on 2019/11/28.
//

#import <UIKit/UIKit.h>

@class WFPileSocketParamVOSModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFPileItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 赋值
@property (nonatomic, strong) WFPileSocketParamVOSModel *sModel;
/// 初始化
/// @param collectionView collectionview
/// @param indexPath indexpath
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
