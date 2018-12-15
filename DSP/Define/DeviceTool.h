//
//  DeviceTool.h
//  DSP
//
//  Created by hk on 2018/7/2.
//  Copyright © 2018年 hk. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "hornDataModel.h"

typedef NS_ENUM(NSInteger,CrossoverSeleType) {
    FLiterType = 200,
    HiSlope,
    LoSlope,
    Hifreq,
    LoFreq,
    Gain_Crossover,
    Q_Crossover,
};
typedef NS_ENUM(NSInteger,FilterType) {
    AllPass = 0,
    HighPassFilter,
    LowPassFIlter,
    BandFilter,
    HiShelfFilter,
    LoShelfFilter,
};
typedef NS_ENUM(NSInteger,DspModeType) {
    ANALOG = 0,
    SPDIF = 2,
    STREAMING = 1,
};
typedef NS_ENUM(NSInteger,INEQ_connectType) {
    INEQ_connectType_none = 0,
    INEQ_connectType_top,//上左
    INEQ_connectType_bottom,//下右
};
typedef NS_ENUM(NSInteger, DeviceType){
    BH_A180 = 0,
    BH_A180A = 1,
};

#define DeviceToolShare [DeviceTool shareInstacne]

@interface DeviceTool : NSObject
+(DeviceTool*)shareInstacne;
+(BOOL)loadInfo;
-(void)saveInfo;
-(void)initIneq;
//特殊方法，经过YYKIT模型转字典后调用此方法 将字典还原模型

+(id)csqHornDataModelFromDict:(NSDictionary *)dict;

@property(nonatomic,assign)NSInteger mcuVersion;
@property(nonatomic , assign)DeviceType deviceType;
-(BOOL)isBH_A180A;
@property(nonatomic,assign)DspModeType DspMode;
@property(nonatomic,assign)BOOL MaxInputLevelAdd6;
@property(nonatomic,assign)BOOL MaxOutputLevelAdd6;
@property(nonatomic,assign)BOOL SpdifOutBool;
@property(nonatomic,assign,getter = isExternalRemodeControl)BOOL ExternalRemodeControl;
@property(nonatomic,assign)BOOL mune;
@property(nonatomic,assign)CGFloat MainLevel;
@property(nonatomic,assign)CGFloat SUBLevel;

@property(nonatomic,assign)CGFloat inputLevel1;
@property(nonatomic,assign)CGFloat inputLevel2;
@property(nonatomic,assign)CGFloat inputLevel3;
@property(nonatomic,assign)CGFloat inputLevel4;
@property(nonatomic,assign)NSInteger managerPreset; //A  0~5  B 6~11


@property(nonatomic,strong)NSMutableArray *selectHornArray;//当前所有的喇叭分类 @"201"~@"257"
@property(nonatomic,strong)NSMutableArray *hornDataArray;//当前所有的喇叭模型数据数组  最多八个通道的horndatamodel
@property(nonatomic,strong)NSMutableArray *eqSeleHornDataArray;//eq页面cheq选中通道数组
@property(nonatomic,strong)NSMutableArray *crossoverSeleHornDataArray;//crossover页面选中通道数组

@property(nonatomic,strong)NSMutableArray *ineqDataArray;//ineq所有的通道
@property(nonatomic,strong)NSMutableArray *ineqSeleDataArray;//eq页面ineq选中通道数组 暂不做存储

@property(nonatomic,strong)id seleHornModel;  //eq页面当前选择修改的通道

@property(nonatomic,assign)BOOL eqF_isConnect; //是否关联
@property(nonatomic,assign)BOOL eqR_isConnect;
@property(nonatomic,assign)BOOL crossoverF_isConnect;
@property(nonatomic,assign)BOOL crossoverR_isConnect;

@property(nonatomic,assign)INEQ_connectType eqF_connectType; //关联模式
@property(nonatomic,assign)INEQ_connectType eqR_connectType;
@property(nonatomic,assign)INEQ_connectType crossoverF_connectType;
@property(nonatomic,assign)INEQ_connectType crossoverR_connectType;


@property(nonatomic,assign)INEQ_connectType analog1_2_connectType; //INEQ记忆关联类型
@property(nonatomic,assign)INEQ_connectType analog3_4_connectType;
@property(nonatomic,assign)INEQ_connectType analog5_6_connectType;
@property(nonatomic,assign)INEQ_connectType diglital_r_l_connectType;

//inputSettingSpdif  model
@property(nonatomic,strong)id spdifInputModel;

@end
