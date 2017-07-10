//
//  SecondRotationViewController.m
//  test_View_Rotation_01
//
//  Created by jeffasd on 2017/7/7.
//  Copyright © 2017年 jeffasd. All rights reserved.
//

#import "SecondRotationViewController.h"
#import "Masonry.h"
#import "JFControllerView.h"

@interface SecondRotationViewController ()

@property (nonatomic, strong) UIButton *rotationBtn;

@end

@implementation SecondRotationViewController

- (void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor yellowColor];
    
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

/**
 注意通过[[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];来设置屏幕旋转不会导致
 iOS version 8.1 ~ iOS version 8.3 之间的版本在横屏时出现home键后半部没有响应的情况，但是回导致设置音量视图
 键盘视图没有正确旋转，同时statusbar也不能正常旋转。
 */
- (void)ortationNotifityHandle:(NSNotification *)notifity{
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationUnknown || deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
        deviceOrientation == UIDeviceOrientationFaceUp || deviceOrientation == UIDeviceOrientationFaceDown
        ) {
        return;
    }

    // [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
    //不会改变[[UIScreen mainScreen] bounds]的大小
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    //会改变[[UIScreen mainScreen] bounds]的大小

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"bounds size is %@", NSStringFromCGSize([[UIScreen mainScreen] bounds].size));
    
//    NSNumber *rotation = [NSNumber numberWithInteger:deviceOrientation];
//    [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
    
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenHeight);
            make.height.mas_equalTo(screenWidth);
            make.center.offset(0);
        }];
    }else if (deviceOrientation == UIDeviceOrientationPortrait){
        [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight);
            make.center.offset(0);
        }];
    }
    
    NSNumber *rotation = [NSNumber numberWithInteger:deviceOrientation];
    [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
    
    CGAffineTransform transform = [self getCurrentDeviceTransform];
    self.view.transform = transform;
}

- (CGAffineTransform)getCurrentDeviceTransform{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait) {
        return CGAffineTransformIdentity;
    }else if (orientation == UIDeviceOrientationLandscapeLeft){
        //return CGAffineTransformMakeRotation(-M_PI_2);
        return CGAffineTransformMakeRotation(M_PI_2);
    }else if (orientation == UIDeviceOrientationLandscapeRight){
        //return CGAffineTransformMakeRotation(M_PI_2);
        return CGAffineTransformMakeRotation(-M_PI_2);
    }
    return CGAffineTransformIdentity;
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

#pragma mark - rotationBtnAction
- (void)rotationBtnAction:(UIButton *)sender{
    
    //手动旋屏方法1:
//    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
//    return;
    
    //手动旋屏方法2:
//    NSNumber *rotation = [NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screenHeight);
        make.height.mas_equalTo(screenWidth);
        make.center.offset(0);
    }];
    
    NSNumber *rotation = [NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:rotation forKey:@"orientation"];
    
    CGAffineTransform transform = [self getCurrentDeviceTransform];
    self.view.transform = transform;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
