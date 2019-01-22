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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spdifOutHeight;

@end

@implementation PreferencesVC
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeColor:(id)sender {
    UIButton * but = (UIButton *)sender;
    if (but.selected) {
        return;
    }
    NSInteger tag = but.tag;
    
//    int a = tag%10;
//    BOOL isSelect = NO;
//    for (int i = 0; i < 4; i++) {
//        int b =  500 + 10 * i + a;
//        UIButton *colorBut = (UIButton *)[self.view viewWithTag:b];
//        if (colorBut.selected) {
//            isSelect = YES;
//        }
//    }
//    if (isSelect) {
//        return;
//    }
    for (int j = 0; j < 4; j++) {
        if(tag >= 501 + j * 10 && tag <= 505 + j * 10){
            for (int i = 501 + j * 10; i <= 505 + j * 10; i++) {
                UIButton *colorBut =(UIButton  *)[self.view viewWithTag:i];
                colorBut.selected = NO;
            }
            but.selected = YES;
            switch (j) {
                case 0:
                    {
                        DeviceToolShare.colorMain = tag - 501;
                        NSMutableString *tipStr = [NSMutableString string];
                        [tipStr appendFormat:@"00%@",colorMainAdr];
                        [tipStr appendFormat:@"%@",[SocketManager stringWithHexNumber:DeviceToolShare.colorMain + 1]];
                        [SocketManagerShare seneTipWithType:colorMainType WithStr:tipStr Count:0];
                    }
                    break;
                case 1:
                {
                    DeviceToolShare.colorSub = tag - 511;
                    
                    NSMutableString *tipStr = [NSMutableString string];
                    [tipStr appendFormat:@"00%@",colorSubAdr];
                    [tipStr appendFormat:@"%@",[SocketManager stringWithHexNumber:DeviceToolShare.colorSub + 1]];
                    [SocketManagerShare seneTipWithType:colorSubType WithStr:tipStr Count:0];
                }
                    break;
                case 2:
                {
                    DeviceToolShare.colorMemoryA = tag - 521;
                    NSMutableString *tipStr = [NSMutableString string];
                    [tipStr appendFormat:@"00%@",colorMemoryAAdr];
                    [tipStr appendFormat:@"%@",[SocketManager stringWithHexNumber:DeviceToolShare.colorMemoryA + 1]];
                    [SocketManagerShare seneTipWithType:colorMemoryAType WithStr:tipStr Count:0];
                }
                    break;
                case 3:
                {
                    DeviceToolShare.colorMemoryB = tag - 531;
                    
                    NSMutableString *tipStr = [NSMutableString string];
                    [tipStr appendFormat:@"00%@",colorMemoryBAdr];
                    [tipStr appendFormat:@"%@",[SocketManager stringWithHexNumber:DeviceToolShare.colorMemoryB + 1]];
                    [SocketManagerShare seneTipWithType:colorMemoryBType WithStr:tipStr Count:0];
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
    }
    
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
                [self changeColorButEnable];
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
            [self changeColorButEnable];
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
        case 104:{
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:104];
            extrnalButton.selected =  YES;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:204];
            extrnalButton2.selected = NO;
            DeviceToolShare.SpdifOutBool = YES;
            [SocketManagerShare sendTipWithType:spdifOutType withCount:0];
        }break;
        case 204:{
            UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:104];
            extrnalButton.selected =  NO;
            UIButton *extrnalButton2 = (UIButton *)[self.view viewWithTag:204];
            extrnalButton2.selected = YES;
            DeviceToolShare.SpdifOutBool = NO;
            [SocketManagerShare sendTipWithType:spdifOutType withCount:0];
        }break;
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
    if (DeviceToolShare.deviceType == BH_A180) {
        _spdifOutHeight.constant = 0;
        UIButton *but1 = (UIButton *)[self.view viewWithTag:104];
        but1.enabled = NO;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:204];
        but2.enabled = NO;
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
    if (DeviceToolShare.SpdifOutBool) {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:104];
        extrnalButton.selected = YES;
    }else {
        UIButton *extrnalButton = (UIButton *)[self.view viewWithTag:204];
        extrnalButton.selected = YES;
    }
    
    UIButton *colorButton = (UIButton *)[self.view viewWithTag:DeviceToolShare.colorMain + 501];
    colorButton.selected = YES;
    UIButton *colorButton2 = (UIButton *)[self.view viewWithTag:DeviceToolShare.colorSub + 511];
    colorButton2.selected = YES;
    UIButton *colorButton3 = (UIButton *)[self.view viewWithTag:DeviceToolShare.colorMemoryA + 521];
    colorButton3.selected = YES;
    UIButton *colorButton4 = (UIButton *)[self.view viewWithTag:DeviceToolShare.colorMemoryB + 531];
    colorButton4.selected = YES;
    
    
    [self changeColorButEnable];
    
    
    
    self.appVersion.text = [NSString stringWithFormat:@"App Version: %@",appMPVersion];
    self.mcuVersion.text = [NSString stringWithFormat:@"Mcu Version: test%ld.%ld",DeviceToolShare.mcuVersion/10,DeviceToolShare.mcuVersion%10];
    
}
-(void)changeColorButEnable{
   
        for (int j = 0; j < 4; j++) {
            for (int i = 1; i <= 5; i++) {
                UIButton *colBut = (UIButton *)[self.view viewWithTag:500 + j * 10 + i];
                colBut.enabled = DeviceToolShare.ExternalRemodeControl;
            }
        }
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
