//
//  WFInputWriteOffView.m
//  AFNetworking
//
//  Created by 王宇 on 2019/12/5.
//

#import "WFInputWriteOffView.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFInputWriteOffView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.layer.cornerRadius = 10.0f;
    self.codeTF.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.codeTF.layer.cornerRadius = 20.0f;
    self.codeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    self.codeTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.phoneTF.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.phoneTF.layer.cornerRadius = 20.0f;
    self.phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    [self endEditing:YES];
    if (sender.tag == 100) {
        //取消
        !self.btnClickBlock ? : self.btnClickBlock(sender.tag,@{});
    }else if (sender.tag == 200){
        //确定
        if (self.phoneTF.text.length == 11 && self.codeTF.text.length != 0) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params safeSetObject:self.phoneTF.text forKey:@"memberMobile"];
            [params safeSetObject:self.codeTF.text forKey:@"orderCode"];
            [params safeSetObject:@"1" forKey:@"type"];
            !self.btnClickBlock ? : self.btnClickBlock(sender.tag,params);
        }else if (self.phoneTF.text.length != 11) {
            [YFToast showMessage:@"请输入正确的手机号"];
        }else if (self.codeTF.text.length == 0) {
            [YFToast showMessage:@"请输入核销码"];
        }
    }
    
}


- (IBAction)textFieldDidChange:(UITextField *)textField {
     if (textField == self.phoneTF && textField.text.length > 11) {
           textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
       }
}

@end
