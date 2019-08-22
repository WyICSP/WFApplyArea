//
//  WFEditAreaContentView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/17.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFEditAreaContentView : UIView
/**单次收费*/
@property (weak, nonatomic) IBOutlet UIView *singleView;
/**单次Contentview*/
@property (weak, nonatomic) IBOutlet UIView *singleContentView;
/**功率收费还是统一收费*/
@property (weak, nonatomic) IBOutlet UILabel *singleTitle;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *sUnliPrice;
/**销售价*/
@property (weak, nonatomic) IBOutlet UILabel *sSalesPrice;
/**单次收费的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleHeight;
/**父视图*/
@property (nonatomic, weak) UIViewController *superVC;
/**多次收费*/
@property (weak, nonatomic) IBOutlet UIView *manyTimeView;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *manyTitle;
/**多次Contentview*/
@property (weak, nonatomic) IBOutlet UIView *manyContentView;
/**多次收费描述*/
@property (weak, nonatomic) IBOutlet UIView *manyDataView;
@property (weak, nonatomic) IBOutlet UILabel *manyTimesTitle;
/**多次收费的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manyHeight;
/**最外一层*/
@property (weak, nonatomic) IBOutlet UIView *manyBaseView;

/**优惠收费*/
@property (weak, nonatomic) IBOutlet UIView *vipView;
/**优惠*/
@property (weak, nonatomic) IBOutlet UIView *vipContentView;
/**数据*/
@property (nonatomic, strong) WFAreaDetailModel *mainModel;

@property (weak, nonatomic) IBOutlet UILabel *vipTitle;
/**单价*/
@property (weak, nonatomic) IBOutlet UILabel *vUnliPrice;
/**销售价*/
@property (weak, nonatomic) IBOutlet UILabel *vSalesPrice;
/**优惠收费的高度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipHeight;
/**最外一层*/
@property (weak, nonatomic) IBOutlet UIView *vipBaseView;

@property (nonatomic, copy) void (^jumpCtrlBlock)(UIViewController *ctrl);

@end

NS_ASSUME_NONNULL_END
