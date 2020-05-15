//
//  WFApplyAreaHeadView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFApplyAreaHeadView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFApplyAreaHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(35.0f))];
}

- (IBAction)clickExplainBtn:(id)sender {
    !self.LookFeeExplainBlock ? : self.LookFeeExplainBlock();
}

@end
