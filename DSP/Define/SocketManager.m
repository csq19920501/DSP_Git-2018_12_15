//
//  SocketManager.m
//  DSP
//
//  Created by hk on 2018/7/27.
//  Copyright © 2018年 hk. All rights reserved.
//
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SocketManager.h"
#import "GCDAsyncSocket.h"
#import "Header.h"
#import "hornDataModel.h"

#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>

//判断是否需要循环发送请求
#define AfrerIfNeedRepeat(X_type)  X_type = YES;CSQ_DISPATCH_AFTER(afterRepeatTime, ^{if (X_type){if(count < maxCount) {[self sendTipWithType:mcuType withCount:count+1];}}})
//简写部分发送指令
#define  SendTip(X_type,Y_type) [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:X_type,[SocketManager stringWithHexNumber:(NSInteger)DeviceToolShare.Y_type]]];

#define  SendTipStr(X_type,Y_type) [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:X_type,Y_type]];

#define  SocketSendStr(X_type) [SocketManagerShare sendDataWithStr:X_type];

@interface SocketManager ()
{
    NSDictionary *_currentWifi;
    GCDAsyncSocket *_Socket;
    BOOL socketConnect;
    
    
    NSInteger InputAnalogPercenInt;
    
}

@property(nonatomic,assign)BOOL MainSoundLevleNeedSecond;
@property(nonatomic,assign)BOOL SUBSoundLevleNeedSecond;
@property(nonatomic,assign)BOOL MainMuteNeedSecond;
@property(nonatomic,assign)BOOL InputSourceNeedSecond;
@property(nonatomic,assign)BOOL LinkSuccesNeedSecond;
@property(nonatomic,assign)BOOL InputLevleNeedSecond;
@property(nonatomic,assign)BOOL ManagerPresetAdrNeedSecond;
@property(nonatomic,assign)BOOL SavePresetAdrNeedSecond;
@property(nonatomic,assign)BOOL DeletePresetAdrNeedSecond;
@property(nonatomic,assign)BOOL UpPresetAdrNeedSecond;
@property(nonatomic,assign)BOOL ExtControlNeedSecond;
@property(nonatomic,assign)BOOL MaxInputLevelNeedSecond;
@property(nonatomic,assign)BOOL MaxOutputLevelNeedSecond;
@property(nonatomic,assign)BOOL SendSpeakerAssignNeedSecond;
@property(nonatomic,assign)BOOL InputAnalogPercenNeedSecond;
@property(nonatomic,assign)BOOL InputDigitalPercenNeedSecond;
@property(nonatomic,assign)BOOL CheqBandNeedSecond;
@property(nonatomic,assign)BOOL IneqBandNeedSecond;
@property(nonatomic,assign)BOOL CopyNeedSecond;
@property(nonatomic,assign)BOOL CrossoverTypeNeedSecond;
@property(nonatomic,assign)BOOL HiSlopeNeedSecond;
@property(nonatomic,assign)BOOL HiFreqNeedSecond;
@property(nonatomic,assign)BOOL LoSlopeNeedSecond;
@property(nonatomic,assign)BOOL LoFreqNeedSecond;
@property(nonatomic,assign)BOOL ChdelayMuneNeedSecond;
@property(nonatomic,assign)BOOL Phase180NeedSecond;


@property(nonatomic,assign)BOOL DelayNeedSecond;
@property(nonatomic,assign)BOOL DistenceNeedSecond;
@property(nonatomic,assign)BOOL Ch1LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch2LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch3LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch4LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch5LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch6LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch7LevelNeedSecond;
@property(nonatomic,assign)BOOL Ch8LevelNeedSecond;

@property(nonatomic,assign)BOOL ResetSelectEQNeedSecond;
@property(nonatomic,assign)BOOL ResetSelectCrossoverNeedSecond;
@property(nonatomic,assign)BOOL McuVersionNeedSecond;
//@property(nonatomic,assign)BOOL CrossoverHiQNeedSecond;
//@property(nonatomic,assign)BOOL CrossoverHiGainNeedSecond;
//@property(nonatomic,assign)BOOL CrossoverLoQNeedSecond;
//@property(nonatomic,assign)BOOL CrossoverLoGainNeedSecond;

@property(nonatomic,strong)NSTimer *connectTimer;
@end
@implementation SocketManager
static SocketManager *_sharedInstance;
+ (SocketManager *)shareInstacne
{
    @synchronized(self) //创建一个互斥锁，保证此时没有其它线程对self对象进行修改
    {
        if (nil == _sharedInstance)
        {
            _sharedInstance = [[SocketManager alloc] init];
            _sharedInstance.server = @"10.10.10.254";//@"10.10.10.254"
            _sharedInstance.port = 3333;
            _sharedInstance.ChlevelNeedRefresh = YES;
            _sharedInstance.ChDelayNeedRefresh = YES;
            _sharedInstance.CrossoverNeedRefresh = YES;
            _sharedInstance.EQNeedRefresh = YES;
            _sharedInstance.HomeNeedRefresh = YES;
        }
    }
    return _sharedInstance;
}
-(id)init{
    if (self = [super init]) {
         getTimer(_connectTimer, 5, repeatSel)
    }
    return self;
}

//初始化socket
- (BOOL)setupSocket
{
    if (nil != _Socket)
    {
        _Socket = nil;
    }
    _Socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    if ([self isCurrentWIFI]) {
        //连接服务端
        NSError *error = nil;
        [_Socket connectToHost:self.server onPort:self.port error:&error];
        if (!error){
            SDLog(@"_Socket 本地socket连接服务端socket成功");
            [_Socket readDataWithTimeout:-1 tag:0];
            return YES;
        }else
        {
            SDLog(@"_Socket error--%@",error);
            return NO;
        }
    }else{
        return NO;
    }
}
-(void)repeatSel{
    if (socketConnect) {
        [_Socket writeData:[self dataWithHexstring:@"FFFFFFFF"] withTimeout:-1 tag:0];
    }else{
        if ([self isCurrentWIFI]) {
            //连接服务端
            NSError *error = nil;
            [_Socket connectToHost:self.server onPort:self.port error:&error];
            if (!error){
                SDLog(@"_Socket 本地socket连接服务端socket成功");
                [_Socket readDataWithTimeout:-1 tag:0];
            }else
            {
                SDLog(@"_Socket error--%@",error);
            }
        }
    }
}
//接收数据一切业务处理主要再其代理的方法中实现的
//连接成功 ---只要连接成功就回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    SDLog(@"_Socket didConnectToHost");
    self.readBuf = [[NSMutableData alloc]init];
    
    socketConnect = YES;
    [_Socket readDataWithTimeout:-1 tag:0];
    
    KPostNotification(LinkSuccessNotificaion, nil)
    CSQ_DISPATCH_AFTER(0.5,^{
           [self sendTipWithType:LinkSuccess withCount:0];
    })
}
//断开连接---与服务器断开就回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    socketConnect = NO;
    SDLog(@"_Socket socketDidDisconnect");
    KPostNotification(LinkDidDisconnect, nil)
   
    _sharedInstance.ChlevelNeedRefresh = YES;
    _sharedInstance.ChDelayNeedRefresh = YES;
    _sharedInstance.CrossoverNeedRefresh = YES;
    _sharedInstance.EQNeedRefresh = YES;
    _sharedInstance.HomeNeedRefresh = YES;
    
    DISPATCH_ON_MAIN_THREAD(^{
        [APPDELEGATE.homeNavi popToRootViewControllerAnimated:YES];
        [UIUtil showToast:@"WIFI DisConnect" inView:[AppData theTopView]];
    })
}
//向服务器发送成功的时候回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    SDLog(@"_Socket didWriteData");
//    [_Socket readDataWithTimeout:5 buffer:[NSMutableData new] bufferOffset:0 tag:tag];
    [_Socket readDataWithTimeout:-1 tag:0];
}

#pragma mark sendData
//按照协议拼装部分指令
-(void)sendDataWithStr:(NSString*)str{
    NSMutableString *allStr = [NSMutableString stringWithFormat:@"a55a"];
    NSInteger  strLong = str.length/2 + 1;
    [allStr appendString:[SocketManager stringWithHexNumber:strLong]];
    [allStr appendString:[NSString stringWithFormat:@"%@",str]];
    
    NSInteger allInt = 0;
    for(int idx = 0; idx + 2<= str.length; idx += 2){
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSInteger intValue = [self numberWithHexString:hexStr];
        allInt = allInt + intValue;
    }
    NSString *checkStr;
    checkStr = [SocketManager stringWithHexNumber:allInt];
    if (checkStr.length > 2) {
        checkStr = [checkStr substringWithRange:NSMakeRange(checkStr.length-2, 2)];
    }
    [allStr appendString:checkStr];
    SDLog(@"allStr   5555 = %@",allStr);
    NSData *data = [self dataWithHexstring:allStr];
    [_Socket writeData:data withTimeout:-1 tag:0];
}


#define SenTipWithStr(X_type) X_type = YES;CSQ_DISPATCH_AFTER(afterRepeatTime, ^{if (X_type) {if (count < maxCount) {[self seneTipWithType:mcuType WithStr:str Count:count+1];}}})
-(void)seneTipWithType:(McuType)mcuType WithStr:(NSString*)str Count:(int)count{
    switch (mcuType) {
        case SendSpeakerAssign:
        {
            [SocketManagerShare sendDataWithStr:str];
           SenTipWithStr(self.SendSpeakerAssignNeedSecond)
        }
            break;
        case InputAnalogPercen:
        {
            InputAnalogPercenInt++;
            NSInteger inputInt = InputAnalogPercenInt;
            
            [SocketManagerShare sendDataWithStr:str];
            
                                    self.InputAnalogPercenNeedSecond = YES;
                                    CSQ_DISPATCH_AFTER(afterRepeatTime, ^{
                                        if (self.InputAnalogPercenNeedSecond && inputInt == self->InputAnalogPercenInt) {
                                            if (count < maxCount) {
                                                [self seneTipWithType:mcuType WithStr:str Count:count+1];
                                            }
                                        }
                                    })
            
        }
            break;
        case InputDigitalPercen:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.InputDigitalPercenNeedSecond)
            
        }
            break;
        case CheqBand:
        {
            SDLog(@"CheqBandSend");
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.CheqBandNeedSecond)
        }
            break;
        case IneqBand:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.IneqBandNeedSecond)
        }
            break;
        case CrossoverType:{
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.CrossoverTypeNeedSecond)
        }
            break;
        case HiSlopeMcuType:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.HiSlopeNeedSecond)
        }
            break;
        case HiFreqMcuType:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.HiFreqNeedSecond)
            
        }
            break;
        case LoSlopeMcuType:
        {
            [SocketManagerShare sendDataWithStr:str];
             SenTipWithStr(self.LoSlopeNeedSecond)
        }
            break;
        case LoFreqMcuType:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.LoFreqNeedSecond)
            
        }
            break;
        case DelayMune:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.ChdelayMuneNeedSecond)
        }
            break;
        case Phase180:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.Phase180NeedSecond)
        }
            break;
        case Delay:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.DelayNeedSecond)
        }
            break;
        case Distence:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.DistenceNeedSecond)
        }
            break;
        case Reset_selectEQ:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.ResetSelectEQNeedSecond)
        }
            break;
        case Reset_selectCrossover:
        {
            [SocketManagerShare sendDataWithStr:str];
            SenTipWithStr(self.ResetSelectCrossoverNeedSecond)
        }
            break;
            default:
            break;
    }
}
#define  SendTipTwoData(X_Type)  X_Type = YES;CSQ_DISPATCH_AFTER(afterRepeatTime, ^{if (X_Type) {if (count < maxCount) {[self sendTwoDataTipWithType:mcuType withCount:count+1 withData0Int:data0 withData1Int:data1];}}})
-(void)sendTwoDataTipWithType:(McuType)mcuType withCount:(int)count withData0Int:(NSInteger)data0 withData1Int:(NSInteger)data1{
    switch (mcuType) {
        case ManagerPreset:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",ManagerPresetAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.ManagerPresetAdrNeedSecond)
        }
            break;
        case SavePresetAdr:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",SavePresetAdrAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.SavePresetAdrNeedSecond)
        }
            break;
        case DeletePresetAdr:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",DeletePresetAdrAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.DeletePresetAdrNeedSecond)
        }
            break;
        case UpPresetAdr:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",UpPresetAdrAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.UpPresetAdrNeedSecond)
        }
            break;
        case Ch1Level:
        {
            SDLog(@"CHlevelChangeSend1");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch1LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch1LevelNeedSecond)
        }
            break;
        case Ch2Level:
        {
            SDLog(@"CHlevelChangeSend2");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch2LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch2LevelNeedSecond)
        }
            break;
        case Ch3Level:
        {
            SDLog(@"CHlevelChangeSend3");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch3LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch3LevelNeedSecond)
        }
            break;
        case Ch4Level:
        {
            SDLog(@"CHlevelChangeSend4");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch4LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch4LevelNeedSecond)
        }
            break;
        case Ch5Level:
        {
            SDLog(@"CHlevelChangeSend5");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch5LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch5LevelNeedSecond)
        }
            break;
        case Ch6Level:
        {
            SDLog(@"CHlevelChangeSend6");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch6LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch6LevelNeedSecond)
        }
            break;
        case Ch7Level:
        {
            SDLog(@"CHlevelChangeSend7");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch7LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch7LevelNeedSecond)
        }
            break;
        case Ch8Level:
        {
            SDLog(@"CHlevelChangeSend8");
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",Ch8LevelAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.Ch8LevelNeedSecond)
        }
            break;
        case AckCurUiIdParameter:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",AckCurUiIdParameterAdr,@"00",[SocketManager stringWithHexNumber:data1]]];
            self.AckCurUiIdParameterNeedSecond = YES;
            
            switch (data1) {
                case 1:
                {
                    CSQ_DISPATCH_AFTER(6, ^{
                        if (self.ChlevelNeedRefresh && self.AckCurUiIdParameterNeedSecond) {
                            if (count < maxCount){
                                [self sendTwoDataTipWithType:mcuType withCount:count+1 withData0Int:data0 withData1Int:data1];
                            }else{
                                DISPATCH_ON_MAIN_THREAD(^{
                                    [UIUtil hideProgressHUD];
                                })
                            }
                        }})
                }
                    break;
                case 2:
                {
                    CSQ_DISPATCH_AFTER(6, ^{
                        if (self.ChDelayNeedRefresh && self.AckCurUiIdParameterNeedSecond) {
                            if (count < maxCount){
                                [self sendTwoDataTipWithType:mcuType withCount:count+1 withData0Int:data0 withData1Int:data1];
                            }
                        }})
                }
                    break;
                case 3:
                {
                    CSQ_DISPATCH_AFTER(6, ^{
                        if (self.CrossoverNeedRefresh
                            && self.AckCurUiIdParameterNeedSecond) {
                            if (count < maxCount){
                                [self sendTwoDataTipWithType:mcuType withCount:count+1 withData0Int:data0 withData1Int:data1];
                            }
                        }})
                }
                    break;
                case 4:
                {
                    CSQ_DISPATCH_AFTER(6, ^{
                        if (self.EQNeedRefresh
                            && self.AckCurUiIdParameterNeedSecond) {
                            if (count < maxCount){
                                [self sendTwoDataTipWithType:mcuType withCount:count+1 withData0Int:data0 withData1Int:data1];
                            }
                        }})
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case InputLevle:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",InputLevleAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.InputLevleNeedSecond)
        }
            break;
        case CopyEnum:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@%@%@",CopyAdr,[SocketManager stringWithHexNumber:data0],[SocketManager stringWithHexNumber:data1]]];
            SendTipTwoData(self.CopyNeedSecond)
        }
            break;
        default:
            break;
    }
}
-(void)sendTipWithType:(McuType)mcuType withCount:(int)count {
    switch (mcuType) {
        case MainSoundLevle:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",MainSoundAdr,[SocketManager stringWithHexNumber:(NSInteger)DeviceToolShare.MainLevel]]];
            AfrerIfNeedRepeat(self.MainSoundLevleNeedSecond)
        }
            break;
        case SUBSoundLevle:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",SUBSoundAdr,[SocketManager stringWithHexNumber:(NSInteger)DeviceToolShare.SUBLevel]]];
            AfrerIfNeedRepeat(self.SUBSoundLevleNeedSecond)
        }
            break;
        case MainMute:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",MainMuteAdr,DeviceToolShare.mune?@"01":@"00"]];
            AfrerIfNeedRepeat(self.MainMuteNeedSecond)
        }
            break;
        case InputSource:
        {
            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",InputSourceAdr,[SocketManager stringWithHexNumber:(NSInteger)DeviceToolShare.DspMode]]];
            AfrerIfNeedRepeat(self.InputSourceNeedSecond)
        }
            break;
        case LinkSuccess:
        {

            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",LinkSuccessAdr,@"01"]];
            self.LinkSuccesNeedSecond = YES;
            CSQ_DISPATCH_AFTER(8, ^{
                if(self.LinkSuccesNeedSecond){
                    if(count < maxCount) {
                        [self sendTipWithType:mcuType withCount:count+1];
                    }else{
                        [_Socket disconnect];
                    }
                }
            })
    
        }
            break;
        
        case ExtControl:
        {

            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",ExtControlAdr,DeviceToolShare.ExternalRemodeControl?@"01":@"00"]];
            AfrerIfNeedRepeat(self.ExtControlNeedSecond)
        }
            break;
        case MaxInputLevel:
        {

            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",MaxInputLevelAdr,DeviceToolShare.MaxInputLevelAdd6?@"01":@"00"]];
            AfrerIfNeedRepeat(self.MaxInputLevelNeedSecond)
        }
            break;
        case MaxOutputLevel:
        {

            [SocketManagerShare sendDataWithStr:[NSString stringWithFormat:@"00%@00%@",MaxOutputLevelAdr,DeviceToolShare.MaxOutputLevelAdd6?@"01":@"00"]];
            AfrerIfNeedRepeat(self.MaxOutputLevelNeedSecond)
        }
            break;
        
            
        default:
            break;
    }
    
}

#pragma mark readData
//接收服务器传过来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.readBuf appendData:data];
    while (self.readBuf.length >= 8) {
        NSMutableData *headData = [[self.readBuf subdataWithRange:NSMakeRange(0, 2)] mutableCopy];
        NSString *firstStr = [self hexadecimalString:headData];
        NSString *firstStr1 = [firstStr substringWithRange:NSMakeRange(0, 2)];
        NSString *firstStr2 = [firstStr substringWithRange:NSMakeRange(2, 2)];

        if (![firstStr1 isEqualToString:@"5a"] || ![firstStr2 isEqualToString:@"a5"]) {
            SDLog(@"剪切data   %@",firstStr1);
            if (self.readBuf.length >= 4) {
                self.readBuf = [NSMutableData dataWithData:[self.readBuf subdataWithRange:NSMakeRange(1, self.readBuf.length - 1)]];
                continue;
            }
        }
        NSString *dataStrAll = [self hexadecimalString:self.readBuf];
        if (dataStrAll.length <= 6) {
            continue;
        }
        NSString *byte2Str = [dataStrAll substringWithRange:NSMakeRange(4, 2)];
        NSInteger allLength = [self numberWithHexString:byte2Str] + 3;
        if (self.readBuf.length >= allLength) {
            NSMutableData *msgData = [[self.readBuf subdataWithRange:NSMakeRange(0, allLength)] mutableCopy];
            SDLog(@"_Socket 开始处理数据%@",[self hexadecimalString:msgData]);
            [self chuLiDataL:msgData];
            if (self.readBuf.length > allLength) {
                self.readBuf = [NSMutableData dataWithData:[self.readBuf subdataWithRange:NSMakeRange(allLength, self.readBuf.length - allLength)]];
            }else if(self.readBuf.length == allLength){
                self.readBuf = [[NSMutableData alloc]init];
            }
            
        }else{
            //缓存区内数据包不是完整的，再次从服务器获取数据，中断while循环
            [_Socket readDataWithTimeout:-1 tag:0];
            break;
        }
    }
}

-(void)chuLiDataL:(NSData*)data{
    if (data.length <7) {
        return;
    }
    int CMD = ((const char *)[data bytes])[3];
    int DataAdr = ((const char *)[data bytes])[4];
    int data0 = ((const char *)[data bytes])[5];
    int data1 = ((const char *)[data bytes])[6];
    switch (CMD) {
        case 0x00:
        {
            if (DataAdr == 0x00) {
                SDLog(@"地址00 =%@ ",[self hexadecimalString:data]);
                if (!self.MainSoundLevleNeedSecond ) {
                    DeviceToolShare.MainLevel = data1;
                }else{
                    self.MainSoundLevleNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x01) {
                SDLog(@"地址01 =%@ ",[self hexadecimalString:data]);
                if (!self.MainMuteNeedSecond) {
                    SDLog(@"data1 = %d",data1);
                    
                    DeviceToolShare.mune =  data1 == 1?YES:NO;
                }else{
                    self.MainMuteNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x02) {
                SDLog(@"地址02 =%@ ",[self hexadecimalString:data]);
                if (!self.SUBSoundLevleNeedSecond ) {
                    DeviceToolShare.SUBLevel = data1;
                }else{
                    self.SUBSoundLevleNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x03) {
                SDLog(@"地址03 =%@ ",[self hexadecimalString:data]);
                if (!self.InputSourceNeedSecond ) {
                    DeviceToolShare.DspMode = data1;
                }else{
                    self.InputSourceNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x04) {
                SDLog(@"地址04 =%@ ",[self hexadecimalString:data]);
                if (!self.LinkSuccesNeedSecond ) {
                    
                }else{
                    if (!self.AckCurUiIdParameterNeedSecond) {
                        [self sendTwoDataTipWithType:AckCurUiIdParameter withCount:maxCount withData0Int:1 withData1Int:1];
//                        self.AckCurUiIdParameterNeedSecond = NO;
                    }
                    self.LinkSuccesNeedSecond = NO;
                }
                self.HomeNeedRefresh = NO;
                KPostNotification(MainRefreshNotificaion, nil)
                //                [UIUtil hideProgressHUD];
            }
            else if (DataAdr == 0x05) {
                SDLog(@"地址05 =%@ ",[self hexadecimalString:data]);
                if (!self.InputLevleNeedSecond ) {
                    if (data0 == 0) {
                        SDLog(@"DeviceToolShare.inputLevel1 = %d",data1);
                        DeviceToolShare.inputLevel1 = data1;
                    }else if(data0 == 1){
                        DeviceToolShare.inputLevel2 = data1;
                         SDLog(@"DeviceToolShare.inputLevel2 = %d",data1);
                    }else if(data0 == 2){
                        DeviceToolShare.inputLevel3 = data1;
                         SDLog(@"DeviceToolShare.inputLevel3 = %d",data1);
                    }else if(data0 == 3){
                        DeviceToolShare.inputLevel4 = data1;
                         SDLog(@"DeviceToolShare.inputLevel4 = %d",data1);
                    }
                }else{
                    self.InputLevleNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x06) {
                SDLog(@"地址06 =%@ ",[self hexadecimalString:data]);
                if (!self.ManagerPresetAdrNeedSecond ) {
                    DeviceToolShare.managerPreset = data0 + data1 * 6;
                }else{
                    self.ManagerPresetAdrNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x07) {
                SDLog(@"地址07 =%@ ",[self hexadecimalString:data]);
                if (!self.SavePresetAdrNeedSecond ) {
                    
                }else{
                    self.SavePresetAdrNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x08) {
                SDLog(@"地址08 =%@ ",[self hexadecimalString:data]);
                if (!self.DeletePresetAdrNeedSecond ) {
                    
                }else{
                    self.DeletePresetAdrNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x09) {
                SDLog(@"地址09 =%@ ",[self hexadecimalString:data]);
                if (!self.UpPresetAdrNeedSecond ) {
                    
                }else{
                    self.UpPresetAdrNeedSecond = NO;
                }
            }
            
            else if (DataAdr == 0x0a) {
                SDLog(@"地址0a =%@ ",[self hexadecimalString:data]);
                if (!self.ExtControlNeedSecond ) {
                    DeviceToolShare.ExternalRemodeControl = data1 == 1?YES:NO;
                }else{
                    self.ExtControlNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x0b) {
                SDLog(@"地址0b =%@ ",[self hexadecimalString:data]);
                if (!self.MaxInputLevelNeedSecond ) {
                    DeviceToolShare.MaxInputLevelAdd6 = data1 == 1?YES:NO;
                }else{
                    self.MaxInputLevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x0c) {
                SDLog(@"地址0c =%@ ",[self hexadecimalString:data]);
                if (!self.MaxOutputLevelNeedSecond ) {
                    DeviceToolShare.MaxOutputLevelAdd6 = data1 == 1?YES:NO;
                }else{
                    self.MaxOutputLevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x0d) {//处理喇叭通道和类型数据
                SDLog(@"地址0d =%@ ",[self hexadecimalString:data]);
                if (!self.SendSpeakerAssignNeedSecond ) {
                    if (self.HomeNeedRefresh) {
                        [self changeHorntWithData:data];
                    }
                }else{
                    self.SendSpeakerAssignNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x0e) {//
                
                if (!self.InputAnalogPercenNeedSecond ) {
                    [self changeInputPercetnWithData:data];
                }else{
                    self.InputAnalogPercenNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x0f) {//
                if (!self.InputDigitalPercenNeedSecond ) {
                    [self changeDigitalPersentWithData:data];
                }else{
                    self.InputDigitalPercenNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x10) {//
                if (!self.CheqBandNeedSecond ) {
                    if (self.EQNeedRefresh) {
                        [self changeChEqBandWithData:data];
                    }
                }else{
                    self.CheqBandNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x11) {//
                if (!self.IneqBandNeedSecond) {
                    if (self.EQNeedRefresh) {
                        [self changeInEqBandWithData:data];
                    }
                }else{
                    self.IneqBandNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x12) {//
                if (!self.CopyNeedSecond ) {
                    
                }else{
                    self.CopyNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x13) {//
                if (!self.CrossoverTypeNeedSecond && self.CrossoverNeedRefresh) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    model.CrossoverFilterType = data2;
                                    SDLog(@"高低切 CrossoverFilterType = %f",model.CrossoverFilterType);
                                }
                            }
                        }
                    }
                }else{
                    self.CrossoverTypeNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x14) {//
                if (!self.HiSlopeNeedSecond  ) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    model.CrossoverHiSlope = data2;
                                    SDLog(@"高低切 CrossoverHiSlope = %f",model.CrossoverHiSlope);
                                }
                            }
                        }
                    }
                }else{
                    self.HiSlopeNeedSecond = NO;
                }
            }
            
            else if (DataAdr == 0x16) {//
                if (!self.LoSlopeNeedSecond ) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    model.CrossoverLoSlope = data2 ;
                                    SDLog(@"高低切 CrossoverLoSlope = %f",model.CrossoverLoSlope);
                                }
                            }
                        }
                    }
                }else{
                    self.LoSlopeNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x15) {//
                if (!self.HiFreqNeedSecond ) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    SDLog(@"高低切 hight******** = %x %x",data1,data2);
                                    model.CrossoverHifreq = (data1 << 8) + (data2 <= 255 ? data2:255);
                                    SDLog(@"高低切 CrossoverHifreq = %lf",model.CrossoverHifreq);
                                    model.CrossoverHifreq = [hornDataModel bandFromFreq:model.CrossoverHifreq];
                                }
                            }
                        }
                    }
                }else{
                    self.HiFreqNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x17) {//
                if (!self.LoFreqNeedSecond ) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    
                                    model.CrossoverLoFreq = (data1 << 8) + (data2 <= 255 ? data2:255);
                                    SDLog(@"高低切 CrossoverLoFreq = %lf",model.CrossoverLoFreq);
                                    
                                    model.CrossoverLoFreq = [hornDataModel bandFromFreq:model.CrossoverLoFreq];
                                    //5aa506001780
                                }
                                
                                
                            }
                        }
                    }
                }else{
                    self.LoFreqNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x18) {//
                if (!self.ChdelayMuneNeedSecond ) {
                    if (data.length >= 7) {
                        NSString *dataStrAll = [self hexadecimalString:data];
                        NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                        NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                        NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                        NSInteger data0 = [self numberWithHexString:byte5Str];
                        NSInteger data1 = [self numberWithHexString:byte6Str];
                        NSInteger data2 = [self numberWithHexString:byte7Str];
                        
                        NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                        for (int i = 0; i <8; i++) {
                            NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                            if ([bit isEqualToString:@"1"]) {
                                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                    if (model.outCh == 8 - i) {
                                        model.cHdelayModel.isMune = data2 == 0 ? NO:YES;
                                        SDLog(@"CHdelay isMune = %d  outch = %d  data1 = %d data2 = %d  %@",model.cHdelayModel.isMune,model.outCh,data1,data2,[self hexadecimalString:data]);
                                    }
                                }
                            }
                        }
                    }
                    
                }else{
                    self.ChdelayMuneNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x19) {//
                if (!self.Phase180NeedSecond ) {
                    if (data.length >= 7) {
                    NSString *dataStrAll = [self hexadecimalString:data];
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    model.cHdelayModel.isPhase180 = data2 == 0 ? NO:YES;
                                    SDLog(@"CHdelay isPhase180 = %d  outch = %d  data1 = %d data2 = %d  %@",model.cHdelayModel.isPhase180,model.outCh,data1,data2,[self hexadecimalString:data]);
                                }
                            }
                        }
                    }
                    }
                }else{
                    self.Phase180NeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1a) {//numberWithHexString
                NSString *dataStrAll = [self hexadecimalString:data];
                
                if (!self.DelayNeedSecond && dataStrAll.length > 15) {
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    
//                  int data0 = ((const char *)[data bytes])[5];
//                  int data1 = ((const char *)[data bytes])[6];
//                  int data2 = ((const char *)[data bytes])[7];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    model.cHdelayModel.delay = (data1 * 16 * 16 + data2) ;
                                    model.cHdelayModel.distance = model.cHdelayModel.delay/100.0 *34.3;
                                    SDLog(@"CHdelay delay = %f  outch = %d  data1 = %d data2 = %d  %@",model.cHdelayModel.delay,model.outCh,data1,data2,[self hexadecimalString:data]);
                                }
                            }
                        }
                    }
                }else{
                    self.DelayNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1b) {//
                NSString *dataStrAll = [self hexadecimalString:data];
                if (!self.DistenceNeedSecond && dataStrAll.length > 15) {
                    
                    NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
                    NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
                    NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
                    NSInteger data0 = [self numberWithHexString:byte5Str];
                    NSInteger data1 = [self numberWithHexString:byte6Str];
                    NSInteger data2 = [self numberWithHexString:byte7Str];
                    
                    NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
                    for (int i = 0; i <8; i++) {
                        NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                        if ([bit isEqualToString:@"1"]) {
                            for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                                if (model.outCh == 8 - i) {
                                    //                                    model.cHdelayModel.distance = (data1 * 16 * 16 + data2)   ;
                                }
                            }
                        }
                    }
                }else{
                    self.DistenceNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1c) {//
                if (!self.Ch1LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
//                    SDLog(@"CHLevelFloat111aaa = %d",data1);
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH1) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat111 = %d",data1);
                        }
                    }
                }else{
                    self.Ch1LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1d) {//
                if (!self.Ch2LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
//                    SDLog(@"CHLevelFloat222aaa = %d",data1);
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH2) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat222 = %d",data1);
                        }
                    }
                }else{
                    self.Ch2LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1e) {//
                if (!self.Ch3LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
//                    SDLog(@"CHLevelFloat333aaa = %d",data1);
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH3) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat333 = %d",data1);
                        }
                    }
                }else{
                    self.Ch3LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x1f) {//
                if (!self.Ch4LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH4) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat444 = %d",data1);
                        }
                    }
                }else{
                    self.Ch4LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x20) {//
                if (!self.Ch5LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH5) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat555 = %d",data1);
                        }
                    }
                }else{
                    self.Ch5LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x21) {//
                if (!self.Ch6LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH6) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat666 = %d",data1);
                        }
                    }
                }else{
                    self.Ch6LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x22) {//
                if (!self.Ch7LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH7) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat777 = %d",data1);
                        }
                    }
                }else{
                    self.Ch7LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x23) {//
                
                if (!self.Ch8LevelNeedSecond ) {
                    int data1 = ((const char *)[data bytes])[6];
                    for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                        if (model.outCh == CH8) {
                            model.CHLevelFloat = data1;
                            SDLog(@"CHLevelFloat888 = %d",data1);
                        }
                    }
                }else{
                    self.Ch8LevelNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x24) {//
                if (!self.AckCurUiIdParameterNeedSecond ) {
                }else{
                    self.AckCurUiIdParameterNeedSecond = NO;
                }
                int data1 = ((const char *)[data bytes])[6];
                switch (data1) {
                    case 1:
                    {
                        //主要信息加载完成后自动加载这里，尽量省去跳转页面时的加载等待
                        SDLog(@"advanced Chlevel");
                        self.ChlevelNeedRefresh = NO;
                        KPostNotification(ChevelRefreshNotificaion, nil)
                        DISPATCH_ON_MAIN_THREAD(^{
                            [UIUtil hideProgressHUD];
                        })
                        //Chlevel信息加载完成后自动加载ChDelay，尽量省去跳转页面时的加载等待
                        if (self.ChDelayNeedRefresh) {
                            [self sendTwoDataTipWithType:AckCurUiIdParameter withCount:maxCount withData0Int:1 withData1Int:2];

                        }
                    }
                        break;
                    case 2:
                    {
                        SDLog(@"advanced chdelay");
                        self.ChDelayNeedRefresh = NO;
                        KPostNotification(ChDelayRefreshNotificaion, nil)
                        DISPATCH_ON_MAIN_THREAD(^{
                            [UIUtil hideProgressHUD];
                        })
                        //ChDelay信息加载完成后自动加载Crossover，尽量省去跳转页面时的加载等待
                        if (self.CrossoverNeedRefresh) {

                            [self sendTwoDataTipWithType:AckCurUiIdParameter withCount:maxCount withData0Int:1 withData1Int:3];

                        }
                    }
                        break;
                    case 3:
                    {
                        SDLog(@"advanced crossover");
                        self.CrossoverNeedRefresh = NO;
                        KPostNotification(CrossoverRefreshNotificaion, nil)
                        DISPATCH_ON_MAIN_THREAD(^{
                            [UIUtil hideProgressHUD];
                        })
                        //Crossover信息加载完成后自动加载EQ，尽量省去跳转页面时的加载等待
                        if (self.EQNeedRefresh) {
                            [self sendTwoDataTipWithType:AckCurUiIdParameter withCount:maxCount withData0Int:1 withData1Int:4];
                        }
                    }
                        break;
                    case 4:
                    {
                        SDLog(@"advanced eqneedrefresh");
                        self.EQNeedRefresh = NO;
                        KPostNotification(EQRefreshNotificaion, nil)
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            else if (DataAdr == 0x25) {//
                if (!self.ResetSelectEQNeedSecond ) {
                    
                }
                else{
                    self.ResetSelectEQNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x26) {//

                if (!self.ResetSelectCrossoverNeedSecond ) {
                    
                }
                else{
                    
                    self.ResetSelectCrossoverNeedSecond = NO;
                }
            }
            else if (DataAdr == 0x27) {
                
                if (!self.McuVersionNeedSecond ) {
                   
                }else{
                    self.McuVersionNeedSecond = NO;
                }
                SDLog(@"mcuVersion = %d",data1);
                DeviceToolShare.mcuVersion = data1;
            }
            }
        
            break;
            
            
        default:
            break;
    }
}

//MCU回给AP  In_EQ下的相对应值的状态；
-(void)changeInEqBandWithData:(NSData*)data{
    if (data.length >= 12) {
        NSString *dataStrAll = [self hexadecimalString:data];
        NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
        NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
        NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
        NSString *byte8Str = [dataStrAll substringWithRange:NSMakeRange(16, 2)];
        NSString *byte9Str = [dataStrAll substringWithRange:NSMakeRange(18, 2)];
        NSString *byte10Str = [dataStrAll substringWithRange:NSMakeRange(20, 2)];
        NSString *byte11Str = [dataStrAll substringWithRange:NSMakeRange(22, 2)];
        NSString *byte12Str = [dataStrAll substringWithRange:NSMakeRange(24, 2)];
         NSString *byte13Str = [dataStrAll substringWithRange:NSMakeRange(26, 2)];
        
        NSInteger data0 = [self numberWithHexString:byte5Str];
        NSInteger data1 = [self numberWithHexString:byte6Str];
        NSInteger data2 = [self numberWithHexString:byte7Str];
        NSInteger data3 = [self numberWithHexString:byte8Str];
        NSInteger data4 = [self numberWithHexString:byte9Str];
        NSInteger data5 = [self numberWithHexString:byte10Str];
        NSInteger data6 = [self numberWithHexString:byte11Str];
        NSInteger data7 = [self numberWithHexString:byte12Str];
        NSInteger data8 = [self numberWithHexString:byte13Str];
        NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
        if (dataStr.length == 0) {
            return;
        }
                SDLog(@"model.ineq Str = %@",dataStr);
                for (int i = 0; i <8; i++) {
                    NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
                    if ([bit isEqualToString:@"1"]) {
                        for (hornDataModel *model in DeviceToolShare.ineqDataArray) {
                            if (model.outCh == 8 - i) {
                                for (eqBandModel *eqBand in model.eqBandIneqArray) {
                                    if (eqBand.bandNumber == data1) {
                                        eqBand.freq = data2 * 16 *16 + data3;
                                        eqBand.bandX = [hornDataModel bandFromFreq:eqBand.freq];
                                        eqBand.gain = ((data4 * 16 *16 + data5) - 120)/10.0;
                                        eqBand.Q = (data7 )/10.0/Q_changeV;
                                        eqBand.Slf_Q = data6/10.0/Q_changeV;
                                        eqBand.bandType = data8;
                                    }
                                }
                            }
                        }
                    }
                }
    }
}
//MCU回给AP  CH_EQ下的相对应值的状态；
-(void)changeChEqBandWithData:(NSData*)data{
    if (data.length >= 12) {
        NSString *dataStrAll = [self hexadecimalString:data];
        
        NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
        NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
        NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
        NSString *byte8Str = [dataStrAll substringWithRange:NSMakeRange(16, 2)];
        NSString *byte9Str = [dataStrAll substringWithRange:NSMakeRange(18, 2)];
        NSString *byte10Str = [dataStrAll substringWithRange:NSMakeRange(20, 2)];
        NSString *byte11Str = [dataStrAll substringWithRange:NSMakeRange(22, 2)];
        NSString *byte12Str = [dataStrAll substringWithRange:NSMakeRange(24, 2)];
        NSString *byte13Str = [dataStrAll substringWithRange:NSMakeRange(26, 2)];

        NSInteger data0 = [self numberWithHexString:byte5Str];
        NSInteger data1 = [self numberWithHexString:byte6Str];
        NSInteger data2 = [self numberWithHexString:byte7Str];
        NSInteger data3 = [self numberWithHexString:byte8Str];
        NSInteger data4 = [self numberWithHexString:byte9Str];
        NSInteger data5 = [self numberWithHexString:byte10Str];
        NSInteger data6 = [self numberWithHexString:byte11Str];
        NSInteger data7 = [self numberWithHexString:byte12Str];
        NSInteger data8 = [self numberWithHexString:byte13Str];
        
        NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
        if (dataStr.length == 0) {
            return;
        }
        SDLog(@"model.cheq Str = %@",dataStr);
        for (int i = 0; i <8; i++) {
            NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
            if ([bit isEqualToString:@"1"]) {
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if (model.outCh == 8 - i) {
                        for (eqBandModel *eqBand in model.eqBandCheqArray) {
                            if (eqBand.bandNumber == data1) {
                                eqBand.freq = data2 * 16 *16 + data3;
                                eqBand.bandX = [hornDataModel bandFromFreq:eqBand.freq];
                                eqBand.gain = ((data4 * 16 *16 + data5)-120)/10.0;
//                                eqBand.Q = (data6 * 16 *16 + data7)/10.0/Q_changeV;
                                
                                eqBand.Q = (data7 )/10.0/Q_changeV;
                                eqBand.Slf_Q = data6/10.0/Q_changeV;
                                eqBand.bandType = data8;
                                
                                SDLog(@"cbandnumber %d_CHenBand bandNumber = %ld   gain= %f  str = %@",8-i,(long)eqBand.bandNumber,eqBand.gain,[self hexadecimalString:data]);
                            }
                        }
                    }
                }
            }
        }
    }
    
}
//MCU回给AP模拟输入通道百分比配置；
-(void)changeInputPercetnWithData:(NSData*)data{
    NSString *dataStrAll = [self hexadecimalString:data];
    if (dataStrAll.length >= 23) {
        NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
        NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
        NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
        NSString *byte8Str = [dataStrAll substringWithRange:NSMakeRange(16, 2)];
        NSString *byte9Str = [dataStrAll substringWithRange:NSMakeRange(18, 2)];
        NSString *byte10Str = [dataStrAll substringWithRange:NSMakeRange(20, 2)];
        NSString *byte11Str = [dataStrAll substringWithRange:NSMakeRange(22, 2)];
        NSInteger data0 = [self numberWithHexString:byte5Str];
        NSInteger data1 = [self numberWithHexString:byte6Str];
        NSInteger data2 = [self numberWithHexString:byte7Str];
        NSInteger data3 = [self numberWithHexString:byte8Str];
        NSInteger data4 = [self numberWithHexString:byte9Str];
        NSInteger data5 = [self numberWithHexString:byte10Str];
        NSInteger data6 = [self numberWithHexString:byte11Str];
        
        NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
        if (dataStr.length != 8) {
            return;
        }
        SDLog(@"model.ch1Input Str = %@  %@   %d",dataStr,[self hexadecimalString:data],data0);
        for (int i = 0; i <8; i++) {
            NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
            
            if ([bit isEqualToString:@"1"]) {
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if (model.outCh == 8 - i) {
                        model.ch1Input = [NSString stringWithFormat:@"%d",data1];
                        model.ch2Input = [NSString stringWithFormat:@"%d",data2];
                        model.ch3Input = [NSString stringWithFormat:@"%d",data3];
                        model.ch4Input = [NSString stringWithFormat:@"%d",data4];
                        model.ch5Input = [NSString stringWithFormat:@"%d",data5];
                        model.ch6Input = [NSString stringWithFormat:@"%d",data6];
                        
                        if (model.outCh == 8) {
                            SDLog(@"model.ch1Input888 = %@ model.ch2Input = %@  model.ch3Input = %@ model.ch4Input = %@ model.ch5Input = %@ model.ch6Input = %@", model.ch1Input,model.ch2Input,model.ch3Input,model.ch4Input,model.ch5Input,model.ch6Input);
                        }
                        SDLog(@"model.ch1Input = %@ model.ch2Input = %@  model.ch3Input = %@ model.ch4Input = %@ model.ch5Input = %@ model.ch6Input = %@", model.ch1Input,model.ch2Input,model.ch3Input,model.ch4Input,model.ch5Input,model.ch6Input);
                    }
                }
            }
        }
    }
}
//MCU回给AP数字输入通道百分比配置
-(void)changeDigitalPersentWithData:(NSData*)data{
    NSString *dataStrAll = [self hexadecimalString:data];
    if (dataStrAll.length >= 15) {
        NSString *byte5Str = [dataStrAll substringWithRange:NSMakeRange(10, 2)];
        NSString *byte6Str = [dataStrAll substringWithRange:NSMakeRange(12, 2)];
        NSString *byte7Str = [dataStrAll substringWithRange:NSMakeRange(14, 2)];
        NSInteger data0 = [self numberWithHexString:byte5Str];
        NSInteger data1 = [self numberWithHexString:byte6Str];
        NSInteger data2 = [self numberWithHexString:byte7Str];
        
        NSString *dataStr = [SocketManager getBinaryByDecimal:data0];
        if (dataStr.length == 0) {
            return;
        }
        SDLog(@"model.ch1Input digitalL Str = %@",dataStr);
        for (int i = 0; i <8; i++) {
            NSString* bit = [dataStr substringWithRange:NSMakeRange(i, 1)];
            
            if ([bit isEqualToString:@"1"]) {
                for (hornDataModel *model in DeviceToolShare.hornDataArray) {
                    if (model.outCh == 8 - i) {
                        model.digitalL = [NSString stringWithFormat:@"%d",data1];
                        model.digitalR = [NSString stringWithFormat:@"%d",data2];
                        
                        SDLog(@"model.ch1Input digitalL = %@  digitalR = %@  ", model.digitalL,model.digitalR);
                    }
                }
            }
        }
    }
    
}
//处理选择的喇叭类型及通道数据
-(void)changeHorntWithData:(NSData*)data{
    [DeviceToolShare.hornDataArray removeAllObjects];
    [DeviceToolShare.crossoverSeleHornDataArray removeAllObjects];
    [DeviceToolShare.eqSeleHornDataArray removeAllObjects];
    [DeviceToolShare.selectHornArray removeAllObjects];
    for (int i = 0; i <= 15 ; i = i+2) {
        int data0 = ((const char *)[data bytes])[i + 5];
        int data1 = ((const char *)[data bytes])[i + 6];
        NSString*hornType = [self hornTypeWithData0:data0 AndDat1:data1];
        if ((data0 != 0 || data1 != 0) && !kStringIsEmpty(hornType)) {

            hornDataModel *model = [[hornDataModel alloc]init];
            model.hornType = hornType;
            SDLog(@"_sockte 添加喇叭类型%@  %d",hornType,i/2 + 1);
            model.outCh = i/2 + 1;
//            if (!isFind) {
            [DeviceToolShare.hornDataArray addObject:model];
//            }
            [DeviceToolShare.selectHornArray addObject:hornType];
        }

    }
}








-(NSString *)hornTypeWithData0:(int)data0 AndDat1:(int)data1{
    if (data0 == 1) {
        if (data1 == 4){
            return @"209";
        }else if (data1 == 5) {
            return @"210";
        }else if (data1 == 3) {
            return @"211";
        }else if (data1 == 2) {
            return @"212";
        }
    }else if (data0 == 2) {
        if (data1 == 1) {
            return @"201";
        }else if (data1 == 2) {
            return @"202";
        }
        else if (data1 == 3) {
            return @"203";
        }else if (data1 == 4) {
            return @"204";
        }
        else if (data1 == 5) {
            return @"205";
        }
//        else if (data1 == 6) {
//            return @"208";
//        }
    }
    else if (data0 == 3) {
        if (data1 == 1) {
            return @"251";
        }else if (data1 == 2) {
            return @"252";
        }
        else if (data1 == 3) {
            return @"253";
        }else if (data1 == 4) {
            return @"254";
        }
        else if (data1 == 5) {
            return @"255";
        }
//        else if (data1 == 6) {
//            return @"208";
//        }
    }else if (data0 == 4) {
        if (data1 == 1) {
            return @"191";
        }
        else if (data1 == 2) {
            return @"192";
        }
        else if (data1 == 3) {
            return @"193";
        }
        if (data1 == 4) {
            return @"207";
        }
        else if (data1 == 5) {
            return @"206";
        }
//        else if (data1 == 6) {
//            return @"208";
//        }
    }else if (data0 == 5) {
        if (data1 == 1) {
            return @"241";
        }
                else if (data1 == 2) {
                    return @"242";
                }
                else if (data1 == 3) {
                    return @"243";
                }
         if (data1 == 4) {
            return @"257";
        }
        else if (data1 == 5) {
            return @"256";
        }
        //        else if (data1 == 6) {
        //            return @"208";
        //        }
    }else if (data0 == 6) {
        
        if (data1 == 6) {
            return @"208";
        }
    }
    return nil;
}




//-(void)sendTestTip{
//    NSData *data = [self dataWithHexstring:@"a55a050000010506"];
//    [_Socket writeData:data withTimeout:-1 tag:0];
//}

-(BOOL)isCurrentWIFI{
    BOOL isCurrent;
    isCurrent = NO;
    _currentWifi = [self getSSIDInfo];
    NSString *SSID = _currentWifi[@"SSID"];
    self.wifiName = SSID;
    SDLog(@"self.wifiName = %@",self.wifiName);
    if ([SSID hasPrefix:@"A180"] || [SSID hasPrefix:@"SK"] || [SSID hasPrefix:@"ETON"] || [SSID hasPrefix:@"eton"] || [SSID hasPrefix:@"Eton"] || [SSID.uppercaseString hasPrefix:@"ET"]) {
        isCurrent =YES;
    }
    return isCurrent ;
}
-(NSString *)currentWIFI
{
    _currentWifi = [self getSSIDInfo];
    return _currentWifi[@"SSID"];
}
- (id)getSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    SDLog(@"self.wifi _ ifs = %@",ifs);
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        SDLog(@"self.wifiName info = %@",info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

// 检测WIFI开关
- (BOOL)isWiFiEnabled {
    
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    SDLog(@"wificonnect = %d",[cset countForObject:@"awdl0"] > 1 ? YES : NO);
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}


//将传入的data类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    if (data.length == 0) {
        return nil;
    }
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2 )];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}
//将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for(idx = 0; idx + 2 <= hexstring.length; idx += 2){
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
    // 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)str { //
    
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}

//普通字符串转换为十六进制的。

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

//十六进制字符串转数字

- (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}

//数字转十六进制字符串

+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    //csq添加“0”凑成整数
    if (hexString.length%2 == 1) {
        hexString = [NSString stringWithFormat:@"0%@",hexString];
    }
    
    return hexString;
}
//数字转十六进制字符串 至少凑成4位
+ (NSString *)fourStringWithHexNumber:(NSUInteger)hexNumber{
    
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    //csq添加“0”凑成4的倍数
    
    if (hexString.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - hexString.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        hexString = [mStr stringByAppendingString:hexString];
    }
    return hexString;
}
//十进制转二进制字符串
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 8 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 8 - binary.length % 8; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
        
    }
    return binary;
}
@end
