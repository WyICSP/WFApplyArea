//
//  WFSingleFeeUnifiedView.m
//  AFNetworking
//
//  Created by 王宇 on 2019/12/25.
//

#import "WFSingleFeeUnifiedView.h"
#import "WFDefaultChargeFeeModel.h"
#import "UITextField+RYNumberKeyboard.h"
#import "WKConfig.h"

@implementation WFSingleFeeUnifiedView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.backgroundColor = UIColor.clearColor;
    WFRadiusRectCorner radiusRect = (WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight);
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:radiusRect imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-KWidth(24.0f), KHeight(50.0f))];
    self.priceView.layer.cornerRadius = self.timeView.layer.cornerRadius = 29.0f/2;
    [self.priceTF setMoneyKeyboard];
    //通过 KVC 监听 moneyTF 的 text
    [self.priceTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 监听数据
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        //监听输入框
        UITextField *textField = (UITextField *)object;
        [self textFieldDidChange:textField];
    }
}

- (void)setModel:(WFDefaultChargeFeeModel *)model {
    _model = model;
    
    //小于 0 的时候不显示
    if (model.unifiedPrice.floatValue < 0) {
        self.priceTF.text = @"";
    }else {
        self.priceTF.text = [NSString stringWithFormat:@"%@",@(model.unifiedPrice.floatValue/100)];
    }
    
    //等于 0 的时候 不显示
    if (model.unifiedTime == 0) {
        self.timeTF.text = @"";
    }else {
        self.timeTF.text = [NSString stringWithFormat:@"%ld",(long)model.unifiedTime];
    }
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (textField == self.priceTF) {
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        
        //发现包含小数点，并且小数点在倒数第三位就，如果再多就截掉。
        NSInteger loca = [textField.text rangeOfString:@"."].location;
        if (loca + 3 < textField.text.length && loca > 0) {
            textField.text = [textField.text substringToIndex:loca + 3];
        }
        
        //如果为输入为空的的时候 就给他一个负值,方便区分
        if (textField.text.length == 0) {
            self.model.unifiedPrice = @(-1);
        }else {
            self.model.unifiedPrice = @(textField.text.floatValue*100);
        }
        
        !self.reloadTimePriceBlock ? : self.reloadTimePriceBlock(self.model.unifiedTime,2,self.model.unifiedPrice);
    }else if (textField == self.timeTF) {
        //次数不能输入0
        if (textField.text.integerValue == 0 || [textField.text containsString:@"."]) {textField.text = @"";}
        
        if (textField.text.doubleValue > 100)
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 2)];
        
        self.model.unifiedTime = textField.text.integerValue;
        !self.reloadTimePriceBlock ? : self.reloadTimePriceBlock(self.model.unifiedTime,1,@(0));
    }
}

- (IBAction)clickSelectBtn:(UIButton *)sender {
    !self.clickSectionBlock ? : self.clickSectionBlock(sender.tag);
}


- (void)dealloc {
    [self.priceTF removeObserver:self forKeyPath:@"text"];
}

@end
