//
//  WFSearchBar.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import "WFSearchBar.h"

@interface WFSearchBar () <UITextFieldDelegate,UISearchBarDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
static CGFloat const searchIconW = 20.0f;
// icon与textField间距
static CGFloat const iconSpacing = 5.0f;
// 默认系统占位文字的字体大小 用于设置间距
static CGFloat const placeHolderFont = 12.0f;

@implementation WFSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.cornerRadius = 18.0f;
    self.textField.layer.masksToBounds = YES;
    self.delegate = self;
    // 先默认居中placeholder
    // 顺便设置Icon 与 textField 的间距
    if (@available(iOS 13.0, *)) {
        self.searchTextPositionAdjustment = UIOffsetMake(iconSpacing, 0);
        [self setPositionAdjustment:UIOffsetMake((self.textField.frame.size.width - self.placeholderWidth) / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
}




// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 13.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}
    
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    // 没输入文字时占位符居中
    if (textField.text.length == 0) {
        if (@available(iOS 13.0, *)) {
            [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width - self.placeholderWidth) / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
        }
    }
    return YES;
}
    
- (void)cleanOtherSubViews {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    !self.monitorReturnBlock ? : self.monitorReturnBlock(textField.text);
    return YES;
}


#pragma mark - setter & getter
// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}
    
- (UITextField *)textField {
    return [self valueForKey:@"searchField"];
}



@end
