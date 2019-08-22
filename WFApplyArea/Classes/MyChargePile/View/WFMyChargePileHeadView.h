//
//  WFMyChargePileHeadView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMyChargePileModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyChargePileHeadView : UIView
/**台数*/
@property (weak, nonatomic) IBOutlet UILabel *pileCount;
/**使用率*/
@property (weak, nonatomic) IBOutlet UILabel *rate;

/**赋值*/
@property (nonatomic, strong) WFMyChargePileModel *models;
@end

NS_ASSUME_NONNULL_END
