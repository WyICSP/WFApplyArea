//
//  WFShareWechatView.m
//  WFKit
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShareWechatView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YFMediatorManager.h"
#import "UIView+Frame.h"
#import "SKSafeObject.h"
#import "WKHelp.h"
#import "YFMediatorManager+WFShopMall.h"

@interface WFShareWechatView ()
//商品名
@property (nonatomic, copy, nullable) NSString *title;
//分享的 url
@property (nonatomic, copy, nullable) NSString *shareUrl;
//图片的 url
@property (nonatomic, copy, nullable) NSString *imgURL;
//商品描述
@property (nonatomic, copy, nullable) NSString *desc;
/// 图片
@property (nonatomic, strong, nullable) UIImageView *imgView;
@end

@implementation WFShareWechatView

+ (WFShareWechatView *)shareInstace {
    __strong static WFShareWechatView *shareView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShareWechatView" owner:nil options:nil] firstObject];
    });
    return shareView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (void)disappear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

- (IBAction)clickShareBtn:(UIButton *)sender {
    //取消
    [self disappear];
    
    if (sender.tag == 100) {
        // 微信好友
        [YFMediatorManager shareWechatWithWebpageUrl:self.shareUrl title:self.title description:self.desc thumbImage:self.imgView.image scnce:0];
    }else if (sender.tag == 200) {
        //微信朋友圈
        [YFMediatorManager shareWechatWithWebpageUrl:self.shareUrl title:self.title description:self.desc thumbImage:self.imgView.image scnce:1];
    }
}

#pragma mark get set
- (void)setDict:(NSDictionary *)dict {
    //商品名
    self.title = [NSString stringWithFormat:@"%@",[dict safeJsonObjForKey:@"title"]];
    //分享的 url
    self.shareUrl = [NSString stringWithFormat:@"%@",[dict safeJsonObjForKey:@"shareUrl"]];
    //商品图
    self.imgURL = [NSString stringWithFormat:@"%@",[dict safeJsonObjForKey:@"imgURL"]];
    //商品描述
    self.desc = [NSString stringWithFormat:@"%@",[dict safeJsonObjForKey:@"desc"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURL] placeholderImage:[UIImage imageNamed:@"shareIcon"]];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}


@end
