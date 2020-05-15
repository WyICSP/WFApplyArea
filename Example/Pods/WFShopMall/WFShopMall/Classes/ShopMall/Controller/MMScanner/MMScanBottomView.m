//
//  MMScanBottomView.m
//  WFKit
//
//  Created by 王宇 on 2019/5/5.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "MMScanBottomView.h"

@implementation MMScanBottomView

- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag == 10) {
        !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag,[UIButton new]);
    }else {
        !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag,sender);
    }
    
}

@end
