//
//  WFInputWriteOffView.h
//  AFNetworking
//
//  Created by 王宇 on 2019/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFInputWriteOffView : UIView
/// contentview
@property (weak, nonatomic) IBOutlet WFInputWriteOffView *contentsView;
/// 电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/// 核销码
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
/// 返回数据
@property (copy, nonatomic) void(^btnClickBlock)(NSInteger tag,NSDictionary *inputInfo);
@end

NS_ASSUME_NONNULL_END
