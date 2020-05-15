//
//  WFShopSearchItemCollectionViewCell.m
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShopSearchItemCollectionViewCell.h"

@interface WFShopSearchItemCollectionViewCell()
@property (nonatomic, assign) CGFloat heightForCell;

@end

@implementation WFShopSearchItemCollectionViewCell


static NSString *const cellId = @"WFShopSearchItemCollectionViewCell";

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath {
    WFShopSearchItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopSearchItemCollectionViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.heightForCell = 30.0f;
    self.itemView.layer.cornerRadius = 3.0f;
    // Initialization code
}



- (void)setSearchKey:(NSString *)searchKey {
    _searchKey = searchKey;
    self.title.text = searchKey;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
}


- (CGSize)sizeForCell {
    //宽度加 heightForCell 为了两边圆角。
    return CGSizeMake([_title sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + self.heightForCell, self.heightForCell);
}

+ (CGSize)getSizeWithText:(NSString*)text;
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 28) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+20, 28);
}

@end
