//
//  MMScanBottomView.h
//  WFKit
//
//  Created by 王宇 on 2019/5/5.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMScanBottomView : UIView
/**10 桩号 20手电筒*/
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger tag,UIButton *btn);
/**打开灯*/
@property (weak, nonatomic) IBOutlet UIButton *openFlash;
/**桩号 lbl*/
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end

NS_ASSUME_NONNULL_END
