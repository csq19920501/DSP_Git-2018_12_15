//
//  EQ_VC.m
//  DSP
//
//  Created by hk on 2018/6/20.
//  Copyright © 2018年 hk. All rights reserved.
//
#import "AppDelegate.h"
//#import "AAChartKit.h"
#import "EQ_VC.h"
#import "RTA_VC.h"
#import "CYTabBarController.h"
#import "AdvancedTuning.h"
#import "ENEQ_VC.h"
#import "SinView.h"
#import "eqBandModel.h"
#import "hornDataModel.h"
#import "CustomerCar.h"
#import "UILabel+TapAction.h"

typedef NS_ENUM(NSInteger,CHEQSelectType) {
  UnKnown = -1,
  Band = 0,
  FREQ = 1,
  Gain = 2,
    Q = 3,
 Type_band,
};
@interface EQ_VC ()<CYTabBarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VCBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csqCircleBottomConstraint;
@property (weak, nonatomic) IBOutlet CSQCircleView *progressV;
@property (weak, nonatomic) IBOutlet SinView *aaChartView;
@property (weak, nonatomic) IBOutlet UILabel *bandLabel;
@property (weak, nonatomic) IBOutlet UILabel *hzLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainLabel;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UIButton *CHeqButton;
@property (weak, nonatomic) IBOutlet UIButton *bandButton;
@property (weak, nonatomic) IBOutlet UIButton *hz_freqButton;
@property (weak, nonatomic) IBOutlet UIButton *gainButton;
@property (weak, nonatomic) IBOutlet UIButton *qButton;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property(nonatomic,assign)CHEQSelectType selectType;
@property(nonatomic,strong)eqBandModel * seleEqBand;
@property(nonatomic,strong)hornDataModel* seleHornModel;
@property(nonatomic,assign)NSInteger freqStep;

@property (weak, nonatomic) IBOutlet UIButton *nowHornTypeButton;
@end

@implementation EQ_VC

- (IBAction)saveClick:(id)sender {
    
    CusSeleView *chouseV = [[CusSeleView alloc]init];
    
    if (!self.CHeqButton.selected ) {
        NSString *leftStr = [NSString stringWithFormat:@"Save to CH EQ %@",[AppData managerAWithTag:501]];
        NSString *rightStr = [NSString stringWithFormat:@"Save to CH EQ %@",[AppData managerAWithTag:601]];
        
        [chouseV showInView:[AppData theTopView] withOneTitle:leftStr TwoTitle:rightStr withTipTitle:@"Please select where to save?" withCancelClick:^{
            
            [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:1 withData1Int:0];
        } withConfirmClick:^{
            
            [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:1 withData1Int:1];
        }];
    }else{
        NSString *leftStr = [NSString stringWithFormat:@"Save to In EQ %@",[AppData managerAWithTag:502]];
        NSString *rightStr = [NSString stringWithFormat:@"Save to In EQ %@",[AppData managerAWithTag:602]];
        
        [chouseV showInView:[AppData theTopView] withOneTitle:leftStr TwoTitle:rightStr withTipTitle:@"Please select where to save?" withCancelClick:^{
            
            [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:2 withData1Int:0];
        } withConfirmClick:^{
            
            [SocketManagerShare sendTwoDataTipWithType:SavePresetAdr withCount:0 withData0Int:2 withData1Int:1];
        }];
    }
    
    
}


- (IBAction)backClick:(id)sender {
    KPostNotification(RemoveAllNotification, nil)
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.homeNavi popToRootViewControllerAnimated:YES];
}
- (IBAction)resetEQ:(id)sender {
    CustomerAlertView *alert = [[CustomerAlertView alloc]init];
    [alert showInView:[AppData theTopView] withCancelTitle:@"Cancel" confirmTitle:@"Yes" withCancelClick:^{
        
        
    } withConfirmClick:^{
//        [SocketManagerShare sendTwoDataTipWithType:DeletePresetAdr withCount:0 withData0Int:DeviceToolShare.managerPreset%6 withData1Int:DeviceToolShare.managerPreset/6];
        if (!self.CHeqButton.selected && DeviceToolShare.eqSeleHornDataArray.count != 0) {
            [self.seleHornModel resectEQ_seleCH];
            self.aaChartView.bandArray = self.seleHornModel.eqBandCheqArray;
            if (DeviceToolShare.eqSeleHornDataArray.count == 2) {
                hornDataModel *model2 = DeviceToolShare.eqSeleHornDataArray[1];
                [model2 resectEQ_seleCH];
            }
            
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.eqSeleHornDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.eqSeleHornDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendFormat:@"00%@00",ResetSelectEQ];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"02"];
            [SocketManagerShare seneTipWithType:Reset_selectEQ WithStr:tipStr Count:maxCount];
        }else if(self.CHeqButton.selected){
            [self.seleHornModel resectEQ_seleIN];
            self.aaChartView.bandArray = self.seleHornModel.eqBandIneqArray;
            
            if (DeviceToolShare.ineqSeleDataArray.count == 2) {
                hornDataModel *model2 = DeviceToolShare.ineqSeleDataArray[1];
                [model2 resectEQ_seleIN];
            }
            
            long data0 = pow(2,self.seleHornModel.outCh - 1);
            if (DeviceToolShare.ineqSeleDataArray.count == 2 ) {
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.ineqSeleDataArray[1];
                data0 = data0 + pow(2,model2.outCh - 1);
            }
            NSMutableString *tipStr = [NSMutableString string];
            [tipStr appendFormat:@"00%@00",ResetSelectEQ];
            [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
            [tipStr appendFormat:@"01"];
            [SocketManagerShare seneTipWithType:Reset_selectEQ WithStr:tipStr Count:maxCount];
        }
        UIButton *bandButton = (UIButton *)[self.view viewWithTag:101];
        [self changeSelectType:bandButton];
    } withTitle:@"Reset will delect data ,Are you sure?"];
}

- (IBAction)hornClick:(id)sender {
    if(self.CHeqButton.selected){
        
        
        ENEQ_VC *VC = [[ENEQ_VC alloc]init];
        
        NSMutableArray *seleSArray = [NSMutableArray array];
        for (hornDataModel *model in DeviceToolShare.ineqSeleDataArray) {
            [seleSArray addObject:[NSString stringWithFormat:@"%d",model.outCh]];
        }
        VC.seleArray = seleSArray;
        MPWeakSelf(self)
        [VC setClickTypeBackNew:^(NSArray *selectArr){
            
            self.aaChartView.CheqshelfCount = 0;
            self.aaChartView.IneqshelfCount = 0;
            
            
            [DeviceToolShare.ineqSeleDataArray removeAllObjects];
            
            NSString *titleStr;
            if (selectArr.count == 2) {
                
                NSString *sele1Str = selectArr[0];
                NSString *sele2Str = selectArr[1];
                for (hornDataModel *model in DeviceToolShare.ineqDataArray) {
                    if (model.outCh ==  sele1Str.integerValue ) {
                        
                    
                        
                        [DeviceToolShare.ineqSeleDataArray addObject:model];
                    }
                }
                for (hornDataModel *model in DeviceToolShare.ineqDataArray) {
                    if (model.outCh ==  sele2Str.integerValue ) {
                        [DeviceToolShare.ineqSeleDataArray addObject:model];
                    }
                }
                
                if (sele1Str.integerValue < 7) {
                    titleStr = [NSString stringWithFormat:@"Analog%ld_%ld",(long)sele1Str.integerValue,(long)sele2Str.integerValue];
                }else{
                    titleStr = [NSString stringWithFormat:@"DigitalL_R"];
                }
            }else if(selectArr.count == 1){
                NSString *sele1Str = selectArr[0];
                for (hornDataModel *model in DeviceToolShare.ineqDataArray) {
                    if (model.outCh ==  sele1Str.integerValue ) {
                        
                        [DeviceToolShare.ineqSeleDataArray addObject:model];
                    }
                }
                
                if (sele1Str.integerValue < 7) {
                    titleStr = [NSString stringWithFormat:@"Analog%ld",(long)sele1Str.integerValue];
                }else if (sele1Str.integerValue > 7){
                    titleStr = [NSString stringWithFormat:@"DigitalR"];
                }else {
                    titleStr = [NSString stringWithFormat:@"DigitalL"];
                }
            }
            [weakself.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            if (!kArrayIsEmpty(DeviceToolShare.ineqSeleDataArray)) {
                DeviceToolShare.seleHornModel = DeviceToolShare.ineqSeleDataArray[0];
                weakself.seleHornModel = DeviceToolShare.ineqSeleDataArray[0];
                
                if (DeviceToolShare.ineqSeleDataArray.count ==2) {
                    long data0 = pow(2,weakself.seleHornModel.outCh - 1);
                    [SocketManagerShare  sendTwoDataTipWithType:CopyEnum withCount:0 withData0Int:data0 withData1Int:2];
                }

                weakself.aaChartView.bandArray = weakself.seleHornModel.eqBandIneqArray;
            }
            
            //同时触发两次设置band方法会崩溃
            UIButton *butt = (UIButton *)[self.view viewWithTag: 101];
            self.selectType = UnKnown;
            [self changeSelectType:butt];
        }];
        
//        [VC setClickTypeBack:^(HornINEQtype clickBackType){
//            switch (clickBackType) {
//                case analog1:
//                    {
//                        DeviceToolShare.seleHornModel = DeviceToolShare.ineqDataArray[0];
//                    }
//                    break;
//                case analog2:
//                {
//                     DeviceToolShare.seleHornModel = DeviceToolShare.ineqDataArray[1];
//                }
//                    break;
//                case analog3:
//                {
//                     DeviceToolShare.seleHornModel = DeviceToolShare.ineqDataArray[2];
//                }
//                    break;
//                case digital:
//                {
//                     DeviceToolShare.seleHornModel = DeviceToolShare.ineqDataArray[3];
//                }
//                    break;
//                default:
//                    break;
//            }
//            self.seleHornModel = DeviceToolShare.seleHornModel;
//            [self.nowHornTypeButton setTitle:self.seleHornModel.hornType forState:UIControlStateNormal];
//
//
//            //同时触发两次设置band方法会崩溃
//            UIButton *butt = (UIButton *)[self.view viewWithTag: 101];
//            self.selectType = UnKnown;
//            [self changeSelectType:butt];
//        }];

        [self.navigationController pushViewController:VC animated:YES];
    }else{
        AdvancedTuning *VC = [[AdvancedTuning alloc]init];
        VC.moduleType = EQmoduleType;
        MPWeakSelf(self)
        [VC setChangeSeleHorn:^(NSArray *seleArray ){
            [DeviceToolShare.eqSeleHornDataArray removeAllObjects];
            NSString *titleStr;
            if (seleArray.count == 2) {
                NSString *outStr1;
                NSString *outStr2;
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if ([model.hornType isEqualToString:seleArray[0]] ) {
                        [DeviceToolShare.eqSeleHornDataArray addObject:model];
                        outStr1 = [NSString stringWithFormat:@"CH%d",model.outCh];
                    }
                }
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if ( [model.hornType isEqualToString:seleArray[1]]) {
                        [DeviceToolShare.eqSeleHornDataArray addObject:model];
                        outStr2 = [NSString stringWithFormat:@"CH%d",model.outCh];
                    }
                }
                titleStr = [NSString stringWithFormat:@"%@ %@/%@ %@",[CustomerCar changeTagToHorn:seleArray[0]],outStr1,[CustomerCar changeTagToHorn:seleArray[1]],outStr2];
                [weakself.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }else if(seleArray.count == 1){
                NSString *outStr1;
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if ([model.hornType isEqualToString:seleArray[0]]) {
                        [DeviceToolShare.eqSeleHornDataArray addObject:model];
                        outStr1 = [NSString stringWithFormat:@"CH%d",model.outCh];
                    }
                }
                titleStr = [NSString stringWithFormat:@"%@ %@",[CustomerCar changeTagToHorn:seleArray[0]],outStr1];
                [weakself.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }
            if (!kArrayIsEmpty(DeviceToolShare.eqSeleHornDataArray)) {
                weakself.seleHornModel = DeviceToolShare.eqSeleHornDataArray[0];
                weakself.aaChartView.bandArray = weakself.seleHornModel.eqBandCheqArray;
                
                
                if (DeviceToolShare.eqSeleHornDataArray.count ==2) {
                
                    long data0 = pow(2,weakself.seleHornModel.outCh - 1);
                    [SocketManagerShare  sendTwoDataTipWithType:CopyEnum withCount:0 withData0Int:data0 withData1Int:1];
                }
            }
            
            //同时触发两次设置band方法会崩溃
            UIButton *butt = (UIButton *)[self.view viewWithTag: 101];
            self.selectType = UnKnown;
            [self changeSelectType:butt];
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (IBAction)addClick:(id)sender {
    if (self.selectType == FREQ) {
        CGFloat freq = [hornDataModel freqFromBand:self.progressV.currentLevel];
        CGFloat band;
//        if (freq <= 100) {
            band = [hornDataModel bandFromFreq:freq + self.freqStep];
//        }else if (freq <= 1000){
//            band = [hornDataModel bandFromFreq:freq + 10];
//        }else if (freq <= 10000){
//            band = [hornDataModel bandFromFreq:freq + 1000];
//        }else{
//            band = [hornDataModel bandFromFreq:freq + 1000];
//        }
        if (band <=  self.progressV.MainLevel) {
            [self.progressV setLevel:band];
        }else{
            [self.progressV setLevel:self.progressV.MainLevel];
        }
    }else if (self.selectType == Type_band) {
        CGFloat nowLevel = self.progressV.currentLevel + 1;
        if (nowLevel <=  self.progressV.MainLevel) {
            [self.progressV setLevel:nowLevel];
        }
    }
    else{
        CGFloat nowLevel = self.progressV.currentLevel + 1;
        if (nowLevel <=  self.progressV.MainLevel) {
            [self.progressV setLevel:nowLevel];
        }
    }
}
- (IBAction)deleClick:(id)sender {
    if (self.selectType == FREQ) {
        CGFloat freq = [hornDataModel freqFromBand:self.progressV.currentLevel];
        CGFloat band;
            band = [hornDataModel bandFromFreq:freq - self.freqStep];
        if (band >= self.progressV.zeroLevel) {
            [self.progressV setCrossLevel:band];
        }else{
            [self.progressV setCrossLevel:self.progressV.zeroLevel];
        }
    }else if (self.selectType == Type_band) {
        CGFloat nowLevel = self.progressV.currentLevel - 1;
        if (nowLevel >=  self.progressV.zeroLevel) {
            [self.progressV setLevel:nowLevel];
        }
    }
    else{
        CGFloat nowLevel = self.progressV.currentLevel - 1;
        if (nowLevel >=  self.progressV.zeroLevel) {
            [self.progressV setLevel:nowLevel];
        }
    }
}
- (IBAction)CHeqClick:(id)sender {
    UIButton *but  = (UIButton *)sender;

//    if (self.selectType == Band) {
        if (!but.selected ) {
            self.aaChartView.sinViewType = IneqViewType;
            [self.progressV setMainLevel:20];
            [self.progressV drawProgress];
            [self.progressV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level + 1);

                NSString *str = [NSString stringWithFormat:@"%.0f",level];
                self.seleHornModel.ineqSelectBand = self.seleHornModel.eqBandIneqArray[[str intValue]];
                self.seleHornModel.nowSelectBand = self.seleHornModel.ineqSelectBand;
                self.seleHornModel.nowSelectBandArray = self.seleHornModel.eqBandIneqArray;
                self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                self.bandLabel.text = [NSString stringWithFormat:@"Band:%.0f(%@)",level + 1,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType ==2?@"HSLF":@"LSLF"];
            }];
            
            self.seleHornModel = DeviceToolShare.ineqSeleDataArray[0];
            [self.progressV setLevel:self.seleHornModel.ineqSelectBand.bandNumber -1];
            
            NSString *titleStr;
            if (DeviceToolShare.ineqSeleDataArray.count == 2) {
                NSString *outStr1;
                NSString *outStr2;
                hornDataModel *model1 = (hornDataModel*)DeviceToolShare.ineqSeleDataArray[0];
                outStr1 = [NSString stringWithFormat:@"%d",model1.outCh];
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.ineqSeleDataArray[1];
                outStr2 = [NSString stringWithFormat:@"%d",model2.outCh];
                
                if (outStr1.integerValue < 7) {
                    titleStr = [NSString stringWithFormat:@"Analog%ld_%ld",(long)outStr1.integerValue,(long)outStr2.integerValue];
                }else{
                    titleStr = [NSString stringWithFormat:@"DigitalL_R"];
                }

                [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }else{
                self.aaChartView.sinViewType = CheqViewType;
                NSString *outStr1;
                hornDataModel *model1 = (hornDataModel*)DeviceToolShare.ineqSeleDataArray[0];
                outStr1 = [NSString stringWithFormat:@"%d",model1.outCh];
                if (outStr1.integerValue < 7) {
                    titleStr = [NSString stringWithFormat:@"Analog%ld",(long)outStr1.integerValue];
                }else if (outStr1.integerValue > 7){
                    titleStr = [NSString stringWithFormat:@"DigitalR"];
                }else {
                    titleStr = [NSString stringWithFormat:@"DigitalL"];
                }
                [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }
        }else{
            [self.progressV setMainLevel:9];
            [self.progressV drawProgress];
            [self.progressV setValueChange:^(CGFloat level){
                SDLog(@"levelChange = %f",level + 1);

//                self.bandLabel.text = [NSString stringWithFormat:@"Band#%.0f",level + 1];
                NSString *str = [NSString stringWithFormat:@"%.0f",level];
                self.seleHornModel.cheqSelectBand = self.seleHornModel.eqBandCheqArray[[str intValue]];
                self.seleHornModel.nowSelectBand = self.seleHornModel.cheqSelectBand;
                self.seleHornModel.nowSelectBandArray = self.seleHornModel.eqBandCheqArray;
                self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                
                 self.bandLabel.text = [NSString stringWithFormat:@"Band:%.0f(%@)",level + 1,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType ==2?@"HSLF":@"LSLF"];
            }];
            self.seleHornModel = DeviceToolShare.eqSeleHornDataArray[0];
            [self.progressV setLevel:self.seleHornModel.cheqSelectBand.bandNumber -1];
            
            NSString *titleStr;
            
            if (DeviceToolShare.eqSeleHornDataArray.count == 2) {
                NSString *outStr1;
                NSString *outStr2;
                
                hornDataModel *model1 = (hornDataModel*)DeviceToolShare.eqSeleHornDataArray[0];
                outStr1 = [NSString stringWithFormat:@"CH%d",model1.outCh];
                hornDataModel *model2 = (hornDataModel*)DeviceToolShare.eqSeleHornDataArray[1];
                outStr2 = [NSString stringWithFormat:@"CH%d",model2.outCh];
                
                titleStr = [NSString stringWithFormat:@"%@ %@/%@ %@",[CustomerCar changeTagToHorn:model1.hornType],outStr1,[CustomerCar changeTagToHorn:model2.hornType],outStr2];
                [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }else if(DeviceToolShare.eqSeleHornDataArray.count == 1){
                
                hornDataModel *model = (hornDataModel*)DeviceToolShare.eqSeleHornDataArray[0];
                NSString *outStr1;
                outStr1 = [NSString stringWithFormat:@"CH%d",model.outCh];
                titleStr = [NSString stringWithFormat:@"%@ %@",[CustomerCar changeTagToHorn:model.hornType],outStr1];
                [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
            }
            
        }
    
        but.selected = !but.selected;
        UIButton *butt = (UIButton *)[self.view viewWithTag:self.selectType + 101];
        self.selectType = UnKnown;
        [self changeSelectType:butt];
}
- (IBAction)changeSelectType:(id)sender {
    [self.progressV setSendData:^(){
        self.stepLabel.isTapAction = YES;
    }];
    UIButton*bu = (UIButton*)sender;
//    if (bu.tag - 101 != self.selectType) {
        for (int i = 101; i <= 105; i++) {
            UIButton *but = (UIButton *)[self.view viewWithTag:i];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [bu setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.selectType = bu.tag - 101;
    
    if (self.selectType == FREQ) {
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
        self.progressV.twoClickBlock = ^(){
          
            
        };
    }else{
        self.stepLabel.hidden = YES;
        self.progressV.twoClickBlock = ^(){
            
        };
    }
    
        switch (self.selectType) {
            case Band:
                {
                    if (self.CHeqButton.selected ) {
                        [self.progressV setMainLevel:20];
                        [self.progressV drawProgress];
                        [self.progressV setValueChange:^(CGFloat level){
                            SDLog(@"levelChange = %.0f",level + 1);
//                            self.bandLabel.text = [NSString stringWithFormat:@"Band#%.0f",level + 1];
                            NSString *str = [NSString stringWithFormat:@"%.0f",level];
                            self.seleHornModel.ineqSelectBand = self.seleHornModel.eqBandIneqArray[[str intValue]];
                            self.seleHornModel.nowSelectBand = self.seleHornModel.ineqSelectBand;
                            self.seleHornModel.nowSelectBandArray = self.seleHornModel.eqBandIneqArray;
                            
                            self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                            self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                            
                            
                            self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",self.seleHornModel.nowSelectBand.freq];
                            self.gainLabel.text = [NSString stringWithFormat:@"G:%.1fdB",self.seleHornModel.nowSelectBand.gain];
                            if ([self.gainLabel.text isEqualToString:@"G:-0.0dB"]
                                || [self.gainLabel.text isEqualToString:@"G:0.0dB"]) {
                                self.gainLabel.text = @"G:0dB";
                            }
                             if (self.seleHornModel.nowSelectBand.bandType == bandType_PEQ) {
                                 self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Q* Q_changeV];
                             }else{
                                 self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV];
                             }
//                            suiJiFaSong([self senTipWithCount:maxCount];)
                            
                            self.bandLabel.text = [NSString stringWithFormat:@"Band:%.0f(%@)",level + 1,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType ==2?@"HSLF":@"LSLF"];
                        }];
                        [self.progressV setLevel:self.seleHornModel.ineqSelectBand.bandNumber -1];
                    }else{
                        [self.progressV setMainLevel:9];
                        [self.progressV drawProgress];
                        [self.progressV setValueChange:^(CGFloat level){
                            SDLog(@"levelChange = %.0f",level + 1);
//                            self.bandLabel.text = [NSString stringWithFormat:@"Band#%.0f",level + 1];

                            NSString *str = [NSString stringWithFormat:@"%.0f",level];
                            self.seleHornModel.cheqSelectBand = self.seleHornModel.eqBandCheqArray[[str intValue]];
                            self.seleHornModel.nowSelectBand = self.seleHornModel.cheqSelectBand;
                            self.seleHornModel.nowSelectBandArray = self.seleHornModel.eqBandCheqArray;
                             self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                            self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                            
                            self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",self.seleHornModel.nowSelectBand.freq];
                            self.gainLabel.text = [NSString stringWithFormat:@"G:%.1fdB",self.seleHornModel.nowSelectBand.gain];
                            if ([self.gainLabel.text isEqualToString:@"G:-0.0dB"]
                                || [self.gainLabel.text isEqualToString:@"G:0.0dB"]) {
                                self.gainLabel.text = @"G:0dB";
                            }
                            if (self.seleHornModel.nowSelectBand.bandType == bandType_PEQ) {
                                self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Q* Q_changeV];
                            }else{
                                self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV];
                            }
//                            suiJiFaSong([self senTipWithCount:maxCount];)
                            self.bandLabel.text = [NSString stringWithFormat:@"Band:%.0f(%@)",level + 1,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType ==2?@"HSLF":@"LSLF"];
                        }];
                        [self.progressV setLevel:self.seleHornModel.cheqSelectBand.bandNumber -1];
                    }
                }
                break;
            case FREQ:{
                //旧版本 可调左右浮动15%
//                [self.progressV setMainLevel:30];
//                [self.progressV drawProgress];
//                [self.progressV setValueChange:^(CGFloat level){
//                    SDLog(@"levelChange = %f",level);
//                    self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",level];
//
//
//                    self.seleHornModel.nowSelectBand.bandX = self.seleHornModel.nowSelectBand.bandXBase  + (level - 15)/100 *(BandAllWidth/(self.aaChartView.bandArray.count + 1));
//
//
//                    self.seleHornModel.nowSelectBand.freq = [hornDataModel freqFromBand:self.seleHornModel.nowSelectBand.bandX];
//
//                    self.seleHornModel.nowSelectBand.freqLevel = level;
//                    self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",self.seleHornModel.nowSelectBand.freq];
//
//                    self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
//                    self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
//                    suiJiFaSong([self senTipWithCount:maxCount];)
//                }];
//                [self.progressV setLevel:self.seleHornModel.nowSelectBand.freqLevel];
                //新版本 任意调动
                [self.progressV setMainLevel:BandAllWidth];
                [self.progressV drawProgress];
                [self.progressV setValueChange:^(CGFloat level){
                    SDLog(@"levelChange = %f",level);
                    self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",level];
                    
                    self.seleHornModel.nowSelectBand.bandX = level;
                    self.seleHornModel.nowSelectBand.freq = [hornDataModel freqFromBand:self.seleHornModel.nowSelectBand.bandX];
//                    self.seleHornModel.nowSelectBand.freqLevel = level;
                    self.hzLabel.text = [NSString stringWithFormat:@"F:%.0fHz",self.seleHornModel.nowSelectBand.freq];
                    
                    self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                    self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
//                    suiJiFaSong([self senTipWithCount:maxCount];)
                    self.stepLabel.isTapAction = NO;
                }];
                [self.progressV setCrossLevel:self.seleHornModel.nowSelectBand.bandX];
            }
                break;
            case Gain:{
                [self.progressV setMainLevel:240];
                [self.progressV drawProgress];
                [self.progressV setValueChange:^(CGFloat level){
                    SDLog(@"levelChange = %.1f",(level -120)/10 );
                    self.gainLabel.text = [NSString stringWithFormat:@"G:%.1fdB",(level -120)/10];
                    if ([self.gainLabel.text isEqualToString:@"G:-0.0dB"]
                        || [self.gainLabel.text isEqualToString:@"G:0.0dB"]) {
                        self.gainLabel.text = @"G:0dB";
                    }
                    
                    
                    
                    self.seleHornModel.nowSelectBand.gain = (level -120)/10;
                    self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                    self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
//                    suiJiFaSong([self senTipWithCount:maxCount];)
                }];
                [self.progressV setLevel:(self.seleHornModel.nowSelectBand.gain * 10 + 120)];
            }
                break;
            case Q:{
                if (self.seleHornModel.nowSelectBand.bandType == bandType_PEQ) {
                    [self.progressV setMainLevel:99];//范围0.1~10
                    [self.progressV drawProgress];
                    [self.progressV setValueChange:^(CGFloat level){
                        SDLog(@"levelChange = %.1f",(level + 1)/10 );
                        self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",(level + 1)/10];
                        
                        self.seleHornModel.nowSelectBand.Q = ((level + 1)/10)/Q_changeV;
                        self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                        self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                        
                        //                    suiJiFaSong([self senTipWithCount:maxCount];)
                    }];
                    [self.progressV setLevel:(self.seleHornModel.nowSelectBand.Q * Q_changeV * 10 -1)];
                }else{
                    [self.progressV setMainLevel:17];//范围0.3~20
                    [self.progressV drawProgress];
                    [self.progressV setValueChange:^(CGFloat level){
                        SDLog(@"levelChange = %.1f",(level + 3)/10 );
                        self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",(level + 3)/10];
                        
                        self.seleHornModel.nowSelectBand.Slf_Q = ((level + 3)/10)/Q_changeV;
                        self.aaChartView.selectBandX = self.seleHornModel.nowSelectBand.bandX;
                        self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                        
                        //                    suiJiFaSong([self senTipWithCount:maxCount];)
                    }];
                    [self.progressV setLevel:(self.seleHornModel.nowSelectBand.Slf_Q * Q_changeV * 10 -3)];
                }
                
            }
                break;
            case Type_band:{
//                [self.progressV setMainLevel:5];//仅有三中可能性，这里设置六个是方便属性规划
//                [self.progressV drawProgress];
//                [self.progressV setValueChange:^(CGFloat level){
//                     SDLog(@"Type_band level= %.1f",level);
//                    if (level >= 4) {
//                        self.seleHornModel.nowSelectBand.bandType = 3;
//                    }else if (level < 2){
//                        self.seleHornModel.nowSelectBand.bandType = 1;
//                    }else{
//                        self.seleHornModel.nowSelectBand.bandType = 2;
//                    }
//
//                    self.bandLabel.text = [NSString stringWithFormat:@"Band:%ld(%@)",(long)self.seleHornModel.nowSelectBand.bandNumber,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType==2?@"HSLF":@"LSLF"];
//
//
//                    self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
//                    //                    suiJiFaSong([self senTipWithCount:maxCount];)
//                }];
                //                [self.progressV setLevel:(self.seleHornModel.nowSelectBand.bandType* 2 - 2)];
                [self.progressV setMainLevel:8];//仅有三中可能性，这里设置六个是方便属性规划
                [self.progressV drawProgress];
                [self.progressV setValueChange:^(CGFloat level){
                    SDLog(@"Type_band level= %.1f",level);
//                    if (level >= 4) {
//                        self.seleHornModel.nowSelectBand.bandType = 3;
//                    }else if (level < 2){
//                        self.seleHornModel.nowSelectBand.bandType = 1;
//                    }else{
//                        self.seleHornModel.nowSelectBand.bandType = 2;
//                    }
                    self.seleHornModel.nowSelectBand.bandType = ((int)level)%3 + 1;
                    
                    self.bandLabel.text = [NSString stringWithFormat:@"Band:%ld(%@)",(long)self.seleHornModel.nowSelectBand.bandNumber,self.seleHornModel.nowSelectBand.bandType == 1?@"PEQ":self.seleHornModel.nowSelectBand.bandType==2?@"HSLF":@"LSLF"];
                    
                    
                    self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
                    //                    suiJiFaSong([self senTipWithCount:maxCount];)
                    if (self.seleHornModel.nowSelectBand.bandType == bandType_PEQ) {
                        self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Q* Q_changeV];
                    }else{
                        self.qLabel.text = [NSString stringWithFormat:@"Q:%.1f",self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV];
                    }
                }];
                [self.progressV setLevel:(self.seleHornModel.nowSelectBand.bandType - 1)];
            }
                break;
            default:
                break;
        }
    CSQ_DISPATCH_AFTER(0.5, ^{
        [self.progressV setSendData:^(){
            [self senTipWithCount:0];
            self.stepLabel.isTapAction = YES;
        }];
    })
}
-(void)RemoveAllNotification{
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    SDLog(@"移除通知444");
}
-(void)EQRefreshNotificaion{
    [self.progressV setSendData:^(){
        self.stepLabel.isTapAction = YES;
    }];
//    DISPATCH_ON_MAIN_THREAD(^{
//
//    })
    CSQ_DISPATCH_AFTER(1, ^{
        [UIUtil hideProgressHUD];
    })
    CSQ_DISPATCH_AFTER(0.1, ^{
        [self refreshViews];
    })
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.freqStep = 1;
    self.aaChartView.sinViewType = CheqViewType;
    self.selectType = UnKnown;
    if (isIphoneX) {
        self.VCBottomConstraint.constant = kTabBarHeight;
        self.naviBarHeight.constant = kTopHeight;
        self.csqCircleBottomConstraint.constant = 40.;
    }
    KAddObserver(RemoveAllNotification, RemoveAllNotification, nil)
    KAddObserver(EQRefreshNotificaion, EQRefreshNotificaion, nil)
    if (SocketManagerShare.EQNeedRefresh && SocketManagerShare.isCurrentWIFI) {
        [UIUtil showProgressHUD:nil inView:self.view];
//        [SocketManagerShare sendTwoDataTipWithType:AckCurUiIdParameter withCount:0 withData0Int:1 withData1Int:4];
    }else{
        [self refreshViews];
    }

    self.bandLabel.adjustsFontSizeToFitWidth = YES;
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.aaChartView.height = self.aaChartView.frame.size.height;
}
-(void)refreshViews{
    NSArray *ineqType  = @[@1,@2,@3,@4,@5,@6,@7,@8];
    if (DeviceToolShare.ineqDataArray.count == 0){
        for (int i = 0; i < ineqType.count; i++) {
            hornDataModel *model = [[hornDataModel alloc]init];
            model.outCh = i + 1;
            [DeviceToolShare.ineqDataArray addObject:model];
        }
        DeviceToolShare.seleHornModel = DeviceToolShare.ineqDataArray[0];
    }
    
    if (DeviceToolShare.eqSeleHornDataArray.count == 0) {
        if (DeviceToolShare.hornDataArray.count != 0) {
            [DeviceToolShare.eqSeleHornDataArray addObject:DeviceToolShare.hornDataArray[0]];
            self.seleHornModel = DeviceToolShare.eqSeleHornDataArray[0];
         //添加默认关联horn---------
            if (self.seleHornModel.hornType.integerValue>=255) {
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if (model.hornType.integerValue == self.seleHornModel.hornType.integerValue - 50) {
                        if (DeviceToolShare.eqR_connectType == INEQ_connectType_top) {
                            [DeviceToolShare.eqSeleHornDataArray insertObject:model atIndex:0];
                            self.seleHornModel = model;
                        }else if(DeviceToolShare.eqR_connectType == INEQ_connectType_bottom){
                            [DeviceToolShare.eqSeleHornDataArray addObject:model];
                        }
                    }
                }
            }else if (self.seleHornModel.hornType.integerValue<=207){
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if (model.hornType.integerValue == self.seleHornModel.hornType.integerValue + 50) {
                        
                        if (DeviceToolShare.eqF_connectType == INEQ_connectType_top) {
                           [DeviceToolShare.eqSeleHornDataArray addObject:model];
                        }else if(DeviceToolShare.eqF_connectType == INEQ_connectType_bottom){
                           [DeviceToolShare.eqSeleHornDataArray insertObject:model atIndex:0];
                            self.seleHornModel = model;
                        }
                    }
                }
            }
          //-------------
            
        }else{
            self.seleHornModel = [[hornDataModel alloc]init];
        }
    }else if(DeviceToolShare.eqSeleHornDataArray.count >= 1){
        self.seleHornModel = DeviceToolShare.eqSeleHornDataArray[0];
    }
    
    NSString *titleStr;
    if (DeviceToolShare.eqSeleHornDataArray.count == 2) {
        hornDataModel *model2 = DeviceToolShare.eqSeleHornDataArray[1];
        titleStr = [NSString stringWithFormat:@"%@ %@/%@ %@",[CustomerCar changeTagToHorn:self.seleHornModel.hornType],[NSString stringWithFormat:@"CH%ld",(long)self.seleHornModel.outCh],[CustomerCar changeTagToHorn:model2.hornType],[NSString stringWithFormat:@"CH%ld",(long)model2.outCh]];
        [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
    }else if(DeviceToolShare.eqSeleHornDataArray.count == 1){
        titleStr = [NSString stringWithFormat:@"%@ %@",[CustomerCar changeTagToHorn:self.seleHornModel.hornType],[NSString stringWithFormat:@"CH%ld",(long)self.seleHornModel.outCh]];
        [self.nowHornTypeButton setTitle:titleStr forState:UIControlStateNormal];
    }
    
    DISPATCH_ON_MAIN_THREAD((^{
        self.aaChartView.bandArray = self.seleHornModel.nowSelectBandArray;
        UIButton *bandButton = (UIButton *)[self.view viewWithTag:101];
        [self changeSelectType:bandButton];
        
        [self.progressV setSendData:^(){
            [self senTipWithCount:0];
            self.stepLabel.isTapAction = YES;
        }];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        }];
//        tap.numberOfTapsRequired = 2;
//        tap.numberOfTouchesRequired = 1;
//        [self.progressV.rotateImage addGestureRecognizer:tap];
    }))
}
-(void)senTipWithCount:(int)count{
    if (self.selectType == Band) {
        return;
    }
//    MPWeakSelf(self)
    if (!self.CHeqButton.selected) {
        long data0 = pow(2,self.seleHornModel.outCh - 1);
        if (DeviceToolShare.eqSeleHornDataArray.count == 2 ) {
            hornDataModel *model2 = (hornDataModel*)DeviceToolShare.eqSeleHornDataArray[1];
            data0 = data0 + pow(2,model2.outCh - 1);
        }
        NSMutableString *tipStr = [NSMutableString string];
        [tipStr appendFormat:@"00%@",CheqBandAdr];
        [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
        //防止q为0
        NSInteger modelQ = (NSInteger)(self.seleHornModel.nowSelectBand.Q* Q_changeV*10)>0 ? (NSInteger)(self.seleHornModel.nowSelectBand.Q* Q_changeV*10):1;
        NSInteger model_SLf_Q = (NSInteger)(self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV*10)>0 ? (NSInteger)(self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV*10):1;
        NSString *Qstr = [NSString stringWithFormat:@"%@%@",[SocketManager stringWithHexNumber:(NSInteger)model_SLf_Q],[SocketManager stringWithHexNumber:(NSInteger)modelQ]];
        
        
        [tipStr appendFormat:@"%@%@%@%@%@",[SocketManager stringWithHexNumber:self.seleHornModel.nowSelectBand.bandNumber],[SocketManager fourStringWithHexNumber:(NSInteger)self.seleHornModel.nowSelectBand.freq],[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.nowSelectBand.gain* 10 + 120)],Qstr,[SocketManager stringWithHexNumber:self.seleHornModel.nowSelectBand.bandType]];
//        SDLog(@"bandNumber = %@  ***freq= %@ ***gain = %@ ***Q = %@",[SocketManager stringWithHexNumber:self.seleHornModel.nowSelectBand.bandNumber],[SocketManager fourStringWithHexNumber:(NSInteger)self.seleHornModel.nowSelectBand.freq],[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.nowSelectBand.gain* 10 + 120)],[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.nowSelectBand.Q* Q_changeV*10)]);
        [SocketManagerShare seneTipWithType:CheqBand WithStr:tipStr Count:count];
    }else{
        NSMutableString *tipStr = [NSMutableString string];
        [tipStr appendFormat:@"00%@",IneqBandAdr];
        
        long data0 = pow(2,self.seleHornModel.outCh - 1);
        if (DeviceToolShare.ineqSeleDataArray.count == 2 ) {
            hornDataModel *model2 = (hornDataModel*)DeviceToolShare.ineqSeleDataArray[1];
            data0 = data0 + pow(2,model2.outCh - 1);
        }
         [tipStr appendString:[SocketManager stringWithHexNumber:data0]];
        
        
        //防止q为0
        NSInteger modelQ = (NSInteger)(self.seleHornModel.nowSelectBand.Q* Q_changeV*10)>0 ? (NSInteger)(self.seleHornModel.nowSelectBand.Q* Q_changeV*10):1;
        NSInteger model_SLf_Q = (NSInteger)(self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV*10)>0 ? (NSInteger)(self.seleHornModel.nowSelectBand.Slf_Q* Q_changeV*10):1;
        
        NSString *Qstr = [NSString stringWithFormat:@"%@%@",[SocketManager stringWithHexNumber:(NSInteger)model_SLf_Q],[SocketManager stringWithHexNumber:(NSInteger)modelQ]];
        
        [tipStr appendFormat:@"%@%@%@%@%@",[SocketManager stringWithHexNumber:self.seleHornModel.nowSelectBand.bandNumber],[SocketManager fourStringWithHexNumber:(NSInteger)self.seleHornModel.nowSelectBand.freq],[SocketManager fourStringWithHexNumber:(NSInteger)(self.seleHornModel.nowSelectBand.gain* 10 + 120)],Qstr,[SocketManager stringWithHexNumber:self.seleHornModel.nowSelectBand.bandType]];
        [SocketManagerShare seneTipWithType:IneqBand WithStr:tipStr Count:count];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CYTABBARCONTROLLER.tabbar.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (DeviceToolShare.eqSeleHornDataArray.count == 2) {
        hornDataModel *model = DeviceToolShare.eqSeleHornDataArray[1];
        hornDataModel *model0 = DeviceToolShare.eqSeleHornDataArray[0];
//        model.eqBandCheqArray = [NSMutableArray arrayWithArray:model0.eqBandCheqArray];
        
        [model.eqBandCheqArray removeAllObjects];
        for (id modelItem in model0.eqBandCheqArray) {
            if ([modelItem isKindOfClass:[eqBandModel class]]) {
                [model.eqBandCheqArray addObject:[modelItem modelDeepCopy]];
            }
        }
    }
    if (DeviceToolShare.ineqSeleDataArray.count == 2) {
        
        hornDataModel *model = DeviceToolShare.ineqSeleDataArray[1];
        hornDataModel *model0 = DeviceToolShare.ineqSeleDataArray[0];
//        model.eqBandIneqArray = [NSMutableArray arrayWithArray:model0.eqBandIneqArray];
        
        [model.eqBandIneqArray removeAllObjects];
        for (eqBandModel *modelItem in model0.eqBandIneqArray) {
            [model.eqBandIneqArray addObject:[modelItem modelDeepCopy]];
        }
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

@end
