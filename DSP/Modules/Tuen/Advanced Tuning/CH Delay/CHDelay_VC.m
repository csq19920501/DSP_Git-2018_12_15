//
//  CHDelay_VC.m
//  DSP
//
//  Created by hk on 2018/6/20.
//  Copyright © 2018年 hk. All rights reserved.
//
#import "AppDelegate.h"
#import "CHDelay_VC.h"
#import "CYTabBarController.h"
#import "RTA_VC.h"
#import "CHDelay.h"
#import "CustomerCar.h"
typedef NS_ENUM(NSInteger,ChdelayNowChangeType) {
    CHdelayUnknow = 899,
    CHdelayPhase = 900,//弃用
    CHdelayDelay = 901,
    CHdelayDistance = 902,
    ChMune,
  
};
@interface CHDelay_VC ()<CYTabBarDelegate>
{
    NSTimeInterval oldTimeIntervar;
    int count;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet UISlider *sliderV;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet CHDelay *centerV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBILi;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoButtonBottomCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *id302Button;

@property (weak, nonatomic) IBOutlet UIButton *backClick;
@property(nonatomic ,strong)CHDelay *seleDelayView;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *phaseButton;

@property(nonatomic ,assign)ChdelayNowChangeType seleDelayMode;

@property(nonatomic,strong)NSMutableArray *chVArray;
@property(nonatomic,strong)NSMutableArray *changeModelArray;
@end

@implementation CHDelay_VC
- (IBAction)saveClick:(id)sender {
    NSString *leftStr = [NSString stringWithFormat:@"Save to CH Delay %@",[AppData managerAWithTag:504]];
    NSString *rightStr = [NSString stringWithFormat:@"Save to CH Delay %@",[AppData managerAWithTag:604]];
    CusSeleView *chouseV = [[CusSeleView alloc]init];
    [chouseV showInView:[AppData theTopView] withOneTitle:leftStr TwoTitle:rightStr withTipTitle:@"Please select where to save?" withCancelClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:4 withData1Int:0];
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:4 withData1Int:1];
    }];
}
- (IBAction)changeArrayTypeClick:(id)sender {
    if (self.seleDelayView != nil) {
        UIButton *but = (UIButton *)sender;
        self.seleDelayView.delayModel.arrayType = but.tag - 2000;
        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        SDLog(@"self.seleDelayView.delayModel.arrayType = %ld",(long)self.seleDelayView.delayModel.arrayType);
    }
}
- (IBAction)deleClick:(id)sender {
    int value = self.sliderV.value;
    
    
    if(self.seleDelayMode  == CHdelayPhase){
//        value  = value - 1;
//        [self.sliderV setValue:value];
//
//        self.seleDelayView.delayModel.phase = self.sliderV.value;
//        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        
    }else if(self.seleDelayMode  == CHdelayDelay){
        value  = value - 2;
        [self.sliderV setValue:value];
        
        [self changeModelDelayWithSlider:self.sliderV];
        [self sendTipModel:self.changeModelArray WithType:CHdelayDelay WithCount:0];
    }else if(self.seleDelayMode  == CHdelayDistance){
        value  = value - 2;
        [self.sliderV setValue:value];
        
       [self changeModelDistanceWithSlider:self.sliderV];
    }
}
- (IBAction)addClick:(id)sender {
    int value = self.sliderV.value;
    
    
    if(self.seleDelayMode  == CHdelayPhase){
//        value  = value + 1;
//        [self.sliderV setValue:value];
//
//        self.seleDelayView.delayModel.phase = self.sliderV.value;
//        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        
    }else if(self.seleDelayMode  == CHdelayDelay){
        value  = value + 2;
        [self.sliderV setValue:value];
        
       [self changeModelDelayWithSlider:self.sliderV];
        [self sendTipModel:self.changeModelArray WithType:CHdelayDelay WithCount:0];
    }else if(self.seleDelayMode  == CHdelayDistance){
        value  = value + 2;
        [self.sliderV setValue:value];
        
        [self changeModelDistanceWithSlider:self.sliderV];
    }
}


- (IBAction)sliderValueChange:(id)sender {
    SDLog(@"IBAction  sliderValueChange");
    
    UISlider *slider = (UISlider*)sender;
    if(self.seleDelayMode  == CHdelayPhase){
//        self.seleDelayView.delayModel.phase = slider.value;
//        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
    }else if(self.seleDelayMode  == CHdelayDelay){
        [self changeModelDelayWithSlider:slider];
        
    }else if(self.seleDelayMode  == CHdelayDistance){
        [self changeModelDistanceWithSlider:slider];
    }
    
    NSTimeInterval timeIntervar = [[NSDate date] timeIntervalSince1970]*1000;
    if (timeIntervar - oldTimeIntervar >= 500) {
        oldTimeIntervar = timeIntervar;
         [self sendTipModel:self.changeModelArray WithType:CHdelayDelay WithCount:maxCount];
    }
}


- (IBAction)IBActionTouchUpInside:(id)sender {
    SDLog(@"IBAction  IBActionTouchUpInside");
    [self sendTipModel:self.changeModelArray WithType:CHdelayDelay WithCount:0];
}



-(void)changeModelDelayWithSlider:(UISlider *)slider{
    SDLog(@"sliderChange = %f",slider.value);
    
    
    [self.changeModelArray removeAllObjects];

    if (self.seleDelayView.delayModel.arrayType == 0) {
        self.seleDelayView.delayModel.delay = slider.value;
        self.seleDelayView.delayModel.distance = self.seleDelayView.delayModel.delay/100.0 *34.3;
        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        [self.changeModelArray addObject:self.seleDelayView.delayModel];
    }else{
        for (CHDelay *chd in self.chVArray) {
            if (chd.delayModel.arrayType == self.seleDelayView.delayModel.arrayType &&
                chd.delayModel != self.seleDelayView.delayModel) {
                
                CGFloat delayDele ;
                delayDele = slider.value - self.seleDelayView.delayModel.delay;
                chd.delayModel.delay =  chd.delayModel.delay + delayDele;
                chd.delayModel.delay = chd.delayModel.delay < 0 ? 0:chd.delayModel.delay > 2000?2000:chd.delayModel.delay;
                chd.delayModel.distance = chd.delayModel.delay/100 *34.3;
                [chd setDelayModel:chd.delayModel];
                [self.changeModelArray addObject:chd.delayModel];
            }
        }
      
        self.seleDelayView.delayModel.delay = slider.value;
        self.seleDelayView.delayModel.distance = self.seleDelayView.delayModel.delay/100.0 *34.3;
        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        [self.changeModelArray addObject:self.seleDelayView.delayModel];
    }
    
}
-(void)changeModelDistanceWithSlider:(UISlider *)slider{
    NSMutableArray *modelArray = [NSMutableArray array];
    if (self.seleDelayView.delayModel.arrayType == 0) {
        self.seleDelayView.delayModel.distance = slider.value;
        self.seleDelayView.delayModel.delay = self.seleDelayView.delayModel.distance/34.3*100.0;
        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        [modelArray addObject:self.seleDelayView.delayModel];
    }else{
        for (CHDelay *chd in self.chVArray) {
            if (chd.delayModel.arrayType == self.seleDelayView.delayModel.arrayType
                && chd.delayModel != self.seleDelayView.delayModel) {
                
                CGFloat distanceDele;
                distanceDele = slider.value - self.seleDelayView.delayModel.distance;
                chd.delayModel.distance = chd.delayModel.distance + distanceDele;
                chd.delayModel.distance = chd.delayModel.distance < 0 ? 0:chd.delayModel.distance > 686?686:chd.delayModel.distance;
                chd.delayModel.delay = chd.delayModel.distance/34.3*100.0;
                [chd setDelayModel:chd.delayModel];
                [modelArray addObject:chd.delayModel];
            }
        }
        self.seleDelayView.delayModel.distance = slider.value;
        self.seleDelayView.delayModel.delay = self.seleDelayView.delayModel.distance/34.3*100.0;
        [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
        [modelArray addObject:self.seleDelayView.delayModel];
    }
    [self sendTipModel:modelArray WithType:CHdelayDelay WithCount:0];
}

- (IBAction)backClick:(id)sender {
    KPostNotification(RemoveAllNotification, nil)
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.homeNavi popToRootViewControllerAnimated:YES];
}
- (IBAction)seleButtonClick:(id)sender {
    for (int i = 300; i <= 307; i++) {
        UIButton*but = (UIButton *)[self.view viewWithTag:i];
        if (![but isEqual:sender]) {
            but.selected = NO;
        } else{
            but.selected = YES;
        }
    }
    UIButton *but1 = (UIButton *)sender;
    int delayViewTag = (int)but1.tag - 100;
    
    self.seleDelayView = (CHDelay*)[self.view viewWithTag:delayViewTag];
    self.muteButton.selected =  self.seleDelayView.delayModel.isMune ;
    self.phaseButton.selected = self.seleDelayView.delayModel.isPhase180;
    
    if (self.seleDelayMode != CHdelayUnknow) {
        self.addButton.enabled = YES;
        self.deleButton.enabled = YES;
        self.sliderV.enabled = YES;
    }
    if(self.seleDelayMode  == CHdelayPhase){
        self.sliderV.maximumValue = 180;
        self.sliderV.value = self.seleDelayView.delayModel.phase;
    }else if(self.seleDelayMode  == CHdelayDelay){
        self.sliderV.maximumValue = 1000 * 2;
        self.sliderV.value = self.seleDelayView.delayModel.delay;
    }else if(self.seleDelayMode  == CHdelayDistance){
        self.sliderV.maximumValue = 343 * 2;
        self.sliderV.value = self.seleDelayView.delayModel.distance;
    }
}
- (IBAction)muteClick:(id)sender {
    NSMutableArray *modelArray = [NSMutableArray array];
    if (self.seleDelayView != nil) {
        self.muteButton.selected = !self.muteButton.selected;
        
        if (self.seleDelayView.delayModel.arrayType == 0) {
            self.seleDelayView.delayModel.isMune = self.muteButton.selected;
            [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
            [modelArray addObject:self.seleDelayView.delayModel];
        }else{
            
            for (CHDelay *chd in self.chVArray) {
                if (chd.delayModel.arrayType == self.seleDelayView.delayModel.arrayType) {
                    chd.delayModel.isMune = self.muteButton.selected;
                    [chd setDelayModel:chd.delayModel];
                    [modelArray addObject:chd.delayModel];
                }
            }
        }
    }
    
    [self sendTipModel:modelArray WithType:ChMune WithCount:0];
}
- (IBAction)phaseClick:(id)sender {
    NSMutableArray *modelArray = [NSMutableArray array];
    if (self.seleDelayView != nil) {
        self.phaseButton.selected = !self.phaseButton.selected;
        if (self.seleDelayView.delayModel.arrayType == 0) {
            self.seleDelayView.delayModel.isPhase180 = self.phaseButton.selected;
            [self.seleDelayView setDelayModel:self.seleDelayView.delayModel];
            [modelArray addObject:self.seleDelayView.delayModel];
        }else{
            for (CHDelay *chd in self.chVArray) {
                if (chd.delayModel.arrayType == self.seleDelayView.delayModel.arrayType) {
                    chd.delayModel.isPhase180 = self.phaseButton.selected;
                    [chd setDelayModel:chd.delayModel];
                    [modelArray addObject:chd.delayModel];
                }
            }
        }
    }
    [self sendTipModel:modelArray WithType:CHdelayPhase WithCount:0];
}
-(void)sendTipModel:(NSArray*)modelArray  WithType:(ChdelayNowChangeType)type  WithCount:(int)count{
    if (kArrayIsEmpty(modelArray)) {
        return;
    }
    switch (type) {
        case ChMune:
            {
                long data0 = 0;
                for (CHdelayModel *model in modelArray) {
                    data0 = pow(2,model.outCH - 1) + data0; 
                    SDLog(@"allStr   5555  data0 = %d model.outch = %d",data0,model.outCH);
                }
                SDLog(@"allStr   5555 [SocketManager stringWithHexNumber:data0] = %@",[SocketManager stringWithHexNumber:data0]);
                
                CHdelayModel *model0 = modelArray[0];
                NSMutableString *tipStr = [NSMutableString string];
                
                [tipStr appendString:[NSString stringWithFormat:@"00%@",CHdelayMuneAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                
                [tipStr appendFormat:@"%@%@",@"00",model0.isMune?@"01":@"00"];
                [SocketManagerShare seneTipWithType:DelayMune WithStr:tipStr Count:count];
            }
            break;
        case CHdelayPhase:
        {
            long data0 = 0;
            for (CHdelayModel *model in modelArray) {
                data0 = pow(2,model.outCH - 1) + data0;
            }
            CHdelayModel *model0 = modelArray[0];
            NSMutableString *tipStr = [NSMutableString string];
           
            [tipStr appendString:[NSString stringWithFormat:@"00%@",CHdelayPhaseAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@%@",@"00",model0.isPhase180?@"01":@"00"];
            [SocketManagerShare seneTipWithType:Phase180 WithStr:tipStr Count:count];
        }
            break;
        case CHdelayDistance:
        {
            long data0 = 0;
            for (CHdelayModel *model in modelArray) {
                data0 = pow(2,model.outCH - 1) + data0;
            }
            CHdelayModel *model0 = modelArray[0];
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendString:[NSString stringWithFormat:@"00%@",CHdelayDistanceAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:model0.distance]];
            [SocketManagerShare seneTipWithType:Distence WithStr:tipStr Count:count];
        }
            break;
        case CHdelayDelay:
        {
//            long data0 = 0;
//            for (CHdelayModel *model in modelArray) {
//                data0 = pow(2,model.outCH - 1) + data0;
//            }
//            CHdelayModel *model0 = modelArray[0];
//            NSMutableString *tipStr = [NSMutableString string];
//            [tipStr appendString:[NSString stringWithFormat:@"00%@",CHdelayDelayAdr]];
//            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
//
//            if((int)model0.delay%2 != 0){
//                model0.delay = (int)model0.delay -1;
//            }
//
//            [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(int)model0.delay]];
//            [SocketManagerShare seneTipWithType:Delay WithStr:tipStr Count:count];
            
            for (CHdelayModel *model in modelArray) {
                long data0 = 0;
                data0 = pow(2,model.outCH - 1) ;
                
                CHdelayModel *model0 = model;
                NSMutableString *tipStr = [NSMutableString string];
                [tipStr appendString:[NSString stringWithFormat:@"00%@",CHdelayDelayAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                
//                if((int)model0.delay%2 != 0){
//                    model0.delay = (int)model0.delay -1;
//                }
                
                [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(int)model0.delay]];
                [SocketManagerShare seneTipWithType:Delay WithStr:tipStr Count:count];
            }
            
        }
            break;
        default:
            break;
    }
}
- (IBAction)modeChangeClick:(id)sender {
    for (int i = 901; i <= 902; i++) {
        UIButton*but = (UIButton *)[self.view viewWithTag:i];
        if (![but isEqual:sender]) {
            but.selected = NO;
        } else{
            but.selected = YES;
        }
    }
    UIButton *but = (UIButton *)sender;
    self.seleDelayMode = but.tag;
    //暂时全部seleDelayMode 都设为 CHdelayDelay其他两种没用
    self.seleDelayMode = CHdelayDelay;
    
    if (self.seleDelayView != nil) {
        self.addButton.enabled = YES;
        self.deleButton.enabled = YES;
        self.sliderV.enabled = YES;
        
        
        if(self.seleDelayMode  == CHdelayPhase){
            self.sliderV.maximumValue = 180;
            
            self.sliderV.value = self.seleDelayView.delayModel.phase;
        }else if(self.seleDelayMode  == CHdelayDelay){
            self.sliderV.maximumValue = 1000 * 2;
            self.sliderV.value = self.seleDelayView.delayModel.delay;
        }else if(self.seleDelayMode  == CHdelayDistance){
            self.sliderV.maximumValue = 343 * 2;
            self.sliderV.value = self.seleDelayView.delayModel.distance;
        }
        SDLog(@"选择了seleDHdelayMode = %d",self.seleDelayMode);
    }
}
-(void)RemoveAllNotification{
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    SDLog(@"移除通知222");
}
-(void)ChDelayRefreshNotificaion{
    DISPATCH_ON_MAIN_THREAD(^{
        [UIUtil hideProgressHUD];
        [self refreshViews];
    })
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seleDelayMode = CHdelayUnknow;
    if (isIphoneX) {
        self.VCBottomConstraint.constant = kTabBarHeight;
        self.naviBarHeight.constant = kTopHeight;
        self.twoButtonBottomCon.constant = 40;
        self.carTopConstraint.constant = 0;
    }
    
    KAddObserver(RemoveAllNotification, RemoveAllNotification, nil)
    KAddObserver(ChDelayRefreshNotificaion, ChDelayRefreshNotificaion, nil)
    
    
    self.changeModelArray = [NSMutableArray array];
    self.chVArray = [NSMutableArray array];
    //设置滑动条
    DISPATCH_ON_MAIN_THREAD((^{
    self.sliderV.minimumValue = 0;
//    self.sliderV.maximumValue = 24;
    self.sliderV.value = 0;
    //设置滚动条左侧和右侧不同的颜色
    [self.sliderV setMaximumTrackImage:[UIImage imageNamed:@"article ability"] forState:UIControlStateNormal];
    [self.sliderV setMinimumTrackImage:[UIImage imageNamed:@"save to ch delay memory_button_selected"] forState:UIControlStateNormal];
    [self.sliderV setThumbImage:[UIImage imageNamed:@"article ability_button"] forState:UIControlStateNormal];
    [self.sliderV setThumbImage:[UIImage imageNamed:@"article ability_button"] forState:UIControlStateHighlighted];
        
    if (SocketManagerShare.ChDelayNeedRefresh && SocketManagerShare.isCurrentWIFI) {
        [UIUtil showProgressHUD:nil inView:self.view];
//        [SocketManagerShare sendTwoDataTipWithType:AckCurUiIdParameter withCount:0 withData0Int:1 withData1Int:2];
    }else{
         [self refreshViews];
    }
        
    }))
}
-(void)refreshViews{
    for (NSString *tagStr in DeviceToolShare.selectHornArray) {
        int tagInt = [tagStr intValue];
        
        UIButton *clcikButton;
        UIView *backView;
        CHDelay *chV= [[CHDelay alloc]init];
        int seleTag;
        switch (tagInt) {
            case 201:
            {
                // 高  中 中抽 2分  低
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"203"]
                        || [itemStr isEqualToString:@"202"]
                        || [itemStr isEqualToString:@"204"]
                        || [itemStr isEqualToString:@"205"]) {
                        seleCount++;
                    }
                }
                
//                if ([DeviceToolShare.selectHornArray indexOfObject:@"203"] != NSNotFound) {
//                    seleTag = F_three;
//                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
//                }else{
//                    seleTag = F_two;
//                    clcikButton = (UIButton *)[self.view viewWithTag:F_two];
//                }
                if (seleCount == 0) {
                    seleTag = F_one;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_three;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"FL\nWoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FL\nWoofer" forState:UIControlStateSelected];
            }
                break;
            case 251:
            {
//                if ([DeviceToolShare.selectHornArray indexOfObject:@"253"] != NSNotFound) {
//                    seleTag = R_three;
//                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
//
//                }else{
//                    seleTag = R_two;
//                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
//                }
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"253"]
                        || [itemStr isEqualToString:@"252"]
                        || [itemStr isEqualToString:@"254"]
                        || [itemStr isEqualToString:@"255"]) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_one;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_three;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"FR\nWoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FR\nWoofer" forState:UIControlStateSelected];
                
            }
                break;
            case 202:
            {
                if ([DeviceToolShare.selectHornArray indexOfObject:@"203"] != NSNotFound) {
                    seleTag = F_two;
                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                }else{
                    seleTag = F_one;
                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                }
                
                
                [clcikButton setTitle:@"FL\nMid range" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FL\nMid range" forState:UIControlStateSelected];
            }
                break;
            case 204:
            {
                
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"203"]
                        || [itemStr isEqualToString:@"202"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_one;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_three;
                }
                
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                
                [clcikButton setTitle:@"FL\nCoax" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FL\nCoax" forState:UIControlStateSelected];
            }
                break;
            case 205:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"203"]
                        || [itemStr isEqualToString:@"202"]
                        || [itemStr isEqualToString:@"204"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_one;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_three;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"FL\n2 Way" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FL\n2 Way" forState:UIControlStateSelected];
            }
                break;
            case 252:
            {
                if ([DeviceToolShare.selectHornArray indexOfObject:@"253"] != NSNotFound) {
                    
                    seleTag = R_two;
                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                }else{
                    
                    seleTag = R_one;
                    clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                }
                [clcikButton setTitle:@"FR\nMid range" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FR\nMid range" forState:UIControlStateSelected];
            }
                break;
            case 254:
            {
                
                
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"253"]
                        || [itemStr isEqualToString:@"252"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_one;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_three;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"FR\nCoax" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FR\nCoax" forState:UIControlStateSelected];
            }
                break;
            case 255:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"253"]
                        || [itemStr isEqualToString:@"252"]
                        || [itemStr isEqualToString:@"254"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_one;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_three;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"FR\n2 Way" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FR\n2 Way" forState:UIControlStateSelected];
            }
                break;
            case 203:
            {
                seleTag = F_one;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"FL\nTweeter" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FL\nTweeter" forState:UIControlStateSelected];
            }
                break;
            case 253:
            {
                seleTag = R_one;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"FR\nTweeter" forState:UIControlStateNormal];
                [clcikButton setTitle:@"FR\nTweeter" forState:UIControlStateSelected];
            }
                break;
            case 191:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"192"]
                        || [itemStr isEqualToString:@"193"]
                        || [itemStr isEqualToString:@"206"]
                        || [itemStr isEqualToString:@"207"]) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_three;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RL\nWoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\nWoofer" forState:UIControlStateSelected];
            }
                break;
            case 192:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ( [itemStr isEqualToString:@"193"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_three;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RL\nMid range" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\nMid range" forState:UIControlStateSelected];
            }
                break;
            case 193:
            {
                
                    seleTag = F_three;
                
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RL\nTweeter" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\nTweeter" forState:UIControlStateSelected];
            }
                break;
            case 241:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"242"]
                        || [itemStr isEqualToString:@"243"]
                        || [itemStr isEqualToString:@"256"]
                        || [itemStr isEqualToString:@"257"]) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_three;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RR\nWoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RR\nWoofer" forState:UIControlStateSelected];
            }
                break;
            case 242:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ( [itemStr isEqualToString:@"243"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_three;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RR\nMid range" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RR\nMid range" forState:UIControlStateSelected];
            }
                break;
            case 243:
            {
                
                seleTag = R_three;
                
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RR\nTweeter" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\nTweeter" forState:UIControlStateSelected];
            }
                break;
            case 206:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"192"]
                        || [itemStr isEqualToString:@"193"]
                        
                        || [itemStr isEqualToString:@"207"]) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_three;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                
                [clcikButton setTitle:@"RL\n2 Way" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\n2 Way" forState:UIControlStateSelected];
            }
                break;
            case 207:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"192"]
                        || [itemStr isEqualToString:@"193"]
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = F_three;
                }else if(seleCount == 1){
                    seleTag = F_two;
                }else {
                    seleTag = F_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"RL\nCoax" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RL\nCoax" forState:UIControlStateSelected];
            }
                break;
            case 256:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"242"]
                        || [itemStr isEqualToString:@"243"]
                        || [itemStr isEqualToString:@"257"]) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_three;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"RR\n2 Way" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RR\n2 Way" forState:UIControlStateSelected];
            }
                break;
            case 257:
            {
                int seleCount = 0;
                for (NSString *itemStr in DeviceToolShare.selectHornArray) {
                    if ([itemStr isEqualToString:@"242"]
                        || [itemStr isEqualToString:@"243"]
                        
                        ) {
                        seleCount++;
                    }
                }
                if (seleCount == 0) {
                    seleTag = R_three;
                }else if(seleCount == 1){
                    seleTag = R_two;
                }else {
                    seleTag = R_one;
                }
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"RR\nCoax" forState:UIControlStateNormal];
                [clcikButton setTitle:@"RR\nCoax" forState:UIControlStateSelected];
            }
                break;
            case 208:
            {
                seleTag = SubWoofer;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateSelected];
            }
                break;
            case 213:
            {
                seleTag = SubWooferL;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateSelected];
            }
                break;
            case 214:
            {
                seleTag = SubWooferR;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateNormal];
                [clcikButton setTitle:@"Subwoofer" forState:UIControlStateSelected];
            }
                break;
            case 209:
            case 210:
            case 211:
            case 212:
            {
                seleTag = Center;
                clcikButton = (UIButton *)[self.view viewWithTag:seleTag];
                [clcikButton setTitle:@"Center" forState:UIControlStateNormal];
                [clcikButton setTitle:@"Center" forState:UIControlStateSelected];
            }
                break;
                
            default:
                seleTag = 0;
                break;
        }
        backView = (UIView *)[self.view viewWithTag:seleTag - 200];
        chV.tag = seleTag - 100;
        clcikButton.hidden = NO;
        if (clcikButton.tag != SubWoofer && clcikButton.tag != Center) {
            clcikButton.titleLabel.numberOfLines = 2;
            
            if ([clcikButton.titleLabel.text isEqualToString:@"FR\nMid range"]
                || [clcikButton.titleLabel.text isEqualToString:@"FL\nMid range"]) {
                clcikButton.titleLabel.font = [UIFont systemFontOfSize:5];
            }else{
                clcikButton.titleLabel.font = [UIFont systemFontOfSize:7];
            }
        }else{
            if (FSystemVersion >= 10.0) {
                clcikButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            }
        }
        
        clcikButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [clcikButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [chV showInView:backView];
        
        
        CHdelayModel *delayModel;
        for (hornDataModel *model in DeviceToolShare.hornDataArray) {
            if ([model.hornType isEqualToString:tagStr]) {
                delayModel = model.cHdelayModel;
                delayModel.outCH = model.outCh;
            }
        }
        
        chV.delayModel = delayModel;
        [self.chVArray addObject:chV];
        
    }
    if (self.chVArray.count != 0) {
        CHDelay *chVV = self.chVArray[0];
        int tag = chVV.tag + 100;
        
        UIButton*but = (UIButton*)[self.view viewWithTag:tag];
        [self seleButtonClick:but];
        
        UIButton*but2 = (UIButton*)[self.view viewWithTag:901];
        [self modeChangeClick:but2];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CYTABBARCONTROLLER.tabbar.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CYTabBarDelegate
//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    
    [self.navigationController pushViewController:[RTA_VC new] animated:YES];
}
@end
