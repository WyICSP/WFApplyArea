//
//  WFBilleMethodCollectionReusableView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodCollectionReusableView.h"

@implementation WFBilleMethodCollectionReusableView

static NSString *const rId = @"WFBilleMethodCollectionReusableView";

+ (instancetype)reusableViewWithCollectionView:(UICollectionView *)collevtionView indexPath:(NSIndexPath *)indexPath {
    WFBilleMethodCollectionReusableView *headView = [collevtionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:rId forIndexPath:indexPath];
    if (headView == nil) {
        headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodCollectionReusableView" owner:nil options:nil] firstObject];
    }
    return headView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
