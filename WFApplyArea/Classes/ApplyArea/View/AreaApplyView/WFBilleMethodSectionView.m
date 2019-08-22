//
//  WFBilleMethodSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodSectionView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFBilleMethodSectionView


- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickSectionBlock ? : self.clickSectionBlock(sender.tag);
}

@end
