//
//  JFControllerView.m
//  ChangeOrientation
//
//  Created by cdd on 2017/7/7.
//  Copyright © 2017年 Haley. All rights reserved.
//

#import "JFControllerView.h"
#import "Masonry.h"

//static int invokingCount = 0;

@interface JFControllerView ()

@property (nonatomic, strong) UIButton *clickBtn;

@end

@implementation JFControllerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.clickBtn];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@66);
        make.right.offset(0);
        make.bottom.offset(-44);
    }];
}

#if 0
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"pointInside point is %@", NSStringFromCGPoint(point));
    NSLog(@"pointInside event is %@", event);
    
    return [super pointInside:point withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (invokingCount == 1) {
        invokingCount = 0;
//        return nil;
    }
    
//    if (invokingCount == 0) {
//        //invokingCount = 0;
//        invokingCount++;
//        //return nil;
//    }
    
    invokingCount++;
    
    NSLog(@"hitTest point is %@", NSStringFromCGPoint(point));
    NSLog(@"hitTest event is %@", event);
    
    UIView *view = [super hitTest:point withEvent:event];
    
    NSArray<__kindof UIGestureRecognizer *> *gestureRecognizers = view.gestureRecognizers;
    
    NSLog(@"view is %@", view);
    NSLog(@"gestureRecognizers is %@", gestureRecognizers);
    
    for (UIGestureRecognizer *gesture in gestureRecognizers) {

        CGPoint touchPoint = [gesture locationInView:gesture.view];
        CGPoint touchPointInKeyWindow = [gesture locationInView:nil];
        NSLog(@"touchPoint is %@", NSStringFromCGPoint(touchPoint));
        NSLog(@"touchPointInKeyWindow is %@", NSStringFromCGPoint(touchPointInKeyWindow));
    }
    
//    CGPoint touchPoint = [gesture locationInView:gesture.view];
//    CGPoint touchPointInKeyWindow = [gesture locationInView:nil];
//    NSLog(@"touchPoint is %@", NSStringFromCGPoint(touchPoint));
//    NSLog(@"touchPointInKeyWindow is %@", NSStringFromCGPoint(touchPointInKeyWindow));
    
    return view;
//    return self;
}
#endif

+ (BOOL)isNeedAdaptiveiOS8Rotation{
    NSArray<NSString *> *versionStrArr = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    NSLog(@"versionArr is %@", versionStrArr);
    
    int firstVer = [[versionStrArr objectAtIndex:0] intValue];
    int secondVer = [[versionStrArr objectAtIndex:1] intValue];
    
    if (firstVer == 8) {
        if (secondVer >= 1 && secondVer <= 3) {
            return YES;
        }
    }
    
    return NO;
}

/**
 //对于iOS8.1 - iOS8.3版本使用
 [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
 导致home键后半部点击区域不响应的解决办法。
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL isNeedAdaptiveiOS8 = [[self class] isNeedAdaptiveiOS8Rotation];
    
    UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //对于iOS8.1 - iOS8.3版本 当点击按钮位于home键的下半区域时不响应点击事件，因此只需要处理不响应的情况即可
    BOOL isNeedJudge = currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
    
    if (isNeedAdaptiveiOS8 && isNeedJudge) {
        CGPoint btnPoint = [self convertPoint:point toView:self.clickBtn];
        if ([self.clickBtn pointInside:btnPoint withEvent:event]) {
            //点击区域在clickBtn上
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf clickBtnAction:self.clickBtn];
            });
            weakSelf.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.userInteractionEnabled = YES;
            });
            return self.clickBtn;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    NSLog(@"point is %@", NSStringFromCGPoint(point));
}

/**
 //对于iOS8.1 - iOS8.3版本使用
 [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
 来设置屏幕的旋转方向会导致按钮位于home键下半部时不响应点击事件。
 需要在hitTest函数内将坐标点重定向到clickBtn上。
 */
- (void)clickBtnAction:(UIButton *)sender{
    NSLog(@"点击");
}

#pragma mark - get/set
- (UIButton *)clickBtn{
    if (_clickBtn == nil) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor redColor];
        [_clickBtn setTitle:@"点击" forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _clickBtn;
}

@end
