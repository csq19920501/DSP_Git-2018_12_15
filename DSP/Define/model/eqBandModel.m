//
//  eqBandModel.m
//  DSP
//
//  Created by hk on 2018/7/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "eqBandModel.h"

@implementation eqBandModel
-(id)init{
    self = [super init ];
    if (self) {
//        self.bandType = bandType_HSLF;
    }
    return self;
}
-(eqBandModel*)modelDeepCopy{
    eqBandModel *model = [[eqBandModel alloc]init];
    model.bandNumber = self.bandNumber;
    model.freq = self.freq;
    model.freqBase = self.freqBase;
    model.freqLevel = self.freqLevel;
    model.bandX = self.bandX;
    model.bandXBase = self.bandXBase;
    model.gain = self.gain;
    model.Q = self.Q;
    model.Slf_Q = self.Slf_Q;
    model.bandType = self.bandType;
    return model;
}
@end
