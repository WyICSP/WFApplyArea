//
//  WFShopMallHeadView.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFShopMallHeadView.h"
#import "NSString+Regular.h"

@implementation WFShopMallHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    //初始化 选中红包
    self.btnTag = 11;
}

// tag = 11 红包 12 导购券 
- (IBAction)clickBtn:(UIButton *)sender {
    //防止重复点击
    if (self.btnTag == sender.tag && sender.tag == 12) return;
    
    //选中当前按钮
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    //如果红包按钮没有选中 就设置未选中的图片
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *defaultPath = [NSString getImagePathWithCurrentBundler:currentBundle PhotoName:@"defaultDir" bundlerName:@"WFShopMall.bundle"];
    [self.redBtn setImage:[UIImage imageWithContentsOfFile:defaultPath] forState:0];
    
    //如果按钮已经选中 就设置选中图片
    if (sender.tag == 11 && sender.selected) {
        self.topOrDowm = self.btnTag == sender.tag ? !self.topOrDowm : self.topOrDowm;
        NSString *selectImage = [NSString getImagePathWithCurrentBundler:currentBundle PhotoName:self.topOrDowm ? @"upward" : @"towardsDown" bundlerName:@"WFShopMall.bundle"];
        [sender setImage:[UIImage imageWithContentsOfFile:selectImage] forState:UIControlStateSelected];
    }
    
    self.btnTag = sender.tag;
    
    !self.screenProductBlock ? : self.screenProductBlock(sender.tag,self.topOrDowm);
}




@end
