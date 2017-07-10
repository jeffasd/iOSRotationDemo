//
//  ViewController.m
//  test_View_Rotation_01
//
//  Created by jeffasd on 2017/7/7.
//  Copyright © 2017年 jeffasd. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "FirstRotationViewController.h"
#import "SecondRotationViewController.h"
#import "ThreeRotationViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *firstRotationBtn;
@property (nonatomic, strong) UIButton *secondRotationBtn;
@property (nonatomic, strong) UIButton *threeRotationBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.view addSubview:self.firstRotationBtn];
    [self.view addSubview:self.secondRotationBtn];
    [self.view addSubview:self.threeRotationBtn];
    
    NSArray<UIButton *> *btnArr = @[self.firstRotationBtn, self.secondRotationBtn, self.threeRotationBtn];
    
    for (UIButton *btn in btnArr) {
        btn.backgroundColor = [UIColor cyanColor];
    }
    
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:50 leadSpacing:100 tailSpacing:100];
    
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.mas_equalTo(250);
    }];

}

#pragma mark - btn action
- (void)rotationOneAction:(UIButton *)sender{
    FirstRotationViewController *firstVC = [FirstRotationViewController new];
    [self presentViewController:firstVC animated:YES completion:nil];
}

- (void)rotationTwoAction:(UIButton *)sender{
    SecondRotationViewController *firstVC = [SecondRotationViewController new];
    [self presentViewController:firstVC animated:YES completion:nil];
}

- (void)rotationThreeAction:(UIButton *)sender{
    ThreeRotationViewController *firstVC = [ThreeRotationViewController new];
    [self presentViewController:firstVC animated:YES completion:nil];
}

#pragma mark - rotation
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - set/get
- (UIButton *)firstRotationBtn{
    if (_firstRotationBtn == nil) {
        _firstRotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstRotationBtn setTitle:@"第1种旋转方法-自动旋屏" forState:UIControlStateNormal];
        [_firstRotationBtn addTarget:self action:@selector(rotationOneAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _firstRotationBtn;
}

- (UIButton *)secondRotationBtn{
    if (_secondRotationBtn == nil) {
        _secondRotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondRotationBtn setTitle:@"第2种旋转方法-强制旋屏" forState:UIControlStateNormal];
        [_secondRotationBtn addTarget:self action:@selector(rotationTwoAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _secondRotationBtn;
}

- (UIButton *)threeRotationBtn{
    if (_threeRotationBtn == nil) {
        _threeRotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_threeRotationBtn setTitle:@"第3种旋转-适配iOS8.1-8.3" forState:UIControlStateNormal];
        [_threeRotationBtn addTarget:self action:@selector(rotationThreeAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _threeRotationBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
