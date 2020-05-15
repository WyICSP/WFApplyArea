//
//  WFShopMallPopUPView.h
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopMallPopUPView : UIView
/**特惠返利统计*/
@property (weak, nonatomic) IBOutlet UIButton *specialStatisticsBut;
/**攻略*/
@property (weak, nonatomic) IBOutlet UIButton *strategyBut;
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
/**水平线*/
@property (weak, nonatomic) IBOutlet UILabel *horizontalLine;


/**操作block  0特惠统计  1攻略*/
@property (nonatomic, copy)void(^operateBlock)(NSInteger type);

/**显示view*/
- (void)popView;
/**取消view*/
- (void)dissmissView;

@end

NS_ASSUME_NONNULL_END
