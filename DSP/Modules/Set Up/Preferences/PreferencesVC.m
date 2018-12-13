//
//  PreferencesVC.m
//  DSP
//
//  Created by hk on 2018/6/22.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "PreferencesVC.h"

@interface PreferencesVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *mcuVersion;

@end

@implementation PreferencesVC
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectClick:(id)sender {
    UIButton *but = (UIButton *)sender;
//    but.selected = !but.selected;
    switch (but.tag) {
        case 101:
            {
                UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:101];
                extrnalButton.selected = YES;
                UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:201];
                extrnalButton2.selected = NO;
                DeviceToolShare.ExternalRemodeControl = YES;
                if (self.clickButton) {
                    self.clickButton(External, YES);
                }
                [SocketManagerShare sendTipWithType:ExtControl withCount:0];
            }
            break;
        case 201:
        {
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:101];
            extrnalButton.selected =  NO;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:201];
            extrnalButton2.selected = YES;
            DeviceToolShare.ExternalRemodeControl = NO;
            if (self.clickButton) {
                self.clickButton(External,  NO);
            }
             [SocketManagerShare sendTipWithType:ExtControl withCount:0];
        }
            break;
        case 102:
        {
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:102];
            extrnalButton.selected = YES;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:202];
            extrnalButton2.selected = NO;
            DeviceToolShare.MaxInputLevelAdd6 = NO;
            if (self.clickButton) {
                self.clickButton(MaxInput,  YES);
            }
             [SocketManagerShare sendTipWithType:MaxInputLevel withCount:0];
        }
            break;
        case 202:
        {
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:102];
            extrnalButton.selected =  NO;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:202];
            extrnalButton2.selected = YES;
            DeviceToolShare.MaxInputLevelAdd6 = YES;
            if (self.clickButton) {
                self.clickButton(MaxInput,  NO);
            }
            [SocketManagerShare sendTipWithType:MaxInputLevel withCount:0];
        }
            break;
        case 103:
        {
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:103];
            extrnalButton.selected = YES;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:203];
            extrnalButton2.selected = NO;
            DeviceToolShare.MaxOutputLevelAdd6 = NO;
            if (self.clickButton) {
                self.clickButton(MaxOutput,  NO);
            }
            [SocketManagerShare sendTipWithType:MaxOutputLevel withCount:0];
        }
            break;
        case 203:
        {
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:103];
            extrnalButton.selected =  NO;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:203];
            extrnalButton2.selected = YES;
            DeviceToolShare.MaxOutputLevelAdd6 = YES;
            if (self.clickButton) {
                
                self.clickButton(MaxOutput,  YES);
            }
            [SocketManagerShare sendTipWithType:MaxOutputLevel withCount:0];
        }
            break;
        default:
            break;
    }
    [DeviceToolShare saveInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (isIphoneX) {
        self.naviBarHeight.constant = kTopHeight;
    }
    if (DeviceToolShare.ExternalRemodeControl) {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:101];
        extrnalButton.selected = YES;
    }else {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:201];
        extrnalButton.selected = YES;
    }
    if (DeviceToolShare.MaxInputLevelAdd6) {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:202];
        extrnalButton.selected = YES;
    }else {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:102];
        extrnalButton.selected = YES;
    }
    if (DeviceToolShare.MaxOutputLevelAdd6) {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:203];
        extrnalButton.selected = YES;
    }else {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:103];
        extrnalButton.selected = YES;
    }
    
    self.appVersion.text = [NSString stringWithFormat:@"App Version: %@",appMPVersion];
    self.mcuVersion.text = [NSString stringWithFormat:@"Mcu Version: test%ld.%ld",DeviceToolShare.mcuVersion/10,DeviceToolShare.mcuVersion%10];
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
