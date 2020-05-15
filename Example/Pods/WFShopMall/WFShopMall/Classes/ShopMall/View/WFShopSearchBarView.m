//
//  WFShopSearchBarView.m
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShopSearchBarView.h"

@implementation WFShopSearchBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 15;
//    [self.searchTF becomeFirstResponder];
    self.searchTF.delegate = self;
}

- (IBAction)clickCancelBtn:(id)sender {
    !self.searchProductsBlock ? : self.searchProductsBlock(YES,@"");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    !self.searchProductsBlock ? : self.searchProductsBlock(NO,textField.text);
    return YES;
}

@end
