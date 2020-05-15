//
//  WFProductListModel.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFProductListModel : NSObject
/// 图片链接
@property (nonatomic, copy) NSString *pictUrl;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 店铺名称
@property (nonatomic, copy) NSString *storeName;
/// 导购券id
@property (nonatomic, copy) NSString *ticketId;
/// 商品名称
@property (nonatomic, copy) NSString *title;
/// 当前价
@property (nonatomic, strong) NSNumber *couponAfterPrice;
/// 商品原价
@property (nonatomic, strong) NSNumber *oriPrice;
/// 分享赚红包
@property (nonatomic, strong) NSNumber *shareTicketAmount;
///导购券金额
@property (nonatomic, strong) NSNumber *ticketAmount;
/// 分享的 url
@property (nonatomic, copy) NSString *shareUrl;
///  分享的ticketId
@property (nonatomic, copy) NSString *shareTicketId;
@end

NS_ASSUME_NONNULL_END
