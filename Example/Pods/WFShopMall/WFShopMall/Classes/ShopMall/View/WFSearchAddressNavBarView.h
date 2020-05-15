//
//  WFSearchAddressNavBarView.h
//  WFKit
//
//  Created by 王宇 on 2019/4/19.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFSearchAddressEventType) {
    WFSearchAddressChargeEventType = 0, //充电搜索
    WFSearchAddressProductEventType //商品搜索
};

@interface WFSearchAddressNavBarView : UIView <UITextFieldDelegate>
/**搜索框*/
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**进来的页面*/
@property (nonatomic, assign) WFSearchAddressEventType type;
/**事件处理 block isBack = YES  为返回, 反之为搜索 searchText为搜索的内容*/
@property (nonatomic, copy) void(^searchBarEventBlock)(BOOL isBack,NSString *searchText);
/**商品搜索*/
@property (nonatomic, copy) void (^searchBarBeginEditEventBlock)(BOOL isBack, NSString *searchText);
@end

NS_ASSUME_NONNULL_END
