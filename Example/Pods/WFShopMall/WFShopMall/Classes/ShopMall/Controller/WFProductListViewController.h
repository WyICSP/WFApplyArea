//
//  WFProductListViewController.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFProductListViewController : YFBaseViewController
/**搜索关键字*/
@property (nonatomic, copy) NSString *searchKeys;
/**搜索返回值*/
@property (nonatomic, copy) void (^goBackSearchkeysBlock)(NSString *keys);
@end

NS_ASSUME_NONNULL_END
