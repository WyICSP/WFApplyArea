//
//  WFMyAreaSearchHeadView.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import "WFMyAreaSearchHeadView.h"
#import "WKHelp.h"

@implementation WFMyAreaSearchHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    
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

- (void)setRType:(WFAreaSearchRadiusType *)rType {
    if (rType == WFAreaSearchRadiusLineType) {
        SKViewsBorder(self.contentsView, 15.0f, 0.5, UIColorFromRGB(0xE4E4E4));
    }else {
        SKViewsBorder(self.contentsView, 15.0f, 0, UIColorFromRGB(0xE4E4E4));
    }
}


@end
