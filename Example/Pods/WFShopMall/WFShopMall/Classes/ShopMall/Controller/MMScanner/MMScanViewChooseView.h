//
//  MMScanViewChooseView.h
//  WFKit
//
//  Created by 王宇 on 2019/5/5.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMScanViewChooseView : UIView
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@property (nonatomic, copy) void(^chooseScanTypeBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
