//
//  WFIssuingVoucherView.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/11.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFIssuingVoucherView : UIView
/// 数量
@property (weak, nonatomic) IBOutlet UITextField *countTF;
///  tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///  确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
/// contentsView
@property (weak, nonatomic) IBOutlet UIView *contentsView;

@end

NS_ASSUME_NONNULL_END
