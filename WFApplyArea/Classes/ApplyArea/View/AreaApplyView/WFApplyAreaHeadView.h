//
//  WFApplyAreaHeadView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaHeadView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**收费说明按钮*/
@property (weak, nonatomic) IBOutlet UIButton *explainBtn;
/**收费说明*/
@property (copy, nonatomic) void (^LookFeeExplainBlock)(void);
@end

NS_ASSUME_NONNULL_END
