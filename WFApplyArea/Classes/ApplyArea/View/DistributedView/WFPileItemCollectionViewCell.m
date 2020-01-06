//
//  WFPileItemCollectionViewCell.m
//  AFNetworking
//
//  Created by 王宇 on 2019/11/28.
//

#import "WFPileItemCollectionViewCell.h"
#import "WFMyChargePileModel.h"
#import "WKHelp.h"

@implementation WFPileItemCollectionViewCell

static NSString *const cellId = @"WFPileItemCollectionViewCell";

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath {
    WFPileItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFPileItemCollectionViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.layer.cornerRadius = 10.0f;
    
}

- (void)setSModel:(WFPileSocketParamVOSModel *)sModel {
    self.title.text = [NSString stringWithFormat:@"%ld",(long)sModel.socketNo];
    if (sModel.status == 1) {
        //未充电
        self.title.layer.backgroundColor = UIColorFromRGB(0x52AE82).CGColor;
        self.title.textColor = UIColor.whiteColor;
    }else {
        //在充电
        self.title.layer.backgroundColor = UIColorFromRGB(0xF5F5F5).CGColor;
        self.title.textColor = UIColorFromRGB(0x333333);
    }
}

@end
