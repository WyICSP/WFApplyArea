//
//  WFEditAreaDetailViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFEditAreaDetailViewController.h"
#import <MJExtension/MJExtension.h>
#import "WFEditAreaContentView.h"

#import "WFAreaDetailModel.h"
#import "SKSafeObject.h"
#import "WKHelp.h"

@interface WFEditAreaDetailViewController ()
@property (nonatomic, strong, nullable) UIScrollView *scrollView;
/**内容*/
@property (nonatomic, strong, nullable) WFEditAreaContentView *eContentViews;
@end

@implementation WFEditAreaDetailViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"修改收费标准";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        [_scrollView addSubview:self.eContentViews];
    }
    return _scrollView;
}

/**
 contentView

 @return eContentViews
 */
- (WFEditAreaContentView *)eContentViews {
    if (!_eContentViews) {
        _eContentViews = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFEditAreaContentView" owner:nil options:nil] firstObject];
        _eContentViews.mainModel = self.models;
        _eContentViews.superVC = self;
        @weakify(self)
        _eContentViews.jumpCtrlBlock = ^(UIViewController * _Nonnull ctrl) {
            @strongify(self)
            [self.navigationController pushViewController:ctrl animated:YES];
        };
    }
    return _eContentViews;
}

- (void)setModels:(WFAreaDetailModel *)models {
    _models = models;
}


@end
