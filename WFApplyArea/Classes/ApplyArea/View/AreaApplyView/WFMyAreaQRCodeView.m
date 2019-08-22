//
//  WFMyAreaQRCodeView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaQRCodeView.h"
#import "WFSavePhotoTool.h"
#import "UIImage+QRCode.h"
#import "WKHelp.h"

@implementation WFMyAreaQRCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.layer.cornerRadius = self.topView.layer.cornerRadius = 2.0f;
}

- (IBAction)clickBtn:(id)sender {
    !self.closeCodeViewBlock ? : self.closeCodeViewBlock();
}

- (IBAction)clickSavePhotoBtn:(id)sender {
    [[WFSavePhotoTool shareInstance] saveImageToAlbumWithUrls:@[self.imgView.image]];
    
    __weak typeof(self) weakSelf = self;
    [WFSavePhotoTool shareInstance].savePhotoSuccessBlock = ^{
        !weakSelf.closeCodeViewBlock ? : weakSelf.closeCodeViewBlock();
    };
    [WFSavePhotoTool shareInstance].savePhotoFailBlock = ^{
        !weakSelf.closeCodeViewBlock ? : weakSelf.closeCodeViewBlock();
    };
}

- (void)setImgUrl:(NSString *)imgUrl {
    UIImage *image = [UIImage WY_ImageOfQRFromURL:imgUrl codeSize:ScreenWidth-180.0f];
    self.imgView.image = image;
}


@end
