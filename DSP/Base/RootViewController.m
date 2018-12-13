//
//  RootViewController.m
//  DSP
//
//  Created by hk on 2018/6/12.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
//动态更新状态栏颜色
//-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
//    _StatusBarStyle=StatusBarStyle;
//    [self setNeedsStatusBarAppearanceUpdate];
//}
#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
