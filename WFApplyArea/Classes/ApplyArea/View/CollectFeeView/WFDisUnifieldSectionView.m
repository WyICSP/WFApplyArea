//
//  WFDisUnifieldSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFDisUnifieldSectionView.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFDisUnifieldSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addBtn.layer.cornerRadius = 10.0f;
}

- (IBAction)clickAddBtn:(id)sender {
    !self.addUserPhoneBlock ? : self.addUserPhoneBlock();
}

@end
