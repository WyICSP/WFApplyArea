//
//  WFBilleMethodTimeTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodTimeTableViewCell.h"
#import "WFBilleMethodCollectionViewCell.h"
#import "WFBilleMethodCollectionReusableView.h"
#import "WFBillMethodModel.h"
#import "WFUpgradeAreaData.h"
#import "UIView+Frame.h"
#import "YFKeyWindow.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFBilleMethodTimeTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
@end

@implementation WFBilleMethodTimeTableViewCell

static NSString *const cellId = @"WFBilleMethodTimeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFBilleMethodTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodTimeTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindToCell:(NSArray<WFBillingTimeMethodModel *> *)models cellHeight:(CGFloat)cellHeight {
    self.models = models;
    self.cellHeight = cellHeight;
    [self.collectionView reloadData];
}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFBilleMethodCollectionViewCell *cell = [WFBilleMethodCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.tModel = self.models[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return KHeight(10.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, KWidth(12.0f), 0.0f, KWidth(12.0f));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //将当前的转态置为相反转态
    WFBillingTimeMethodModel *model = self.models[indexPath.row];
    //升级片区 如果是充满自停, 老片区拥有多次收费 或者优惠收费 必须选择充满自停
    if (model.isDefault == 2 && [WFUpgradeAreaData shareInstance].isExistence && model.isSelect) {
        return;
    }
    model.isSelect = !model.isSelect;
    //选中的数据计数
   NSInteger selectNum = 0;
    for (WFBillingTimeMethodModel *sModel in self.models) {
        if (sModel.isSelect) {
            selectNum ++;
        }
    }
    //最多就 6 条数据
    if (selectNum > 6) {
        WFBillingTimeMethodModel *lastModel =  self.models[indexPath.row];
        lastModel.isSelect = NO;
        [YFToast showMessage:@"最多只能选择6个" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        return;
    }
    
    //将选中的数据添加到数组中
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (WFBillingTimeMethodModel *itemModel in self.models) {
        if (itemModel.isSelect) {
            [array addObject:itemModel];
        }
    }
    
    //发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:@(array.count) forKey:@"dataNum"];
    [YFNotificationCenter postNotificationName:@"MonitorTimeKeys" object:nil userInfo:userInfo];
    
    [collectionView reloadData];
}

#pragma mark get set
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenWidth-KWidth(24.0f)-KWidth(54.0f))/4, KHeight(32.0f));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-KWidth(24.0f), self.cellHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"WFBilleMethodCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"WFBilleMethodCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"WFBilleMethodCollectionReusableView" bundle:[NSBundle bundleForClass:[self class]]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WFBilleMethodCollectionReusableView"];
        [_collectionView setCornerRadiusWithRoundedRect:CGRectMake(0, 0, ScreenWidth-KWidth(24.0f), self.cellHeight) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end
