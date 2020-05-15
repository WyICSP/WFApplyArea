//
//  MMScanViewChooseView.m
//  WFKit
//
//  Created by 王宇 on 2019/5/5.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "MMScanViewChooseView.h"

@implementation MMScanViewChooseView

- (IBAction)clickBtn:(UIButton *)sender {
    
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    !self.chooseScanTypeBlock ? : self.chooseScanTypeBlock(sender.tag);
}


@end
