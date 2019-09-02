//
//  WFAreaDetailOtherSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailOtherSectionView.h"
#import "WFAreaDetailModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFAreaDetailOtherSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(44.0f))];
    SKViewsBorder(self.lookBtn, 27/2, 0.5, UIColorFromRGB(0xE4E4E4));
    SKViewsBorder(self.editVipBtn, 27/2, 0.5, UIColorFromRGB(0xE4E4E4));
}

- (IBAction)clickBtn:(id)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock();
}

/**查看按钮*/
- (IBAction)clickLookBtn:(UIButton *)sender {
    !self.lookBtnBlock ? : self.lookBtnBlock(sender.titleLabel.text);
}

- (void)setModel:(WFAreaDetailSectionTitleModel *)model {
    self.title.text = model.title;
    
    
    self.detailLbl.hidden = !model.isShowDetail;
    self.detailLbl.text = model.detailTitle;
    self.detailBtn.hidden = !model.isShowEditBtn;
    
    if ([model.formTitle containsString:@"编辑会员"]) {
        [self.editVipBtn setTitle:model.formTitle forState:0];
        self.editVipBtn.hidden = NO;
        self.lookBtn.hidden = YES;
    }else {
        [self.lookBtn setTitle:model.formTitle forState:0];
        self.lookBtn.hidden = NO;
        self.editVipBtn.hidden = YES;
        self.lookBtn.hidden = !model.isShowForm;
    }
    
}


@end
