//
//  WFProductMsgShareView.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/10.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WFProductListModel;

@interface WFProductMsgShareView : UIView
/// contents
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 商品信息 view
@property (weak, nonatomic) IBOutlet UIView *goodsView;
///  商品图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/// 商品名字
@property (weak, nonatomic) IBOutlet UILabel *name;
/// 优惠券
@property (weak, nonatomic) IBOutlet UILabel *coupon;
/// 二维码
@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
/// 商品价格
@property (weak, nonatomic) IBOutlet UILabel *price;
/// 赋值
@property (nonatomic, strong) WFProductListModel *model;
/// 消失
@property (nonatomic, copy) void (^clickApperBlock)(void);

@end

NS_ASSUME_NONNULL_END
