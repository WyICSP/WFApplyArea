//
//  WFAreaDetailOtherSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailOtherSectionView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFAreaDetailOtherSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(44.0f))];
}

- (IBAction)clickBtn:(id)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock();
}

@end
