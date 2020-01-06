//
//  WFChargePileSearchView.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import "WFChargePileSearchView.h"
#import "WKHelp.h"

@implementation WFChargePileSearchView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    self.contentsView.layer.cornerRadius = 15.0f;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length != 0)
        return;
    !self.searchResultBlock ? : self.searchResultBlock(textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    !self.searchResultBlock ? : self.searchResultBlock(textField.text);
    return YES;
}

@end
