//
//  WFChargePileSearchView.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFChargePileSearchView : UIView <UITextFieldDelegate>
/// contentsViews
@property (weak, nonatomic) IBOutlet UIView *contentsView;
///  title
@property (weak, nonatomic) IBOutlet UILabel *title;
///  数量
@property (weak, nonatomic) IBOutlet UILabel *count;
/// 输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;
/// 搜索结果
@property (nonatomic, copy) void (^searchResultBlock)(NSString *searchKeys);
@end

NS_ASSUME_NONNULL_END
