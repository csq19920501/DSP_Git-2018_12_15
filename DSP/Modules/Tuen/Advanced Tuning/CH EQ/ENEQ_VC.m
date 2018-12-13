//
//  ENEQ_VC.m
//  DSP
//
//  Created by hk on 2018/7/5.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "ENEQ_VC.h"

@interface ENEQ_VC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;

@end

@implementation ENEQ_VC
- (IBAction)backClick:(id)sender {
    DeviceToolShare.analog1_2_connectType = self.analog1_2_connectType;
    DeviceToolShare.analog3_4_connectType = self.analog3_4_connectType;
    DeviceToolShare.analog5_6_connectType = self.analog5_6_connectType;
    DeviceToolShare.diglital_r_l_connectType = self.diglital_r_l_connectType;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buttonConnect:(id)sender {
    
    UIButton *but = sender;
    switch (but.tag) {
        case 113:
            {
                if (but.selected) {//断开
                    but.selected = !but.selected;
                    self.analog1_2_connectType = INEQ_connectType_none;
                    
                }else if(!but.selected) {//连接
                    
                        CusSeleView *chouseV = [[CusSeleView alloc]init];
                        [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Up to Down" TwoTitle:@"Copy Down to Up" withTipTitle:@"Please select what you want?" withCancelClick:^{
                            
                            but.selected = !but.selected;
                            self.analog1_2_connectType = INEQ_connectType_top;
                            
                        } withConfirmClick:^{
                            but.selected = !but.selected;
                            self.analog1_2_connectType = INEQ_connectType_bottom;
                        }];
                }
            }
            break;
        case 114:
        {
            if (but.selected) {//断开
                but.selected = !but.selected;
                self.analog3_4_connectType = INEQ_connectType_none;
                
            }else if(!but.selected) {//连接
                CusSeleView *chouseV = [[CusSeleView alloc]init];
                [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Up to Down" TwoTitle:@"Copy Down to Up" withTipTitle:@"Please select what you want?" withCancelClick:^{
                    
                    but.selected = !but.selected;
                    self.analog3_4_connectType = INEQ_connectType_top;
                    
                } withConfirmClick:^{
                    but.selected = !but.selected;
                    self.analog3_4_connectType = INEQ_connectType_bottom;
                }];
            }
        }
            break;
        case 115:
        {
            if (but.selected) {//断开
                but.selected = !but.selected;
                self.analog5_6_connectType = INEQ_connectType_none;
                
            }else if(!but.selected) {//连接
                CusSeleView *chouseV = [[CusSeleView alloc]init];
                [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Up to Down" TwoTitle:@"Copy Down to Up" withTipTitle:@"Please select what you want?" withCancelClick:^{
                    
                    but.selected = !but.selected;
                    self.analog5_6_connectType = INEQ_connectType_top;
                    
                } withConfirmClick:^{
                    but.selected = !but.selected;
                    self.analog5_6_connectType = INEQ_connectType_bottom;
                }];
            }
        }
            break;
        case 205:
        {
            if (but.selected) {//断开
                but.selected = !but.selected;
                self.diglital_r_l_connectType = INEQ_connectType_none;
                
            }else if(!but.selected) {//连接
                CusSeleView *chouseV = [[CusSeleView alloc]init];
                [chouseV showInView:[AppData theTopView] withOneTitle:@"Copy Up to Down" TwoTitle:@"Copy Down to Up" withTipTitle:@"Please select what you want?" withCancelClick:^{
                    but.selected = !but.selected;
                    self.diglital_r_l_connectType = INEQ_connectType_top;
                    
                } withConfirmClick:^{
                    but.selected = !but.selected;
                    self.diglital_r_l_connectType = INEQ_connectType_bottom;
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    switch (but.tag) {
        case digital:
            case digital_new:
            {
//                UIButton *butt = (UIButton*)[self.view viewWithTag:205];
//                butt.selected = YES;
                
//                for (int i = 203; i <= 204; i++) {
//                    UILabel *lab = (UILabel*)[self.view viewWithTag:i];
//                    lab.backgroundColor = [UIColor greenColor];
//                }
//                if (self.clickTypeBack) {
//                    self.clickTypeBack(digital);
//                }
                NSMutableArray *seleArray = [NSMutableArray array];
                switch (self.diglital_r_l_connectType) {
                    case INEQ_connectType_none:
                    {
                        if (but.tag == digital_new) {
                            [seleArray addObject:@"8"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:204];
                            lab.backgroundColor = [UIColor greenColor];
                        }else{
                            [seleArray addObject:@"7"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:203];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_top:
                    {
                        [seleArray addObject:@"7"];
                        [seleArray addObject:@"8"];
                        for (int i = 203; i <= 204; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_bottom:
                    {
                        [seleArray addObject:@"8"];
                        [seleArray addObject:@"7"];
                        for (int i = 203; i <= 204; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.clickTypeBackNew) {
                    self.clickTypeBackNew(seleArray);
                }
            }
            break;
        case analog1:
            case analog1_new:
        case analog2:
            case analog2_new:
        case analog3:
            case analog3_new:
        {
            for (int i = 107; i <= 112; i++) {
                UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                lab.backgroundColor = [UIColor whiteColor];
            }
//            for (int i = 113 ; i <= 115; i++) {
//                UIButton *butt = (UIButton*)[self.view viewWithTag:i];
//                butt.selected = NO;
//            }
//            UIButton *butt = (UIButton*)[self.view viewWithTag:but.tag - 5];
//            butt.selected = YES;
            
            if (but.tag == analog1 || but.tag == analog1_new) {
//                for (int i = 107; i <= 108; i++) {
//                    UILabel *lab = (UILabel*)[self.view viewWithTag:i];
//                    lab.backgroundColor = [UIColor greenColor];
//                }
//                if (self.clickTypeBack) {
//                    self.clickTypeBack(analog1);
//                }
                NSMutableArray *seleArray = [NSMutableArray array];
                switch (self.analog1_2_connectType) {
                    case INEQ_connectType_none:
                    {
                        if (but.tag == analog1) {
                            [seleArray addObject:@"1"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:107];
                            lab.backgroundColor = [UIColor greenColor];
                        }else{
                            [seleArray addObject:@"2"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:108];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_top:
                    {
                        [seleArray addObject:@"1"];
                        [seleArray addObject:@"2"];
                        for (int i = 107; i <= 108; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_bottom:
                    {
                        [seleArray addObject:@"2"];
                        [seleArray addObject:@"1"];
                        for (int i = 107; i <= 108; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.clickTypeBackNew) {
                    self.clickTypeBackNew(seleArray);
                }
            }else if(but.tag == analog2 || but.tag == analog2_new){
//                for (int i = 109; i <= 110; i++) {
//                    UILabel *lab = (UILabel*)[self.view viewWithTag:i];
//                    lab.backgroundColor = [UIColor greenColor];
//                }
//                if (self.clickTypeBack) {
//                    self.clickTypeBack(analog2);
//                }
                NSMutableArray *seleArray = [NSMutableArray array];
                switch (self.analog3_4_connectType) {
                    case INEQ_connectType_none:
                    {
                        if (but.tag == analog2) {
                            [seleArray addObject:@"3"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:109];
                            lab.backgroundColor = [UIColor greenColor];
                        }else{
                            [seleArray addObject:@"4"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:110];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_top:
                    {
                        [seleArray addObject:@"3"];
                        [seleArray addObject:@"4"];
                        for (int i = 109; i <= 110; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_bottom:
                    {
                        [seleArray addObject:@"4"];
                        [seleArray addObject:@"3"];
                        for (int i = 109; i <= 110; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.clickTypeBackNew) {
                    self.clickTypeBackNew(seleArray);
                }
            }else if(but.tag == analog3 || but.tag == analog3_new){
//                for (int i = 111; i <= 112; i++) {
//                    UILabel *lab = (UILabel*)[self.view viewWithTag:i];
//                    lab.backgroundColor = [UIColor greenColor];
//                }
//                if (self.clickTypeBack) {
//                    self.clickTypeBack(analog3);
//                }
                NSMutableArray *seleArray = [NSMutableArray array];
                switch (self.analog5_6_connectType) {
                    case INEQ_connectType_none:
                    {
                        if (but.tag == analog3) {
                            [seleArray addObject:@"5"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:111];
                            lab.backgroundColor = [UIColor greenColor];
                        }else{
                            [seleArray addObject:@"6"];
                            UILabel *lab = (UILabel*)[self.view viewWithTag:112];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_top:
                    {
                        [seleArray addObject:@"5"];
                        [seleArray addObject:@"6"];
                        for (int i = 111; i <= 112; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                    case INEQ_connectType_bottom:
                    {
                        [seleArray addObject:@"6"];
                        [seleArray addObject:@"5"];
                        for (int i = 111; i <= 112; i++) {
                            UILabel *lab = (UILabel*)[self.view viewWithTag:i];
                            lab.backgroundColor = [UIColor greenColor];
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.clickTypeBackNew) {
                    self.clickTypeBackNew(seleArray);
                }
            }
        }
            break;
            
        default:
            break;
    }
    CSQ_DISPATCH_AFTER(afterTime, ^{
        [self backClick:nil];
    })
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (isIphoneX) {
        self.naviBarHeight.constant = kTopHeight;
        self.VCBottomConstraint.constant = 35.;
    }
    
    for (UILabel *lab in self.view.subviews) {
        if (lab.tag == 116
            || lab.tag == 117
            || lab.tag == 206
            || lab.tag == 207) {
            lab.layer.masksToBounds = YES;
            lab.layer.cornerRadius = 5;
            lab.layer.borderColor = [UIColor whiteColor].CGColor;
            lab.layer.borderWidth = 1;
        }
        if (lab.tag == 209
            || lab.tag == 121) {
            lab.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
    }
    self.analog1_2_connectType = DeviceToolShare.analog1_2_connectType;
    self.analog3_4_connectType = DeviceToolShare.analog3_4_connectType;
    self.analog5_6_connectType = DeviceToolShare.analog5_6_connectType;
    self.diglital_r_l_connectType = DeviceToolShare.diglital_r_l_connectType;
    
    if (self.analog1_2_connectType == INEQ_connectType_none) {
        UIButton *butt = (UIButton*)[self.view viewWithTag:113];
        butt.selected = NO;
    }else{
        UIButton *butt = (UIButton*)[self.view viewWithTag:113];
        butt.selected = YES;
    }
    if (self.analog3_4_connectType == INEQ_connectType_none) {
        UIButton *butt = (UIButton*)[self.view viewWithTag:114];
        butt.selected = NO;
    }else{
        UIButton *butt = (UIButton*)[self.view viewWithTag:114];
        butt.selected = YES;
    }
    if (self.analog5_6_connectType == INEQ_connectType_none) {
        UIButton *butt = (UIButton*)[self.view viewWithTag:115];
        butt.selected = NO;
    }else{
        UIButton *butt = (UIButton*)[self.view viewWithTag:115];
        butt.selected = YES;
    }
    if (self.diglital_r_l_connectType == INEQ_connectType_none) {
        UIButton *butt = (UIButton*)[self.view viewWithTag:205];
        butt.selected = NO;
    }else{
        UIButton *butt = (UIButton*)[self.view viewWithTag:205];
        butt.selected = YES;
    }
    
    
    if (DeviceToolShare.DspMode == ANALOG) {
        for (int a = 201; a <= 207; a++) {
            UIView *V = [self.view viewWithTag:a];
            V.alpha = 0.3;
        }
        UIView *V = [self.view viewWithTag:209];
        V.alpha = 0.3;
        for (int i = 208; i <= 208; i++) {
            UIButton *but = (UIButton*)[self.view viewWithTag:i];
            but.enabled = NO;
        }
        UIButton *but303 = (UIButton*)[self.view viewWithTag:303];
        but303.enabled = NO;
    }else{
        for (int a = 101; a <= 117; a++) {
            UIView *V = [self.view viewWithTag:a];
            V.alpha = 0.3;
        }
        UIView *V = [self.view viewWithTag:121];
        V.alpha = 0.3;
        for (int i = 118; i <= 120; i++) {
            UIButton *but = (UIButton*)[self.view viewWithTag:i];
            but.enabled = NO;
        }
        for (int i = 300; i <= 302; i++) {
            UIButton *but = (UIButton*)[self.view viewWithTag:i];
            but.enabled = NO;
        }
    }
    
    for (NSString *str in self.seleArray) {
        switch (str.intValue) {
            case 1:
                {
                    UILabel *label = (UILabel *)[self.view viewWithTag:107];
                    label.backgroundColor = [UIColor greenColor];
                }
                break;
            case 2:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:108];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 3:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:109];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 4:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:110];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 5:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:111];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 6:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:112];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 7:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:203];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
            case 8:
            {
                UILabel *label = (UILabel *)[self.view viewWithTag:204];
                label.backgroundColor = [UIColor greenColor];
            }
                break;
                
            default:
                break;
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
