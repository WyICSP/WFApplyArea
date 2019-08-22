//
//  WFAreaDetailOtherSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailOtherSectionView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**查看详情*/
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
/**说明*/
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
/**点击事件*/
@property (nonatomic, copy) void (^clickBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
