//
//  WFSearchAddressNavBarView.m
//  WFKit
//
//  Created by 王宇 on 2019/4/19.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFSearchAddressNavBarView.h"

#import "WKHelp.h"

@implementation WFSearchAddressNavBarView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 14.5f;
    self.searchTF.delegate = self;
}

- (void)setType:(WFSearchAddressEventType)type {
    _type = type;
    self.searchTF.placeholder = _type == WFSearchAddressChargeEventType ? @"请输入搜索关键字" : @"请输入搜索关键字";
    if (self.type == WFSearchAddressChargeEventType) {
        [self.searchTF becomeFirstResponder];
    }else {
        [self.searchTF resignFirstResponder];
    }
}

- (IBAction)clickBackBtn:(id)sender {
    if (self.type == WFSearchAddressChargeEventType) {
        !self.searchBarEventBlock ? : self.searchBarEventBlock(YES,@"");
    }else {
        !self.searchBarBeginEditEventBlock ? : self.searchBarBeginEditEventBlock(YES,@"");
    }
}

- (IBAction)textFieldDidChange:(UITextField *)sender {
    if (self.type == WFSearchAddressChargeEventType)
    !self.searchBarEventBlock ? : self.searchBarEventBlock(NO,sender.text);
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.type == WFSearchAddressProductEventType)
    !self.searchBarBeginEditEventBlock ? : self.searchBarBeginEditEventBlock(NO,textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    if (self.type == WFSearchAddressChargeEventType) {
        !self.searchBarEventBlock ? : self.searchBarEventBlock(NO,textField.text);
    }else {
        !self.searchBarBeginEditEventBlock ? : self.searchBarBeginEditEventBlock(NO,textField.text);
    }
    return YES;
}

@end
