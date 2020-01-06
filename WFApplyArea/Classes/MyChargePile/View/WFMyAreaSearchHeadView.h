//
//  WFMyAreaSearchHeadView.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaSearchHeadView : UIView <UITextFieldDelegate>
/// 背景 view
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;
/// 搜索关键字
@property (copy, nonatomic) void (^searchResultBlock)(NSString *searchKeys);

@end

NS_ASSUME_NONNULL_END
