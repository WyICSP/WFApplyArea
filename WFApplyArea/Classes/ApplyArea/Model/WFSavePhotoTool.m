//
//  WFSavePhotoTool.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFSavePhotoTool.h"
#import "UIImage+QRCode.h"
#import "YFKeyWindow.h"
#import "YFToast.h"

@implementation WFSavePhotoTool

+ (instancetype)shareInstance {
    static WFSavePhotoTool *savePhoto = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        savePhoto = [[WFSavePhotoTool alloc] init];
    });
    return savePhoto;
}

#pragma mark 生成二维码
- (UIImage *)imageWithUrl:(NSString *)url
                 codeSize:(CGFloat)codeSize {
    return [UIImage WY_ImageOfQRFromURL:url codeSize:codeSize];
}


#pragma mark 保存图片到相册
- (void)saveImageToAlbumWithUrls:(NSArray *)urls {
    if (urls.count == 0) return;
    NSMutableArray *photos = [NSMutableArray new];
    
    for (UIImage *url in urls) {
        [photos addObject:url];
    }
    
    dispatch_queue_t queue = dispatch_queue_create("intelligentcharge", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < photos.count; i ++) {
            UIImage *image = (UIImage *)photos[i];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [YFToast showMessage:@"保存图片失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        !self.savePhotoSuccessBlock ? : self.savePhotoSuccessBlock();
    }else{
        [YFToast showMessage:@"保存图片成功" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
        !self.savePhotoFailBlock ? : self.savePhotoFailBlock();
    }
}

@end
