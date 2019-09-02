//
//  WFAreaDetailOtherSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WFAreaDetailSectionTitleModel;

@interface WFAreaDetailOtherSectionView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**查看详情*/
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
/**说明*/
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
/**查看按钮*/
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *editVipBtn;

/**赋值*/
@property (nonatomic, strong) WFAreaDetailSectionTitleModel *model;
/**编辑按钮点击事件*/
@property (nonatomic, copy) void (^clickBtnBlock)(void);
/**查看按钮点击事件*/
@property (nonatomic, copy) void (^lookBtnBlock)(NSString *title);
@end

NS_ASSUME_NONNULL_END
