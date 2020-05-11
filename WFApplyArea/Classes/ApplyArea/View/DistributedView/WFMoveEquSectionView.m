//
//  WFMoveEquSectionView.m
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import "WFMoveEquSectionView.h"
#import "WKHelp.h"

@implementation WFMoveEquSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textField.delegate = self;
    
    SKViewsBorder(self.contentsView, 15.0f, 0, UIColorFromRGB(0xE4E4E4));
    self.contentsView.backgroundColor = UIColorFromRGB(0xF5F5F5);
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
