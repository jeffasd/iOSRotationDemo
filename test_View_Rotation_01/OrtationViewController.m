//
//  OrtationViewController.m
//  test_View_Rotation_01
//
//  Created by cdd on 2017/7/7.
//  Copyright © 2017年 jeffasd. All rights reserved.
//

#import "OrtationViewController.h"
#import "Masonry.h"

@interface OrtationViewController ()

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation OrtationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.bottomBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.top.left.mas_equalTo(20);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.bottom.offset(0);
        make.centerX.offset(0);
    }];
}

#pragma mark - btn action
- (void)closeBtnAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bottomBtnAction:(UIButton *)sender{
    NSLog(@"func -> %s", __func__);
}

#pragma mark - get/set
- (UIButton *)closeBtn{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _closeBtn;
}

- (UIButton *)bottomBtn{
    if (_bottomBtn == nil) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = [UIColor redColor];
        [_bottomBtn setTitle:@"底部按钮" forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _bottomBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
