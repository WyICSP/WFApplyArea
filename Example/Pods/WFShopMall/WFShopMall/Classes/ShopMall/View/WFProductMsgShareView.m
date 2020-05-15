//
//  WFProductMsgShareView.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/10.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFProductMsgShareView.h"
#import "WFIssuingVoucherView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YFMediatorManager+WFShopMall.h"
#import "WFProductListModel.h"
#import "UIImage+LXQRCode.h"
#import "WFShopMallShareTool.h"
#import "AttributedLbl.h"
#import "UIView+Frame.h"
#import "YFKeyWindow.h"
#import "UserData.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFProductMsgShareView ()
/// 发券
@property (nonatomic, strong, nullable) WFIssuingVoucherView *issuVoucherView;
@end

@implementation WFProductMsgShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsView.layer.cornerRadius = 10.0f;
    self.imgView.layer.cornerRadius = 10.0f;
    SKViewsBorder(self.coupon, 3, 0.5, NavColor);
}
- (IBAction)clickBtn:(UIButton *)sender {
    
    if (sender.tag != 60)
        !self.clickApperBlock ? : self.clickApperBlock();
    
    //分享地址
    NSString *shareUrl = [NSString stringWithFormat:@"%@&shareBatchCode=%@&shareUUID=%@",self.model.shareUrl,self.model.shareTicketId,USER_UUID];
    //多少元导购券
    NSString *cPrice = [NSString stringWithFormat:@"¥%@元优惠券, 限量抢购",@(self.model.ticketAmount.integerValue/100.0f)];
    //描述
    NSString *description = [self.model.ticketId isEqualToString:@"0"] ? @"我在云智充发现一样好东西, 快来看看吧~" : cPrice;
    if (sender.tag == 10) {
        //微信好友
        [YFMediatorManager shareWechatWithWebpageUrl:shareUrl title:self.model.title description:description thumbImage:self.imgView.image scnce:0];
    }else if (sender.tag == 20) {
        //微信朋友圈
        [YFMediatorManager shareWechatWithWebpageUrl:shareUrl title:self.model.title description:description thumbImage:self.imgView.image scnce:1];
    }else if (sender.tag == 30) {
        //复制链接
        [WFShopMallShareTool copyByContentText:shareUrl resultBlock:^{
            [YFToast showMessage:@"复制成功" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }];
    }else if (sender.tag == 40) {
        //保存图片
        UIImage *image = [WFShopMallShareTool screenshotForView:self.contentsView];
        self.contentsView.backgroundColor = UIColor.clearColor;
        [WFShopMallShareTool saveImageToAlbumWithUrls:@[image]];
    }else if (sender.tag == 50) {
        //取消
    }else if (sender.tag == 60) {
        //充点券
        self.issuVoucherView.hidden = NO;
    }
}

#pragma mark get set
- (WFIssuingVoucherView *)issuVoucherView {
    if (!_issuVoucherView) {
        _issuVoucherView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFIssuingVoucherView" owner:nil options:nil] firstObject];
        _issuVoucherView.frame = self.bounds;
        _issuVoucherView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        [self addSubview:_issuVoucherView];
    }
    return _issuVoucherView;
}

- (void)setModel:(WFProductListModel *)model {
    _model = model;
    //商品图
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.pictUrl] placeholderImage:[UIImage imageNamed:@"pfang"]];
    //商品名
    self.name.text = model.title;
    //优惠券
    self.coupon.text = [NSString stringWithFormat:@"  购买立减%@元  ",@(model.ticketAmount.integerValue/100.0f)];
    //商品价格
    NSString *price = [NSString stringWithFormat:@"¥ %@",@(model.couponAfterPrice.integerValue/100.0f)];
    [AttributedLbl setRichTextOnlyFont:self.price titleString:price textFont:[UIFont boldSystemFontOfSize:12] fontRang:NSMakeRange(0, 1)];
    //二维码
    NSString *shareUrl = [NSString stringWithFormat:@"%@&shareBatchCode=%@&shareUUID=%@",self.model.shareUrl,self.model.shareTicketId,USER_UUID];
    UIImage *image = [UIImage LX_ImageOfQRFromURL:shareUrl codeSize:75.0f];
    self.qrCode.image = image;
        
}

@end
