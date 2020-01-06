//
//  WFSearchBar.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/21.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WFSearchBar : UISearchBar
    
// searchBar的textField
@property (nonatomic, weak) UITextField *textField;
/// 监听搜索的关键字
@property (nonatomic, copy) void (^monitorReturnBlock)(NSString *searchKeys);
/**
 清除搜索条以外的控件
 */
- (void)cleanOtherSubViews;
@end

NS_ASSUME_NONNULL_END
