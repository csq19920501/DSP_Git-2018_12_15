//
//  inputLevelVC.m
//  DSP
//
//  Created by hk on 2018/6/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "inputLevelVC.h"

@interface inputLevelVC ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;

@property (weak, nonatomic) IBOutlet CSQCircleView *ana1_2;
@property (weak, nonatomic) IBOutlet CSQCircleView *ana3_4;
@property (weak, nonatomic) IBOutlet CSQCircleView *ana5_6;
@property (weak, nonatomic) IBOutlet CSQCircleView *digR_L;
@property (weak, nonatomic) IBOutlet UILabel *level1;
@property (weak, nonatomic) IBOutlet UILabel *level2;
@property (weak, nonatomic) IBOutlet UILabel *levle3;
@property (weak, nonatomic) IBOutlet UILabel *level4;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel4;



@end

@implementation inputLevelVC
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIphoneX) {
//        self.VCBottomConstraint.constant = 35.;
        self.naviBarHeight.constant = kTopHeight;
    }
    DISPATCH_ON_MAIN_THREAD((^{
       
        if (!DeviceToolShare.MaxInputLevelAdd6) {
            self.ana1_2.MainLevel = Level120;
            self.ana3_4.MainLevel = Level120;
            self.ana5_6.MainLevel = Level120;
            DeviceToolShare.inputLevel1 = DeviceToolShare.inputLevel1 > Level120 ? Level120 : DeviceToolShare.inputLevel1;
            DeviceToolShare.inputLevel2 = DeviceToolShare.inputLevel2 > Level120 ? Level120 : DeviceToolShare.inputLevel2;
            DeviceToolShare.inputLevel3 = DeviceToolShare.inputLevel3 > Level120 ? Level120 : DeviceToolShare.inputLevel3;
        }else{
            self.ana1_2.MainLevel = Level132;
            self.ana3_4.MainLevel = Level132;
            self.ana5_6.MainLevel = Level132;
        }
        [self.ana1_2 drawProgress];
        [self.ana3_4 drawProgress];
        [self.ana5_6 drawProgress];
        
        [self.ana1_2 setValueChange:^(CGFloat level){
            SDLog(@"levelChange = %f",level);
            self.level1.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
            DeviceToolShare.inputLevel1 = level;
            
            self.level1.textColor = [UIColor greenColor];
            suiJiFaSong([SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:maxCount withData0Int:0 withData1Int:DeviceToolShare.inputLevel1];)
        }];
        [self.ana1_2 setValueChangeEnd:^(){
            self.level1.textColor = [UIColor whiteColor];
        }];

        [self.ana3_4 setValueChange:^(CGFloat level){
            SDLog(@"levelChange = %f",level);
            self.level2.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
            DeviceToolShare.inputLevel2 = level;
            self.level2.textColor = [UIColor greenColor];
            suiJiFaSong( [SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:maxCount withData0Int:1 withData1Int:DeviceToolShare.inputLevel2];)
            
        }];
        [self.ana3_4 setValueChangeEnd:^(){
            self.level2.textColor = [UIColor whiteColor];
        }];
        [self.ana5_6 setValueChange:^(CGFloat level){
            SDLog(@"levelChange = %f",level);
            self.levle3.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
            DeviceToolShare.inputLevel3 = level;
            self.levle3.textColor = [UIColor greenColor];
            suiJiFaSong([SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:maxCount withData0Int:2 withData1Int:DeviceToolShare.inputLevel3];)
            
          
        }];
        [self.ana5_6 setValueChangeEnd:^(){
            self.levle3.textColor = [UIColor whiteColor];
        }];
        
        
        
        
        [self.ana1_2 setLevel:DeviceToolShare.inputLevel1];
        [self.ana3_4 setLevel:DeviceToolShare.inputLevel2];
        [self.ana5_6 setLevel:DeviceToolShare.inputLevel3];
        
        [self.ana1_2 setSendData:^(){
            [SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:0 withData0Int:0 withData1Int:DeviceToolShare.inputLevel1];
        }];
        [self.ana3_4 setSendData:^(){
            [SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:0 withData0Int:1 withData1Int:DeviceToolShare.inputLevel2];
        }];
        [self.ana5_6 setSendData:^(){
            [SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:0 withData0Int:2 withData1Int:DeviceToolShare.inputLevel3];
        }];
        
        
        self.digR_L.MainLevel = Level120;
        [self.digR_L drawProgress];
        [self.digR_L setValueChange:^(CGFloat level){
            SDLog(@"levelChange = %f",level);
            self.level4.text = [NSString stringWithFormat:@"%.1f",((int)level - Level120)/2.0];
            DeviceToolShare.inputLevel4 = level;
            self.level4.textColor = [UIColor greenColor];
            suiJiFaSong([SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:maxCount withData0Int:3 withData1Int:DeviceToolShare.inputLevel4];)
        }];
        [self.digR_L setLevel:DeviceToolShare.inputLevel4];
        [self.digR_L setValueChangeEnd:^(){
            self.level4.textColor = [UIColor whiteColor];
        }];
        [self.digR_L setSendData:^(){
            [SocketManagerShare sendTwoDataTipWithType:InputLevle withCount:0 withData0Int:3 withData1Int:DeviceToolShare.inputLevel4];
        }];
        
        [self setInputTypeInMain:self.inputType];
    }))
}
-(void)setInputTypeInMain:(InputType)inputType{
    CGFloat hiddenAlpha = 0.3;
    CGFloat diplayAlpha = 1.0;
    
    switch (inputType) {
        case Ana:
            {
                _ana1_2.alpha = diplayAlpha;
                _level1.alpha = diplayAlpha;
                _typeLabel1.alpha = diplayAlpha;
                _ana1_2.userInteractionEnabled = YES;
                
                
                _ana3_4.alpha = diplayAlpha;
                _level2.alpha = diplayAlpha;
                _typeLabel2.alpha = diplayAlpha;
                _ana3_4.userInteractionEnabled = YES;
                
                _ana5_6.alpha = diplayAlpha;
                _levle3.alpha = diplayAlpha;
                _typeLabel3.alpha = diplayAlpha;
                _ana5_6.userInteractionEnabled = YES;
                
              
                _digR_L.alpha = hiddenAlpha;
                _level4.alpha = hiddenAlpha;
                _typeLabel4.alpha = hiddenAlpha;
                _digR_L.userInteractionEnabled = NO;
            }
            break;
        case Dig:
        {
            _ana1_2.alpha = hiddenAlpha;
            _level1.alpha = hiddenAlpha;
            _typeLabel1.alpha = hiddenAlpha;
            _ana1_2.userInteractionEnabled = NO;
            
            
            _ana3_4.alpha = hiddenAlpha;
            _level2.alpha = hiddenAlpha;
            _typeLabel2.alpha = hiddenAlpha;
            _ana3_4.userInteractionEnabled = NO;
            
            _ana5_6.alpha = hiddenAlpha;
            _levle3.alpha = hiddenAlpha;
            _typeLabel3.alpha = hiddenAlpha;
            _ana5_6.userInteractionEnabled = NO;
            
            
            _digR_L.alpha = diplayAlpha;
            _level4.alpha = diplayAlpha;
            _typeLabel4.alpha = diplayAlpha;
            _digR_L.userInteractionEnabled = YES;
        }
            break;
        default:
            break;
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
