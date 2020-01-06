//
//  WFSingleFeeUnifiedView.h
//  AFNetworking
//
//  Created by 王宇 on 2019/12/25.
//

#import <UIKit/UIKit.h>

@class WFDefaultChargeFeeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFSingleFeeUnifiedView : UIView
/// contentsView
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 按钮
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
///title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 价格
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
/// 时间
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
/// 价格 view
@property (weak, nonatomic) IBOutlet UIView *priceView;
///  时间 view
@property (weak, nonatomic) IBOutlet UIView *timeView;
/// 点击操作
@property (copy, nonatomic) void (^clickSectionBlock)(NSInteger index);
/// 刷新功率不同的数据 time 时间 type 1 价格, 2 时间 price 价格
@property (copy, nonatomic) void (^reloadTimePriceBlock)(NSInteger time,NSInteger type,NSNumber *price);
/**赋值操作*/
@property (nonatomic, strong) WFDefaultChargeFeeModel *model;
@end

NS_ASSUME_NONNULL_END
