//
//  WFShopMallShareTool.m
//  AFNetworking
//
//  Created by 王宇 on 2019/10/15.
//

#import "WFShopMallShareTool.h"

#import "YFKeyWindow.h"
#import "YFToast.h"

@implementation WFShopMallShareTool

#pragma mark 保存图片到相册
+ (void)saveImageToAlbumWithUrls:(NSArray *)urls {
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

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [YFToast showMessage:@"保存图片失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }else{
        [YFToast showMessage:@"保存图片成功" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }
}


#pragma mark 复制文本
+ (void)copyByContentText:(NSString *)contentText
              resultBlock:(void(^)(void))resultBlock {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = contentText;
    if ([pasteboard.string isEqualToString:contentText]) {
        resultBlock();
    } else {
        [YFToast showMessage:@"复制失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }
}

#pragma mark 截图
+ (UIImage *)screenshotForView:(UIView *)contentView {
    UIImage *image = nil;
    //判断View类型（一般不是滚动视图或者其子类的话内容不会超过一屏，当然如果超过了也可以通过修改frame来实现绘制）
    if ([contentView.class isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView *scrView = (UIScrollView *)contentView;
        
        CGPoint tempContentOffset = scrView.contentOffset;
        CGRect tempFrame = scrView.frame;
        
        scrView.contentOffset = CGPointZero;
        scrView.frame = CGRectMake(0, 0, scrView.contentSize.width, scrView.contentSize.height);
        
        image = [self screenshotForView:scrView size:scrView.frame.size];
        
        scrView.contentOffset = tempContentOffset;
        scrView.frame = tempFrame;
        
    } else {
        image = [self screenshotForView:contentView size:contentView.frame.size];
    }
    
    return image;
}

+ (UIImage *)screenshotForView:(UIView *)view size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

@end
