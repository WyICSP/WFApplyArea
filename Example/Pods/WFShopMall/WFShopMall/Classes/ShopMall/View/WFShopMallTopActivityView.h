//
//  WFShopMallTopActivityView.h
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopMallTopActivityView : UIView
/**image view*/
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
/**点击事件block*/
@property (nonatomic, copy) void(^operateBlock)();

@end

NS_ASSUME_NONNULL_END
