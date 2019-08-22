//
//  WFMyAreaDetailHeadView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaDetailHeadView : UIView
/**收费按钮*/
@property (weak, nonatomic) IBOutlet UIButton *feeBtn;
/**充电桩*/
@property (weak, nonatomic) IBOutlet UIButton *pileBtn;
/**左边的一个脚*/
@property (weak, nonatomic) IBOutlet UIImageView *leftFoot;
/**右边的一个脚*/
@property (weak, nonatomic) IBOutlet UIImageView *rightFoot;
/**按钮点击事件*/
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
