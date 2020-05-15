//
//  WFShopMallTopActivityView.m
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import "WFShopMallTopActivityView.h"

@implementation WFShopMallTopActivityView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

/**点击事件*/
- (void)tapAction {
    
    self.operateBlock ? self.operateBlock() : nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
