//
//  WFShopSearchBarView.h
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopSearchBarView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**搜索事件*/
@property (nonatomic, copy) void (^searchProductsBlock)(BOOL isCancel,NSString *keys);
@end

NS_ASSUME_NONNULL_END
