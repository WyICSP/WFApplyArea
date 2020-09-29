//
//  WFBilleMethodCollectionViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodCollectionViewCell.h"
#import "WFAreaDetailModel.h"
#import "WFBillMethodModel.h"
#import "WKHelp.h"

@implementation WFBilleMethodCollectionViewCell

static NSString *const cellId = @"WFBilleMethodCollectionViewCell";

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView
                             indexPath:(NSIndexPath *)indexPath {
    WFBilleMethodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodCollectionViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentsView.layer.cornerRadius = KHeight(16.0f);
}

/**
 时间赋值

 @param cmodel 数据
 */
- (void)setTModel:(WFBillingTimeMethodModel *)cmodel {
    self.title.text = cmodel.billingName;
    self.title.textColor = cmodel.isSelect ? UIColor.whiteColor : UIColorFromRGB(0x333333);
    self.contentsView.backgroundColor = cmodel.isSelect ? NavColor : UIColorFromRGB(0xF5F5F5);
    
}

/**
 金额赋值
 
 @param pModel 数据
 */
- (void)setPModel:(WFBillingPriceMethodModel *)pModel {
    self.title.text = pModel.billingName;
    self.title.textColor = pModel.isSelect ? UIColor.whiteColor : UIColorFromRGB(0x333333);
    self.contentsView.backgroundColor = pModel.isSelect ? NavColor : UIColorFromRGB(0xF5F5F5);
}

/**
 片区详情时间或者金额赋值

 @param dModel 数据
 */
- (void)setDModel:(WFAreaDetailBillingInfosModel *)dModel {
    self.title.text = dModel.billingName;
}

@end
