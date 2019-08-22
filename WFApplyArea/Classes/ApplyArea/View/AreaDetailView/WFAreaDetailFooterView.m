//
//  WFAreaDetailFooterView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailFooterView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFAreaDetailFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerBottomLeft | WFRadiusRectCornerBottomRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, 10.0f)];
}

@end
