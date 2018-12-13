//
//  ManagerPresetVC.m
//  DSP
//
//  Created by hk on 2018/6/22.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "ManagerPresetVC.h"

@interface ManagerPresetVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;

@end

@implementation ManagerPresetVC

- (IBAction)saveClick:(id)sender {
//    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
//    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
//
//
//    } withConfirmClick:^{
//        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:DeviceToolShare.managerPreset%6 withData1Int:DeviceToolShare.managerPreset/6];
//
//    } withTitle:@"Save current settings or not"];
    
    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:ManagerPreset withCount:0 withData0Int:DeviceToolShare.managerPreset%6 withData1Int:DeviceToolShare.managerPreset/6];
        
        [self refresh];
    } withTitle:@"Loading current settings or not?"];
}

-(void)refresh{
//    SocketManagerShare.AckCurUiIdParameterNeedSecond = NO;
    SocketManagerShare.ChlevelNeedRefresh = YES;
    SocketManagerShare.ChDelayNeedRefresh = YES;
    SocketManagerShare.CrossoverNeedRefresh = YES;
    SocketManagerShare.EQNeedRefresh = YES;
    [SocketManagerShare sendTwoDataTipWithType:AckCurUiIdParameter withCount:maxCount withData0Int:1 withData1Int:1];
}

- (IBAction)upClick:(id)sender {
    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
        
        
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:UpPresetAdr withCount:0 withData0Int:DeviceToolShare.managerPreset%6 withData1Int:DeviceToolShare.managerPreset/6];
        
    } withTitle:@"Up current settings or not"];
}
- (IBAction)delectClick:(id)sender {
    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:DeletePresetAdr withCount:0 withData0Int:DeviceToolShare.managerPreset%6 withData1Int:DeviceToolShare.managerPreset/6];
        
    } withTitle:@"Delete current settings or not"];
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)compileClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    if (but.selected) {
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.hidden = NO;
                UITextField *tf = (UITextField *)view;
                tf.text = [AppData managerAWithTag:view.tag];
            }
            if((view.tag >= 100 && view.tag <= 105)
               || (view.tag >= 200 && view.tag <= 205)
               || (view.tag >= 300 && view.tag <= 305)
               || (view.tag >= 400 && view.tag <= 405)
               ){
                view.hidden = YES;
            }
        }
    }else{
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.hidden = YES;
                
                UITextField *tf = (UITextField *)view;
                [AppData setManagerAWithTag:tf.tag String:tf.text];
            }
            if((view.tag >= 100 && view.tag <= 105)
               || (view.tag >= 200 && view.tag <= 205)
               || (view.tag >= 300 && view.tag <= 305)
               || (view.tag >= 400 && view.tag <= 405)
               ){
                view.hidden = NO;
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *but = (UIButton *)view;
                     UITextField *tf = (UITextField *)[self.view viewWithTag:but.tag + 400];
//                    NSString *butText = [AppData managerAWithTag:(view.tag + 400)];
                    NSString *butText = tf.text;
                    [but setTitle:butText forState:UIControlStateNormal];
                    [but setTitle:butText forState:UIControlStateSelected];
                }
            }
        }
    } 
}
- (IBAction)setButtonClick:(id)sender {
    UIButton *but = (UIButton *)sender;
    
    if (but.selected) {
        but.selected = !but.selected;
    }else{
        but.selected = !but.selected;
        for (UIButton *butt in self.view.subviews) {
            if ((butt.tag >= 100 && butt.tag <= 105)
                || (butt.tag >= 200 && butt.tag <= 205)) {
                if (![butt isEqual:but]) {
                    butt.selected = NO;
                }
            }
        }
    }
    DeviceToolShare.managerPreset =  but.tag%100 + 6 *(but.tag/100-1);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (isIphoneX) {
        self.VCBottomConstraint.constant = kTabBarHeight;
        self.naviBarHeight.constant = kTopHeight;
    }
    DISPATCH_ON_MAIN_THREAD((^{
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.hidden = YES;
            }
            if((view.tag >= 100 && view.tag <= 105)
               || (view.tag >= 200 && view.tag <= 205)
               
               ){
                view.hidden = NO;
                UIButton *but = (UIButton *)view;
                NSString *butText = [AppData managerAWithTag:(view.tag + 400)];
                [but setTitle:butText forState:UIControlStateNormal];
                [but setTitle:butText forState:UIControlStateSelected];
            }
        }
    }))
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
