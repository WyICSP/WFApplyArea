//
//  WFMyAreaQRCodeView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaQRCodeView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**头部 view*/
@property (weak, nonatomic) IBOutlet UIView *topView;
/**片区名*/
@property (weak, nonatomic) IBOutlet UILabel *name;
/**二维码*/
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/**图片 url*/
@property (nonatomic, copy) NSString *imgUrl;
/**消失视图*/
@property (nonatomic, copy) void (^closeCodeViewBlock)(void);

@end

NS_ASSUME_NONNULL_END
