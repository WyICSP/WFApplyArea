//
//  WFMoveEquHeadView.h
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import <UIKit/UIKit.h>

@class WFRemoveEquModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMoveEquHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) WFRemoveEquModel *model;
@end

NS_ASSUME_NONNULL_END
