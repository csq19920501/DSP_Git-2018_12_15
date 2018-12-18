//
//  AppDelegate.m
//  DSP
//
//  Created by hk on 2018/6/12.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "HomeViewController.h"
#import "SocketManager.h"
#import "DeviceTool.h"
#import <Bugly/Bugly.h>
#define BUGLY_APP_ID @"4bb0c0f79c"
@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [NSThread sleepForTimeInterval:1];
    [SocketManagerShare setupSocket];
    [self setGlobalStyle];
    [self setRootLoginVC];
    [self setupBugly];
    
    return YES;
}
-(void)setRootLoginVC{
    self.homeNavi = [[RootNavigationController alloc]initWithRootViewController:[HomeViewController new]];
    //默认开启系统右划返回
    self.homeNavi.interactivePopGestureRecognizer.enabled = YES;
    self.window.rootViewController = self.homeNavi;
}
-(void)setGlobalStyle{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    //设置APP键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    // 背景颜色
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //字体颜色
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
//    //导航栏背景图片
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"标题栏.png"] forBarMetrics:UIBarMetricsDefault];//searchBack  标题栏
    [UINavigationBar appearance].translucent = YES;
    [UINavigationBar appearance].hidden = YES;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SocketManagerShare repeatSel];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [DeviceToolShare saveInfo];
}
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    
    //    #if DEBUG
    //    config.debugMode = YES;
    //    #endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}

@end
