//
//  WFShopMallPopUPView.m
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import "WFShopMallPopUPView.h"

@implementation WFShopMallPopUPView



-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    
}
/**特惠返利统计*/
- (IBAction)specialStatisticsButttonAction:(id)sender {
    
    self.operateBlock ? self.operateBlock(0) : nil;
    [self dissmissView];
    
}

/**攻略*/
- (IBAction)strategyButtonAction:(id)sender {
    
    self.operateBlock ? self.operateBlock(1) : nil;
    
    [self dissmissView];
}


/**显示view*/
- (void)popView {
    self.alpha = 0.0f;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1.0f;
    }];
    
    
}
/**取消view*/
- (void)dissmissView {
    
    self.alpha = 1.0f;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0.0f;
    }];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
