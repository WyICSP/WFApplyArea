//
//  WFShopSearchCollectionReusableView.h
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopSearchCollectionReusableView : UICollectionReusableView
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**删除历史记录*/
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**删除历史记录时间*/
@property (nonatomic, copy) void(^deleteHistoryRecordBlock)(void);
/**初始化*/
+ (instancetype)reusableViewWithCollectionView:(UICollectionView *)collevtionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
