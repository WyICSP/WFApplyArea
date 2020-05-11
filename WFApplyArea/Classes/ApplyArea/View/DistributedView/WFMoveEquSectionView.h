//
//  WFMoveEquSectionView.h
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMoveEquSectionView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
/// 搜索关键字
@property (copy, nonatomic) void (^searchResultBlock)(NSString *searchKeys);
@end

NS_ASSUME_NONNULL_END
