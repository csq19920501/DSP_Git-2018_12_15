//
//  DeviceTool.m
//  DSP
//
//  Created by hk on 2018/7/2.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "DeviceTool.h"

#import "Header.h"
static NSString *deviceTool = @"deviceTool23";
static DeviceTool *_deviceTool;
@implementation DeviceTool
+(DeviceTool*)shareInstacne{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
//    if (_deviceTool == nil) {
   
        if (![DeviceTool loadInfo]) {
            _deviceTool = [[self alloc]init];
            _deviceTool.selectHornArray = [NSMutableArray array];
            _deviceTool.hornDataArray = [NSMutableArray array];
            _deviceTool.eqSeleHornDataArray = [NSMutableArray array];
            _deviceTool.crossoverSeleHornDataArray = [NSMutableArray array];
            _deviceTool.ineqDataArray = [NSMutableArray array];
            _deviceTool.ineqSeleDataArray = [NSMutableArray array];
            
            [_deviceTool initIneq];
            _deviceTool.ExternalRemodeControl = NO;
            _deviceTool.managerPreset = 0;

            _deviceTool.analog1_2_connectType = INEQ_connectType_top;
            _deviceTool.analog3_4_connectType = INEQ_connectType_top;
            _deviceTool.analog5_6_connectType = INEQ_connectType_top;
            _deviceTool.diglital_r_l_connectType = INEQ_connectType_top;
            
            _deviceTool.eqF_isConnect = YES;
            _deviceTool.eqR_isConnect = YES;
            _deviceTool.crossoverF_isConnect = YES;
            _deviceTool.crossoverR_isConnect = YES;
//            _deviceTool.deviceType = BH_A180A;
            
        }
            SDLog(@"_deviceTool = %@",[_deviceTool modelDescription]);
    });
//    }
    return _deviceTool;
}
-(void)initIneq{
    NSArray *ineqType  = @[@"Analog1",@"Analog2",@"Analog3",@"Analog4",@"Analog5",@"Analog6",@"DigitalL",@"DigitalR"];
    for (int i = 0; i < ineqType.count; i++) {
        hornDataModel *model = [[hornDataModel alloc]init];
        model.hornType = ineqType[i];
        model.outCh = i+1;
        [_deviceTool.ineqDataArray addObject:model];
    }
    
    _deviceTool.seleHornModel = _deviceTool.ineqDataArray[0];
    [_deviceTool.ineqSeleDataArray addObject:_deviceTool.seleHornModel];
}
+(BOOL)loadInfo{
    
//    return NO;//不做保存 因为band里面保存太多数据导致加载过慢或者失败
    YYCache *cache = [[YYCache alloc]initWithName:deviceTool];
    NSDictionary * userDic = (NSDictionary *)[cache objectForKey:deviceTool];
    if (userDic) {
        _deviceTool = [DeviceTool modelWithJSON:userDic];
        NSMutableArray *selectHornArray = [NSMutableArray array];
//        _deviceTool.selectHornArray = [NSMutableArray arrayWithArray:_deviceTool.selectHornArray];
        _deviceTool.selectHornArray = selectHornArray;

        //为什么不用上方的简单，因为返回来将userDic还原成model时_deviceTool.hornDataArray生成的是字典而不是model 造成错误需要进一步转model  并且hornDataArray转换后成了nsArray 并不是nsmutableArray;
        NSMutableArray *hornDataArray = [NSMutableArray array];
        
//        for (NSDictionary *dict in _deviceTool.hornDataArray) {
//            [hornDataArray addObject:[self csqHornDataModelFromDict:dict]];
//        }
        _deviceTool.hornDataArray = hornDataArray;
        
        
        //下面三个同上
        NSMutableArray *eqSeleHornDataArray = [NSMutableArray array];
//        for (NSDictionary *dict in _deviceTool.eqSeleHornDataArray) {
//            [eqSeleHornDataArray addObject:[self csqHornDataModelFromDict:dict]];
//        }
        _deviceTool.eqSeleHornDataArray = eqSeleHornDataArray;
        
        NSMutableArray *crossoverSeleHornDataArray = [NSMutableArray array];
//        for (NSDictionary *dict in _deviceTool.crossoverSeleHornDataArray) {
//            [crossoverSeleHornDataArray addObject:[self csqHornDataModelFromDict:dict]];
//        }
        _deviceTool.crossoverSeleHornDataArray = crossoverSeleHornDataArray;

        
        NSMutableArray *ineqDataArray = [NSMutableArray array];
//        for (NSDictionary *dict in _deviceTool.ineqDataArray) {
//            [ineqDataArray addObject:[self csqHornDataModelFromDict:dict]];
//        }
        _deviceTool.ineqDataArray = ineqDataArray;
        
        NSMutableArray *ineqSeleDataArray = [NSMutableArray array];
//        for (NSDictionary *dict in _deviceTool.ineqSeleDataArray) {
//            [ineqSeleDataArray addObject:[self csqHornDataModelFromDict:dict]];
//        }
        _deviceTool.ineqSeleDataArray = ineqSeleDataArray;
        
//        if (_deviceTool.ineqDataArray.count > 0) {
//            _deviceTool.seleHornModel = _deviceTool.ineqDataArray[0];
//        }
        [_deviceTool initIneq];
        return YES;
    }
    return NO;
}
-(void)saveInfo{
        YYCache *cache = [[YYCache alloc]initWithName:deviceTool];
        NSDictionary *dic = [self modelToJSONObject];
        [cache setObject:dic forKey:deviceTool];
}
//特殊方法，经过YYKIT模型转字典后调用此方法 将字典还原模型  避免数组内字典没有还原成模型
+(hornDataModel*)csqHornDataModelFromDict:(NSDictionary *)dict{
    
    hornDataModel *model = [hornDataModel modelWithJSON:dict];
    //悲催的是发现子model里面的可变数组也要做相同的处理0.0 这里暂时处理的方法比较复杂 应该寻求简单方法**
    NSMutableArray *objc1 = [NSMutableArray array];
    for (NSDictionary *objcDict1 in model.eqBandCheqArray) {
        eqBandModel *objcModel = [eqBandModel modelWithJSON:objcDict1];
        [objc1 addObject:objcModel];
    }
    model.eqBandCheqArray = objc1;
    
    NSMutableArray *objc2 = [NSMutableArray array];
    for (NSDictionary *objcDict1 in model.eqBandIneqArray) {
        eqBandModel *objcModel = [eqBandModel modelWithJSON:objcDict1];
        
        [objc2 addObject:objcModel];
    }
    model.eqBandIneqArray = objc2;
    
    NSMutableArray *objc3 = [NSMutableArray array];
    for (NSDictionary *objcDict1 in model.nowSelectBandArray) {
        eqBandModel *objcModel = [eqBandModel modelWithJSON:objcDict1];
        [objc3 addObject:objcModel];
    }
    model.nowSelectBandArray = objc3;
    //子 转换结束***
    return model;
}
-(BOOL)isBH_A180A{
    return self.deviceType == BH_A180A;
}
-(void)setDeviceType:(DeviceType )modeType{
    _deviceType = modeType;
    if(modeType == BH_A180A){
        self.SpdifOutBool = YES;
    }else{
        self.SpdifOutBool = NO;
    }
}
@end
