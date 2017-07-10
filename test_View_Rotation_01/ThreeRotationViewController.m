//
//  ThreeRotationViewController.m
//  test_View_Rotation_01
//
//  Created by cdd on 2017/7/7.
//  Copyright © 2017年 jeffasd. All rights reserved.
//

#import "ThreeRotationViewController.h"
#import "Masonry.h"
#import "JFControllerView.h"

@interface ThreeRotationViewController ()

@property (nonatomic, strong) UIButton *rotationBtn;

@end

@implementation ThreeRotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    JFControllerView *controllerView = [JFControllerView new];
    controllerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:controllerView];
    [controllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.view addSubview:self.rotationBtn];
    [self.rotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(66);
        make.center.offset(0);
    }];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ortationNotifityHandle:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - ortation
- (BOOL)shouldAutorotate{
    return NO;
}

- (CGAffineTransform)getCurrentInterfaceTransform{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    }else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

/**
 注意通过[[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];来设置屏幕旋转会导致
 iOS version 8.1 ~ iOS version 8.3 之间的版本在横屏时出现home键后半部没有响应的情况。
 对于点击事件会导致点击的坐标点不正确，但是对于滑动等手势不会造成影响，滑动拖动等手势一般都是根据相对位移来进行判断的。而点击事件大多都是根据绝对坐标进行判断的。
 解决办法为重写hitTest方法将hitTest的坐标点转移到具有点击事件的视图上。
 请参看JFControllerView的hitTest方法。
 */
#pragma mark - UIDevice Notify
- (void)ortationNotifityHandle:(NSNotification *)notifity{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationUnknown || deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
        deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationFaceDown
        ) {
        return;
    }
    
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationUnknown;
    if (deviceOrientation == UIDeviceOrientationPortrait) {
        interfaceOrientation = UIInterfaceOrientationPortrait;
    }else if (deviceOrientation == UIDeviceOrientationLandscapeLeft){
        interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    }else if (deviceOrientation == UIDeviceOrientationLandscapeRight){
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    }
    
    UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (interfaceOrientation == currentInterfaceOrientation) {
        NSLog(@"已经是正确的方向");
        return;
    }
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"bounds size is %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
    
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || currentInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenHeight);
            make.height.mas_equalTo(screenWidth);
            make.center.offset(0);
        }];
    }
    
    //[[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
    
    CGAffineTransform transform = [self getCurrentInterfaceTransform];
    self.view.transform = transform;
}

#pragma mark - rotationBtnAction
- (void)rotationBtnAction:(UIButton *)sender{
    
    //方法1:
//    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    
//    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//    
//    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(screenHeight);
//        make.height.mas_equalTo(screenWidth);
//        make.center.offset(0);
//    }];
//    
//    CGAffineTransform transform = [self getCurrentInterfaceTransform];
//    self.view.transform = transform;
    
    //方法2:
    //[self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
    //方法3:
    NSNumber *rotation = [NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - get/set
- (UIButton *)rotationBtn{
    if (_rotationBtn == nil) {
        _rotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotationBtn.backgroundColor = [UIColor redColor];
        [_rotationBtn setTitle:@"旋屏按钮" forState:UIControlStateNormal];
        [_rotationBtn addTarget:self action:@selector(rotationBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _rotationBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
