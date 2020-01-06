//
//  WFGatewayListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/21.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFGatewayListTableViewCell.h"
#import "WFPileItemCollectionViewCell.h"
#import "WFGatewayListModel.h"
#import "WKHelp.h"

@interface WFGatewayListTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WFGatewayListTableViewCell

static NSString *const cellId = @"WFGatewayListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFGatewayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFGatewayListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;

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

- (void)setModel:(WFGatewayLoarListModel *)model {
    _model = model;
    self.selectBtn.selected = model.isSelect;
    self.title.text = [NSString stringWithFormat:@"设备: %@  %@",model.cdzCode,model.letter];
    
    [self.collectionView reloadData];
}


- (IBAction)clickSelectBtn:(UIButton *)sender {
    if (sender.tag == 200) {
        self.model.isOpen = !self.model.isOpen;
        //显示与隐藏子设备
        self.itemVieqHeight.constant = self.model.isOpen ? 116.0f : CGFLOAT_MIN;
    }
    !self.selectItemBlock ? : self.selectItemBlock(sender.tag,sender.selected);
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.socketParamVOList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFPileItemCollectionViewCell *cell = [WFPileItemCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.sModel = self.model.socketParamVOList[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
