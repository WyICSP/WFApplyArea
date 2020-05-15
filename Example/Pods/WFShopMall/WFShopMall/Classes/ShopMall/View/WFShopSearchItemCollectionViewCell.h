//
//  WFShopSearchItemCollectionViewCell.h
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopSearchItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *itemView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, copy) NSString *searchKey;
/**初始化方法*/
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForCell;

/**得到 cell 的大小*/
+ (CGSize)getSizeWithText:(NSString*)text;
@end

NS_ASSUME_NONNULL_END
