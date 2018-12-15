//
//  hornDataModel.h
//  DSP
//
//  Created by hk on 2018/7/21.
//  Copyright © 2018年 hk. All rights reserved.


//  ([UIScreen mainScreen].bounds.size.width * 361.33/414)
#define BandAllWidth ([UIScreen mainScreen].bounds.size.width * 365/414)
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "eqBandModel.h"
#import "CHdelayModel.h"
#import "Header.h"
typedef NS_ENUM(NSInteger,OutPutCH) {
    CH1 = 1,
    CH2 ,
    CH3 ,
    CH4 ,
    CH5 ,
    CH6 ,
    CH7 ,
    CH8 ,
};

@interface hornDataModel : NSObject
@property(nonatomic,strong)CHdelayModel *cHdelayModel;
@property(nonatomic,strong)NSMutableArray *eqBandCheqArray;//cheq数组
@property(nonatomic,strong)eqBandModel *cheqSelectBand;//当前选择cheq



//ineq相关全部移到deivcetool里面
@property(nonatomic,strong)NSMutableArray *eqBandIneqArray;//ineq数组

//ineq相关全部移到deivcetool里面
@property(nonatomic,strong)eqBandModel *ineqSelectBand;//当前选择的ineq
@property(nonatomic,strong)eqBandModel *nowSelectBand;//当前选择的

@property(nonatomic,strong)NSMutableArray *nowSelectBandArray;//当前选择的数组

@property(nonatomic,assign)OutPutCH outCh;
@property(nonatomic,assign)CGFloat CHLevelFloat;
@property(nonatomic,copy)NSString *hornType;//喇叭类型  201 202 203 等等

@property(nonatomic,assign)CGFloat CrossoverFilterType;
@property(nonatomic,assign)CGFloat CrossoverHiSlope;
@property(nonatomic,assign)CGFloat CrossoverLoSlope;
@property(nonatomic,assign)CGFloat CrossoverHifreq;  //该值 寓意改成  bandx   
@property(nonatomic,assign)CGFloat CrossoverLoFreq;  //该值 寓意改成  bandx
@property(nonatomic,assign)CGFloat CrossoverHiGain;
@property(nonatomic,assign)CGFloat CrossoverLoGain;
@property(nonatomic,assign)CGFloat CrossoverHiQ;
@property(nonatomic,assign)CGFloat CrossoverLoQ;


@property(nonatomic,copy)NSString* ch1Input;  //abalog input
@property(nonatomic,copy)NSString* ch2Input;  //abalog input
@property(nonatomic,copy)NSString* ch3Input;  //abalog input
@property(nonatomic,copy)NSString* ch4Input;  //abalog input
@property(nonatomic,copy)NSString* ch5Input;  //abalog input
@property(nonatomic,copy)NSString* ch6Input;  //abalog input

@property(nonatomic,copy)NSString* digitalL;  //digital input
@property(nonatomic,copy)NSString* digitalR;  //digital input

+(CGFloat)freqFromBand:(CGFloat)band;
+(CGFloat)bandFromFreq:(CGFloat)freq;
-(void)resectEQ_seleCH;
-(void)resectEQ_seleIN;
-(void)reset_corssover;
@end
