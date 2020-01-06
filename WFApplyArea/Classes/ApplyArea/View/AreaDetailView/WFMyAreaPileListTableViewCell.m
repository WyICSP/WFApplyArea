//
//  WFMyAreaPileListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaPileListTableViewCell.h"
#import "WFPileItemCollectionViewCell.h"
#import "WFMyChargePileModel.h"
#import "NSString+Regular.h"
#import "WKHelp.h"

@interface WFMyAreaPileListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation WFMyAreaPileListTableViewCell

static NSString *const cellId = @"WFMyAreaPileListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMyAreaPileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaPileListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.yuanView.layer.cornerRadius = 7.0/2;
    
    for (UIImageView *imgView in self.progress.subviews) {
        imgView.layer.cornerRadius = 3;
        imgView.clipsToBounds = YES;
    }
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    flowlayout.itemSize = CGSizeMake((ScreenWidth-50)/6, 46);
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowlayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WFPileItemCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"WFPileItemCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFSignleIntensityListModel *)model {
    _model = model;
    self.shellId.text = model.shellId.length ==  0 ? @" " : model.shellId;
    if (model.shellId.length == 0) 
        self.selectImg.hidden = self.yuanView.hidden = YES;
    //在线 //离线
    self.yuanView.backgroundColor = model.status == 1 ? UIColorFromRGB(0x19B07E) : NavColor;
    //当前文件的 bundle
    NSBundle *currentBundler = [NSBundle bundleForClass:[self class]];
    NSString *imgPath = [NSString getImagePathWithCurrentBundler:currentBundler PhotoName:model.isSelect ? @"selectLogo" : @"unSelect" bundlerName:@"WFApplyArea.bundle"];
    self.selectImg.image = [UIImage imageWithContentsOfFile:imgPath];
    //信号强度
    self.signal.text = [NSString stringWithFormat:@"%ld",(long)model.qos];
    CGFloat pro = model.qos/100.0f;
    [self.progress setProgress:pro];
    
    [self.collectionView reloadData];
}

- (IBAction)clickItemBtn:(UIButton *)sender {
    if (sender.tag == 200) {
        self.model.isOpen = !self.model.isOpen;
        //显示与隐藏子设备
        self.itemViewHeight.constant = self.model.isOpen ? 116.0f : CGFLOAT_MIN;
    }
    !self.selectItemBlock ? : self.selectItemBlock(sender.tag,sender.selected);
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.socketParamVOS.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFPileItemCollectionViewCell *cell = [WFPileItemCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.sModel = self.model.socketParamVOS[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}


@end
