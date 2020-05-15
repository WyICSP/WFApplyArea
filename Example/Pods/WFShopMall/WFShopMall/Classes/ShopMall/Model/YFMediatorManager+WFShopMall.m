//
//  YFMediatorManager+WFShopMall.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "YFMediatorManager+WFShopMall.h"

@implementation YFMediatorManager (WFShopMall)

+ (void)shareWechatWithWebpageUrl:(NSString *)webpageUrl
                            title:(NSString *)title
                      description:(NSString *)description
                       thumbImage:(UIImage *)thumbImage
                            scnce:(NSInteger)scnce {
    NSArray *pamrs = @[webpageUrl,title,description,thumbImage,@(scnce)];
    [self performTarget:@"WFPayPublicAPI" action:@"shareWechatWithWebpageUrlWithParams:" params:pamrs isRequiredReturnValue:NO];
}



@end
