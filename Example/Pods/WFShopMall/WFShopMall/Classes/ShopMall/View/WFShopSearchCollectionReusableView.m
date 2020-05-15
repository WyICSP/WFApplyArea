//
//  WFShopSearchCollectionReusableView.m
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShopSearchCollectionReusableView.h"

@implementation WFShopSearchCollectionReusableView

static NSString *const rId = @"WFShopSearchCollectionReusableView";

+ (instancetype)reusableViewWithCollectionView:(UICollectionView *)collevtionView indexPath:(NSIndexPath *)indexPath {
    WFShopSearchCollectionReusableView *headView = [collevtionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:rId forIndexPath:indexPath];
    if (headView == nil) {
        headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopSearchCollectionReusableView" owner:nil options:nil] firstObject];
    }
    return headView;
}

- (IBAction)clickDeleteBtn:(id)sender {
    !self.deleteHistoryRecordBlock ? : self.deleteHistoryRecordBlock();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
