//
//  InputSettingVC.m
//  DSP
//
//  Created by hk on 2018/7/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "InputSettingVC.h"
#import "CustomerCar.h"

@interface InputSettingVC ()<UITextFieldDelegate>
{
    NSString* beginEditText;
    NSMutableArray *textArray;
}
@property (weak, nonatomic) IBOutlet UIView *showCarBackView;
@property (weak, nonatomic) IBOutlet UIView *coverShowCarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *right2Label;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property(nonatomic,strong)CustomerCar* customerCar;

@property (weak, nonatomic) IBOutlet UIButton *anaButton;
@property (weak, nonatomic) IBOutlet UIButton *digitalButton;
@property (weak, nonatomic) IBOutlet UIButton *ch1Button;
@property (weak, nonatomic) IBOutlet UIButton *ch2Button;
@property (weak, nonatomic) IBOutlet UIButton *ch3Button;
@property (weak, nonatomic) IBOutlet UIButton *ch4Button;
@property (weak, nonatomic) IBOutlet UIButton *ch5Button;
@property (weak, nonatomic) IBOutlet UIButton *ch6Button;
@property (weak, nonatomic) IBOutlet UIButton *digitalLButton;
@property (weak, nonatomic) IBOutlet UIButton *digitialRButton;
@property(nonatomic,strong)hornDataModel* seleHornModel;


@end

@implementation InputSettingVC
- (IBAction)changeDSPmodeCLick:(id)sender {
    if ([sender isEqual:_anaButton]) {
        DeviceToolShare.DspMode = ANALOG;
        [SocketManagerShare sendTipWithType:InputSource withCount:0];
        _anaButton.selected = YES;
        _digitalButton.selected = NO;
        
        for (int i = 1001; i <= 1008; i++) {
            UITextField * tf = (UITextField*)[self.view viewWithTag:i];
            UIButton *but = (UIButton *)[self.view viewWithTag:i + 8000];
            if (i <= 1006) {
                if ([tf.text intValue] == 0) {
                    but.selected = NO;
                }else{
                    but.selected = YES;
                }
            }
            else{
                but.selected = NO;
            }
        }
    }else{
        DeviceToolShare.DspMode = SPDIF;
        [SocketManagerShare sendTipWithType:InputSource withCount:0];
        _anaButton.selected = NO;
        _digitalButton.selected = YES;
        
        for (int i = 1001; i <= 1008; i++) {
            UITextField * tf = (UITextField*)[self.view viewWithTag:i];
            UIButton *but = (UIButton *)[self.view viewWithTag:i + 8000];
            if (i > 1006) {
                if ([tf.text intValue] == 0) {
                    but.selected = NO;
                }else{
                    but.selected = YES;
                }
            }
            else{
                but.selected = NO;
            }
        }
    }
}

- (IBAction)analogClick:(id)sender {
    UIButton *but = (UIButton *)sender;

    if (_anaButton.selected) {
        but.selected = !but.selected;
        int count = 0;
        for (int i = 1001; i <= 1006; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i + 8000];
            if (button.selected) {
                count++;
            }
        }
        SDLog(@"count == %d",count);
        if (count == 0) {
            self.seleHornModel.ch1Input = @"0";
            self.seleHornModel.ch2Input = @"0";
            self.seleHornModel.ch3Input = @"0";
            self.seleHornModel.ch4Input = @"0";
            self.seleHornModel.ch5Input = @"0";
            self.seleHornModel.ch6Input = @"0";
        }else{
            count = 100/count;
            if (_ch1Button.selected) {
                self.seleHornModel.ch1Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch1Input = [NSString stringWithFormat:@"%d",0];
            }
           
            
            
            
            if (_ch2Button.selected) {
                self.seleHornModel.ch2Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch2Input = [NSString stringWithFormat:@"%d",0];
            }
           
            
            
            
            if (_ch3Button.selected) {
                self.seleHornModel.ch3Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch3Input = [NSString stringWithFormat:@"%d",0];
            }
           
            
            
            
            if (_ch4Button.selected) {
                self.seleHornModel.ch4Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch4Input = [NSString stringWithFormat:@"%d",0];
            }
            
            
            if (_ch5Button.selected) {
                self.seleHornModel.ch5Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch5Input = [NSString stringWithFormat:@"%d",0];
            }
           
            
            
            
            if (_ch6Button.selected) {
                self.seleHornModel.ch6Input = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.ch6Input = [NSString stringWithFormat:@"%d",0];
            }
           
        }

        UITextField * tf = (UITextField*)[self.view viewWithTag:1001];
        tf.text = self.seleHornModel.ch1Input;
        UITextField * tf2 = (UITextField*)[self.view viewWithTag:1002];
        tf2.text = self.seleHornModel.ch2Input;
        UITextField * tf3 = (UITextField*)[self.view viewWithTag:1003];
        tf3.text = self.seleHornModel.ch3Input;
        UITextField * tf4 = (UITextField*)[self.view viewWithTag:1004];
        tf4.text = self.seleHornModel.ch4Input;
        UITextField * tf5 = (UITextField*)[self.view viewWithTag:1005];
        tf5.text = self.seleHornModel.ch5Input;
        UITextField * tf6 = (UITextField*)[self.view viewWithTag:1006];
        tf6.text = self.seleHornModel.ch6Input;
        
        NSMutableArray *textArr = [NSMutableArray array];
        for (int i = 1001; i <= 1008; i++) {
            UITextField * tf = (UITextField*)[self.view viewWithTag:i];
            [textArr addObject:tf.text];
        }
        [textArray addObject:textArr];
        [self sendPersentTip];
    }
}
- (IBAction)digitalClick:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (_digitalButton.selected) {
        but.selected = !but.selected;
        int count = 0;
        for (int i = 1007; i <= 1008; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i + 8000];
            if (button.selected) {
                count++;
            }
        }
        SDLog(@"count == %d",count);
        if (count == 0) {
            self.seleHornModel.digitalL = @"0";
            self.seleHornModel.digitalR = @"0";
        }else{
            count = 100/count;
            if (_digitalLButton.selected) {
                self.seleHornModel.digitalL = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.digitalL = [NSString stringWithFormat:@"%d",0];
            }
           
            if (_digitialRButton.selected) {
                self.seleHornModel.digitalR = [NSString stringWithFormat:@"%d",count];
            }else{
                self.seleHornModel.digitalR = [NSString stringWithFormat:@"%d",0];
            }
        }
        
        UITextField * tf = (UITextField*)[self.view viewWithTag:1007];
        tf.text = self.seleHornModel.digitalL;
        UITextField * tf2 = (UITextField*)[self.view viewWithTag:1008];
        tf2.text = self.seleHornModel.digitalR;
        
        NSMutableArray *textArr = [NSMutableArray array];
        for (int i = 1001; i <= 1008; i++) {
            UITextField * tf = (UITextField*)[self.view viewWithTag:i];
            [textArr addObject:tf.text];
        }
        [textArray addObject:textArr];
        [self sendPersentTip];
    }
    
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)nextClick:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    textArray = [NSMutableArray array];
    
    if (isIphoneX) {
        self.naviBarHeight.constant = kTopHeight;
        self.VCBottomConstraint.constant = 35.;
    }
    
    MPWeakSelf(self)
    DISPATCH_ON_MAIN_THREAD((^{
        self.topBackView.hidden = YES;
        self.topBackView.layer.masksToBounds = YES;
        self.topBackView.layer.cornerRadius = 5;
        self.topBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.topBackView.layer.borderWidth = 0.7;
        
        self.customerCar = [[CustomerCar alloc]init];
        [self.customerCar showInView:self.showCarBackView withFrame:self.showCarBackView.bounds];
        self.customerCar.F_connectButton.hidden = YES;
        self.customerCar.R_connectButton.hidden = YES;
        [self.customerCar inputSettingViewWith:self.selectCarArray];
        
        [self.customerCar setHornClick:^(int tag){
            weakself.topBackView.hidden = NO;
            SDLog(@"tag = %d",tag);
            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                if ([model.hornType isEqualToString:[NSString stringWithFormat:@"%d",tag]]) {
                    SDLog(@"customerCar 找到seleHornmodel");
                    weakself.seleHornModel = model;
                }
            }
            
            NSArray *inputLevelArr = @[weakself.seleHornModel.ch1Input,weakself.seleHornModel.ch2Input,weakself.seleHornModel.ch3Input,weakself.seleHornModel.ch4Input,weakself.seleHornModel.ch5Input,weakself.seleHornModel.ch6Input,weakself.seleHornModel.digitalL,weakself.seleHornModel.digitalR,];
            
            NSMutableArray *textArr = [NSMutableArray array];
            for (int i = 1001; i <= 1008; i++) {
                UITextField * tf = (UITextField*)[weakself.view viewWithTag:i];
                tf.text = inputLevelArr[i - 1001];
                [textArr addObject:tf.text];
                
                UIButton *but = (UIButton *)[weakself.view viewWithTag:i + 8000];
                if (DeviceToolShare.DspMode == ANALOG) {
                    weakself.anaButton.selected = YES;
                    weakself.digitalButton.selected = NO;
                    if (i <= 1006) {
                        if ([tf.text intValue] == 0) {
                            but.selected = NO;
                        }else{
                            but.selected = YES;
                        }
                    }
                    else{
                        but.selected = NO;
                    }
                }
                else{
                    weakself.anaButton.selected = NO;
                    weakself.digitalButton.selected = YES;
                    if (i > 1006) {
                        if ([tf.text intValue] == 0) {
                            but.selected = NO;
                        }else{
                            but.selected = YES;
                        }
                    }
                    else{
                        but.selected = NO;
                    }
                }
            }
            [self->textArray addObject:textArr];
            weakself.coverShowCarView.hidden = NO;
            
            NSString *titleStr = [CustomerCar changeTagToHorn:[NSString stringWithFormat:@"%d",tag]];
            

            weakself.right2Label.text = [NSString stringWithFormat:@"%@ CH%d",titleStr,(int)weakself.seleHornModel.outCh];
        }];
    }))
    
}
- (IBAction)setNext:(id)sender {
//    [self sendPersentTip];
    [self.customerCar changeButton:nil];
    self.topBackView.hidden = YES;
    [textArray removeAllObjects];
    self.coverShowCarView.hidden = YES;
}
-(void)sendPersentTip{
    if (DeviceToolShare.DspMode == ANALOG) {
        long data0 = pow(2,self.seleHornModel.outCh - 1);
        NSMutableString *tipStr = [NSMutableString string];
        [tipStr appendFormat:@"00%@",InputAnalogPercenAdr];
        [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
        [tipStr appendFormat:@"%@%@%@%@%@%@",[SocketManager stringWithHexNumber:self.seleHornModel.ch1Input.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.ch2Input.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.ch3Input.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.ch4Input.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.ch5Input.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.ch6Input.integerValue]];
        [SocketManagerShare seneTipWithType:InputAnalogPercen WithStr:tipStr Count:0];
    }else{
        long data0 = pow(2,self.seleHornModel.outCh - 1);
        NSMutableString *tipStr = [NSMutableString string];
        [tipStr appendFormat:@"00%@",InputDigitalPercenAdr];
        [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
        [tipStr appendFormat:@"%@%@",[SocketManager stringWithHexNumber:self.seleHornModel.digitalL.integerValue],[SocketManager stringWithHexNumber:self.seleHornModel.digitalR.integerValue]];
        [SocketManagerShare seneTipWithType:InputDigitalPercen WithStr:tipStr Count:0];
    }
}
- (IBAction)setBack:(id)sender {
    if (textArray.count > 1) {
        [textArray removeLastObject];
        NSMutableArray *a = [textArray lastObject];
        for (int i = 1001; i <= 1008; i++) {
            UITextField * tf = (UITextField*)[self.view viewWithTag:i];
            tf.text = a[i - 1001];
        }
    }

    for (int i = 1001; i <= 1008; i++) {
        UITextField * tf = (UITextField*)[self.view viewWithTag:i];
        UIButton *but = (UIButton *)[self.view viewWithTag:i + 8000];
        if (_anaButton.selected) {
            if (i <= 1006) {
                if ([tf.text intValue] == 0) {
                    but.selected = NO;
                }else{
                    but.selected = YES;
                }
            }
            else{
                but.selected = NO;
            }
        }else{
            if (i > 1006) {
                if ([tf.text intValue] == 0) {
                    but.selected = NO;
                }else{
                    but.selected = YES;
                }
            }
            else{
                but.selected = NO;
            }
        }
    }
    
    
    UITextField * tf = (UITextField*)[self.view viewWithTag:1001];
    self.seleHornModel.ch1Input = tf.text ;
    UITextField * tf2 = (UITextField*)[self.view viewWithTag:1002];
    self.seleHornModel.ch2Input = tf2.text ;
    UITextField * tf3 = (UITextField*)[self.view viewWithTag:1003];
    self.seleHornModel.ch3Input = tf3.text ;
    UITextField * tf4 = (UITextField*)[self.view viewWithTag:1004];
    self.seleHornModel.ch4Input = tf4.text ;
    UITextField * tf5 = (UITextField*)[self.view viewWithTag:1005];
    self.seleHornModel.ch5Input = tf5.text ;
    UITextField * tf6 = (UITextField*)[self.view viewWithTag:1006];
    self.seleHornModel.ch6Input = tf6.text ;
    UITextField * tfDig = (UITextField*)[self.view viewWithTag:1007];
    self.seleHornModel.digitalL = tfDig.text ;
    UITextField * tfDig2 = (UITextField*)[self.view viewWithTag:1008];
    self.seleHornModel.digitalR = tfDig2.text ;
    [self sendPersentTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    beginEditText = textField.text;
    int a = [textField.text intValue];
    if ( a == 0) {
        textField.text = @"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    int a = [textField.text intValue];
    NSLog(@"a = %d",a);
    if (a < 1) {
        textField.text = @"0";
    }
    if ([textField.text isEqualToString:beginEditText]) {
        return;
    }

    NSMutableArray *textArr = [NSMutableArray array];
    for (int i = 1001; i <= 1008; i++) {
        UITextField * tf = (UITextField*)[self.view viewWithTag:i];
        [textArr addObject:tf.text];
    }

    [textArray addObject:textArr];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int a = [textField.text intValue];
    if (a >= 100 && string.length > 0) {
        return NO;
    }
    int b = a/10;
    if (textField.text.length == 2 && (b != 1 || b != 0) && string.length > 0) {
        return NO;
    }
    return YES;
}

@end
