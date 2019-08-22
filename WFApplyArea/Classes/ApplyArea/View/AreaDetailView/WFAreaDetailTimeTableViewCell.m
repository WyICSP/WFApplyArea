//
//  WFAreaDetailTimeTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailTimeTableViewCell.h"
#import "WFBilleMethodCollectionViewCell.H"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@interface WFAreaDetailTimeTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
@end

@implementation WFAreaDetailTimeTableViewCell

static NSString *const cellId = @"WFAreaDetailTimeTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailTimeTableViewCell" owner:nil options:nil] firstObject];
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

- (void)bindToCell:(NSArray<WFAreaDetailBillingInfosModel *> *)billDatas
        cellHeight:(CGFloat)cellHeight {
    self.billDatas = billDatas;
    self.cellHeight = cellHeight;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.billDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFBilleMethodCollectionViewCell *cell = [WFBilleMethodCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.dModel = self.billDatas[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return KHeight(10.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 12.0f);
}

#pragma mark get set
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((ScreenWidth-24.0f-KWidth(48.0f))/3, KHeight(32.0f));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-24.0f, self.cellHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"WFBilleMethodCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"WFBilleMethodCollectionViewCell"];
        [self.contentsView addSubview:_collectionView];
    }
    return _collectionView;
}

@end
