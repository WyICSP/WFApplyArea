//
//  WFIssuingVoucherView.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/11.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFIssuingVoucherView.h"
#import "WFIssuingCircleTableViewCell.h"
#import "WKHelp.h"

@interface WFIssuingVoucherView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WFIssuingVoucherView

#pragma mark 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentsView.layer.cornerRadius = 10.0f;
    self.confirmBtn.layer.cornerRadius = 20.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.rowHeight = KHeight(93.0f);
}

#pragma mark 私有方法
- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag == 100) {
        //确定
    }else if (sender.tag == 200) {
        //取消
        self.hidden = YES;
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFIssuingCircleTableViewCell *cell = [WFIssuingCircleTableViewCell cellWithTableView:tableView];
    return cell;
}



@end
