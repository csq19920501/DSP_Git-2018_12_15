//
//  SocketManager.h
//  DSP
//
//  Created by hk on 2018/7/27.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SocketManagerShare [SocketManager shareInstacne]
#define maxCount 3
#define afterRepeatTime 1

//#define suiJiFaSong(X_type) NSTimeInterval timeIntervar = [[NSDate date] timeIntervalSince1970]*1000;if (timeIntervar - [CSQCircleView changeTimeInterval] >= 300) {[CSQCircleView setChangeTimeInterval: timeIntervar];X_type}
#define suiJiFaSong(X_type) if ( (int)level%10 < 5 && (int)level *10%100 < 5  && (int)level *10%100 > 0) {X_type}

static NSString *const RemoveAllNotification = @"RemoveAllNotification";

static NSString *const LinkSuccessNotificaion = @"LinkSuccessNotificaion";
static NSString *const LinkDidDisconnect = @"LinkDidDisconnect";
static NSString *const MainRefreshNotificaion = @"MainRefreshNotificaion";
static NSString *const ChevelRefreshNotificaion = @"ChevelRefreshNotificaion";
static NSString *const ChDelayRefreshNotificaion = @"ChDelayRefreshNotificaion";
static NSString *const CrossoverRefreshNotificaion = @"CrossoverRefreshNotificaion";
static NSString *const EQRefreshNotificaion = @"EQRefreshNotificaion";


#define MainSoundAdr @"00"
#define MainMuteAdr @"01"
#define SUBSoundAdr @"02"
#define InputSourceAdr @"03"
#define LinkSuccessAdr @"04"
#define InputLevleAdr @"05"
#define ManagerPresetAdr @"06"
#define SavePresetAdrAdr @"07"
#define DeletePresetAdrAdr @"08"
#define UpPresetAdrAdr @"09"
#define ExtControlAdr @"0a"
#define MaxInputLevelAdr @"0b"
#define MaxOutputLevelAdr @"0c"
#define SendSpeakerAssignAdr @"0d"
#define InputAnalogPercenAdr @"0e"
#define InputDigitalPercenAdr @"0f"
#define CheqBandAdr @"10"
#define IneqBandAdr @"11"
#define CopyAdr @"12"

#define fliterAdr @"13"
#define HiSlopeTAdr @"14"
#define HifreqAdr @"15"
#define LoSlopeAdr @"16"
#define LoFreqAdr @"17"
#define CHdelayMuneAdr @"18"
#define CHdelayPhaseAdr @"19"
#define CHdelayDelayAdr @"1a"
#define CHdelayDistanceAdr @"1b"
#define Ch1LevelAdr @"1c"
#define Ch2LevelAdr @"1d"
#define Ch3LevelAdr @"1e"
#define Ch4LevelAdr @"1f"
#define Ch5LevelAdr @"20"
#define Ch6LevelAdr @"21"
#define Ch7LevelAdr @"22"
#define Ch8LevelAdr @"23"
#define AckCurUiIdParameterAdr @"24"



#define ResetSelectEQ @"25"
#define ResetSelectCrossover @"26"
#define mcuVersionAdr @"27"
#define crossoverHiQAdr @"28"
#define crossoverHiGainAdr @"29"
#define crossoverLoQAdr @"2a"
#define crossoverLoGainAdr @"2b"
typedef NS_ENUM(NSInteger,McuType) {
    MainSoundLevle = 0,
    SUBSoundLevle ,
    MainMute,
    InputSource,
    LinkSuccess,
    InputLevle,
    ManagerPreset,
    SavePresetAdr,
    DeletePresetAdr,
    UpPresetAdr,
    ExtControl,
    MaxInputLevel,
    MaxOutputLevel,
    SendSpeakerAssign, //发送重新选择的喇叭
    InputAnalogPercen,
    InputDigitalPercen,
    CheqBand,
    IneqBand,
    CopyEnum,
    CrossoverType,
    HiSlopeMcuType,
    HiFreqMcuType,
    LoSlopeMcuType,
    LoFreqMcuType,
    DelayMune,
    Phase180,
    Delay,
    Distence,
    Ch1Level = 101,
    Ch2Level = 102,
    Ch3Level = 103,
    Ch4Level = 104,
    Ch5Level = 105,
    Ch6Level = 106,
    Ch7Level = 107,
    Ch8Level = 108,
    AckCurUiIdParameter,
    Reset_selectEQ,
    Reset_selectCrossover,
    mcuVersionType,
};

@interface SocketManager : NSObject
@property (nonatomic, copy) NSString *wifiName;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, assign) NSInteger port;

@property(nonatomic,assign)BOOL ChlevelNeedRefresh;
@property(nonatomic,assign)BOOL ChDelayNeedRefresh;
@property(nonatomic,assign)BOOL CrossoverNeedRefresh;
@property(nonatomic,assign)BOOL EQNeedRefresh;
@property(nonatomic,assign)BOOL AckCurUiIdParameterNeedSecond;//是否进入advanced turning页面

@property(nonatomic,assign)BOOL HomeNeedRefresh;
@property(nonatomic,strong)NSMutableData* readBuf;
+(SocketManager*)shareInstacne;
-(BOOL)isCurrentWIFI;
-(NSString *)currentWIFI;
-(void)repeatSel;

-(BOOL)setupSocket;
-(void)sendTestTip;
-(void)sendDataWithStr:(NSString*)str;
-(void)sendTipWithType:(McuType)mcuType withCount:(int)count;
// 检测WIFI开关
-(BOOL)isWiFiEnabled;
//改变inputLevel
-(void)sendInputlevelTipWithCount:(int)count withNumber:(int)number;
//发送两个data1 和data0
-(void)sendTwoDataTipWithType:(McuType)mcuType withCount:(int)count withData0Int:(NSInteger)data0 withData1Int:(NSInteger)data1;
//发送字符串
-(void)seneTipWithType:(McuType)mcuType WithStr:(NSString*)str Count:(int)count;
//数字转十六进制字符串
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;
//数字转十六进制字符串 至少凑成4位
+ (NSString *)fourStringWithHexNumber:(NSUInteger)hexNumber;
//十进制转二进制字符串
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;
// 十进制转换十六进制
- (NSString *)getHexByDecimal:(NSInteger)decimal;

//将传入的data类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data;
    //将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring;
@end
