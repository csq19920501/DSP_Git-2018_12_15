//
//  CHCrossover_VC.m
//  DSP
//
//  Created by hk on 2018/6/20.
//  Copyright © 2018年 hk. All rights reserved.
//
#import "AppDelegate.h"
#import "CHCrossover_VC.h"
#import "CYTabBarController.h"
#import "RTA_VC.h"
#import "CSQCircleView.h"
#import "AdvancedTuning.h"
#import "CustomerCar.h"
#import "CsqCrossoverView.h"
#import "UILabel+TapAction.h"
@interface CHCrossover_VC ()<CYTabBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet CSQCircleView *csqCircleV;
@property (weak, nonatomic) IBOutlet CsqCrossoverView *aaChartView;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@property (weak, nonatomic) IBOutlet UILabel *seleHornLabel;
@property(nonatomic,strong)hornDataModel* seleHornModel;

@property(nonatomic,assign)CrossoverSeleType seleType;
@property(nonatomic,assign)NSInteger freqStep;
@end

@implementation CHCrossover_VC

- (IBAction)seleClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    for (int i = 200; i<205; i++) {
        UIButton *bu = (UIButton *)[self.view viewWithTag:i];
        if (![bu isEqual:but]) {
            bu.selected = NO;
        }else{
            bu.selected = YES;
        }
    }
    [self setProgreseeWithType:but.tag];
}
- (IBAction)reset:(id)sender {
    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
        
    } withConfirmClick:^{
            [self.seleHornModel reset_corssover];
            self.aaChartView.hornDataModel = self.seleHornModel;
            [self changeLabelTitle];
            [self setProgreseeWithType:FLiterType];
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2) {
                hornDataModel *model2 = DeviceToolShare.crossoverSeleHornDataArray[1];
                [model2 reset_corssover];
            }
            
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendFormat:@"00%@00",ResetSelectCrossover];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
//            [tipStr appendFormat:@"02"];
            [SocketManagerShare seneTipWithType:Reset_selectCrossover WithStr:tipStr Count:maxCount];
    } withTitle:@"Reset will delece data ,Are you sure?"];
}


- (IBAction)backClick:(id)sender {
    KPostNotification(RemoveAllNotification, nil)
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.homeNavi popToRootViewControllerAnimated:YES];
}
- (IBAction)saveClicl:(id)sender {
    NSString *leftStr = [NSString stringWithFormat:@"Save to CH Crossover %@",[AppData managerAWithTag:505]];
    NSString *rightStr = [NSString stringWithFormat:@"Save to CH Crossover %@",[AppData managerAWithTag:605]];
    CusSeleView *chouseV = [[CusSeleView alloc]init];
    [chouseV showInView:[AppData theTopView] withOneTitle:leftStr TwoTitle:rightStr withTipTitle:@"Please select where to save?" withCancelClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:5 withData1Int:0];
    } withConfirmClick:^{
        [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:5 withData1Int:1];
    }];
}
- (IBAction)hornClick:(id)sender {
    AdvancedTuning *VC = [[AdvancedTuning alloc]init];
    VC.moduleType = CrossoverModuleType;
    MPWeakSelf(self)
    [VC setChangeSeleHorn:^(NSArray *seleArray ){
        [DeviceToolShare.crossoverSeleHornDataArray removeAllObjects];
        NSString *titleStr;
        if (seleArray.count == 2) {
           
            
            NSString *outStr1;
            NSString *outStr2;
            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                if ([model.hornType isEqualToString:seleArray[0]] ) {
                    [DeviceToolShare.crossoverSeleHornDataArray addObject:model];
                    outStr1 = [NSString stringWithFormat:@"CH%d",model.outCh];
                }
                
            }
            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                
                if ( [model.hornType isEqualToString:seleArray[1]]) {
                    [DeviceToolShare.crossoverSeleHornDataArray addObject:model];
                    outStr2 = [NSString stringWithFormat:@"CH%d",model.outCh];
                }
            }
            titleStr = [NSString stringWithFormat:@"%@ %@/%@ %@",[CustomerCar changeTagToHorn:seleArray[0]],outStr1,[CustomerCar changeTagToHorn:seleArray[1]],outStr2];
            
            weakself.seleHornLabel.text = titleStr;
        }else if(seleArray.count == 1){
            NSString *outStr1;
            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                if ([model.hornType isEqualToString:seleArray[0]]) {
                    [DeviceToolShare.crossoverSeleHornDataArray addObject:model];
                    outStr1 = [NSString stringWithFormat:@"CH%d",model.outCh];
                }
            }
            titleStr = [NSString stringWithFormat:@"%@ %@",[CustomerCar changeTagToHorn:seleArray[0]],outStr1];
            weakself.seleHornLabel.text = titleStr;
        }
        if (!kArrayIsEmpty(DeviceToolShare.crossoverSeleHornDataArray)) {
            weakself.seleHornModel = DeviceToolShare.crossoverSeleHornDataArray[0];
            [weakself changeLabelTitle];
            UIButton *seleBut = (UIButton*)[weakself.view viewWithTag:200];
            [weakself seleClick:seleBut];
            weakself.aaChartView.hornDataModel = weakself.seleHornModel;
            
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2) {
                long data0 = pow(2,weakself.seleHornModel.outCh - 1);
                [SocketManagerShare  sendTwoDataTipWithType:CopyEnum withCount:0 withData0Int:data0 withData1Int:3];
            }
        }
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)addClick:(id)sender {
    UIButton *hiFreqBut = (UIButton *)[self.view viewWithTag:Hifreq];
    UIButton *loFreqBut = (UIButton*)[self.view viewWithTag:LoFreq];
    if (loFreqBut.selected ) {
        CGFloat loEq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverLoFreq];
        CGFloat band = [hornDataModel bandFromFreq:loEq + 1];
        
//        if (loEq <= 100) {
            band = [hornDataModel bandFromFreq:loEq + self.freqStep];
//        }else if (loEq <= 1000){
//            band = [hornDataModel bandFromFreq:loEq + 10];
//        }else if (loEq <= 10000){
//            band = [hornDataModel bandFromFreq:loEq + 1000];
//        }else{
//            band = [hornDataModel bandFromFreq:loEq + 1000];
//        }
        
        if (band <=  self.csqCircleV.MainLevel) {
            [self.csqCircleV setLevel:band];
        }else{
             [self.csqCircleV setLevel:self.csqCircleV.MainLevel];
        }
    }else if (hiFreqBut.selected){
        CGFloat loEq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverHifreq];
        CGFloat band = [hornDataModel bandFromFreq:loEq + 1];
        
//        if (loEq <= 100) {
            band = [hornDataModel bandFromFreq:loEq + self.freqStep];
//        }else if (loEq <= 1000){
//            band = [hornDataModel bandFromFreq:loEq + 10];
//        }else if (loEq <= 10000){
//            band = [hornDataModel bandFromFreq:loEq + 1000];
//        }else{
//            band = [hornDataModel bandFromFreq:loEq + 1000];
//        }
        
        if (band <=  self.csqCircleV.MainLevel) {
            [self.csqCircleV setLevel:band];
        }else{
            [self.csqCircleV setLevel:self.csqCircleV.MainLevel];
        }
    }
    else{
        CGFloat nowLevel = self.csqCircleV.currentLevel + 1;
        if (nowLevel <=  self.csqCircleV.MainLevel) {
            [self.csqCircleV setLevel:nowLevel];
        }else{
            [self.csqCircleV setLevel:self.csqCircleV.MainLevel];
        }
    }
}
- (IBAction)deleClick:(id)sender {
    
    UIButton *hiFreqBut = (UIButton *)[self.view viewWithTag:Hifreq];
    UIButton *loFreqBut = (UIButton*)[self.view viewWithTag:LoFreq];
    if (loFreqBut.selected ) {
        CGFloat loEq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverLoFreq];
        CGFloat band = [hornDataModel bandFromFreq:loEq - 1];
       
//        if (loEq <= 100) {
            band = [hornDataModel bandFromFreq:loEq - self.freqStep];
         SDLog(@"levelChangedele band = %f  ",band);
//        }else if (loEq <= 1000){
//            band = [hornDataModel bandFromFreq:loEq - 10];
//        }else if (loEq <= 10000){
//            band = [hornDataModel bandFromFreq:loEq - 1000];
//        }else{
//            band = [hornDataModel bandFromFreq:loEq - 1000];
//        }
        
        if (band >= self.csqCircleV.zeroLevel) {
            [self.csqCircleV setCrossLevel:band];
        }else{
            [self.csqCircleV setCrossLevel:self.csqCircleV.zeroLevel];
        }
    }else if (hiFreqBut.selected){
        CGFloat loEq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverHifreq];
        CGFloat band = [hornDataModel bandFromFreq:loEq - 1];
        
//        if (loEq <= 100) {
            band = [hornDataModel bandFromFreq:loEq - self.freqStep];
//        }else if (loEq <= 1000){
//            band = [hornDataModel bandFromFreq:loEq - 10];
//        }else if (loEq <= 10000){
//            band = [hornDataModel bandFromFreq:loEq - 1000];
//        }else{
//            band = [hornDataModel bandFromFreq:loEq - 1000];
//        }
        if (band >= self.csqCircleV.zeroLevel) {
            [self.csqCircleV setCrossLevel:band];
        }else{
            [self.csqCircleV setCrossLevel:self.csqCircleV.zeroLevel];
        }
    }
    else{
        CGFloat nowLevel = self.csqCircleV.currentLevel - 1;
        if (nowLevel >=  self.csqCircleV.zeroLevel) {
            [self.csqCircleV setLevel:nowLevel];
        }else{
            [self.csqCircleV setLevel:self.csqCircleV.zeroLevel];
        }
    }
}
-(void)RemoveAllNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    SDLog(@"移除通知333");
}
-(void)CrossoverRefreshNotificaion{
    [self.csqCircleV setSendData:^(){
        self.stepLabel.isTapAction = YES;
    }];
    DISPATCH_ON_MAIN_THREAD((^{
        [UIUtil hideProgressHUD];
        [self refreshViews];
    }));
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.freqStep = 1;
    self.seleArray = [NSMutableArray array];
    if (isIphoneX) {
        self.VCBottomConstraint.constant = kTabBarHeight;
        self.naviBarHeight.constant = kTopHeight;
    }
    
    KAddObserver(RemoveAllNotification, RemoveAllNotification, nil)
    KAddObserver(CrossoverRefreshNotificaion, CrossoverRefreshNotificaion, nil)
    if (SocketManagerShare.CrossoverNeedRefresh && SocketManagerShare.isCurrentWIFI) {
        [UIUtil showProgressHUD:nil inView:self.view];
//        [SocketManagerShare sendTwoDataTipWithType:AckCurUiIdParameter withCount:0 withData0Int:1 withData1Int:3];
    }else{
        [self refreshViews];
    }
    
}
-(void)refreshViews{

    DISPATCH_ON_MAIN_THREAD((^{
        
        if (DeviceToolShare.crossoverSeleHornDataArray.count == 0) {
            if (DeviceToolShare.hornDataArray.count != 0) {
                [DeviceToolShare.crossoverSeleHornDataArray addObject:DeviceToolShare.hornDataArray[0]];
                self.seleHornModel = DeviceToolShare.crossoverSeleHornDataArray[0];
                
                //添加默认关联horn---------
                if (self.seleHornModel.hornType.integerValue>=255) {
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.hornType.integerValue == self.seleHornModel.hornType.integerValue - 50) {
                           
                            
                            if (DeviceToolShare.crossoverR_connectType == INEQ_connectType_top) {
                                [DeviceToolShare.crossoverSeleHornDataArray insertObject:model atIndex:0];
                                self.seleHornModel = DeviceToolShare.crossoverSeleHornDataArray[0];
                            }else if(DeviceToolShare.crossoverR_connectType == INEQ_connectType_bottom){
                                [DeviceToolShare.crossoverSeleHornDataArray addObject:model];
                            }
                        }
                    }
                }else if (self.seleHornModel.hornType.integerValue<=207){
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.hornType.integerValue == self.seleHornModel.hornType.integerValue + 50) {
                            if (DeviceToolShare.crossoverF_connectType == INEQ_connectType_top) {
                                [DeviceToolShare.crossoverSeleHornDataArray addObject:model];
                            }else if(DeviceToolShare.crossoverF_connectType == INEQ_connectType_bottom){
                                [DeviceToolShare.crossoverSeleHornDataArray insertObject:model atIndex:0];
                                self.seleHornModel = DeviceToolShare.crossoverSeleHornDataArray[0];
                            }
                        }
                    }
                }
                //-------------
            }else{
                self.seleHornModel = [[hornDataModel alloc]init];
            }
        }else if(DeviceToolShare.crossoverSeleHornDataArray.count >= 1){
            
            self.seleHornModel = DeviceToolShare.crossoverSeleHornDataArray[0];
        }
        
        NSString *titleStr;
        if (DeviceToolShare.crossoverSeleHornDataArray.count == 2) {
            hornDataModel *model2 = DeviceToolShare.crossoverSeleHornDataArray[1];
            titleStr = [NSString stringWithFormat:@"%@ %@/%@ %@",[CustomerCar changeTagToHorn:self.seleHornModel.hornType],[NSString stringWithFormat:@"CH%d",self.seleHornModel.outCh],[CustomerCar changeTagToHorn:model2.hornType],[NSString stringWithFormat:@"CH%d",model2.outCh]];
            self.seleHornLabel.text = titleStr;
        }else if(DeviceToolShare.crossoverSeleHornDataArray.count == 1){
            titleStr = [NSString stringWithFormat:@"%@ %@",[CustomerCar changeTagToHorn:self.seleHornModel.hornType],[NSString stringWithFormat:@"CH%d",self.seleHornModel.outCh]];
            self.seleHornLabel.text = titleStr;
        }
        
        
        
        [self changeLabelTitle];
        self.aaChartView.hornDataModel = self.seleHornModel;
        UIButton *seleBut = (UIButton*)[self.view viewWithTag:200];
        seleBut.selected = YES;
        [self setProgreseeWithType:FLiterType];
        [self.csqCircleV setSendData:^(){
            [self sendTipWithCount:0];
            self.stepLabel.isTapAction = YES;
        }];
        
    }))
}
-(void)sendTipWithCount:(int)count{
    
    switch (self.seleType) {
        case FLiterType:
            {
                long data0 = pow(2,self.seleHornModel.outCh - 1);
                if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                    hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                    data0 = data0 + pow(2,model2.outCh - 1);
                }
                NSMutableString *tipStr = [NSMutableString string];
                [tipStr appendString:[NSString stringWithFormat:@"00%@",fliterAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                [tipStr appendFormat:@"%@%@",@"00",[SocketManager stringWithHexNumber:(int)self.seleHornModel.CrossoverFilterType]];
                NSLog(@"crossoverType Send= %@",[SocketManager stringWithHexNumber:(int)self.seleHornModel.CrossoverFilterType]);
                [SocketManagerShare seneTipWithType:CrossoverType WithStr:tipStr Count:count];
            }
            break;
        case HiSlope:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendString:[NSString stringWithFormat:@"00%@",HiSlopeTAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@%@",@"00",[SocketManager stringWithHexNumber:(NSInteger)self.seleHornModel.CrossoverHiSlope]];
            [SocketManagerShare seneTipWithType:HiSlopeMcuType WithStr:tipStr Count:count];
        }
            break;
        case Hifreq:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendString:[NSString stringWithFormat:@"00%@",HifreqAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)[hornDataModel freqFromBand:self.seleHornModel.CrossoverHifreq]]];
            [SocketManagerShare seneTipWithType:HiFreqMcuType WithStr:tipStr Count:count];
        }
            break;
        case LoSlope:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendString:[NSString stringWithFormat:@"00%@",LoSlopeAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@%@",@"00",[SocketManager stringWithHexNumber:(NSInteger)self.seleHornModel.CrossoverLoSlope ]];
            [SocketManagerShare seneTipWithType:LoSlopeMcuType WithStr:tipStr Count:count];
        }
            break;
        case LoFreq:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendString:[NSString stringWithFormat:@"00%@",LoFreqAdr]];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)[hornDataModel freqFromBand:self.seleHornModel.CrossoverLoFreq]]];
            [SocketManagerShare seneTipWithType:LoFreqMcuType WithStr:tipStr Count:count];
        }
            break;
        case Gain_Crossover:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                [tipStr appendString:[NSString stringWithFormat:@"00%@",crossoverHiGainAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.CrossoverHiGain* 10 + 120)]];
            }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter) {
                [tipStr appendString:[NSString stringWithFormat:@"00%@",crossoverLoGainAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.CrossoverLoGain* 10 + 120)]];
            }
            
            [SocketManagerShare seneTipWithType:LoFreqMcuType WithStr:tipStr Count:count];
        }
            break;
        case Q_Crossover:
        {
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.crossoverSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.crossoverSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                [tipStr appendString:[NSString stringWithFormat:@"00%@",crossoverHiQAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.CrossoverHiQ* Q_changeV*10)]];
            }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter) {
                [tipStr appendString:[NSString stringWithFormat:@"00%@",crossoverLoQAdr]];
                [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
                [tipStr appendFormat:@"%@",[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.CrossoverLoQ* Q_changeV*10)]];
            }
            [SocketManagerShare seneTipWithType:LoFreqMcuType WithStr:tipStr Count:count];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CYTABBARCONTROLLER.tabbar.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (DeviceToolShare.crossoverSeleHornDataArray.count == 2) {
        hornDataModel *model = DeviceToolShare.crossoverSeleHornDataArray[1];
        hornDataModel *model0 = DeviceToolShare.crossoverSeleHornDataArray[0];
        
        model.CrossoverFilterType =  model0.CrossoverFilterType;
        model.CrossoverHiSlope =  model0.CrossoverHiSlope;
        model.CrossoverLoSlope =  model0.CrossoverLoSlope;
        model.CrossoverHifreq =  model0.CrossoverHifreq;
        model.CrossoverLoFreq =  model0.CrossoverLoFreq;
    }
    [DeviceToolShare saveInfo];
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


-(void)setLabelTextWithTag:(int)tag{
    UILabel *label = (UILabel *)[self.view viewWithTag:tag];
    
    NSMutableAttributedString *slfstring = [[NSMutableAttributedString alloc]initWithString:
                                            [NSString stringWithFormat:@"%@", label.text]];
    NSRange slfstringRange = {0,[slfstring length]};
    [slfstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                      range:slfstringRange];
    
    label.attributedText = slfstring;
}
-(void)changeLabel:(UILabel*)label withStr:(NSString*)str{
    NSMutableAttributedString *slfstring = [[NSMutableAttributedString alloc]initWithString:
                                            [NSString stringWithFormat:@"%@", str]];
    NSRange slfstringRange = {0,[slfstring length]};
    [slfstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                      range:slfstringRange];
    
    label.attributedText = slfstring;
}
-(void)setProgreseeWithType:(CrossoverSeleType)seleType{
    self.seleType = seleType;
    
    if (self.seleType == Hifreq || self.seleType == LoFreq) {
        self.stepLabel.hidden = NO;
        self.stepLabel.text = [NSString stringWithFormat:@"Step:%ldHz",(long)self.freqStep];
        [self.stepLabel csqTapBlock:^{
            
            
            switch (self.freqStep) {
                case 1:
                {
                    self.freqStep = 10;
                }
                    break;
                case 10:
                {
                    self.freqStep = 100;
                }
                    break;
                case 100:
                {
                    self.freqStep = 1000;
                }
                    break;
                case 1000:
                {
                    self.freqStep = 1;
                }
                    break;
                    
                default:
                    break;
            }
            self.stepLabel.text = [NSString stringWithFormat:@"Step:%ldHz",(long)self.freqStep];
        }];

        self.csqCircleV.twoClickBlock = ^(){
        };
    }else{
        self.stepLabel.hidden = YES;
        self.csqCircleV.twoClickBlock = ^(){
        };
    }
    switch (seleType) {
        case FLiterType:
            {
                UILabel *typeLabel = (UILabel*)[self.view viewWithTag:100];
                [self.csqCircleV setMainLevel:BandFilter];
                [self.csqCircleV drawProgress];
                [self.csqCircleV setValueChange:^(CGFloat level){
                    SDLog(@"levelChange = %f",level);
                    self.seleHornModel.CrossoverFilterType = (int)level;
                    self.aaChartView.hornDataModel = self.seleHornModel;
                    
                    switch ((int)level) {
                        case AllPass:
                            case HighPassFilter:
                            case LowPassFIlter:
                            case BandFilter:
                            {
                                for (int i = 100; i < 105; i++) {
                                    if (i == 101 || i == 102 ) {
                                        UILabel *label = (UILabel *)[self.view viewWithTag:i];
                                        label.hidden = NO;
                                        UIButton *but =(UIButton *)[self.view viewWithTag:100 + i];
                                        but.hidden = NO;
                                    }
                                }
                                
                                for (int i = 105; i <= 106; i++) {
                                    UILabel *label = (UILabel *)[self.view viewWithTag:i];
                                    label.hidden = YES;
                                    UIButton *but =(UIButton *)[self.view viewWithTag:100 + i];
                                    but.hidden = YES;
                                }
                            }
                            break;
                         case HiShelfFilter:
                            case LoShelfFilter:
                        {
                            for (int i = 100; i < 105; i++) {
                                if (i == 101 || i == 102 ) {
                                    UILabel *label = (UILabel *)[self.view viewWithTag:i];
                                    label.hidden = YES;
                                    UIButton *but =(UIButton *)[self.view viewWithTag:100 + i];
                                    but.hidden = YES;
                                }
                            }
                            for (int i = 105; i <= 106; i++) {
                                UILabel *label = (UILabel *)[self.view viewWithTag:i];
                                label.hidden = NO;
                                UIButton *but =(UIButton *)[self.view viewWithTag:100 + i];
                                but.hidden = NO;
                            }
                            [self changeLabelTitle];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    switch ((int)level) {
                        case AllPass:
                        {
                            [self changeLabel:typeLabel withStr:@"All Pass"];
                            for (int i = 201; i <= 204; i++) {
                                UIButton*but = (UIButton*)[self.view viewWithTag:i];
                                but.enabled = NO;
                                but.alpha = 0.3;
                                
                                UILabel *label = (UILabel *)[self.view viewWithTag:i -100];
                                label.alpha = 0.3;
                            }
                        }
                            break;
                        case HighPassFilter:
                        {
                            
                            [self changeLabel:typeLabel withStr:@"High Pass Filter"];
                            UIButton*but = (UIButton*)[self.view viewWithTag:203];
                            but.enabled = YES;
                            but.alpha = 1;
                            UIButton*but2 = (UIButton*)[self.view viewWithTag:201];
                            but2.enabled = YES;
                            but2.alpha = 1;
                            
                            UILabel *label = (UILabel *)[self.view viewWithTag:103];
                            label.alpha = 1;
                            
                            UILabel *label2 = (UILabel *)[self.view viewWithTag:101];
                            label2.alpha = 1;
                            
                            UIButton*but3 = (UIButton*)[self.view viewWithTag:204];
                            but3.enabled = NO;
                            but3.alpha = 0.3;
                            UIButton*but4 = (UIButton*)[self.view viewWithTag:202];
                            but4.enabled = NO;
                            but4.alpha = 0.3;
                            
                            UILabel *label3 = (UILabel *)[self.view viewWithTag:104];
                            label3.alpha = 0.3;
                            
                            UILabel *label4 = (UILabel *)[self.view viewWithTag:102];
                            label4.alpha = 0.3;
                        }
                            break;
                        case LowPassFIlter:
                        {
                            
                            [self changeLabel:typeLabel withStr:@"Low Pass FIlter"];
                            UIButton*but = (UIButton*)[self.view viewWithTag:204];
                            but.enabled = YES;
                            but.alpha = 1;
                            UIButton*but2 = (UIButton*)[self.view viewWithTag:202];
                            but2.enabled = YES;
                            but2.alpha = 1;
                            
                            UILabel *label = (UILabel *)[self.view viewWithTag:104];
                            label.alpha = 1;
                            
                            UILabel *label2 = (UILabel *)[self.view viewWithTag:102];
                            label2.alpha = 1;
                            
                            UIButton*but3 = (UIButton*)[self.view viewWithTag:203];
                            but3.enabled = NO;
                            but3.alpha = 0.3;
                            UIButton*but4 = (UIButton*)[self.view viewWithTag:201];
                            but4.enabled = NO;
                            but4.alpha = 0.3;
                            
                            UILabel *label3 = (UILabel *)[self.view viewWithTag:103];
                            label3.alpha = 0.3;
                            
                            UILabel *label4 = (UILabel *)[self.view viewWithTag:101];
                            label4.alpha = 0.3;
                        }
                            break;
                        case BandFilter:
                        {
                            
                            [self changeLabel:typeLabel withStr:@"Band Filter"];
                            for (int i = 201; i <= 204; i++) {
                                UIButton*but = (UIButton*)[self.view viewWithTag:i];
                                but.enabled = YES;
                                but.alpha = 1;
                                
                                UILabel *label4 = (UILabel *)[self.view viewWithTag:i - 100];
                                label4.alpha = 1;
                            }
                        }
                            break;
                            case HiShelfFilter:
                        {
                            [self changeLabel:typeLabel withStr:@"Hi Shelf FIlter"];
                            for (int i = 201; i <= 204; i++) {
                                if (i != 204) {
                                    UIButton*but = (UIButton*)[self.view viewWithTag:i];
                                    but.enabled = YES;
                                    but.alpha = 1;
                                    
                                    UILabel *label4 = (UILabel *)[self.view viewWithTag:i - 100];
                                    label4.alpha = 1;
                                }else{
                                    UIButton*but3 = (UIButton*)[self.view viewWithTag:i];
                                    but3.enabled = NO;
                                    but3.alpha = 0.3;
                                    UILabel *label3 = (UILabel *)[self.view viewWithTag:i - 100];
                                    label3.alpha = 0.3;
                                }
                            }
                            
                        }
                            break;
                        case LoShelfFilter:
                        {
                            [self changeLabel:typeLabel withStr:@"Lo Shelf FIlter"];
                            for (int i = 201; i <= 204; i++) {
                                if (i != 203) {
                                    UIButton*but = (UIButton*)[self.view viewWithTag:i];
                                    but.enabled = YES;
                                    but.alpha = 1;
                                    
                                    UILabel *label4 = (UILabel *)[self.view viewWithTag:i - 100];
                                    label4.alpha = 1;
                                }else{
                                    UIButton*but3 = (UIButton*)[self.view viewWithTag:i];
                                    but3.enabled = NO;
                                    but3.alpha = 0.3;
                                    UILabel *label3 = (UILabel *)[self.view viewWithTag:i - 100];
                                    label3.alpha = 0.3;
                                }
                            }
                            
                        }
                            break;
                        default:
                            break;
                    }
                    
                    
                    
                }];
                [self.csqCircleV setLevel:(int)self.seleHornModel.CrossoverFilterType];
            }
            break;
        case HiSlope:
        {
            UILabel *hiSlopeLabel = (UILabel*)[self.view viewWithTag:101];
            
//            BOOL isFind = NO;
//            for (hornDataModel *model in DeviceToolShare.crossoverSeleHornDataArray) {
//                if ([model.hornType isEqualToString:@"208"]) {
//                    isFind = YES;
//                }
//            }
//            if (isFind) {
//                [self.csqCircleV setMainLevel:4];
//            }else{
//                [self.csqCircleV setMainLevel:3];
//            }
            [self.csqCircleV setMainLevel:7];
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level);
                self.seleHornModel.CrossoverHiSlope = (int)level + 1;
                NSString *str = [NSString stringWithFormat:@"-%ddB",((int)self.seleHornModel.CrossoverHiSlope)*6];
                [self changeLabel:hiSlopeLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
                suiJiFaSong([self sendTipWithCount:maxCount];)
            }];
            [self.csqCircleV setLevel:(int)self.seleHornModel.CrossoverHiSlope -1];
        }
            break;
        case LoSlope:
        {
            UILabel *loSlopeLabel = (UILabel*)[self.view viewWithTag:102];
            
            [self.csqCircleV setMainLevel:7];
            
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level);
                self.seleHornModel.CrossoverLoSlope = (int)level+ 1;
                NSString *str = [NSString stringWithFormat:@"-%ddB",((int)self.seleHornModel.CrossoverLoSlope)*6];
                [self changeLabel:loSlopeLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
                suiJiFaSong([self sendTipWithCount:maxCount];)
            }];
            [self.csqCircleV setLevel:(int)self.seleHornModel.CrossoverLoSlope -1];
        }
            break;
        case Hifreq:
        {
            UILabel *hiFreqLabel = (UILabel*)[self.view viewWithTag:103];
            [self.csqCircleV setMainLevel:BandAllWidth];
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level);
                self.seleHornModel.CrossoverHifreq = level;
                
                
                CGFloat freq = [hornDataModel freqFromBand:level];
                NSString *str ;
//                if (freq >= 1000) {
//                    str = [NSString stringWithFormat:@"%.1fkHz",freq/1000];
//                }else{
                    str = [NSString stringWithFormat:@"%.0fHz",freq];
//                }
                [self changeLabel:hiFreqLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
                suiJiFaSong([self sendTipWithCount:maxCount];)
                self.stepLabel.isTapAction = NO;
            }];
            [self.csqCircleV setCrossLevel:self.seleHornModel.CrossoverHifreq];
        }
            break;
        case LoFreq:
        {
            UILabel *loFreqLabel = (UILabel*)[self.view viewWithTag:104];
            [self.csqCircleV setMainLevel:BandAllWidth];
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level);
                self.seleHornModel.CrossoverLoFreq = level;
                NSString *str ;
                CGFloat freq = [hornDataModel freqFromBand:level];
//                if (level >= 1000) {
//                    str = [NSString stringWithFormat:@"%.1fkHz",freq/1000];
//                }else{
                    str = [NSString stringWithFormat:@"%.0fHz",freq];
//                }
                [self changeLabel:loFreqLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
                suiJiFaSong([self sendTipWithCount:maxCount];)
                
                self.stepLabel.isTapAction = NO;
            }];
            [self.csqCircleV setCrossLevel:self.seleHornModel.CrossoverLoFreq];
        }
            break;
        case Gain_Crossover:
        {
            UILabel *gainLabel = (UILabel*)[self.view viewWithTag:105];
            [self.csqCircleV setMainLevel:240];
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %.1f",(level -120)/10 );
                if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                     self.seleHornModel.CrossoverHiGain = (level -120)/10;
                }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter){
                    self.seleHornModel.CrossoverLoGain = (level -120)/10;
                }
                NSString *str = [NSString stringWithFormat:@"%.1fdB",(level -120)/10];
                [self changeLabel:gainLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
//                suiJiFaSong([self sendTipWithCount:maxCount];)
            }];
            if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                [self.csqCircleV setLevel:(self.seleHornModel.CrossoverHiGain* 10 + 120)];
            }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter){
                [self.csqCircleV setLevel:(self.seleHornModel.CrossoverLoGain* 10 + 120)];
            }
        }
            break;
        case Q_Crossover:
        {
            UILabel *QLabel = (UILabel*)[self.view viewWithTag:106];
            [self.csqCircleV setMainLevel:99];
            [self.csqCircleV drawProgress];
            [self.csqCircleV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %.1f",(level + 1)/10 );
                
                if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                    self.seleHornModel.CrossoverHiQ= ((level + 1)/10)/Q_changeV;
                }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter){
                    self.seleHornModel.CrossoverLoQ = ((level + 1)/10)/Q_changeV;
                }
                
                NSString *str = [NSString stringWithFormat:@"%.1f",(level + 1)/10];
                
                [self changeLabel:QLabel withStr:str];
                self.aaChartView.hornDataModel = self.seleHornModel;
                //                suiJiFaSong([self sendTipWithCount:maxCount];)
            }];
            if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
                [self.csqCircleV setLevel:(self.seleHornModel.CrossoverHiQ * Q_changeV * 10 -1)];
            }else if (self.seleHornModel.CrossoverFilterType == LoShelfFilter){
                [self.csqCircleV setLevel:(self.seleHornModel.CrossoverLoQ * Q_changeV * 10 -1)];
            }
            
        }
            break;
        default:
            break;
    }
}
-(void)changeLabelTitle{
    UILabel *typeLabel = (UILabel*)[self.view viewWithTag:100];

    switch ((int)self.seleHornModel.CrossoverFilterType) {
        case AllPass:
        {
            [self changeLabel:typeLabel withStr:@"All Pass"];
        }
            break;
        case HighPassFilter:
        {
            [self changeLabel:typeLabel withStr:@"High Pass Filter"];
        }
            break;
        case LowPassFIlter:
        {
            [self changeLabel:typeLabel withStr:@"Low Pass FIlter"];
        }
            break;
        case BandFilter:
        {
            [self changeLabel:typeLabel withStr:@"Band Filter"];
        }
            break;
            
        default:
            break;
    }
    UILabel *hiSlopeLabel = (UILabel*)[self.view viewWithTag:101];

    NSString *hiSlopeStr = [NSString stringWithFormat:@"-%ddB",((int)self.seleHornModel.CrossoverHiSlope)*6];
    [self changeLabel:hiSlopeLabel withStr:hiSlopeStr];
    UILabel *loSlopeLabel = (UILabel*)[self.view viewWithTag:102];

    NSString *loStr = [NSString stringWithFormat:@"-%ddB",((int)self.seleHornModel.CrossoverLoSlope)*6];
    [self changeLabel:loSlopeLabel withStr:loStr];
    
    
    UILabel *hiFreqLabel = (UILabel*)[self.view viewWithTag:103];
    NSString *hiFreqStr ;
    CGFloat freq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverHifreq];
//    if (freq >= 1000) {
//        hiFreqStr = [NSString stringWithFormat:@"%.1fkHz",freq/1000];
//    }else{
        hiFreqStr = [NSString stringWithFormat:@"%.0fHz",freq];
//    }
    [self changeLabel:hiFreqLabel withStr:hiFreqStr];
    
    UILabel *loFreqLabel = (UILabel*)[self.view viewWithTag:104];
    NSString *loFreqStr ;
    CGFloat Lofreq = [hornDataModel freqFromBand:self.seleHornModel.CrossoverLoFreq];
//    if (Lofreq >= 1000) {
//        loFreqStr = [NSString stringWithFormat:@"%.1fkHz",Lofreq/1000];
//    }else{
        loFreqStr = [NSString stringWithFormat:@"%.0fHz",Lofreq];
//    }
    [self changeLabel:loFreqLabel withStr:loFreqStr];
    
    
    if (self.seleHornModel.CrossoverFilterType == HiShelfFilter) {
        UILabel *gainHiLabel = (UILabel*)[self.view viewWithTag:105];
        NSString *gainHistr = [NSString stringWithFormat:@"%.1fdB",self.seleHornModel.CrossoverHiGain];
        [self changeLabel:gainHiLabel withStr:gainHistr];
        
        UILabel *QLoLabel = (UILabel*)[self.view viewWithTag:106];
        NSString *gainLostr = [NSString stringWithFormat:@"%.1fdB",self.seleHornModel.CrossoverHiQ*Q_changeV];
        [self changeLabel:QLoLabel withStr:gainLostr];
    }else if(self.seleHornModel.CrossoverFilterType == LoShelfFilter){
        UILabel *gainLoLabel = (UILabel*)[self.view viewWithTag:105];
        NSString *gainLostr = [NSString stringWithFormat:@"%.1f",self.seleHornModel.CrossoverLoGain];
        [self changeLabel:gainLoLabel withStr:gainLostr];
        UILabel *QLoLabel = (UILabel*)[self.view viewWithTag:106];
        NSString *QLostr = [NSString stringWithFormat:@"%.1f",self.seleHornModel.CrossoverLoQ*Q_changeV];
        [self changeLabel:QLoLabel withStr:QLostr];
    }
    
}
@end
