//
//  hornDataModel.m
//  DSP
//
//  Created by hk on 2018/7/21.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "hornDataModel.h"
#include <math.h>
#define Peq_Q 3.0
#define Hslf_Q 0.7
#define Lslf_Q 0.7
@implementation hornDataModel
-(id)init{
    self = [super init];
    if (self) {
        self.cHdelayModel = [[CHdelayModel alloc]init];
        self.eqBandCheqArray = [NSMutableArray array];
        
        self.outCh = 3;
        self.CHLevelFloat = 120;
        NSArray *cheqArray = @[@40,@80,@150,@300,@600,@1000,@2000,@4000,@8000,@16000];
        for (int i = 1; i <= 10; i++) {
            eqBandModel *model = [[eqBandModel alloc]init];
            
//            model.bandXBase = BandAllWidth/11 *i;
//            model.bandX = model.bandXBase;
//            model.freqBase = [hornDataModel freqFromBand:model.bandXBase];
//            model.freq = model.freqBase;
            
            NSString *str = cheqArray[i-1];
            model.freqBase = str.floatValue;
            model.freq = model.freqBase;
            model.bandXBase = [hornDataModel bandFromFreq:model.freqBase];
            model.bandX = model.bandXBase;
            
            
            model.bandNumber = i;
            model.freqLevel = 15;
            model.Q = Peq_Q/Q_changeV;
            model.Slf_Q = Hslf_Q/Q_changeV;
            model.gain = 0.0;
            model.bandType = bandType_PEQ;
//            if (CsqDebug) {
//                if (i == 5) {
//                    model.bandType = bandType_HSLF;
//                    model.gain = 10;

//                }else{
//                    model.bandType = bandType_LSHF;
//                }
//            }
            
            [self.eqBandCheqArray addObject:model];
        }
        self.nowSelectBandArray = self.eqBandCheqArray;
        self.cheqSelectBand = self.eqBandCheqArray[0];
        self.eqBandIneqArray = [NSMutableArray array];
        
        
        
        NSArray *ineqArray = @[@25,@40,@60,@80,@100,@200,@300,@500,@800,@1000,@1200,@1600,@2000,@3000,@4000,@6000,@8000,@10000,@12000,@16000,@20000];
        for (int i = 1; i <= 21; i++) {
            eqBandModel *model = [[eqBandModel alloc]init];
           
//            model.bandXBase = BandAllWidth/22 *i;
//            model.bandX = model.bandXBase;
//            model.freq = [hornDataModel freqFromBand:model.bandX];
//            model.freqBase = model.freq;
            NSString *str = ineqArray[i-1];
            model.freqBase = str.floatValue;
            model.freq = model.freqBase;
            model.bandXBase = [hornDataModel bandFromFreq:model.freqBase];
            model.bandX = model.bandXBase;
            
            model.Q = Peq_Q/Q_changeV;
            model.Slf_Q = Hslf_Q/Q_changeV;
            model.gain = 0.0;
            model.freqLevel = 15;
            model.bandNumber = i;
            model.bandType = bandType_PEQ;
//            if (CsqDebug) {
//                if (i == 5) {
//                    model.bandType = bandType_LSHF;
//                    model.gain = 10;

//                }else{
//                    model.bandType = bandType_HSLF;
//                }
//            }
            [self.eqBandIneqArray addObject:model];
        }
        self.ineqSelectBand = self.eqBandIneqArray[0];
        self.nowSelectBand = self.cheqSelectBand;
        
        self.CrossoverFilterType = 0;//初始值后面要修改
        self.CrossoverHiSlope =  1;//初始值后面要修改
        self.CrossoverLoSlope =  1;//初始值后面要修改
        self.CrossoverHifreq =   [hornDataModel bandFromFreq:600];;//初始值后面要修改
        self.CrossoverLoFreq =   [hornDataModel bandFromFreq:6000];;//初始值后面要修改
        self.CrossoverHiGain =   0;
        self.CrossoverLoGain =   0;
        self.CrossoverHiQ =   1.4/Q_changeV;
        self.CrossoverLoQ =   1.4/Q_changeV;
        
        self.ch1Input = @"0";
        self.ch2Input = @"0";
        self.ch3Input = @"0";
        self.ch4Input = @"0";
        self.ch5Input = @"0";
        self.ch6Input = @"0";
        self.digitalL = @"0";
        self.digitalR = @"0";
    }
    return self;
}
-(void)reset_corssover{
    self.CrossoverFilterType = 0;
    self.CrossoverHiSlope =  1;
    self.CrossoverLoSlope =  1;
    self.CrossoverHifreq =   [hornDataModel bandFromFreq:600];
    self.CrossoverLoFreq =   [hornDataModel bandFromFreq:6000];
    
    self.CrossoverHiGain = 0;
    self.CrossoverLoGain =  0;
    self.CrossoverHiQ = 1.4/Q_changeV;
    self.CrossoverLoQ =  1.4/Q_changeV;
    
}
-(void)resectEQ_seleCH{
    NSArray *cheqArray = @[@40,@80,@150,@300,@600,@1000,@2000,@4000,@8000,@16000];
    for (int i = 1; i <= 10; i++) {
        eqBandModel *model = self.eqBandCheqArray[i - 1];
        NSString *str = cheqArray[i-1];
        model.freqBase = str.floatValue;
        model.freq = model.freqBase;
        model.bandXBase = [hornDataModel bandFromFreq:model.freqBase];
        model.bandX = model.bandXBase;
        model.Q = Peq_Q/Q_changeV;
        model.Slf_Q = Hslf_Q/Q_changeV;
        model.gain = 0;
        model.bandType = bandType_PEQ;
    }
//    [SocketManagerShare sendTwoDataTipWithType:Reset_selectEQ withCount:0 withData0Int:0 withData1Int:2];
}
-(void)resectEQ_seleIN{
    NSArray *ineqArray = @[@25,@40,@60,@80,@100,@200,@300,@500,@800,@1000,@1200,@1600,@2000,@3000,@4000,@6000,@8000,@10000,@12000,@16000,@20000];
    for (int i = 1; i <= 21; i++) {
        eqBandModel *model = self.eqBandIneqArray[i - 1];
        NSString *str = ineqArray[i-1];
        model.freqBase = str.floatValue;
        model.freq = model.freqBase;
        model.bandXBase = [hornDataModel bandFromFreq:model.freqBase];
        model.bandX = model.bandXBase;
        model.Q = Peq_Q/Q_changeV;
        model.Slf_Q = Hslf_Q/Q_changeV;
        model.gain = 0;
        model.bandType = bandType_PEQ;
    }
//    [SocketManagerShare sendTwoDataTipWithType:Reset_selectEQ withCount:0 withData0Int:0 withData1Int:1];
}
-(void)setHornType:(NSString*)hornType{
    _hornType = hornType;
    if (hornType.intValue >= 201 && hornType.intValue <= 205) {
        self.ch1Input = @"100";
        self.digitalL = @"100";
    }
    if (hornType.intValue >= 251 && hornType.intValue <= 255) {
        self.ch2Input = @"100";
        self.digitalR = @"100";
    }
    if ((hornType.intValue >= 206 && hornType.intValue <= 207)
        ||(hornType.intValue >= 191 && hornType.intValue <= 193)) {
        self.ch3Input = @"100";
        self.digitalL = @"100";
    }
    if ((hornType.intValue >= 256 && hornType.intValue <= 257)
        || (hornType.intValue >= 241 && hornType.intValue <= 243)) {
        self.ch4Input = @"100";
        self.digitalR = @"100";
    }
    if (hornType.intValue >= 209 && hornType.intValue <= 212) {
        self.ch4Input = @"25";
        self.ch1Input = @"25";
        self.ch2Input = @"25";
        self.ch3Input = @"25";

        self.digitalL = @"50";
        self.digitalR = @"50";
    }
    if (hornType.intValue == 208) {
        self.ch4Input = @"25";
        self.ch1Input = @"25";
        self.ch2Input = @"25";
        self.ch3Input = @"25";

        self.digitalL = @"50";
        self.digitalR = @"50";
    }
}

+(CGFloat)freqFromBand:(CGFloat)band{
    CGFloat freq;
    /*初级算法
    if (band <= BandAllWidth* 1/4.5) {
        freq = 20 + band * (100 - 20)/(BandAllWidth/4.5);
    }else if(band <= BandAllWidth* 2.5/4.5){
        freq = 100 + (band - BandAllWidth* 1/4.5) * (1000 - 100)/(BandAllWidth* 1.5/4.5);
    }else if(band <= BandAllWidth* 4/4.5){
        freq = 1000 + (band - BandAllWidth* 2.5/4.5) * (10000 - 1000)/(BandAllWidth* 1.5/4.5);
    }else {
        //这里同上 暂不做特殊处理
        freq = 10000 + (band - BandAllWidth* 4/4.5) * (20000 - 10000)/(BandAllWidth* 0.5/4.5);
    }
     */
    
    /*高级算法*/
    double F = pow(20000/20.0, 1.0/(BandAllWidth - 5));
    freq = 20 * pow(F, band);
    
    return freq;
}
+(CGFloat)bandFromFreq:(CGFloat)freq{
    CGFloat band = 0.0;
    
//    if (freq <= 100.0) {
//        band = (freq - 20)/((100 - 20)/(BandAllWidth/4.5));
//    }else if(freq <= 1000.0){
//        band = (freq - 100)/((1000 - 100)/(BandAllWidth* 1.5/4.5)) + BandAllWidth* 1/4.5;
//    }else if(freq <= 10000.0){
//        band = (freq - 1000)/((10000 - 1000)/(BandAllWidth* 1.5/4.5)) + BandAllWidth* 2.5/4.5;
//    }else{
//        //这里同上 暂不做特殊处理
//        band = (freq - 10000)/((20000 - 10000)/(BandAllWidth* 0.5/4.5)) + BandAllWidth* 4/4.5;
//    }
    
    double F = pow(20000/20.0, 1.0/(BandAllWidth - 5));
    band = log(freq/20)/log(F);
    
    return band;
}
@end
