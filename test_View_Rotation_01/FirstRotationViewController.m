//
//  FirstRotationViewController.m
//  test_View_Rotation_01
//
//  Created by jeffasd on 2017/7/7.
//  Copyright © 2017年 jeffasd. All rights reserved.
//

#import "FirstRotationViewController.h"
#import "Masonry.h"
#import "JFControllerView.h"

@interface FirstRotationViewController ()

@property (nonatomic, assign) BOOL isSupportOrientation;

@end

@implementation FirstRotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isSupportOrientation = NO;
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.title = @"自动旋屏";
    
//    UIWebView *webView = [UIWebView new];
//    [self.view addSubview:webView];
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//    }];
//    NSURL *url = [NSURL URLWithString:@"https://www.newdesk.cn/landing3?param=bdxin"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:urlRequest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 尝试将屏幕方向调整为和设备在同一个方向
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isSupportOrientation = YES;
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

/**
 假设当前的 interface orientation 只支持 Portrait。
 如果 device orientation 变成 Landscape，那么 interface orientation 仍然显示 Portrait；
 如果这时我们希望 interface orientation 也变成和 device orientation 一致的 Landscape，
 以iOS 6 为例，需要先将 supportedInterfaceOrientations 的返回值改成Landscape，然后调用 attemptRotationToDeviceOrientation方法，系统会重新询问支持的 interface orientation，已达到立即更改当前 interface orientation 的目的。
 */

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //return UIInterfaceOrientationMaskPortrait;
    
    if (self.isSupportOrientation == NO) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
